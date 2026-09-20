# Working title: EPOCH

A Hades-style action roguelike where every run is a sprint through human history. You play **Alegus**, who died at the moment the first fire was lit and now runs the whole timeline again and again. You start each run in the Stone Age with a rock and a stick. Each age you clear evolves your weapon into its next historical form. Between runs you unlock new weapon lineages, new ages, and new story.

Rendered in **3D with a watercolour look**: painted-paper surfaces, bleeding pigment, ink edges, and a camera that reads like a Hades screen.

This document is the planning baseline. It is deliberately opinionated so there is something concrete to argue with. Sections marked **Decision** need a call from you before that part gets built.

---

## 1. Pitch and pillars

**One-liner:** Hades, but the underworld is the timeline.

**Pillars:**

1. **Fast, readable, top-down combat.** Attack, special, cast, dash, call. Every hit has weight. Death comes from being outplayed, never from reading failure. The watercolour look must never cost readability.
2. **Every run is a full arc through history.** Stone Age to the edge of the future in about 45 to 50 minutes. The player always feels the world advancing under their feet.
3. **Your weapon grows with the world.** The club you start with becomes a mace, then a warhammer, then a trench club. Progression inside a run is visible and physical, not just a stat sheet.
4. **Death is the story.** Every failed run sends Alegus back to the hub, where the cast reacts to how he died and what he found. Story is delivered in small, frequent doses, fully voiced.
5. **Builds emerge from Inventions.** The boon system is driven by ideas humanity discovered: Fire, the Wheel, Writing, Gunpowder, the Atom. Combining them is the core creative act of a run.

**Not in scope:** open world, crafting menus, party members, historical accuracy as a goal. History is a flavour engine, not a curriculum.

---

## 2. Narrative frame

**Premise:** Alegus was the first human to carry fire, and he died the night he did it. Instead of passing on, he was caught by **the Loom**, the force that keeps the timeline stitched together. The Loom is fraying. Something at the far end of history, the **Terminus**, is pulling every age toward a single silent point. Alegus is the only thread that can be re-run through the whole weave, again and again, until the fray is found and cut.

Why this frame works:

- It explains why you restart at the Stone Age every run (you always begin at your own death).
- It explains why weapons evolve mid-run (the Loom re-forges your tools as it pushes you forward through each age).
- It gives the hub a natural cast: figures who fell out of time and now live at the edge of the weave.
- It gives the final boss an identity that isn't just "the last historical era".

**Alegus.** Named, voiced, and talkative. He is curious rather than heroic: he has never seen any of this before and says so. His arc across the game is from tourist to custodian. He starts wanting to see what humans became and ends up responsible for whether they get to keep becoming it. Voice direction: dry, warm, quick to wonder, slow to despair. Think Zagreus's energy with less swagger and more awe.

**Hub: The Hearth.** A cave lit by the first fire. Timeless. Cave paintings on the wall serve as the run log and the meta-upgrade tree. Cast members wander in over time as you unlock them.

**Core cast (first pass):**

| Character | Role | Hades analogue |
|---|---|---|
| The Firekeeper | Mentor, gives weapon lineages and lore on each age | Achilles / Nyx |
| The Cartographer | Sells map upgrades, thread choices, run modifiers | Charon |
| Wren | Rival runner from a later age, comic relief, occasional co-op fight | Thanatos / Meg |
| The Archivist | Unlocks story via the codex, tracks kills and discoveries | The Codex / Hypnos |
| The Terminus | Final antagonist, a voice at the end of every run | Hades (the character) |

All cast members are invented. No real historical people appear as characters. Real events and cultures appear as places, enemies, and set dressing.

**Voice plan.** Alegus is the largest role by far. Budget roughly:

| Role | Lines (launch target) |
|---|---|
| Alegus | 2,500 |
| Firekeeper | 900 |
| Cartographer | 500 |
| Wren | 700 |
| Archivist | 400 |
| Terminus | 300 |
| Bosses (barks, intros, defeats) | 60 to 80 each |

