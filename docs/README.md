# EPOCH design documents

Planning for a Hades-style action roguelike set across human history, played as Alegus, rendered in 3D watercolour.

Read in this order:

1. [GAME_DESIGN.md](GAME_DESIGN.md), the master design document. Pitch, pillars, narrative, run structure, weapons, Inventions, combat, meta progression, art, technology, milestones, open questions.
2. [ALEGUS.md](ALEGUS.md), the protagonist's character and voice bible.
3. [VERTICAL_SLICE.md](VERTICAL_SLICE.md), the full spec for the first playable: the Stone Age, Ice Age thread.
4. [BOSSES.md](BOSSES.md), the nine launch boss fights.
5. [INVENTIONS.md](INVENTIONS.md), the complete boon catalogue with duos and offer rules.
6. [RENDER_PIPELINE.md](RENDER_PIPELINE.md), the watercolour render stack and the milestone 1 test plan.
7. [PRODUCTION.md](PRODUCTION.md), **the current plan**: who does what, the art answer, the engine, and the eight-rung ladder to a Stone Age release.
8. [ENEMIES.md](ENEMIES.md), rosters for ages 2 to 9 built on eight shared archetypes.
9. [FIREKEEPER_DIALOGUE.md](FIREKEEPER_DIALOGUE.md), the ten hub conversations for the vertical slice.
10. [CAVE_WALL.md](CAVE_WALL.md), the permanent upgrade tree and the Ochre economy.

11. [FAST_PATH.md](FAST_PATH.md), the launch scope decisions and the 14 month plan behind them. Read this second if you only read two.
12. [TONE.md](TONE.md), how the game darkens across the ages and where the warmth goes instead.
13. [WEAPONS.md](WEAPONS.md), the three launch lineages at all five forms, the evolution trades, and the twelve Aspects.
14. [DIFFICULTY.md](DIFFICULTY.md), the Anachronism pact system, the Firekeeper's Hand, and accessibility.
15. [CAST.md](CAST.md), the Cartographer, Archivist and Wren, plus the keepsake system.
16. [ROOMS.md](ROOMS.md), the forty room layouts for ages 2 to 5.
17. [STORY_SCHEDULE.md](STORY_SCHEDULE.md), what unlocks after which run, and what gates it.
18. [WREN_DIALOGUE.md](WREN_DIALOGUE.md), her ten beats and in-run lines, drafted ahead of the recording order.

`tools/run-sim/simulate.js` is a dependency-free Monte Carlo model of a run. It produced the run-length and Ochre numbers quoted in the documents above. Run it with `node tools/run-sim/simulate.js` and re-run it whenever room counts, boss timings, or Ochre values change.

**The first release is the Stone Age alone, built in Godot for Steam by two people and Claude.** Everything else in these documents is design for later. `PRODUCTION.md` is the plan that governs; read it first.

The game does not live in this repository. This repo holds the design documents and the run simulator; the game is built in Unity in its own repository. See the technology section of the master document.
