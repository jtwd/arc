# Working title: EPOCH

A Hades-style action roguelike where every run is a sprint through human history. You start each run in the Stone Age with a rock and a stick, and you fight your way forward through the ages. Each era you clear evolves your weapon into its next historical form. Between runs you unlock new weapon lineages, new eras, and new story.

This document is the planning baseline. It is deliberately opinionated so there is something concrete to argue with. Sections marked **Decision** need a call from you before that part gets built.

---

## 1. Pitch and pillars

**One-liner:** Hades, but the underworld is the timeline.

**Pillars** (borrowed from what makes Hades work, adapted to the theme):

1. **Fast, readable, top-down combat.** Attack, special, cast, dash, call. Every hit has weight. Death comes from being outplayed, never from reading failure.
2. **Every run is a full arc through history.** Stone Age to the modern day in 25 to 35 minutes. The player always feels the world advancing under their feet.
3. **Your weapon grows with the world.** The club you start with becomes a mace, then a flail, then a warhammer. Progression inside a run is visible and physical, not just a stat sheet.
4. **Death is the story.** Every failed run sends you back to the hub, where the cast reacts to how you died and what you found. Story is delivered in small, frequent doses.
5. **Builds emerge from Inventions.** The boon system is driven by ideas humanity discovered: Fire, the Wheel, Writing, Gunpowder. Combining them is the core creative act of a run.

**Not in scope:** open world, crafting menus, party members, historical accuracy as a goal. History is a flavour engine, not a curriculum.

---

## 2. Narrative frame

**Premise:** The player is a nameless human who died at the very dawn of history, at the moment the first fire was lit. Instead of passing on, they were caught by **the Loom**, a force that keeps the timeline stitched together. The Loom is fraying. Something at the far end of history, the **Terminus**, is pulling every era toward a single silent point. The player is the only thread that can be re-run through the whole weave, again and again, until the fray is found and cut.

Why this frame works:

- It explains why you restart at the Stone Age every run (you always begin at your own death).
- It explains why weapons evolve mid-run (the Loom re-forges your tools as it pushes you forward through each era).
- It gives the hub a natural cast: figures who fell out of time and now live at the edge of the weave.
- It gives the final boss an identity that isn't just "the last historical era".

**Hub: The Hearth.** A cave lit by the first fire. Timeless. Cave paintings on the wall serve as the run log and the meta-upgrade tree. Cast members wander in over time as you unlock them.

**Core cast (first pass):**

| Character | Role | Hades analogue |
|---|---|---|
| The Firekeeper | Mentor, gives weapon lineages and lore on each era | Achilles / Nyx |
| The Cartographer | Sells map upgrades, era-skip tokens, run modifiers | Charon |
| Pytheas the Wanderer | Comic relief, rival runs, occasional co-op fight in an era | Thanatos / Meg |
| The Archivist | Unlocks story beats via a codex, tracks kills and discoveries | The Codex / Hypnos |
| The Terminus | Final antagonist, voice at the end of every run | Hades (the character) |

**Decision:** Is the protagonist a fixed character with a voice, or a silent avatar? Hades gets a lot of mileage from Zagreus talking back. Recommend a voiced, named protagonist.

---

## 3. Run structure

A run is a fixed sequence of **Eras** (biomes). Each era is a set of hand-authored rooms drawn randomly, ending in a boss.

