# Vertical slice: Stone Age, Ice Age thread

Milestone 4 in `GAME_DESIGN.md`. This is the first complete, representative piece of the game. It answers one question: **is one full age fun for ten runs?**

Everything here is the minimum that lets a playtester experience the real loop: pick a lineage at the Hearth, run six rooms, fight the Mammoth Mother, die or win, return to the Hearth, talk to the Firekeeper, spend Ochre, go again.

---

## 1. Scope

**In:**

- The Hearth with the Firekeeper only. Cave Wall with the first three rows. Lineage rack with Blunt and Edge.
- Stone Age, Ice Age thread: 6 rooms drawn from a pool of 10, then the boss.
- 4 enemy types plus elites, 1 boss.
- 4 Inventors (Ember, Wheel, Seed, Forge), 5 Inventions each, 2 duos, no legendaries.
- Blunt and Edge at their Stone Age form. Bronze form is shown only in the re-forge scene at the end of the age, as a reward preview, and the run ends there.
- Ember stone Cast, dash, one Call per Inventor.
- Ochre and Flint currencies. One shop room type.
- Alegus fully voiced for combat and the Firekeeper conversations. Firekeeper voiced.
- The full watercolour render stack from `RENDER_PIPELINE.md`.
- Controller and keyboard-and-mouse.

**Out:**

- Every other age, thread, lineage, Inventor, cast member, currency, and Aspects.
- Anachronisms, keepsakes, codex, story unlocks beyond the Firekeeper's first ten conversations.
- Settings beyond volume, resolution, and rebinding.

---

## 2. The Frayed

Enemies are the **Frayed**: echoes of creatures and people that the Terminus has pulled loose from the weave. They are drawn in a looser, wetter watercolour than Alegus and the world, with edges that will not settle. When they die they run like a wet painting and drain into the paper.

This device does three jobs. It lets Alegus fight humans in later ages without it reading as murder. It justifies the watercolour dissolve as the universal death effect. And it gives every enemy one shared visual tell (the unstable edge) that separates hostile from harmless at a glance.

---

## 3. Enemy roster

Health and damage are relative to Alegus's starting 100 health. Speed is relative to Alegus's run speed (1.0).

| Enemy | Health | Damage | Speed | Behaviour | Age mechanic it teaches |
|---|---|---|---|---|---|
| **Frayed Wolf** | 30 | 8 | 1.3 | Spawns in packs of 3 to 5. Circles to flank, lunges when Alegus is facing another wolf. Lunge has a 0.4 s ink telegraph. | Flanking. Teaches the player to keep moving and use knockback to reset the pack. |
| **Frayed Boar** | 90 | 18 | 0.8, charge 2.2 | Winds up for 0.8 s then charges in a straight line, stops at walls with a 0.6 s stun. Hitting it during the stun deals bonus damage. | Punish windows. First enemy that rewards patience over aggression. |
| **Frayed Hunter** | 45 | 12 | 0.9 | Keeps range 6 to 8 units, throws a stone every 2.5 s with a visible arc, retreats when approached. Two hunters will alternate throws. | Ranged pressure. Teaches dash-attack and Cast as a gap closer. |
| **Frayed Cave Bear** | 220 | 25 | 0.7 | Mini-boss. Slow swipes with 0.9 s telegraph, a roar that pushes Alegus back, and a grab that must be dashed out of. Only appears in the elite room. | Big single target. Teaches sustained damage and that heavy hits stagger. |

**Elite modifiers** (one per elite, gold ink outline instead of black):

- **Hardened:** health doubled, immune to stagger for the first 30% of health.
- **Swift:** speed times 1.4, all telegraphs 25% shorter.
- **Frayed Deeper:** on death, splits into two half-size copies with half health.

**Spawn rules:** rooms have 2 to 3 waves. Wave 1 is always the room's dominant type. Wave 2 adds a second type. Wave 3, present only in later rooms, is a mixed group with one elite. Total enemies per room between 6 and 14.

---

## 4. Rooms

Six rooms per run drawn from a pool of ten layouts. Room 1 is always a combat room from the first three layouts. Room 6 is always the boss. Rooms 2 to 5 follow the door-choice system: each door shows the reward type behind it.

