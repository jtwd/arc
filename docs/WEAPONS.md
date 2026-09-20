# Launch lineages, forms, and Aspects

The three launch lineages at all five forms, with the defining change each evolution makes, the trades that make holding a form worth doing, frame data for Sling, and the twelve launch Aspects.

Blunt and Edge frame data at their Stone Age form is in `VERTICAL_SLICE.md` section 6 and is not repeated here.

---

## 1. The trade rule

`GAME_DESIGN.md` 4.4 lets players refuse a re-forge and hold the form they have. That feature is decorative unless holding is sometimes genuinely correct, which means **some forms must trade rather than add**.

A trade takes away something reliable and gives back something stronger but conditional. Each lineage gets exactly one, and they sit at different points so holding is a live decision at more than one boundary.

| Lineage | Trade sits at | What is given up | What is gained |
|---|---|---|---|
| Edge | Form 3, Gladius | The five-hit chain, shortened to four | A finisher that steps forward and hits far harder |
| Sling | Form 4, Crossbow | Variable draw, so no more quick partial shots | Much higher fixed damage |
| Blunt | Form 5, Gunner's maul | The reliable ground slam special | A point-blank shot on a single reloading charge |

Everything else adds. One trade per lineage is the target; more than that and evolution stops reading as a reward.

---

## 2. Blunt

Slow, heavy, big stagger. The free starting lineage.

| Age | Form | Defining change |
|---|---|---|
| 1 | Stone club | Three-hit combo. Third hit knocks back |
| 2 | Bronze mace | Third hit now stuns instead of only knocking back |
| 3 | Iron flanged mace | Special becomes a ground slam with a shockwave ring |
| 4 | Warhammer | Charged attack added. Holds enemies in place on hit |
| 5 | Gunner's maul | **Trade.** Special is now a point-blank shot, one charge, reloads over 8 s. The ground slam is gone |

**Why anyone holds Blunt.** The warhammer is the peak for most players. The Gunner's maul's shot is stronger than the slam but it runs out, and a player built around reliable crowd control will refuse the fifth re-forge on purpose.

---

## 3. Edge

Fast combos, parry on special.

| Age | Form | Defining change |
|---|---|---|
| 1 | Flint knife | Five-hit chain. Special is a parry |
| 2 | Khopesh | A successful parry now also hooks the enemy and pulls them in |
| 3 | Gladius | **Trade.** Chain shortens to four hits, each hitting harder, finisher steps forward |
| 4 | Longsword | Hold attack becomes a long thrust with extended reach |
| 5 | Cutlass | Parry window shortens, but a successful parry triggers an automatic riposte |

**Why anyone holds Edge.** The chain length is the most "feel" thing a combo weapon has. A player who has learned the flint knife's five-hit rhythm may not want the gladius's four, and holding at the Khopesh keeps that rhythm with the hook attached. The cost is the thrust and the riposte, which is a real cost.

---

## 4. Sling

Ranged, reload rhythm. Unlocks for 3 Keys of Ages.

| Age | Form | Defining change |
|---|---|---|
| 1 | Stone sling | Wind up, then fire. No ammo limit. Alegus can walk at 60% speed while winding |
| 2 | Bronze javelins | Shots pierce the first enemy hit |
| 3 | Recurve bow | Hold to draw. Damage and speed scale with draw, and a partial draw is a fast weak shot |
| 4 | Crossbow | **Trade.** No draw. Fixed high damage with a 1.4 s reload after each shot |
| 5 | Musket | Special becomes a bayonet thrust, so the lineage gains a real melee answer |

**Why anyone holds Sling.** The recurve bow is the only form with a spectrum: a player can tap for chip damage at close range and hold for a heavy shot at distance. The crossbow removes that choice in exchange for raw numbers. Holding at the bow costs the bayonet, which is the lineage's only good answer to something standing on top of you.

### 4.1 Sling frame data, Stone sling

Frames at 60 per second, matching the format in `VERTICAL_SLICE.md` section 6. Starting points for the prototype, expected to move.