| # | Era | Rooms | Visual identity | Boss |
|---|---|---|---|---|
| 1 | **Stone Age** | 8 to 10 | Tundra, caves, tar pits, aurora skies | The Mammoth Mother, a wounded mammoth wrapped in the first hunters' spears |
| 2 | **Bronze Age** | 8 to 10 | Ziggurats, river deltas, burning reed fields | The Bull of Heaven, a bronze automaton bull from a lost temple |
| 3 | **Classical** | 8 to 10 | Marble colonnades, sea cliffs, arenas | The Strategos, a phalanx commander who fights with his formation as a single unit |
| 4 | **Medieval** | 8 to 10 | Castle courtyards, plague-lit villages, cathedral scaffolds | The Hollow Knight, a suit of armour animated by a whole crusade's oaths |
| 5 | **Gunpowder** | 6 to 8 | Ship decks, powder magazines, siege lines | The Admiral, a duel on a sinking ship with cannon timing |
| 6 | **Industrial** | 4 to 6 (short, like Temple of Styx) | Foundries, rail yards, smog | Gauntlet, no single boss: the Furnace, a survival room against waves |
| 7 | **Terminus** | 1 | A white room with every era layered on top of each other | The Terminus, three-phase final boss |

Rules:

- **Era count grows with progression.** A new player sees eras 1 to 3 and a placeholder ending. Beating the Strategos for the first time unlocks the Medieval era for all future runs, and so on. This mirrors how Hades gates Elysium and Styx and keeps early runs short.
- **Room types**, shared across eras and re-skinned: combat, elite combat, mini-boss, shop, Invention altar, fountain (heal), a story room with a cast member, and a challenge room (survive, escort, break the objects).
- **Door choice** shows the reward type ahead, exactly as Hades does. This is the main strategic decision loop and it should be copied faithfully.
- **Era transitions** are a short scripted moment: the Loom re-forges your weapon on screen, the Firekeeper says one line about the era ahead, and the palette shifts. This is the payoff moment for pillar 3 and should get real animation budget.

**Decision:** Seven eras is a lot of content. If scope is tight, cut Gunpowder and fold cannons into the Industrial gauntlet. Recommend building 1 to 4 first and adding 5 to 7 after the vertical slice.

---

## 4. Weapons

### 4.1 Lineages

Instead of six separate weapons, the player picks a **Lineage** at the start of a run. A lineage is a family of weapons with the same moveset skeleton. Each era you clear evolves it into that era's form. Stats, range, and visuals change. The core inputs and rhythm stay the same, so muscle memory carries across a run.

| Lineage | Stone Age | Bronze | Classical | Medieval | Gunpowder | Industrial | Style |
|---|---|---|---|---|---|---|---|
| **Blunt** | Stone club | Bronze mace | Iron flanged mace | Warhammer | Pistol-butt hammer | Sledge with steam piston | Slow, heavy, big stagger |
| **Edge** | Flint knife | Bronze sickle sword | Gladius | Longsword | Sabre | Bayonet | Fast combos, parry on special |
| **Reach** | Sharpened spear | Bronze spear | Sarissa | Halberd | Pike | Trench spike on a rifle | Thrust range, spear throw on special |
| **Sling** | Stone sling | Bronze javelins | Recurve bow | Crossbow | Musket | Bolt-action rifle | Ranged, reload rhythm |
| **Guard** | Hide shield and rock | Bronze shield and axe | Hoplon and xiphos | Kite shield and mace | Buckler and pistol | Riot plate and baton | Block, bash, throw the shield |
| **Twin** | Two hand-axes | Two bronze daggers | Two short swords | Twin flails | Twin pistols | Twin revolvers | Highest speed, dash-attack focus |

Each evolution step has a **defining change**, not just bigger numbers. Examples for Blunt:

- Stone club: three-hit combo, third hit knocks back.
- Bronze mace: third hit now stuns.
- Iron mace: special becomes a ground slam with shockwave.
- Warhammer: charged attack added, holds enemies in place.
- Pistol-butt hammer: special fires a point-blank shot, single ammo that reloads over time.
- Piston sledge: every third hit vents steam that burns.

### 4.2 Aspects

As in Hades, each lineage has 4 **Aspects**, unlocked with a rare meta currency. An aspect changes the whole lineage's identity. Example for Reach: "Aspect of the Hunter" adds a second thrown spear and a recall dash; "Aspect of the Phalanx" makes the special summon a ghost line of spears.

### 4.3 Unlock order (meta progression)

