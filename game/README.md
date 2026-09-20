# EPOCH, rung 1

The watercolour look running in Godot. There is no game here yet: you can walk
Alegus around one room and run the age transition. That is the whole scope, and
it is deliberate. Rung 1 exists to prove the render stack before anything is
built on top of it.

## Running it

1. Install **Godot 4.3 or newer**, standard build. No C# needed.
2. Open Godot, choose **Import**, and select `game/project.godot`.
3. Press **F5**.

| Input | Does |
|---|---|
| Arrow keys | Walk |
| Space, or the button | Run the age transition |
| The checkboxes | Turn each render pass on and off |
| The slider | Wobble amplitude, 0 to 4 pixels |

## What to look at

- **Does it read as paint when it moves?** A still frame is not the test. Walk
  around, then stand still and watch the edges drift.
- **Can you always find Alegus?** Turn the paper reserve off. He should become
  noticeably harder to pick out, which is the pass earning its place.
- **Run the transition a few times.** It is the signature moment of every run
  and the payoff for the weapon re-forging, so it has to be worth its budget.
- **Jointed off** draws the same art rigid. It should look dead by comparison.
- **The frame counter.** It should sit at 60. If it does not, say so and I will
  cut the cost before we build anything else on this.

## If it still is not 60

The first build was not, so the frame is now instrumented rather than guessed
at. The readout top right says where the time goes:

```
58 fps
process 12.40 ms     <- everything Claude's code does per frame
world    9.10 ms @ 10/s   <- one world bake, and how often they happen
figures  1.20 ms     <- Alegus
paints     56        <- watercolour shapes drawn last frame
```

**Read `process` first.** At 60 frames a second the whole frame has 16.6 ms, and
the renderer needs some of it, so anything over about 8 ms of script is the
problem.

Then bisect with the two **Layer** switches, which turn a whole layer off:

| What happens | Means |
|---|---|
| `world` is large and turning the world layer off fixes it | Still CPU geometry. Drop **bake Hz**; ten is already generous, four is fine |
| `process` is small but the frame rate is still low | It is the GPU, not the script. Untick **Paper composite**, then **Paper reserve**, and tell me which one moved it |
| Turning **Bleed and wobble** off fixes it | The noise is the cost. It can be precomputed per shape instead of per frame |
| Nothing moves it | Something outside this code. Check the renderer is GL Compatibility in Project Settings |

Tell me the four numbers and which switch moved them and I will cut the right
thing. Please do not just lower the resolution: this has to be fast honestly,
because rung 2 adds enemies on top of it.

## I could not run this

Godot is not installed in the container I work in, so this is the first code on
the project I have not seen execute. Everything below is a real possibility
rather than paranoia, and each one has a one-line fix. Tell me which happens and
I will correct it.

| If you see | The cause | The fix |
|---|---|---|
| Dark halos or fringes around Alegus | Premultiplied alpha from the transparent SubViewport | In `game.gd`, change `figure_rect`'s blend mode to `BLEND_MODE_MIX`, and drop `render_mode blend_premul_alpha` from `reserve.gdshader` |
| The whole screen goes black or white | `blend_mul` on the paper pass not behaving under the GL compatibility renderer | Untick **Paper composite** to confirm, then tell me and I will move it to a `SCREEN_TEXTURE` read |
| Shapes with pinched or crossed fills | A polygon went concave and the triangulation fanned it badly | Tell me which shape; the fix is a tighter radius range in `Painter.blob` |
| The figure layer never appears | SubViewport not updating | Check `render_target_update_mode` is `UPDATE_ALWAYS` in `game.gd` |
| The world is blank or black | The world viewport never baked | `_bake_world()` sets `UPDATE_ONCE`; check it runs in `_ready` |
| The world visibly steps or stutters | Bake rate too low for the drift | Raise **bake Hz**. It is a straight trade against frame time |
| A parse error on launch | A Godot 4 API difference I guessed wrong | Paste the line and the message |

## How it is put together

Layer order is the whole design, and it is the part most likely to be got wrong
by someone changing it later:

```
world           ground and scenery, no reserve, painted directly
paper reserve   a ring of bare paper dilated from the figure silhouette
contact shadow  over the reserve, under the figure
figures         Alegus, rendered in a SubViewport
wash            the age transition, when it is running
paper           grain and vignette, multiplied over the finished frame
```

Figures render into their own SubViewport so the reserve can be taken from the
**finished silhouette**. Doing it per body part opens paper gaps between an arm
and the torso and slices the figure into pieces. The shadow sits between the
reserve and the figure so the reserve does not lift Alegus off the ground.

| File | Holds |
|---|---|
| `scripts/painter.gd` | Every drawing routine. Noise, blobs, limbs, the pigment bands |
| `scripts/puppet.gd` | The jointed base: a transform stack and nothing else |
| `scripts/alegus.gd` | Ten parts, eight pivots, one character |
| `scripts/world.gd` | Ground, horizon, scenery |
| `scripts/palette.gd` | An age, as colours. Stone and Rivers |
| `scripts/game.gd` | Layer construction, input, the wash, the debug panel |
| `shaders/` | Reserve, paper, wash |

**There are no image files.** Every visual is generated from code. That is what
makes the art possible for this team, so keep it true: if something needs a
texture, say so and we decide deliberately rather than drifting into an asset
pipeline nobody can staff.

`tools/render-test/index.html` is the browser sandbox and stays the place to try
risky ideas quickly. Keep the two in step when the look changes.
