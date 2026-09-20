#!/usr/bin/env node
/*
 * EPOCH run simulator.
 *
 * Monte Carlo model of a single run through the nine ages, used to sanity
 * check the numbers claimed in docs/GAME_DESIGN.md (run length and room
 * count), docs/VERTICAL_SLICE.md (slice run time) and docs/CAVE_WALL.md
 * (Ochre income). No dependencies. Run with:
 *
 *   node tools/run-sim/simulate.js [runs] [profile] [--scenario=baseline|tight]
 *
 * profile is one of: new, mid, expert, all (default all). The default
 * scenario is "launch", the shipping scope the docs now describe.
 */

'use strict';

// ---------------------------------------------------------------- config

// Three scenarios. "baseline" is the first draft of the docs. "tight" is the
// nine-age set adopted after the first simulation showed baseline clears at
// roughly 75 minutes. "launch" is the five-age shipping scope from
// docs/FAST_PATH.md and is the default. Select with --scenario=name.
const SCENARIOS = {
  baseline: {
    ages: [
      { name: 'Stone',           rooms: 6, boss: 210 },
      { name: 'Rivers',          rooms: 6, boss: 220 },
      { name: 'Empires',         rooms: 6, boss: 230 },
      { name: 'Faith and Steel', rooms: 6, boss: 240 },
      { name: 'Sail',            rooms: 5, boss: 240 },
      { name: 'Revolution',      rooms: 5, boss: 200 },
      { name: 'Wars',            rooms: 3, boss: 180 },
      { name: 'Atoms',           rooms: 3, boss: 180 },
      { name: 'Terminus',        rooms: 1, boss: 300 },
    ],
    roomTime: {
      combat: [60, 100], elite: [90, 130], altar: [20, 30],
      shop: [20, 40], fountain: [10, 15], story: [25, 35],
    },
    ageTimeScale: 0.05,
    transitionTime: 25,
    hearthTime: [60, 90],
    ochre: {
      doorBase: 15, doorPerAge: 5, eliteBonus: 10, story: 25,
      bossFirst: 100, bossRepeat: 20, perRoomCleared: 5,
    },
  },
  tight: {
    ages: [
      { name: 'Stone',           rooms: 6, boss: 150 },
      { name: 'Rivers',          rooms: 5, boss: 160 },
      { name: 'Empires',         rooms: 5, boss: 170 },
      { name: 'Faith and Steel', rooms: 5, boss: 180 },
      { name: 'Sail',            rooms: 4, boss: 180 },
      { name: 'Revolution',      rooms: 4, boss: 150 },
      { name: 'Wars',            rooms: 3, boss: 120 },
      { name: 'Atoms',           rooms: 3, boss: 120 },
      { name: 'Terminus',        rooms: 1, boss: 240 },
    ],
    roomTime: {
      combat: [40, 70], elite: [65, 95], altar: [15, 25],
      shop: [15, 30], fountain: [8, 12], story: [20, 30],
    },
    ageTimeScale: 0.04,
    transitionTime: 20,
    hearthTime: [45, 75],
    ochre: {
      doorBase: 15, doorPerAge: 3, eliteBonus: 10, story: 25,
      bossFirst: 100, bossRepeat: 10, perRoomCleared: 5,
    },
  },
  launch: {
    ages: [
      { name: 'Stone',           rooms: 6, boss: 150 },
      { name: 'Rivers',          rooms: 5, boss: 160 },
      { name: 'Empires',         rooms: 5, boss: 170 },
      { name: 'Faith and Steel', rooms: 5, boss: 180 },
      { name: 'Sail',            rooms: 4, boss: 180 },
      { name: 'Terminus',        rooms: 1, boss: 240 },
    ],
    roomTime: {
      combat: [40, 70], elite: [65, 95], altar: [15, 25],
      shop: [15, 30], fountain: [8, 12], story: [20, 30],
    },
    ageTimeScale: 0.04,
    transitionTime: 20,
    hearthTime: [45, 75],
    ochre: {
      doorBase: 15, doorPerAge: 3, eliteBonus: 10, story: 25,
      bossFirst: 100, bossRepeat: 10, perRoomCleared: 5,
    },
  },
};