Record Alegus in three sessions: combat barks and reactions first (needed for the vertical slice), hub dialogue second, ending and late-game third.

---

## 3. Run structure

A run is a fixed sequence of **Ages** (biomes). Each age has one or more **Threads**: regional variants of that age with their own palette, enemy roster, and boss. On any given run the Cartographer's map shows which thread each age is on. Threads are how the game covers a lot of history without making runs longer.

Room counts are tuned to 36 rooms and a full clear of about 45 to 50 minutes. That is longer than Hades because there are nine bosses instead of four; the simulator in `tools/run-sim` is the source for these numbers and should be re-run whenever room counts or boss timings change.

| # | Age | Rooms | Threads (region variants) | Boss per thread |
|---|---|---|---|---|
| 1 | **Stone Age** | 6 | Ice Age tundra; First villages (Çatalhöyük-style) | The Mammoth Mother; The Harvest Idol |
| 2 | **Age of Rivers** (Bronze) | 5 | Egypt; Mesopotamia; Indus | The Sphinx of Sand; The Bull of Heaven; The Unnamed King |
| 3 | **Age of Empires** (Iron and Classical) | 5 | Greece; Rome; Han China; Persia | The Strategos; The Legate; The Jade General; The Immortal |
| 4 | **Age of Faith and Steel** (Medieval) | 5 | Crusader Europe; Viking North; Mongol Steppe; Sengoku Japan | The Hollow Knight; The Draugr Jarl; The Khan's Shadow; The Masterless |
| 5 | **Age of Sail** (Renaissance, Exploration, Gunpowder) | 4 | Venice; Caribbean; Ottoman siege | The Doge's Automaton; The Admiral; The Bombard |
| 6 | **Age of Revolution** (Enlightenment, Napoleonic, Industrial) | 4 | Paris barricades; Foundry city; American frontier | The Marshal; The Furnace; The Marshal of Iron Rails |
| 7 | **Age of Wars** (1914 to 1945) | 3 | Trenches; Bombed city | The Landship (tank); The Siren (air raid gauntlet) |
| 8 | **Age of Atoms and Stars** (Cold War, space, digital) | 3 | Silo; Launch pad; Server hall | Countdown gauntlet, no single boss |
| 9 | **Terminus** | 1 | A white room with every age layered on top of each other | The Terminus, three-phase final boss |

What this covers that the first draft missed: Egypt, the Indus Valley, Rome, China, Persia, the Vikings, the Mongols, feudal Japan, the Renaissance, the Ottomans, the Enlightenment, the Napoleonic wars, the American frontier, both world wars, the Cold War, the space race, and the digital age. Still absent and worth a thread each later: the Aztec and Inca empires, the Islamic Golden Age, Mali and Great Zimbabwe, the Byzantines, Polynesian navigation, and the Indian empires. These are listed as post-launch threads in section 12.

Rules:

- **Age count grows with progression.** A new player sees ages 1 to 3 and a placeholder ending. Beating an Age of Empires boss for the first time unlocks age 4 for all future runs, and so on. This mirrors how Hades gates Elysium and Styx and keeps early runs short.
- **Thread selection.** At launch, one thread per age is always available and the rest unlock through the Cartographer. Once unlocked, the thread for each age is chosen randomly per run, and the Cartographer sells a one-run override.
- **Room types**, shared across ages and re-skinned: combat, elite combat, mini-boss, shop, Invention altar, fountain (heal), a story room with a cast member, and a challenge room (survive, escort, break the objects).
- **Door choice** shows the reward type ahead, exactly as Hades does. This is the main strategic decision loop and should be copied faithfully.
- **Age transitions** are a short scripted moment: the Loom re-forges Alegus's weapon on screen, the watercolour of the current age runs and bleeds into the palette of the next, the Firekeeper says one line, and Alegus reacts. This is the payoff moment for pillar 3 and should get real animation budget.

**Decision:** Run length. Even with short rooms and short bosses, nine ages puts a full clear near 50 minutes. Merging Wars and Atoms into one age saves about five minutes; cutting to seven ages saves about ten. Recommend shipping nine and revisiting after the alpha 30-run test.

