# Enemy rosters, ages 2 to 9

Extends the Stone Age roster in `VERTICAL_SLICE.md` section 3 to every launch thread. Every enemy is an instance of one of eight **archetypes**. An archetype is one behaviour script and one animation rig. An age's enemy is a re-skin of an archetype with a mesh, a palette, tuned numbers, and at most one added behaviour. This is how nine ages of enemies fit in one character artist's schedule: the budget is two days per re-skin and two weeks per new archetype.

All health and damage numbers are relative to Alegus's 100 starting health and are set at age entry. Every enemy in an age scales by that age's multiplier, so the values below are the age 1 baseline. Multipliers: age 1 at 1.0, age 2 at 1.3, age 3 at 1.6, age 4 at 2.0, age 5 at 2.4, age 6 at 2.8, age 7 at 3.2, age 8 at 3.5.

---

## 1. Archetypes

| Archetype | Rig | Core behaviour | Baseline health | Baseline damage | First appears |
|---|---|---|---|---|---|
| **Pack** | Quadruped small | Spawns in groups of 3 to 5, circles, lunges when Alegus faces another | 30 | 8 | Stone (Wolf) |
| **Charger** | Quadruped large | Wind-up then straight-line charge, stunned on wall hit | 90 | 18 | Stone (Boar) |
| **Thrower** | Biped light | Keeps 6 to 8 units, projectile on a timer, retreats | 45 | 12 | Stone (Hunter) |
| **Brute** | Biped heavy | Slow sweeping melee, roar knockback, grab | 220 | 25 | Stone (Cave Bear) |
| **Shield** | Biped medium | Blocks from the front, must be flanked or Shattered | 70 | 14 | Rivers |
| **Formation** | Biped medium, grouped | 4 to 8 units move as one body with a leader; the group has shared behaviour | 40 each | 10 | Empires |
| **Caster** | Biped light, stationary | Stands still, places a hazard or buff at range, weak in melee | 35 | 15 hazard | Faith and Steel |
| **Turret** | Non-humanoid | Fixed emplacement, cone of fire with reload window, cannot move | 120 | 20 | Sail |

Eight rigs total. The Stone Age already has four. Two arrive in ages 2 and 3, two more in ages 4 and 5. Nothing new is built after age 5; ages 6 to 9 are entirely re-skins with added behaviours.

**Age mechanic** (from the design doc) is always carried by one enemy in that age, marked with ⬥ below.

---

## 2. Age of Rivers: Egypt

Palette: ochre, turquoise, black silt. Frayed here are wrapped in linen that trails and unravels.

| Enemy | Archetype | Health | Damage | Added behaviour |
|---|---|---|---|---|
| Jackal | Pack | 30 | 8 | Lunge from sand: pack members can burrow and re-emerge behind Alegus |
| Temple Bull | Charger | 90 | 18 | Charge leaves a sand furrow that slows for 3 s |
| Slinger | Thrower | 45 | 12 | Two-stone volley, second stone arrives 0.5 s later |
| ⬥ Shieldbearer | Shield | 70 | 14 | Introduces the Shield archetype. Front block absorbs all damage; a hit from behind or a Shatter breaks the shield permanently |
| Embalmer | Brute | 220 | 25 | Grab wraps Alegus in linen: 2 s root unless dashed out of within 0.5 s |

Elite modifiers: Hardened, Swift, Frayed Deeper, plus one new: **Sun-Struck**, the enemy leaves a burning patch on death.

---

## 3. Age of Empires: Rome

Palette: white marble, sea blue, terracotta. Frayed are legionaries whose armour is drawn but whose faces are blank paper.