// Middle-room type weights (room 1 is always combat, last is always boss).
const ROOM_WEIGHTS = {
  combat: 55, elite: 12, altar: 15, shop: 8, fountain: 5, story: 5,
};
// At most one of each of these per age.
const ONCE_PER_AGE = new Set(['shop', 'fountain', 'story']);

// Share of combat/elite door choices where the player takes the Ochre door.
const OCHRE_DOOR_SHARE = 1 / 3;

// Player profiles: per-room death chance in age 1, growth per age, boss
// death chance in age 1 and growth per age.
const PROFILES = {
  new:    { room: 0.06, roomGrowth: 0.015, boss: 0.55, bossGrowth: 0.05 },
  mid:    { room: 0.025, roomGrowth: 0.008, boss: 0.25, bossGrowth: 0.03 },
  expert: { room: 0.008, roomGrowth: 0.003, boss: 0.08, bossGrowth: 0.015 },
};

// ---------------------------------------------------------------- helpers

function rand(lo, hi) { return lo + Math.random() * (hi - lo); }

function pickWeighted(weights, banned) {
  const entries = Object.entries(weights).filter(([k]) => !banned.has(k));
  const total = entries.reduce((s, [, w]) => s + w, 0);
  let r = Math.random() * total;
  for (const [k, w] of entries) {
    if ((r -= w) <= 0) return k;
  }
  return entries[entries.length - 1][0];
}

function percentile(sorted, p) {
  if (sorted.length === 0) return 0;
  const i = Math.min(sorted.length - 1, Math.floor(p * sorted.length));
  return sorted[i];
}

function fmtMin(sec) { return (sec / 60).toFixed(1); }

// ---------------------------------------------------------------- model

/**
 * Simulate one run.
 * @param {object} cfg       scenario config
 * @param {object} profile   death-chance profile
 * @param {number} maxAges   how many ages are unlocked (1 for the slice)
 * @param {boolean} firstKills  whether boss kills count as first-time
 * @returns {{seconds:number, rooms:number, ochre:number, cleared:boolean, diedIn:string|null}}
 */
function simulateRun(cfg, profile, maxAges, firstKills) {
  const { ages: AGES, roomTime: ROOM_TIME, ageTimeScale: AGE_TIME_SCALE,
    transitionTime: TRANSITION_TIME, hearthTime: HEARTH_TIME, ochre: OCHRE } = cfg;
  let seconds = rand(...HEARTH_TIME);
  let rooms = 0;
  let ochre = 0;

  for (let a = 0; a < Math.min(maxAges, AGES.length); a += 1) {
    const age = AGES[a];
    const scale = 1 + a * AGE_TIME_SCALE;
    const roomDeath = profile.room + a * profile.roomGrowth;
    const bossDeath = profile.boss + a * profile.bossGrowth;
    const used = new Set();
    let hadAltar = false;

    // Non-boss rooms.
    for (let r = 0; r < age.rooms - 1; r += 1) {
      let type;
      if (r === 0) {
        type = 'combat';
      } else if (r === age.rooms - 2 && !hadAltar) {
        type = 'altar'; // guarantee one altar per age
      } else {
        type = pickWeighted(ROOM_WEIGHTS, used);
      }
      if (ONCE_PER_AGE.has(type)) used.add(type);
      if (type === 'altar') hadAltar = true;

      const [lo, hi] = ROOM_TIME[type];
      const combatLike = type === 'combat' || type === 'elite';
      seconds += rand(lo, hi) * (combatLike ? scale : 1);

      if (combatLike && Math.random() < roomDeath) {
        ochre += rooms * OCHRE.perRoomCleared;
        return { seconds, rooms, ochre, cleared: false, diedIn: age.name };
      }

      rooms += 1;
      if (combatLike && Math.random() < OCHRE_DOOR_SHARE) {
        ochre += OCHRE.doorBase + OCHRE.doorPerAge * (a + 1);
        if (type === 'elite') ochre += OCHRE.eliteBonus;
      }
      if (type === 'story') ochre += OCHRE.story;
    }

    // Boss.
    seconds += age.boss * (0.85 + Math.random() * 0.3);
    if (Math.random() < bossDeath) {
      ochre += rooms * OCHRE.perRoomCleared;
      return { seconds, rooms, ochre, cleared: false, diedIn: `${age.name} boss` };
    }
    rooms += 1;
    ochre += (firstKills ? OCHRE.bossFirst : OCHRE.bossRepeat) * (a + 1);
    seconds += TRANSITION_TIME;
  }

  ochre += rooms * OCHRE.perRoomCleared;
  return { seconds, rooms, ochre, cleared: true, diedIn: null };
}

