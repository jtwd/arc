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

**Second correction.** James is on a **Chromebook**, which Claude never asked
about before recommending Godot and an engine download. That reopens the engine
and platform decision, recorded as open in `PRODUCTION.md`.

It also means the "does not hold 60" report was almost certainly about the
**browser prototype**, since Godot was never installed. The same flaw was in
both copies, so the world baking, the benchmark and the cheaper geometry are now
in the browser build as well. The browser build can answer rung 1's question on
the actual hardware today, with nothing to install.

A rule worth keeping alongside the first: **ask what the machine is before
recommending a toolchain.**

**Decided:** build in the browser now, Steam eventually. Claude publishes each
build as a link, James opens it on the Chromebook and plays, nothing is
installed. The Godot port is parked rather than deleted. `PRODUCTION.md` 7a
carries the six rules that keep a Steam wrap cheap later.

---

## Rung 2, the combat gate

**Built:** dash with ten invulnerable frames, health and death and restart, hard
edged ground telegraphs, and the three Stone Age enemies from
`VERTICAL_SLICE.md` section 3 with the behaviour each one exists to teach.

- **Wolf** flanks and circles, so keep moving.
- **Boar** warns for 0.8 seconds, commits to a direction, charges, and is
  stunned for over a second if it hits a wall. A stunned boar takes triple
  damage. Patience beats aggression, and that is the lesson of the age.
- **Hunter** holds 150 to 230 pixels, backs away when crowded, and is open only
  during the long recovery after a throw.

**This is the gate.** `PRODUCTION.md` says that if the combat does not feel
good, the project stops or changes here, and that the call is Edward's.

**Wanted, and not "it is fine":** which enemy he hated and whether that was a
good hate or a bad one, and whether he ever died feeling it was not his fault.

**Reported:** the boar, the wolves and Alegus all needed to look better, and
the movement needed real work.

**Fair.** The first pass was placeholder shapes with one sine wave per limb. The
rebuild is in `CHARACTER_RIGS.md`: two bones and a flat foot on every limb,
counter-rotating shoulders and head, hair on a spring, per-creature gaits (the
wolf trots on diagonal pairs, the boar gallops when charging), and silhouettes
built from mass distribution rather than scale. The boar had been a bigger wolf
with tusks, which is why it did not read.

Also added hit-stop and squash on contact, eased turning and gait, and a
half-opacity tell during the dash's invulnerable frames.

Paid for by removing a canvas clip from the paint routine and skipping the wet
bleed on parts too small to show it.

**Reported:** movement much better, but the faces need more detail.

**Done, with a design answer rather than more shapes.** Alegus gets a full face
whose brow carries the character, expressions tied to what he is doing, a blink,
and a head that turns toward the nearest Frayed. The Frayed get the features
they lost: voids of bare paper where eyes were, a jaw opening on nothing. That
is `ALEGUS.md` beat 8 rather than a small-size compromise.

**Flagged:** at 960 by 600 a head is 25 pixels and a feature is three, so faces
are inherently marginal in play. Added a model sheet at 1.75x under the play
area so the design can be judged at all, and noted that a 1920 by 1080 shipping
resolution doubles every face.

**Edward's call:** *(to fill in)*
