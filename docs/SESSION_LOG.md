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

---

## Rung 3, a run

**Built:** six rooms, a door choice after each, and five layouts on rotation.

The door choice is the strategic loop of the whole game, so it is built the way
`GAME_DESIGN.md` section 3 specifies: two or three doors rise when a room
clears, each showing what is behind it before you commit. Ochre, a heal, or an
idea, which does nothing yet because Inventions are rung 4 and it says so.

**Layouts change how the fight works, not how it looks**, which is the test of
whether a room is a room or a repaint:

| Layout | What it does |
|---|---|
| Kill site | One piece of cover in the open |
| Ice shelf | A crevasse costing 15 health and putting you back on the edge |
| Snow hollow | Three pillars, and a charging boar knocks itself out on them |
| Frozen river | The dash overshoots badly on ice |
| Tar pit | Everything inside is slowed, them included |

The boar knocking itself out on a pillar was worth the wiring: it means a room
with cover hands you the punish window rather than hiding it.

**Wanted:** whether the rooms genuinely play differently, and whether the door
choice is ever hard. If it is obvious every time, the rewards are too
comparable and need changing.

---

## Rung 4, Inventions

**Built:** the twenty Stone Age boons from `VERTICAL_SLICE.md` section 7, four
Inventors, altars offering three from one of them, and rarity.

Rung 4 needed three verbs the prototype did not have, so those came first.
**Special** is the Blunt ground slam on its real frame data, 22 startup, 10
active, 30 recovery. **Cast** is the Ember stone: one stone, it lodges in what
it hits and has to be fetched back, because a Cast is a loan rather than a
spell. **Call** is a meter that fills from damage dealt and is spent on whatever
Call boon you took, so an empty Call slot means no Call at all.

Three statuses came with them: Burn, Root and Shatter. Burn shows on the body
rather than as an icon, by running the paint warm.

**One decision worth keeping.** Boon effects are checked by id at the point they
apply rather than installed as closures. More typing, far easier to read, and it
matters once the list reaches a hundred.

**Wanted:** whether a run gets a shape. Two Ember runs and two Forge runs should
feel like different games rather than the same game with bigger numbers. And
whether fetching the stone is a cost or a chore.

**Edward's call:** *"They don't. Make them stranger. It is a cost."*

---

## Rung 4b, stranger Inventions

**The diagnosis.** Almost every boon in the first pass was a percentage, and a
percentage cannot change how you play. Rewrote all twenty against one rule, now
recorded at the top of `INVENTIONS.md`: **a boon changes what a verb does, not
how much it does.** If it can be written as a number and a percent sign it is
not finished.

Each Inventor got an identity that the boons actually enforce:

| Inventor | What a run with it becomes |
|---|---|
| Ember | Fire spreads between them, persists on the floor, and the slam detonates it |
| Wheel | Every boon removes a reason to stand still; the first swing out of a dash has no wind-up |
| Seed | Delayed and positional; seeds burst where the fight was three seconds ago |
| Forge | Slow and committed; the slam raises cover, and Quench deals what the room has cost you |

Added the two slice duos, which only appear once a run holds both Inventors, so
committing to two themes is told rather than merely allowed.

**The stone stays a cost**, confirmed. Coal and Taproot now make it burn or root
where it lies, so leaving it out there is sometimes the better play. That turns
the retrieval cost into a decision instead of a tax.

**Wanted next:** not which boon is strongest, but which combination made him
change how he was playing halfway through a run.

---

## Rung 5, the Mammoth Mother

**Built:** the boss from `BOSSES.md` 1 and `VERTICAL_SLICE.md` 5. Fourteen
hundred health across three phases, on the frozen lake, as the sixth room.

The rule the fight is built on is that **every phase takes something away from
you**, rather than adding health:

| Phase | What it takes |
|---|---|
| 1, to 65% | Your patience. Slow telegraphs, and the four spears teach that weak points take double |
| 2, to 30% | Your footing. The lake cracks into floes with open water between them, reusing the Ice Shelf room's crevasse rule |
| 3, to 0 | Your space. She stops moving entirely and everything becomes area denial, so the spears are now the only way through: all four inside six seconds and she falters |

Phase 1 exists to teach the thing phase 3 requires, which is why the spears had
to be readable from the start.