| Move | Startup | Active | Recovery | Damage | Notes |
|---|---|---|---|---|---|
| Attack | 20 wind | projectile | 12 | 18 | Movement allowed at 60% speed during wind. Releasing early does nothing; the wind must complete |
| Special | 14 | 10 | 22 | 30 | Spin. 360 degree sweep at 2 unit range, knocks back. The panic button for enemies in melee |
| Dash attack | 8 | projectile | 10 | 14 | Quick shot, no wind, shorter range |
| Dash special | 10 | 8 | 16 | 25 | Spin at the end of the dash |
| Cast | 8 | projectile | 16 | 50 | Ember stone, identical to every lineage |

Design goals: the wind-up is the whole identity. A Sling player is always deciding whether they have time. The special exists so that decision is never fatal, and it is deliberately weak so that melee is a retreat, not a plan.

Later forms change the attack row only. The bow's draw replaces the wind, the crossbow replaces it with a post-shot reload, and the musket keeps the reload while the special becomes the bayonet.

---

## 5. Aspects

Four per lineage. The first is the base and exists so that Amber always has somewhere to go; the other three change what the lineage is. An Aspect applies across every form, held or evolved.

Each has five ranks. Cost in Amber: 1, 2, 3, 4, 5, so fifteen to max one Aspect. Unlocking an Aspect at all costs 3 Amber at the lineage rack.

### Blunt

| Aspect | Effect | Identity |
|---|---|---|
| **Aspect of Alegus** | +4% damage per rank | The base. No change in behaviour |
| **Aspect of the Quarry** | Every third hit cracks the floor, leaving a 2 unit hazard for 4 s that deals 8 damage per second, +2 per rank | Rewards standing your ground and fighting in one place |
| **Aspect of the Bell** | Knockback becomes a stagger ring that hits everything within 4 units. Attack damage reduced 25% | Crowd control over single-target. Turns Blunt into a room-clearing weapon |
| **Aspect of the Mountain** | Attacks are 20% slower and cannot be interrupted. Damage taken while attacking reduced 30%, +4% per rank | Trades mobility for armour. The answer to being surrounded |

### Edge

| Aspect | Effect | Identity |
|---|---|---|
| **Aspect of Alegus** | +4% damage per rank | The base |
| **Aspect of the Thread** | A successful parry marks the attacker. The next hit on a marked enemy is a guaranteed critical for 200%, +20% per rank | Parry into burst. Rewards playing the special as the primary move |
| **Aspect of the Wound** | Attacks deal 40% less direct damage but apply a stacking bleed of 5 per second for 6 s, +1 per rank. Stacks do not expire while the chain continues | The chain becomes about accumulation rather than impact. Strong on bosses, weak on crowds |
| **Aspect of the Mirror** | Special becomes a counter-stance. Holding it for up to 1 s absorbs one attack and replays it at the attacker for 150% of its damage, +15% per rank | The highest-skill Aspect in the game. Useless against enemies that do not attack |

### Sling

| Aspect | Effect | Identity |
|---|---|---|
| **Aspect of Alegus** | +4% damage per rank | The base |
| **Aspect of the Horizon** | Shots pierce all enemies and gain 50% range. Damage falls off by 40% within 4 units, reduced by 6% per rank | Pure sniper. Punishes being approached, which the lineage already struggles with |
| **Aspect of the Flock** | One attack fires three projectiles in a 20 degree spread at 45% damage each, +3% per rank | A shotgun. Reverses the lineage: strongest at the range it was worst at |
| **Aspect of the Tether** | Shots leave a line back to Alegus for 3 s. Enemies crossing a line take 20 damage, +4 per rank, once per line | Zone control. Pairs hard with Compass Inventions and with beacons |

Twelve Aspects at launch. Reach, Guard, and Twin bring twelve more post-launch.

---

## 6. Open

- Whether holding a form should interact with Aspects at all. Current answer is no: an Aspect applies to whatever form is held, unchanged. Revisit if milestone 3 shows a combination that trivialises an age.
- Whether the base Aspect should be free rather than costing 3 Amber to unlock. Free is friendlier; a cost makes the first Amber decision meaningful. Decide at alpha.
