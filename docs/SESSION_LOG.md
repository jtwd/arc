# Session log

`PRODUCTION.md` section 6 asks for a running note of what Edward says in each
session. Taste judgements are easy to make and easy to forget, and they are the
scarcest input on this project.

One entry per session. Keep them short and keep the exact words where they
matter.

---

## Rung 0, art direction review

**Built:** the browser render test, `tools/render-test/index.html`.

**Edward's call:** *"No ink outline or darkening."*

**What it changed.** The ink outline was named in four documents as the
readability guarantee, so it needed replacing rather than deleting. It became a
paper reserve: a ring of bare paper left around each figure, which is how a
painter separates a subject from its ground without drawing a line. It is more
honest to the medium than the ink was, and the Frayed's unstable edge survived
the change for free, since their reserve wobbles where Alegus's is steady.

**Also reported:** the touch controls were unusable and the page selected text
and zoomed on mobile. The d-pad was the wrong control and was replaced with a
floating thumbstick. Recorded as a general finding in `DIFFICULTY.md`, since it
applies to any touch build.

---

## Rung 1, Godot port

**Built:** `game/`, the render stack in Godot 4. Walk one room, run the age
transition, toggle each pass.

**Open, and needed from this session:**

1. Does it read as paint in motion, at 60 frames per second?
2. Does the reserve earn its place? Turn it off and see.
3. Is the age transition worth real animation budget?
4. Anything on the failure list in `game/README.md`, which is the part Claude
   could not verify.

**Reported:** it does not hold 60 frames per second.

**Diagnosed before changing anything.** Counting the per-frame work showed the
world was 82% of the geometry cost and was being fully re-tessellated sixty
times a second, while the render spec only drifts the wobble at 0.15 Hz. That
is roughly a sixfold waste on the largest item in the frame.

**Cut.** The world now renders into its own SubViewport and is baked ten times
a second instead of sixty. Subdivision scales with shape size rather than
sitting at five for everything. The pigment bands allocate one point array
instead of two. Centre and radius come from the control points rather than the
smoothed outline. The paper grain is baked into a tiling texture once at
startup instead of being hashed per pixel per frame, and the reserve takes
eight samples instead of twelve. Together that is about a 3.2x cut in CPU
geometry before the shader savings.

**Instrumented,** so the next report is diagnostic rather than binary: the
readout gives frame time, script time, world bake time and rate, figure time
and shape count, and there are switches to turn each layer off and bisect.

**Still open:** whether that was enough. Claude still cannot run it.

**Correction, same session.** The first ask back was a bisect table: turn eight
switches on and off by hand, read four numbers each time, report. That is not a
reasonable thing to ask of a team with twelve hours a week, and James said so.
Replaced with a single button that runs the whole bisect automatically and
prints one block to paste back.

Worth keeping as a rule: when Claude needs information from a human, it should
cost them one action, not a procedure.