**Decision:** Nine ages with 20-odd threads is a big game. The launch scope recommendation is **one thread per age** (nine bosses), with second and third threads as the post-launch content plan. See section 12.

---

## 4. Weapons

### 4.1 Lineages

Instead of six separate weapons, the player picks a **Lineage** at the start of a run. A lineage is a family of weapons with the same moveset skeleton. Each age you clear evolves it into that age's form. Stats, range, and visuals change. The core inputs and rhythm stay the same, so muscle memory carries across a run.

| Lineage | 1 Stone | 2 Rivers | 3 Empires | 4 Faith and Steel | 5 Sail | 6 Revolution | 7 Wars | 8 Atoms | Style |
|---|---|---|---|---|---|---|---|---|---|
| **Blunt** | Stone club | Bronze mace | Iron flanged mace | Warhammer | Gunner's maul | Steam-piston sledge | Trench club | Powered breaching ram | Slow, heavy, big stagger |
| **Edge** | Flint knife | Khopesh | Gladius | Longsword | Cutlass | Sabre | Trench knife | Ceramic combat blade | Fast combos, parry on special |
| **Reach** | Sharpened spear | Bronze spear | Sarissa | Halberd | Boarding pike | Bayonet rifle | Trench spike | Rail lance | Thrust range, throw on special |
| **Sling** | Stone sling | Bronze javelins | Recurve bow | Crossbow | Musket | Lever-action rifle | Bolt-action and grenades | Coilgun | Ranged, reload rhythm |
| **Guard** | Hide shield and rock | Bronze shield and axe | Hoplon and xiphos | Kite shield and mace | Buckler and pistol | Sapper's plate and pick | Trench shield and club | Riot shield and baton | Block, bash, throw the shield |
| **Twin** | Two hand-axes | Two bronze daggers | Two short swords | Twin flails | Twin flintlocks | Twin revolvers | Twin trench pistols | Twin machine pistols | Highest speed, dash-attack focus |

Each evolution step has a **defining change**, not just bigger numbers. Examples for Blunt:

- Stone club: three-hit combo, third hit knocks back.
- Bronze mace: third hit now stuns.
- Iron mace: special becomes a ground slam with shockwave.
- Warhammer: charged attack added, holds enemies in place.
- Gunner's maul: special fires a point-blank shot, single ammo that reloads over time.
- Piston sledge: every third hit vents steam that burns.
- Trench club: attacks apply Bleed, special is a lunge.
- Breaching ram: charged attack becomes a shield-breaking charge through enemies.

Age 8 forms lean lightly into near-future flavour because Alegus is close to the Terminus and the Loom is fraying. Nothing is magic; it is all plausible equipment.

### 4.2 Aspects

As in Hades, each lineage has 4 **Aspects**, unlocked with a rare meta currency. An aspect changes the whole lineage's identity across every age form. Example for Reach: "Aspect of the Hunter" adds a second thrown spear and a recall dash; "Aspect of the Phalanx" makes the special summon a ghost line of spears.

### 4.3 Unlock order (meta progression)

Blunt is free. The others unlock with **Keys of Ages** earned mostly from first-time age clears and boss kills:

1. Blunt (start)
2. Edge (1 key)
3. Reach (2 keys)
4. Sling (3 keys)
5. Guard (5 keys)
6. Twin (8 keys)

This gives the "unlock newer and better weapons" fantasy at two speeds: inside a run (evolution) and across runs (lineages and aspects).

**Decision:** Do you want a lineage to skip evolution steps? A player who dislikes the Musket form of Sling might want to lock it at Crossbow. Recommend no for the first version; forced evolution keeps runs feeling like history moving on.

---

## 5. Inventions (the boon system)

Boons are **Inventions**, granted at altars by **Inventors**: mythologised spirits of ideas, not real historical people. Each Inventor has a theme and a status effect, and each Invention attaches to one of the five slots: Attack, Special, Cast, Dash, Call.

