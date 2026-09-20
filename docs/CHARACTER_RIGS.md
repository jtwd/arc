# Character rigs

How a puppet is built, and why each rule is there. Written after the first
character pass, when the first attempt read as a diagram rather than a body.

Every figure in the game is painted shapes on pivots. There are no image files,
no meshes and no skinning. What separates a rig that reads as alive from one
that reads as a stick figure is not detail. It is four things.

---

## 1. Two bones per limb

A knee or an elbow is the whole difference between a leg and a stick. One
tapered shape rotating from the hip cannot look like walking no matter how the
angle is driven.

Every limb is a thigh and a shin, or an upper arm and a forearm, each on its own
pivot, with the second angled relative to the first.

## 2. The foot stays flat

The ankle counter-rotates against the hip and the knee together, so the sole
points at the ground rather than wherever the leg happens to be swinging. In
code that is one line, `-hip - knee`, and without it every walk looks like
wading.

## 3. Counter-rotation

Shoulders turn against hips. The head turns against the shoulders. Arms swing
opposite the leg on the same side. A body that rotates as one piece reads as a
mannequin being carried.

## 4. Lag

Hair, tails and cloth arrive late and leave late. Alegus's hair is on a spring
driven by his velocity, so it trails when he runs and overshoots when he stops.
A spring is four lines and it does more for life than any amount of detail.

---

## Gaits

A gait is not one sine wave shared by every leg. The phase offsets are the gait.

| Creature | Gait | Phases |
|---|---|---|
| Alegus | Walk and run | Legs opposed, arms opposed to the leg on their side |
| Wolf | Trot | Diagonal pairs. Front-left with rear-right, front-right with rear-left |
| Boar, approaching | Four-beat walk | Front and rear opposed |
| Boar, charging | Gallop | Front pair together, rear pair together, offset by about a third of a cycle |

Two other details carry weight. The body bobs **twice** per stride, down at each
foot plant, not once. And the knee bends on the forward swing only, never
backward, which is one `max(0, ...)`.

---

## Silhouette is where an animal earns its name

The first pass drew the boar as a bigger wolf with tusks. That is why it did not
read. Real distinction lives in the mass distribution, and it has to survive at
25% screen size in greyscale.

| | Wolf | Boar |
|---|---|---|
| Weight | Even, slightly forward | Heavily front |
| Shoulder | Deep chest | A huge hump, the tallest point of the animal |
| Hindquarters | Full, rounded | Small and low |
| Head carriage | Level with the spine | Low, below the shoulder |
| Legs | Long | Short and thick |
| Outline detail | Upright ears, bushy tail | Bristle ridge along the spine, tusks curving up |

The bristle ridge is six small triangles and it is the single most identifying
thing about the boar at a glance. Cheap outline detail beats expensive surface
detail every time, because the outline is what survives being small.

The hunter has a hood rather than hair, and a crouch, so it never reads as
Alegus at a distance.

---

## Feel

Three things that are not drawing but sell a body:

- **Ease everything.** The gait fades in and out so he settles into a stand
  rather than freezing mid-stride. Turning takes about seventy milliseconds; an
  instant mirror flip reads as a glitch. He leans into a run.
- **Turn through the edge.** He is a paper cut-out, so the turn scales his width
  through zero. That is authentic to the medium rather than a compromise.
- **Hit-stop.** A landed hit holds the entire frame for 60 to 110 milliseconds
  and squashes what it hit. Nothing else in a melee game buys as much weight for
  as little work.

During the dash's invulnerable frames Alegus thins to half opacity. It is a
readable tell, and it is what he is: a thread being pulled through the weave.

---

## What it costs

The pass roughly doubled the painted shapes per character, from about ten to
about twenty for Alegus and twenty-seven for the boar.

That was paid for by making each shape cheaper. The pigment bands were a clipped
overdraw, costing a canvas clip and two extra point arrays per shape; they are
now shrunken offset copies, which land in the same place on blobby forms and
cost two polygons and no clip. Parts under about eight pixels across skip the
wet bleed entirely, since nobody can see it at that size.

`tools/render-test/index.html` is the implementation. `game/scripts/puppet.gd`
is the parked Godot equivalent and should be brought up to this if that route is
ever resumed.