Blunt is free. The others unlock with **Keys of Ages** earned mostly from first-time era clears and boss kills:

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

| Inventor | Theme | Status effect | Signature |
|---|---|---|---|
| **Ember** (fire) | Damage over time | Burn | Attacks ignite; burn spreads on kill |
| **Wheel** | Mobility | Momentum | Dash goes further and deals damage at full speed |
| **Seed** (agriculture) | Sustain | Root | Heals on room clear; rooted enemies take bonus damage |
| **Glyph** (writing) | Control | Marked | Marked enemies take crit damage; Cast marks a target |
| **Forge** (metallurgy) | Raw power | Shatter | Flat damage, armour break on heavy hits |
| **Lens** (astronomy) | Precision and timing | Exposed | Perfect dodge and last-hit bonuses |
| **Salt** (medicine) | Survival | Weakened | Death defiance charges, enemies do less damage |
| **Powder** (gunpowder) | Burst and area | Primed | Enemies explode on death, Cast becomes a bomb |
| **Steam** | Late-era only | Pressure | Stacks build into a large release; only appears in eras 5+ |

**Duo Inventions** combine two Inventors. Example: Ember and Powder give "Wildfire", which makes exploding enemies leave burning ground. Aim for 20 to 25 duos at launch.

**Legendary Inventions** are a single build-defining pickup per Inventor.

**Era gating:** Inventors are not all available from room one. Ember, Wheel, Seed, and Forge appear from the Stone Age. Glyph and Lens arrive in Bronze. Powder arrives in Gunpowder, Steam in Industrial. This means late-era altars matter more than early ones and rewards pushing deep. It also naturally teaches new players fewer systems up front.

**Keepsakes** from cast members work as in Hades: a small passive that you can swap at each era boundary.

---

## 6. Combat model

Direct copy of the Hades verb set, since it is proven and the theme does not need to change it:

- **Attack**: lineage-specific combo.
- **Special**: lineage-specific alt (throw, slam, parry, shield bash).
- **Cast**: a thrown **Ember stone** that lodges in the enemy and must be recovered, exactly like the Bloodstone. Inventions modify it.
- **Dash**: universal, with i-frames. Dash-attack and dash-special exist for every lineage.
- **Call**: charged by taking and dealing damage, spends a meter on a big Inventor-themed effect.

**Enemy design rules:**

- Every era introduces one new mechanic that later eras keep. Stone Age: pack animals that flank. Bronze: shielded enemies that must be hit from behind or shattered. Classical: formations that move as a unit. Medieval: armoured enemies immune to Burn until broken. Gunpowder: ranged enemies with telegraphed reload windows. Industrial: environmental hazards that kill enemies too.
- Enemies from earlier eras never appear in later eras. The world moves on.
- Elite variants get one modifier drawn from a shared pool (armoured, swift, exploding, healing others).

**Difficulty scaling (Anachronism, the Pact of Punishment):** after the first full clear, the player can add **Anachronisms** to a run for better rewards. Each is a break in history: "Enemies carry weapons from one era later", "Bosses have a second health bar", "Rooms are 30% smaller", "No fountains", "Era 6 is a full era, not a gauntlet". Anachronism total is the difficulty number for leaderboards and story gates.

---

## 7. Meta progression

| Currency | Source | Spent on |
|---|---|---|
| **Ochre** | Common, every room | The Cave Wall (permanent stat and utility upgrades, the Mirror of Night equivalent) |
| **Keys of Ages** | First-time boss kills, rare room rewards | Lineage unlocks, Cave Wall row unlocks |
| **Amber** | Rare, boss drops and challenge rooms | Aspects, keepsake upgrades |
| **Tallow** | Uncommon, elite kills | Hearth cosmetics and story-unlocking gifts for the cast |
| **Flint** | In-run only, resets | Shops during a run |