| Inventor | Theme | Status effect | Signature | First appears |
|---|---|---|---|---|
| **Ember** (fire) | Damage over time | Burn | Attacks ignite; burn spreads on kill | Age 1 |
| **Wheel** | Mobility | Momentum | Dash goes further and deals damage at full speed | Age 1 |
| **Seed** (agriculture) | Sustain | Root | Heals on room clear; rooted enemies take bonus damage | Age 1 |
| **Forge** (metallurgy) | Raw power | Shatter | Flat damage, armour break on heavy hits | Age 1 |
| **Glyph** (writing) | Control | Marked | Marked enemies take crit damage; Cast marks a target | Age 2 |
| **Lens** (astronomy) | Precision and timing | Exposed | Perfect dodge and last-hit bonuses | Age 3 |
| **Salt** (medicine) | Survival | Weakened | Death defiance charges, enemies do less damage | Age 3 |
| **Compass** (navigation) | Positioning | Adrift | Enemies drift toward Cast; dash leaves a beacon you can return to | Age 5 |
| **Powder** (gunpowder) | Burst and area | Primed | Enemies explode on death, Cast becomes a bomb | Age 5 |
| **Press** (printing) | Duplication | Copied | Attacks have a chance to repeat; Call spawns a copy of your last hit | Age 6 |
| **Volt** (electricity) | Chain | Charged | Damage arcs between charged enemies | Age 6 |
| **Atom** | Late-age only | Fission | Stacks build into a large release; only appears in age 8 | Age 8 |

**Duo Inventions** combine two Inventors. Example: Ember and Powder give "Wildfire", which makes exploding enemies leave burning ground. Volt and Compass give "Storm Front", where the beacon pulses lightning. Aim for 25 to 30 duos at launch.

**Legendary Inventions** are a single build-defining pickup per Inventor.

**Age gating** means late altars matter more than early ones and rewards pushing deep. It also naturally teaches new players fewer systems up front.

**Keepsakes** from cast members work as in Hades: a small passive that you can swap at each age boundary.

---

## 6. Combat model

Direct copy of the Hades verb set, since it is proven and the theme does not need to change it:

- **Attack**: lineage-specific combo.
- **Special**: lineage-specific alt (throw, slam, parry, shield bash).
- **Cast**: a thrown **Ember stone** that lodges in the enemy and must be recovered, exactly like the Bloodstone. Inventions modify it.
- **Dash**: universal, with i-frames. Dash-attack and dash-special exist for every lineage.
- **Call**: charged by taking and dealing damage, spends a meter on a big Inventor-themed effect.

**Enemy design rules:**

- Every age introduces one new mechanic that later ages keep. Stone: pack animals that flank. Rivers: shielded enemies that must be hit from behind or shattered. Empires: formations that move as a unit. Faith and Steel: armoured enemies immune to Burn until broken. Sail: ranged enemies with telegraphed reload windows. Revolution: environmental hazards that kill enemies too. Wars: cover that blocks projectiles both ways, and area denial (gas, artillery marks). Atoms: countdown rooms where the objective is to survive or disarm, not to kill.
- Threads within an age share the mechanic but re-skin the roster. Rome's legion and Han's crossbow line are both "formation" enemies with different shapes.
- Enemies from earlier ages never appear in later ages. The world moves on.
- Elite variants get one modifier drawn from a shared pool (armoured, swift, exploding, healing others).

**Difficulty scaling (Anachronism, the Pact of Punishment):** after the first full clear, the player can add **Anachronisms** to a run for better rewards. Each is a break in history: "Enemies carry weapons from one age later", "Bosses have a second health bar", "Rooms are 30% smaller", "No fountains", "Ages 7 and 8 are full length". Anachronism total is the difficulty number for leaderboards and story gates.

---

## 7. Meta progression

| Currency | Source | Spent on |
|---|---|---|
| **Ochre** | Common, every room | The Cave Wall (permanent stat and utility upgrades, the Mirror of Night equivalent) |
| **Keys of Ages** | First-time boss kills, rare room rewards | Lineage unlocks, Cave Wall row unlocks |
| **Amber** | Rare, boss drops and challenge rooms | Aspects, keepsake upgrades |
| **Tallow** | Uncommon, elite kills | Hearth cosmetics and story-unlocking gifts for the cast |
| **Charts** | Boss kills on a thread you have not cleared before | New threads at the Cartographer |
| **Flint** | In-run only, resets | Shops during a run |