| Enemy | Archetype | Health | Damage | Added behaviour |
|---|---|---|---|---|
| War Dog | Pack | 30 | 8 | Standard |
| ⬥ Legionary | Formation | 40 | 10 | Introduces Formation. 6 legionaries in a line with a leader at the centre. The line advances, halts, throws pila together on the leader's call, then advances again. Killing the leader breaks the formation into individual Shield enemies |
| Velite | Thrower | 45 | 12 | Throws a javelin that pins the ground and slows in a 1 unit radius for 3 s |
| Retiarius | Shield | 70 | 14 | No shield. Net throw instead: roots 1.5 s, trident follow-up. Same rig with the block replaced by a net |
| Gladiator | Brute | 220 | 25 | Grab becomes a shield bash chain. Roar is replaced by a crowd-cheer buff: nearby enemies deal 20% more for 5 s |

Elite modifiers add **Decorated**: a gold-reserve enemy that buffs the formation it stands in.

---

## 4. Age of Faith and Steel: Crusader Europe

Palette: grey stone, stained glass, snow. Frayed are pilgrims, men-at-arms, and things from the margins of manuscripts.

| Enemy | Archetype | Health | Damage | Added behaviour |
|---|---|---|---|---|
| Wolfhound | Pack | 30 | 8 | Standard |
| Destrier | Charger | 90 | 18 | Armoured: Burn does nothing until Shattered. Charge has a rider who throws a lance mid-charge |
| Crossbowman | Thrower | 45 | 16 | Slow single bolt, 3 s reload, high damage. Bolt is a straight line, dodgeable on reaction |
| ⬥ Man-at-Arms | Shield | 110 | 14 | Introduces armour. Immune to Burn and stagger until Shattered or reduced below 50% by heavy hits. Teaches Forge |
| Flagellant | Caster | 35 | 15 | Introduces Caster. Stands still and chants, placing a 3 unit circle that heals all Frayed inside 5 per second. Dies in two hits from anything |
| Ogre of the Margin | Brute | 260 | 28 | Grab lifts and throws Alegus toward the nearest hazard |

Elite modifiers add **Sworn**: the enemy re-armours once at 30% health.

---

## 5. Age of Sail: Caribbean

Palette: teal, tar, brass, powder smoke. Frayed are crews, marines, and drowned things wearing their coats.

| Enemy | Archetype | Health | Damage | Added behaviour |
|---|---|---|---|---|
| Rat Swarm | Pack | 15 each, packs of 8 | 4 | Tiny, fast, individually harmless. Teaches area attacks |
| Boarding Crew | Formation | 40 | 10 | 4 crew swing in on ropes together and land in a ring around Alegus, then fight as individuals with cutlasses |
| ⬥ Marine | Thrower | 50 | 20 | Introduces the reload window. Musket shot with a 1 s aim telegraph, then 4 s reload during which the Marine is helpless. Teaches punishing the reload |
| Swivel Gun | Turret | 120 | 20 | Introduces Turret. Fixed to the rail, 90 degree cone, fires grapeshot every 5 s. Cannot be flanked but has a 2 s reload |
| Powder Monkey | Caster | 35 | 40 explosion | Runs toward Alegus and detonates. The one Caster that moves. Killing it at range detonates it where it stands, which can hurt other Frayed |
| Drowned Bosun | Brute | 240 | 25 | Grab is a drowning hold: continuous damage until dashed out. Roar summons a 6 s rain that slows |

Elite modifiers add **Press-Ganged**: on death the enemy spawns a Rat Swarm.

---

## 6. Age of Revolution: Foundry city

Palette: rust, gaslight, tricolour. Frayed are workers, soldiers, and machines that have learned to walk.

| Enemy | Archetype | Health | Damage | Added behaviour |
|---|---|---|---|---|
| Foundry Dog | Pack | 30 | 8 | Lunge sets Alegus Burning if the dog was standing in a hazard |
| Line Infantry | Formation | 40 | 12 | 6 in a line, fire a volley on a 5 s cycle. The volley is a wall of projectiles with a 1 s gap that must be dashed through or blocked |
| Sapper | Thrower | 45 | 14 | Throws a bomb with a 2 s fuse that can be knocked back into enemies |
| ⬥ Steam Hammer | Turret | 200 | 30 | Introduces environmental damage that hurts enemies too. Fixed, slams the ground every 4 s in a 3 unit radius, killing any Frayed caught under it. The player learns to bait enemies under it |
| Overseer | Caster | 35 | 0 | Blows a whistle: all Frayed in 6 units move 40% faster for 5 s. Priority target |
| Ironclad Walker | Brute | 300 | 30 | Armoured. Steam vents on its back are the weak point; hitting them from behind deals triple |

