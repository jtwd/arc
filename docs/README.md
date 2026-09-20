# EPOCH design documents

Planning for a Hades-style action roguelike set across human history, played as Alegus, rendered in 3D watercolour.

Read in this order:

1. [GAME_DESIGN.md](GAME_DESIGN.md), the master design document. Pitch, pillars, narrative, run structure, weapons, Inventions, combat, meta progression, art, technology, milestones, open questions.
2. [ALEGUS.md](ALEGUS.md), the protagonist's character and voice bible.
3. [VERTICAL_SLICE.md](VERTICAL_SLICE.md), the full spec for the first playable: the Stone Age, Ice Age thread.
4. [BOSSES.md](BOSSES.md), the nine launch boss fights.
5. [INVENTIONS.md](INVENTIONS.md), the complete boon catalogue with duos and offer rules.
6. [RENDER_PIPELINE.md](RENDER_PIPELINE.md), the watercolour render stack and the milestone 1 test plan.
7. [PRODUCTION.md](PRODUCTION.md), team, milestone backlogs, risks, and the decisions log.
8. [ENEMIES.md](ENEMIES.md), rosters for ages 2 to 9 built on eight shared archetypes.
9. [FIREKEEPER_DIALOGUE.md](FIREKEEPER_DIALOGUE.md), the ten hub conversations for the vertical slice.
10. [CAVE_WALL.md](CAVE_WALL.md), the permanent upgrade tree and the Ochre economy.

`tools/run-sim/simulate.js` is a dependency-free Monte Carlo model of a run. It produced the run-length and Ochre numbers quoted in the documents above. Run it with `node tools/run-sim/simulate.js` and re-run it whenever room counts, boss timings, or Ochre values change.

The game does not live in this repository. This repo is an ARc React boilerplate and may later host a companion web tool. The engine recommendation is Unity URP; see the technology section of the master document.