**The Cave Wall** has two columns per row like the Mirror, with a toggle between them. Examples: extra death defiance versus bonus damage on first hit; dash i-frame length versus dash count; Ochre gain versus Flint gain.

**Story unlocks** are tied to gifts, run counts, and specific events (first death to each boss, first clear with each lineage, first duo Invention). Aim for the Hades rhythm: something new in the hub after nearly every run for the first 30 runs.

---

## 8. Art direction: 3D watercolour

**Camera.** Fixed three-quarter top-down, roughly 50 degrees, orthographic or near-orthographic. Same framing as Hades so readability rules transfer directly. Full 3D scene: characters, props, and environments are all meshes. This is a change from the Hades approach of 2D sprites over 3D backgrounds, chosen because it makes weapon evolution and age transitions far cheaper to animate and lets one Alegus rig carry every weapon form.

**Watercolour render pipeline.** A non-photorealistic post and material stack:

1. **Paper.** A global paper-grain texture that everything is composited onto, with slight vignette and warm tint. The paper is the same across all ages; only the pigment changes.
2. **Pigment.** Flat-shaded base colours with soft, blotchy lighting quantised to two or three tones. Shadow regions get a hue shift toward a complementary colour, as real watercolour does.
3. **Edge darkening.** A screen-space effect that darkens colour at the boundary of each shape, mimicking pigment pooling at the edge of a wash.
4. **Bleed and wobble.** UV distortion by a low-frequency noise that drifts slowly, so edges never sit perfectly still. Kept subtle in combat, stronger in the hub.
5. **Ink lines.** Thin outline pass for characters and enemies only, not environments. This is the readability guarantee: every hostile thing has an ink edge, backgrounds do not.
6. **Age-transition wash.** At age boundaries, the whole frame runs like a wet painting, pigment drains, and the new age's palette floods in. This same effect at small scale is used for enemy deaths (they dissolve into a wash rather than ragdoll).

**Readability rules that override the look:**

- Enemy attacks telegraph with a hard-edged ink shape on the ground, never a soft wash.
- Alegus, enemies, and projectiles always get the ink outline. Set dressing never does.
- Damage numbers and status icons are flat UI, not painted.
- The bleed effect is disabled on any surface within a fixed radius of Alegus so the play space is crisp.

**References to look at:** Okami for ink and paper; Dordogne for pure watercolour environments; Tchia and Sable for flat-shaded 3D that still reads painterly; Hades 2 for camera and telegraph readability. The target is closer to Dordogne's palette on Sable's rendering approach.

**Palette per age.** The primary tool for "history moving forward":

| Age | Palette |
|---|---|
| Stone | Cold blues, snow whites, one warm orange from firelight |
| Rivers | Ochre, turquoise, black river silt |
| Empires | White marble, deep sea blue, terracotta, Han lacquer red |
| Faith and Steel | Grey stone, stained glass jewel tones, snow and pine for the North |
| Sail | Teal water, tar, brass, powder smoke |
| Revolution | Rust, gaslight yellow, tricolour reds and blues |
| Wars | Mud brown, mustard gas green, searchlight white |
| Atoms | Concrete grey, phosphor green, one hard red warning light |
| Terminus | Unpainted paper with pencil underdrawing showing through |

**Music.** One motif arranged in the instruments of each age. Bone flute and drum in the Stone Age, oud and harp in Rivers, lyre and Chinese guqin in Empires, choir and organ in Faith and Steel, fife and shanty in Sail, brass band and industrial percussion in Revolution, a solo piano over distant artillery in Wars, synths and Geiger clicks in Atoms, then the bone flute alone at the Terminus. Same melody, whole run.

**UI.** Cave painting style in the hub, age-appropriate framing in runs: clay tablet, papyrus, scroll, illuminated manuscript, sea chart, printed broadsheet, telegram, terminal.