Elite modifiers add **Overclocked**: the enemy's attacks are 30% faster and it takes 5 damage per second itself.

---

## 7. Age of Wars: Trenches

Palette: mud, gas green, searchlight white. Frayed are soldiers whose uniforms are drawn but whose bodies are smoke.

Short age, three rooms. The roster is small and every enemy relates to cover.

| Enemy | Archetype | Health | Damage | Added behaviour |
|---|---|---|---|---|
| Trench Rat | Pack | 15 each, packs of 6 | 4 | Standard swarm |
| ⬥ Rifleman | Thrower | 50 | 22 | Introduces cover. Fires only when it has line of sight; craters and sandbags block the shot. Slow, accurate, deadly in the open. Teaches moving crater to crater |
| Gas Sergeant | Caster | 35 | 8 per second | Throws a gas canister: 4 unit cloud for 8 s that fills low ground first. Craters stop being safe |
| Machine Gun Nest | Turret | 150 | 15 per hit, rapid | 60 degree cone, fires in 3 s bursts with 3 s reloads. Suppresses: standing in the cone slows Alegus 30% |
| Shock Trooper | Formation | 40 | 12 | 4 troopers rush in a wedge with a grenade throw at the start. Fast, not defensive |

Elite modifiers add **Shell-Shocked**: the enemy is immune to stagger and takes 20% more damage.

---

## 8. Age of Atoms and Stars: Silo

Palette: concrete, phosphor green, one red light. Frayed are technicians and guards, drawn as photocopies: flat, slightly misaligned.

Short age, three rooms. Every room has a countdown or objective; enemies are pressure, not the goal.

| Enemy | Archetype | Health | Damage | Added behaviour |
|---|---|---|---|---|
| Security Dog | Pack | 30 | 8 | Standard, but packs are 2 and spawn continuously while a console is being held |
| ⬥ Technician | Caster | 35 | 0 | Introduces objective interference. Runs to the nearest console and locks it for 10 s. Does not attack. Must be killed before it arrives |
| Guard | Shield | 70 | 14 | Riot shield. Bash knocks Alegus off a console |
| Sentry Gun | Turret | 100 | 10, rapid | Tracks Alegus continuously, 1 s spin-up before firing, 2 s cooldown. Can be disabled for 10 s by a hit from behind |
| Response Team | Formation | 40 | 12 | 4 guards in a diamond that advance on Alegus's console and hold position around it |
| Hazmat Brute | Brute | 240 | 25 | Grab is a decontamination spray: 2 s stun. Roar sets off the room's klaxon early |

Elite modifiers add **Redacted**: the enemy has no paper reserve at all and must be tracked by its shadow. Used sparingly, and the one place the readability rule is broken on purpose.

---

## 9. Terminus

No roster. During phase 2 of the Terminus fight, each painted age spawns two of its ⬥ enemies for the duration of the age window, so the player fights a compressed rerun of what they learned.

---

## 10. Build order and budget

| Milestone | New archetypes | Re-skins | Artist days |
|---|---|---|---|
| Slice | Pack, Charger, Thrower, Brute | 0 | 4 rigs, 40 days |
| Alpha | Shield, Formation, Caster, Turret | 22 (ages 2 to 5) | 4 rigs, 40 days, plus 44 days of re-skins |
| Beta | none | 17 (ages 6 to 8) | 34 days |

Roughly 160 artist days for every enemy in the game, which fits one character artist across alpha and beta alongside the boss and lineage work. If that is too tight, the Formation members can reuse the Shield rig with a different animation set, saving one archetype.
