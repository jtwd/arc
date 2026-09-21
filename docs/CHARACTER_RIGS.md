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
| Cave Bear | Pace | Lateral pairs. Both legs on one side swing together, which is where the roll comes from |

Two other details carry weight. The body bobs **twice** per stride, down at each
foot plant, not once. And the knee bends on the forward swing only, never
backward, which is one `max(0, ...)`.

---

## Silhouette is where an animal earns its name

The first pass drew the boar as a bigger wolf with tusks. That is why it did not
read. Real distinction lives in the mass distribution, and it has to survive at
25% screen size in greyscale.

| | Wolf | Boar | Cave Bear |
|---|---|---|---|
| Weight | Even, slightly forward | Heavily front | Heavily front, and much heavier |
| Shoulder | Deep chest | A huge hump, the tallest point of the animal | A higher hump, set further forward, above the head |
| Hindquarters | Full, rounded | Small and low | Small and low |
| Head carriage | Level with the spine | Low, below the shoulder | Low, on a long neck, below the hump |
| Legs | Long | Short and thick | Forelimbs longer than the hind, and flat-footed |
| Outline detail | Upright ears, bushy tail | Bristle ridge along the spine, tusks curving up | A shaggy fringe hanging off the belly, round ears set wide |

The bristle ridge is six small triangles and it is the single most identifying
thing about the boar at a glance. Cheap outline detail beats expensive surface
detail every time, because the outline is what survives being small.

The bear's fringe is the same trick inverted on purpose: the boar's outline
detail **spikes upward**, the bear's **hangs down**. Two front-heavy quadrupeds
with humps could easily have become one animal drawn twice, and the direction of
the fringe is what stops that happening in a thumbnail.

Three other things separate the bear from both. It is **plantigrade**, so the
whole foot is on the ground where the other two are up on their toes. It
**paces**, which no other creature in the Stone Age does. And when it grabs, it
**rears**, rotating everything above the hip while the hind feet stay planted:
it is the only thing in the game taller than Alegus, and it is only taller for
three quarters of a second.

The hunter has a hood rather than hair, and a crouch, so it never reads as
Alegus at a distance.

---

## Faces

At the game's camera a head is about 25 pixels across and a feature is three,
so a face here is four or five shapes and not one more. The rule that makes it
work is that the shapes are **flat fills at a third of the wobble**. Two pigment
bands and a wet bleed on a three-pixel eye is mush, and full-strength drift
makes an eye crawl around the head.

**Alegus is the only person who gets a whole face**, because he is the only one
who is fully present. Brow, eye with a highlight, a far eye and brow to stop it
reading as a flat profile, nose shadow, ear, mouth.

The brow is the character. It sits **up** by default, because wonder is his
register per the bible, and one shape carries that better than any amount of
detail. It drops on the active frames of a swing, lifts and opens when he is
hit, narrows on a dash. He blinks every two to five seconds, and he turns his
head toward the nearest Frayed, which is four lines and the single cheapest
thing in the rig that makes him seem to be thinking.

**The Frayed have the features they lost.** An eye is a void of bare paper with
the paint failing around it. A jaw opens on something it cannot bite with. This
is not a shortcut at small sizes, it is `ALEGUS.md` beat 8, where the bear "didn't
have a mouth any more, just the shape of one, and the worst part was that it was
still trying to use it."

Each also gets one behavioural tell on the face: the wolf pins its ears and
opens its jaw as it closes, the boar's eye is small, high and set well back
which is most of why the head reads as a boar and not a dog, and the hunter's
face is in hood shadow with a single catchlight that brightens when it aims.

## Seeing the work

Faces this size cannot be judged in play. `tools/render-test/index.html` has a
**model sheet** below the play area showing all five rigs at 1.75 times game
size, which is as large as the character buffer holds without clipping his hair.
The bear is shown at two thirds of its fighting size, because at full size it
does not fit beside the other four. It redraws at 20 frames a second rather than
60, and it shares the rigs through one `artScale` multiplier so it can never
drift out of step with what is actually in play.

The character buffer is 360 by 360 with its origin at (180, 260), and a figure
that overruns it is silently clipped, which is exactly the kind of bug that does
not show up in a syntax check and does show up to a player. `tools/render-test`
is measured by a headless bounds harness that runs every rig through every state
with a real transform stack and reports the worst-case box. A reared bear is the
tightest: 24 pixels of headroom.

Worth deciding later: the test runs at 960 by 600. At a shipping resolution of
1920 by 1080 every face doubles and these features stop being marginal.

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