**One design correction during the build.** The spears began as points to hit,
and she is far too tall for a man with a club to aim up her side. They are now
mostly a horizontal test, so a spear is a place to stand rather than a pixel to
find, which makes the fight positional.

**The trunk is four segments on springs** and it is the only light thing about
her. It is also the clearest demonstration yet of the lag rule in
`CHARACTER_RIGS.md`.

**Wanted:** whether she is a fight or a wall. If a phase only adds health it is
not a phase and it gets rebuilt.

---

## Rung 6, the Hearth

**Built:** the loop closes. A cave lit by the first fire, the Firekeeper's ten
conversations one per return, the Cave Wall's first three rows, and persistence
across visits.

Everything from `FIREKEEPER_DIALOGUE.md` is in verbatim, including the gating:
the fifth conversation waits for the first Mammoth kill rather than firing on a
run count, so the beat about her kneeling only lands once she has.

**The wall is `CAVE_WALL.md` rows 1 to 3** with the Mirror's rule intact:
switching sides is free and you keep the ranks you bought on both. Ember's Grace
is a real Death Defiance now, and it is not a respawn. He gets up where he fell
at half health and says "Not yet", which is his line from the bible.

**One detail worth keeping.** The wall shows one ochre handprint per Mammoth
kill, so it is a record of him rather than a menu. That is straight out of
`ALEGUS.md`, where his forearms are the progress log.

**Saving goes through one interface**, as `PRODUCTION.md` 7a requires. Browser
storage now, a file when this is wrapped for Steam, one function changed and
nothing else. Every read and write is wrapped, so a blocked-storage browser
still plays; it just forgets.

**Wanted:** whether coming back feels like arriving somewhere, or like a menu
between attempts.

---

## Rung 7, content and feel

**Built:** a run with a shape. Eight rooms to the Mammoth, eight door kinds, and
three of the rooms behind those doors contain nothing that wants to kill you.

**The Frayed Cave Bear** is the mini-boss the Mammoth needs you to have met: 220
health, staggered by heavy hits, and slow enough that everything it does is
legible. Its grab is the design: it takes hold of Alegus, it costs him health
while he decides, and the only way out is the dash — the thing he was saving. It
is the one attack in the game that takes a resource away and then asks for it
back. Every other verb is locked while he is held, so the decision is small and
total.

Its face is `ALEGUS.md` beat 8 taken literally. The bear "didn't have a mouth
any more, just the shape of one, and the worst part was that it was still trying
to use it", so the mouth is a hole in the paint and it opens.

**The bear could have been a bigger boar.** Two front-heavy quadrupeds with
shoulder humps is exactly the mistake the first boar pass made against the wolf.
What separates them is written up in `CHARACTER_RIGS.md`: the boar's outline
detail spikes upward and the bear's hangs down, the bear is flat-footed where
both others are on their toes, and it paces — the two legs on one side swing
together — which nothing else in the Stone Age does.

**Three elite modifiers**, Hardened, Swift and Frayed Deeper, marked with a gold
paper reserve instead of the plain one. The reserve was built to guarantee
readability; making it gold is the same mechanism doing a second job for free.
Each modifier changes how you fight the thing rather than how long it takes,
which is the boon rule applied to enemies.

**Flint is spent inside a run and does not survive it.** Ochre is what he carries
home and thinks about; flint is what he decides with while he is still cold. The
trade fire sells three of six wares, and nobody is sitting at it.

**Buying is a dwell, not a collision.** Walking into an altar offering is a
gift; walking into a price is a mistake, and the doors are on the far side of
the fire, so it has to be possible to cross the room without spending anything.
Standing still for half a second costs nothing to learn and works the same under
a thumb as under a keyboard.

**Sharp Flint finally has a shop.** The right-hand rank of the third wall row has
had a name and nothing to spend it on since the wall was built. `CAVE_WALL.md`
row 3 is amended to match what was built.

**Two harnesses, because I cannot see the screen.** One stubs enough DOM to run
the real code and drives every creature, every room kind, every door and twelve
complete runs; the other tracks a real transform stack and measures whether any
rig overruns the 360-pixel character buffer. A clipped muzzle does not show up in
a syntax check and does show up to a player. The reared bear has 24 pixels
spare.

**Wanted:** whether the grab reads as a bill arriving or as a stun; whether the
quiet rooms earned the fight they each replaced; and whether there was ever
enough flint to want all three stones and afford two.