| Layout | Type | Shape | Notes |
|---|---|---|---|
| Kill site | Combat | Open oval with a mammoth carcass in the middle as cover | Tutorial-safe. Wolves only. |
| Ice shelf | Combat | Long, narrow, with a crevasse down one side | Boars charge across it. Falling in costs 15 health and respawns Alegus at the edge. |
| Snow hollow | Combat | Circular with three rock pillars | Hunters use pillars as cover. |
| Frozen river | Combat | Wide, slippery patches where dash goes 50% further | Wolves and hunters. |
| Tar pit | Combat | Central pit that slows anything inside | Boars stuck in tar are free hits. |
| Bear den | Elite | Small cave, single entrance | Always the Cave Bear with one modifier, plus a wolf wave. |
| Painted cave | Altar | Narrow with a wall painting | Invention choice. No enemies. The painting shows the Inventor's symbol. |
| Trade fire | Shop | Circular around a fire | Flint shop. One item, one Invention reroll, one heal. |
| Hot spring | Fountain | Small, steam | Heals 30% of max health. |
| The overlook | Story | Cliff edge looking at the aurora | The Firekeeper's voice from the fire. One line of story, one Ochre bundle. |

**Door reward types:** Ochre, Flint, Invention (shows the Inventor's symbol), Health, and the boss door which is always visible from room 5.

---

## 5. The Mammoth Mother

Arena: a wide frozen lake ringed by ice cliffs, with four hunters' spears already lodged in her flank. She is slow, enormous, and wounded. The fight is about her protecting a calf that is never seen, only heard.

**Health:** 1,400 across three phases.

**Phase 1 (100% to 65%): the wounded animal.**
- **Trample:** walks toward Alegus, 1.2 s telegraph, then a short charge. Fair and slow.
- **Trunk sweep:** 180 degree arc in front, 0.9 s telegraph. Knockback.
- **Stamp:** a ring of ice shards erupts around her, 1.0 s telegraph. Punishes standing under her.
- Alegus learns that hitting the lodged spears (they glow with ink) deals double damage. This is the DPS skill check.

**Phase 2 (65% to 30%): the ice breaks.**
- The lake surface cracks into five floes. Between floes is water: falling in costs 15 health and a 1 s recovery.
- Trample now crosses floes and can shatter the one Alegus is standing on if it is already cracked.
- New attack, **Bellow:** she calls, and three Frayed Wolves spawn on the far floes. They must be handled while she keeps attacking.
- Trunk sweep now throws ice chunks as projectiles.

**Phase 3 (30% to 0): the last stand.**
- She stops moving. She stands over the spot where the calf is heard and refuses to leave it.
- All attacks become area-of-denial around her: overlapping stamp rings, sweep, and ice falling from the cliffs in telegraphed columns.
- Her exposed spears now pulse. Hitting all four in sequence within 6 s triggers a 3 s stagger. This is the intended kill window and the payoff for phase 1's lesson.

**On defeat:** she does not dissolve like the Frayed. She kneels, the calf's call stops, and the watercolour of the lake runs, taking her with it. Alegus has a line here that is not a joke.

**Barks:** 6 intro variants (first time, repeat, low health arrival, each lineage), 4 phase-change lines, 2 death lines for Alegus, 1 victory line.

---

## 6. Lineage movesets

Frame targets are at 60 frames per second. "Active" is the window that deals damage. Numbers are starting points for the combat prototype and are expected to move.

### Blunt: Stone club

| Move | Startup | Active | Recovery | Damage | Notes |
|---|---|---|---|---|---|
| Attack 1 | 12 | 6 | 14 | 20 | Horizontal swing, 90 degree arc |
| Attack 2 | 10 | 6 | 14 | 20 | Reverse swing |
| Attack 3 | 18 | 8 | 24 | 40 | Overhead. Knockback 3 units. Combo resets. |
| Special | 22 | 10 | 30 | 50 | Ground slam, 2.5 unit radius, staggers |
| Dash attack | 6 | 6 | 12 | 25 | Lunging swing |
| Dash special | 14 | 8 | 20 | 35 | Slam at dash end |
| Cast | 8 | projectile | 16 | 50 | Ember stone. Recover by walking over it or on enemy death. |

Feel goals: every third hit clears space. Player learns to end combos facing the pack.

### Edge: Flint knife

| Move | Startup | Active | Recovery | Damage | Notes |
|---|---|---|---|---|---|
| Attack 1 to 4 | 6 | 4 | 8 | 10 each | Four-hit chain, last hit 15 |
| Attack 5 | 10 | 6 | 16 | 25 | Finisher, small forward step |
| Special | 8 | 12 parry window | 20 | 0, or 60 on parry | Successful parry stuns 1.5 s and refunds a dash |
| Dash attack | 4 | 4 | 10 | 15 | Slash through |
| Dash special | 6 | 10 parry window | 14 | 0, or 60 on parry | Moving parry |
| Cast | 8 | projectile | 16 | 50 | As Blunt |

Feel goals: parry is the identity. A player who never parries should still clear the age; a player who parries well should feel untouchable against boars.

**Universal:**

- **Dash:** 4 frames startup, 10 frames of invulnerability, 6 recovery, 4.5 units. One charge by default; the Cave Wall adds a second.
- **Call:** meter fills from damage dealt (1 per 10) and taken (1 per 4). 100 to fill. Ember's Call sets a 4 unit ring on fire for 5 s. Wheel's Call is a 3-dash chain with damage. Seed's Call heals 25 and roots all enemies 2 s. Forge's Call makes the next 5 hits deal triple damage and shatter armour.

---

## 7. Inventions in the slice

Five per Inventor, one per slot. Three rarities: Common, Rare, Epic, at 1.0, 1.5, 2.0 times the listed value.

| Inventor | Attack | Special | Cast | Dash | Call |
|---|---|---|---|---|---|
| Ember | Attacks apply Burn, 4 damage per second for 4 s | Special applies Burn and 30% more damage | Cast leaves a burning patch where it lands | Dash leaves a trail of fire | Ring of fire, above |
| Wheel | Attacks deal 20% more after a dash for 2 s | Special has 40% shorter recovery | Cast returns to Alegus after 3 s | Dash gains a second charge for this run | Dash chain, above |
| Seed | Attacks have 8% chance to drop a heal seed (5 health) | Special roots enemies 1.5 s | Cast roots on hit | Dashing through a rooted enemy heals 3 | Heal and root, above |
| Forge | Attacks deal 30% more but combo 10% slower | Special deals 60% more and staggers | Cast deals 80% more and shatters armour | Dash attack deals 50% more | Triple damage, above |

**Duos in the slice:**

- Ember and Forge, **Slag:** shattered enemies burn for double.
- Wheel and Seed, **Fallow:** each dash heals 2, rooted enemies drop heal seeds on death.

**Altar rules:** each altar offers three Inventions from one Inventor. The first altar in a run always offers Ember, so a new player sees the simplest system first. Rarity is rolled per option. Duos only appear once both prerequisites are held.

---

## 8. The Hearth

Small. A cave with the fire in the centre. Three interaction points:

1. **The fire.** The Firekeeper. Ten conversations, unlocked in order, one per return. Topics: who Alegus is, what the Loom is, what the Frayed are, why the Mammoth Mother will not leave, and a hint that there are more ages.
2. **The Cave Wall.** Three rows. Row 1: Death Defiance (1 extra life) or Fierce Start (first hit of each room does double). Row 2: Second dash or Longer dash i-frames. Row 3: More Ochre or More Flint. Each rank costs Ochre, scaling 50, 100, 200.
3. **The lineage rack.** Blunt and Edge. Edge is unlocked by clearing the Mammoth Mother once; until then it is visible but greyed with the Firekeeper's line explaining Keys of Ages.

Alegus adds a handprint to his arm on the first Mammoth Mother kill. This is scripted and should be visible in the hub.

---

## 9. Run flow and timing

| Segment | Target time |
|---|---|
| Hearth visit | 45 s to 75 s |
| Rooms 1 to 5 | 4 to 6 min |
| Mammoth Mother | 2 to 3 min |
| Re-forge preview and return | 20 s |
| **Total per run** | **7 to 9 min** |

These come from `tools/run-sim` with the tight scenario. Ten runs is roughly 75 to 90 minutes. That is the playtest session length.

---

## 10. Acceptance criteria

The slice is done when all of these are true on a mid-range PC at 1080p:

- 60 frames per second sustained in all rooms and the boss, with the full render stack on.
- A new player with a controller clears room 1 without instruction.
- A new player dies to the Mammoth Mother on their first attempt and beats her by run five without help.
- Playtesters can name Alegus and describe the Firekeeper unprompted after the session.
- At least one playtester says the age transition wash is the best moment.
- No playtester reports being unable to tell an enemy from the background.
- Zero crashes across ten consecutive runs.

## 11. Playtest questions

Asked after ten runs, in this order:

1. What did you want to do next?
2. Which weapon did you prefer and why?
3. Which enemy did you hate? Was that a good hate or a bad hate?
4. Did you understand why the ice broke in phase 2?
5. Did you ever lose Alegus on screen?
6. Did the art make you want to see the next age?
7. What did the Firekeeper tell you? (Tests whether story lands.)
8. Would you play this again tomorrow?