// ---------------------------------------------------------------- report

function report(cfg, label, profile, maxAges, runs, firstKills) {
  const results = [];
  for (let i = 0; i < runs; i += 1) results.push(simulateRun(cfg, profile, maxAges, firstKills));

  const all = results.map((r) => r.seconds).sort((x, y) => x - y);
  const clears = results.filter((r) => r.cleared);
  const clearT = clears.map((r) => r.seconds).sort((x, y) => x - y);
  const clearO = clears.map((r) => r.ochre).sort((x, y) => x - y);
  const deaths = results.filter((r) => !r.cleared);
  const deathO = deaths.map((r) => r.ochre).sort((x, y) => x - y);
  const roomsAvg = results.reduce((s, r) => s + r.rooms, 0) / results.length;

  const where = {};
  for (const d of deaths) where[d.diedIn] = (where[d.diedIn] || 0) + 1;
  const topDeaths = Object.entries(where)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 4)
    .map(([k, v]) => `${k} ${(100 * v / runs).toFixed(0)}%`)
    .join(', ');

  console.log(`\n== ${label} (${runs} runs, ${maxAges} age${maxAges > 1 ? 's' : ''}) ==`);
  console.log(`clear rate            ${(100 * clears.length / runs).toFixed(1)}%`);
  console.log(`rooms per run (mean)  ${roomsAvg.toFixed(1)}`);
  console.log(`all runs, minutes     p50 ${fmtMin(percentile(all, 0.5))}  p90 ${fmtMin(percentile(all, 0.9))}`);
  if (clearT.length) {
    console.log(`full clears, minutes  p10 ${fmtMin(percentile(clearT, 0.1))}  p50 ${fmtMin(percentile(clearT, 0.5))}  p90 ${fmtMin(percentile(clearT, 0.9))}`);
    console.log(`full clears, ochre    p10 ${percentile(clearO, 0.1)}  p50 ${percentile(clearO, 0.5)}  p90 ${percentile(clearO, 0.9)}`);
  }
  if (deathO.length) {
    console.log(`deaths, ochre         p10 ${percentile(deathO, 0.1)}  p50 ${percentile(deathO, 0.5)}  p90 ${percentile(deathO, 0.9)}`);
    console.log(`where they die        ${topDeaths}`);
  }
}

function main() {
  const args = process.argv.slice(2);
  const scenarioArg = args.find((a) => a.startsWith('--scenario='));
  const scenarioName = scenarioArg ? scenarioArg.split('=')[1] : 'launch';
  const positional = args.filter((a) => !a.startsWith('--'));
  const runs = Number(positional[0]) || 20000;
  const which = positional[1] || 'all';
  const profiles = which === 'all' ? Object.keys(PROFILES) : [which];

  const cfg = SCENARIOS[scenarioName];
  if (!cfg) { console.error(`unknown scenario ${scenarioName}`); process.exit(1); }
  const totalRooms = cfg.ages.reduce((s, a) => s + a.rooms, 0);
  console.log(`EPOCH run simulator, scenario "${scenarioName}". ${cfg.ages.length} ages, ${totalRooms} rooms on a full clear.`);

  for (const name of profiles) {
    const p = PROFILES[name];
    if (!p) { console.error(`unknown profile ${name}`); process.exit(1); }
    report(cfg, `${name} player, vertical slice (repeat boss kills)`, p, 1, runs, false);
    report(cfg, `${name} player, full game (repeat boss kills)`, p, cfg.ages.length, runs, false);
  }
  report(cfg, 'mid player, full game, every boss a first kill', PROFILES.mid, cfg.ages.length, runs, true);
}

main();
