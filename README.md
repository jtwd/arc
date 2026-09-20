# EPOCH

Design documentation for a Hades-style action roguelike in which every level is a different point in history.

You play **Alegus**, who died the night he carried the first fire and was caught by the Loom, the force that keeps the timeline stitched together. Something at the far end of history is pulling the weave apart. Every run begins in the Stone Age and pushes forward through the ages, and each age you clear re-forges your weapon into its next historical form. A stone club becomes a bronze mace, then a warhammer, then a flintlock. Rendered in 3D with a watercolour look.

**Launch scope:** five ages plus the final boss, three weapon lineages, Steam on Windows, built in Unity. Roughly 14 months for a team of four to five. The full nine-age design is the post-launch roadmap.

## What is here

This repository holds planning only. The game is built in Unity in its own repository.

| Path | Contents |
|---|---|
| `docs/` | The design documents. Start at [docs/README.md](docs/README.md) |
| `tools/run-sim/` | A dependency-free Monte Carlo model of a run |
| `tools/render-test/` | The interactive art-direction test. Open `index.html` in a browser |

Start with [docs/GAME_DESIGN.md](docs/GAME_DESIGN.md) for the design, then [docs/FAST_PATH.md](docs/FAST_PATH.md) for what ships first and why.

## The render test

`tools/render-test/index.html` is a single self-contained page. Open it in any browser, move Alegus with the arrow keys, attack with space, and toggle the render passes. On a touch screen, drag anywhere on the left of the frame for a floating thumbstick and tap the right to attack.

It is Canvas 2D approximating the look rather than the real shader stack, so treat it as a floor and not a ceiling. It exists to answer the one question a still image cannot: whether the watercolour direction holds up in motion. It did, and the first review cut the ink outline and edge darkening on the strength of it. A paper reserve carries the readability instead.

## The run simulator

`tools/run-sim/simulate.js` models room types, door choice, player skill, and the Ochre economy across a run. It produced the run-length and currency numbers quoted throughout the documents, and it is what showed the original nine-age design came to 75 minutes per clear rather than the 30 to 40 the pitch claimed.

```
node tools/run-sim/simulate.js [runs] [profile] [--scenario=launch|tight|baseline]
```

Profiles are `new`, `mid`, `expert`, or `all`. The default scenario is `launch`, the five-age shipping scope. Re-run it whenever room counts, boss timings, or Ochre values change.

## History

This repository previously held [ARc](https://github.com/diegohaz/arc), a React boilerplate, which has been removed. That code is still in the history and on the default branch.