**The Cave Wall** has two columns per row like the Mirror, with a toggle between them. Examples: extra death defiance versus bonus damage on first hit; dash i-frame length versus dash count; Ochre gain versus Flint gain.

**Story unlocks** are tied to gifts, run counts, and specific events (first death to each boss, first clear with each lineage, first duo Invention). Aim for the Hades rhythm: something new in the hub after nearly every run for the first 30 runs.

---

## 8. Art and audio direction

- **Camera:** fixed three-quarter top-down, 2D hand-drawn characters over painted 3D-lit backgrounds, same as Hades. This is the cheapest way to get the look and the readability.
- **Palette shift per era** is the primary tool for "history moving forward". Stone Age is cold blues and firelight. Bronze is ochre and turquoise. Classical is white marble and sea. Medieval is grey stone and stained glass. Gunpowder is tar, brass, and powder smoke. Industrial is rust and gaslight.
- **Weapon evolution animation** at era boundaries is the signature visual. Budget it like a boss intro.
- **Music:** one motif that is arranged in the instruments of each era. Bone flute and drum in the Stone Age, lyre in Classical, choir and organ in Medieval, brass and fife in Gunpowder, industrial percussion at the end. Same melody, whole run. This is cheap to write and very memorable.
- **UI:** cave painting style in the hub, era-appropriate framing in runs (clay tablet, papyrus, illuminated manuscript, printed broadsheet, telegraph strip).

---

## 9. Technology

This repository is currently an ARc React boilerplate (React, Webpack, Jest, Storybook). It is not a game engine. Two realistic routes:

**Route A, recommended: Godot 4 in a new repo.** 2D-first engine with a built-in physics layer, tilemaps, animation tools, and a scripting language that suits rapid iteration. Free, exports to desktop and consoles via partners. Best fit for a Hades-like from a small team.

**Route B: browser prototype in this repo.** Add Phaser 3 or PixiJS as a dependency, mount the canvas inside a React shell, use React for menus, the hub, the codex, and the Cave Wall. Good for a fast playable prototype to test combat feel and the evolution idea, and it fits the existing tooling. Would not be the shipping engine.

Recommendation: do Route B for a 2 to 4 week combat prototype (one lineage, one era, one boss) to validate the evolution mechanic, then move to Route A once the core loop is proven.

**Decision:** Which route, and is there a target platform (PC, Switch, browser) that forces the choice?

---

## 10. Milestones

Each milestone is playable and answers one question.

1. **Combat prototype** (4 weeks). One lineage (Blunt), one room, three enemy types, no Inventions. Question: does the attack, special, dash loop feel good?
2. **Evolution prototype** (3 weeks). Stone Age club to Bronze mace transition, with the re-forge animation and a Bronze room. Question: does mid-run weapon evolution feel like a reward, or like losing a weapon you liked?
3. **Vertical slice** (10 weeks). Stone Age era complete: 8 rooms, Mammoth Mother boss, four Inventors, Blunt and Edge lineages, a hub with the Firekeeper and Cave Wall, death and restart loop. Question: is one full era fun for ten runs?
4. **Alpha** (5 months). Eras 1 to 4, all six lineages at base aspect, all Inventors except Steam, 10 duos, placeholder ending after the Hollow Knight. Question: does progression across 30 runs hold attention?
5. **Beta** (4 months). Eras 5 to 7, Terminus fight, Anachronisms, full cast and story, aspects, keepsakes, music.
6. **Polish and ship** (3 months).

Total roughly 16 to 18 months for a team of 3 to 5. A solo developer should halve the era count and double the timeline.

---

## 11. Open questions

- Protagonist: voiced and named, or silent?
- Era count: 7 as written, or 5 to protect scope?
- Forced evolution, or let players lock a favourite form?
- Engine route and target platform.
- Tone: Hades is warm and funny. Does EPOCH keep that, or lean more solemn given it is about all of human history ending?
- Real historical figures as cast members (Pytheas is a real name) versus fully invented ones. Invented is safer and easier to write.