---

## 9. Technology

This repository is currently an ARc React boilerplate (React, Webpack, Jest, Storybook). It is not a game engine, and a 3D watercolour game will not live here. The engine choice is driven by the render pipeline.

**Recommended: Unity with the Universal Render Pipeline.** The watercolour look is a custom shader and post-process stack, and Unity has the deepest pool of published non-photorealistic rendering techniques, Shader Graph for iteration, and the most reference material for exactly the effects listed in section 8. It handles console ports and has proven Hades-like projects behind it.

**Alternative: Godot 4.** Free, capable 3D, a good shader language, and rapidly improving. Choose it if licensing cost or open source matter more than tooling maturity. The watercolour stack is achievable but you will be writing more of it yourself.

**Not recommended: Unreal.** Excellent renderer but heavier than this project needs, and its default look fights a flat watercolour style.

**Use of this repo.** Keep it for a companion web tool if useful: a codex viewer, a run planner, or a marketing site. Not for the game.

**First technical milestone is the render test**, not combat. The art style is the biggest unknown, so prove it before anything else.

---

## 10. Milestones

Each milestone is playable or viewable and answers one question.

1. **Watercolour render test** (3 weeks). One static room, one Alegus placeholder model, one enemy, the full shader stack from section 8. Question: does the look work in motion at the target camera, and does it stay readable?
2. **Combat prototype** (4 weeks). One lineage (Blunt), one room, three enemy types, no Inventions, first Alegus combat barks recorded as scratch audio. Question: does the attack, special, dash loop feel good?
3. **Evolution prototype** (3 weeks). Stone club to Bronze mace transition, with the re-forge animation, the age-transition wash, and a Rivers room. Question: does mid-run weapon evolution feel like a reward, or like losing a weapon you liked?
4. **Vertical slice** (10 weeks). Stone Age complete on one thread: 6 rooms, Mammoth Mother boss, four Inventors, Blunt and Edge lineages, a hub with the Firekeeper and Cave Wall, death and restart loop, first Alegus voice session. Question: is one full age fun for ten runs?
5. **Alpha** (6 months). Ages 1 to 5 on one thread each, all six lineages at base aspect, Inventors through Powder, 12 duos, placeholder ending after the Admiral. Question: does progression across 30 runs hold attention?
6. **Beta** (5 months). Ages 6 to 9, Terminus fight, Anachronisms, full cast and story, aspects, keepsakes, music, full voice.
7. **Polish and ship** (3 months).

Total roughly 20 to 22 months for a team of 4 to 6, with a dedicated technical artist from day one. A solo developer should halve the age count and double the timeline.

---

## 11. Open questions

- Nine ages at launch at roughly 50 minutes per clear, or seven at roughly 40?
- Forced evolution, or let players lock a favourite form?
- Unity or Godot.
- Target platform: PC first, or PC and Switch together? Switch affects how heavy the post-process stack can be.
- Tone: Hades is warm and funny. Alegus as written is warm and curious. Does the game stay light through the Age of Wars, or does the tone darken with the history?
- Alegus's origin: is he from a specific real culture, or deliberately pre-cultural since he predates all of them? Recommend pre-cultural; it lets every age be equally foreign to him.

---

## 12. Post-launch thread plan

Second and third threads per age, in rough priority order. Each is one biome skin, one enemy roster, and one boss.

1. Age of Empires: **Mauryan India**
2. Age of Faith and Steel: **Islamic Golden Age** (Baghdad, House of Wisdom)
3. Age of Sail: **Aztec Tenochtitlan** (the conquest, seen from the city)
4. Age of Faith and Steel: **Mali** (Timbuktu, the salt roads)
5. Age of Empires: **Byzantium**
6. Age of Sail: **Polynesian navigation** (open ocean, star paths)
7. Age of Sail: **Inca Andes**
8. Age of Rivers: **Minoan Crete**
9. Age of Revolution: **Meiji Japan**
10. Age of Atoms: **Berlin Wall**
