# Watercolour render pipeline

Technical spec for the look described in `GAME_DESIGN.md` section 8. Written for Unity Universal Render Pipeline as the recommended engine, with notes where Godot differs. This is the subject of milestone 1, the render test, and must be proven before combat work begins in earnest.

---

## 1. Goals and constraints

**Look goals**, in priority order:

1. Reads as paint on paper, not as a filter on 3D.
2. Alegus, enemies, projectiles, and telegraphs are always instantly readable.
3. The whole frame can "run" as a wet painting for age transitions and enemy deaths.
4. Every age is a different palette on the same paper.

**Performance budgets:**

| Platform | Resolution | Frame rate | Post-process budget |
|---|---|---|---|
| PC, mid-range (GTX 1660 class) | 1080p | 60 | 3.5 ms |
| PC, minimum | 1080p | 60 | 2.5 ms with bleed and wobble off |
| Steam Deck | 800p | 60 | 3.0 ms |

Launch is Steam only with a Windows build, so there is no console budget to design against. Steam Deck verification is the low-spec target and needs no certification process. The stack is still designed so that passes can be dropped in order without breaking the look, which keeps a console port open as a post-launch quote rather than a constraint now.

---

## 2. Pass order

Rendered every frame, in this order. Passes marked **(drop)** can be disabled on low settings, in the order listed from the bottom up.

1. **Geometry and lighting** into colour, depth, normals, and an object-ID buffer.
2. **Pigment quantisation** (material stage, not post).
3. **Paper reserve** from the object-ID buffer.
4. **Bleed and wobble** (drop).
5. *(ink outline and edge darkening sat here and were cut; see 3.3 and 3.4)*
6. **Paper composite.**
7. **Wash events** (age transition and death, only when active).
8. **UI**, flat, never painted.

---

## 3. Pass detail

### 3.1 Geometry and lighting

Standard forward rendering. One directional light per age, plus up to four point lights for fire and hazards. No real-time shadows: shadows are painted into the quantised shading via a shadow term from the directional light only, with a large bias so they read as loose washes rather than crisp silhouettes.

The **object-ID buffer** stores a category per pixel: background, character, enemy, projectile, telegraph, UI-in-world. This drives every later pass. In Unity, write it from a custom pass using a per-material stencil or a dedicated render feature. In Godot, use a second viewport with an ID material override.

### 3.2 Pigment quantisation

Per-material shader. Three components:

- **Base tone:** a flat albedo colour. No textures on characters except hand-painted detail maps at very low frequency. Environments may use one large painterly texture per surface.
- **Lighting steps:** the light term is quantised to three bands (lit, mid, shadow) with soft 0.05 transitions. The shadow band shifts hue toward a per-age complementary colour set in a palette asset, and reduces saturation by 20%. This is the single most important effect for reading as watercolour rather than cel shading.
- **Granulation:** a tiling noise texture at screen-space scale, multiplied into the mid and shadow bands at 8% strength, to simulate pigment settling into paper tooth.

**Palette asset:** one per age, holding the directional light colour, the shadow hue shift, the paper tint, the ink colour, and eight pigment swatches that environment artists must build from. Age transitions blend between two palette assets over the wash.

### 3.3 Paper reserve

**Replaces the ink outline, cut at the first art review.** A painter separates a subject from its background by leaving a ring of untouched paper around it, not by drawing a line around it. That is what this pass does, and it is more honest to the medium than ink was.

Dilate the silhouette from the object-ID buffer and fill the resulting ring with the palette's paper colour, beneath the figure itself.

- Ring width 3 pixels at 1080p, scaled with resolution, with a soft outer falloff rather than a hard edge.
- Taken from the **whole figure's silhouette**, never per body part. A per-part reserve cuts paper gaps between an arm and the torso and slices the figure into pieces.
- Contact shadows draw **over** the reserve and under the figure, so the reserve separates the body from the background without cutting it loose from the ground.
- Elites take a warm gold-tinted reserve from a second palette slot instead of the paper colour.
- **The Frayed's reserve wobbles.** Alegus's is steady; theirs drifts with the noise from 3.5. That is the unstable edge, and it now costs nothing extra because the reserve already exists.

### 3.4 Edge darkening (cut)

Cut at the same review. The pigment banding in 3.2 now carries all the form, so give it more contrast between base and shade than it would otherwise need. Kept in the prototype behind a toggle for comparison only.

### 3.5 Bleed and wobble

Screen-space UV distortion using a low-frequency 3D noise (two spatial dimensions plus time), sampled at 0.15 Hz so movement is barely perceptible. Displacement is 1.5 pixels at 1080p for backgrounds and 0 for anything the ID buffer marks as character, enemy, projectile, or telegraph.

**Readability exclusion:** a circular mask of 6 world units around Alegus reduces displacement to zero with a soft falloff, so the play space is always crisp. The mask follows the character, not the camera.

In the hub, displacement is raised to 3 pixels and the exclusion mask is off, so the Hearth feels wetter and more alive than a combat room.

### 3.6 Paper composite

The final colour is multiplied by a paper texture (tiled, 2048 square, high-frequency tooth plus low-frequency mottling) at 12% strength, tinted by the palette asset. A soft vignette at 10%. The paper never moves with the camera; it is fixed to the screen, as if the scene is painted onto the monitor.

### 3.7 Wash events

A full-screen effect triggered by gameplay.

**Enemy death:** local. A circular region around the dying enemy, 3 units, has its colour smeared downward along a noise-driven flow field over 0.6 s, fading to the paper colour. The enemy mesh is hidden at the start; only the smear remains. This is a screen-space effect using the previous frame's colour, so it is cheap and needs no per-enemy work.

**Age transition:** global. Over 2.5 s:

1. Bleed displacement rises to 8 pixels (0 to 0.5 s).
2. Colour flows downward across the whole frame, revealing paper (0.5 to 1.5 s). The flow speed varies by a noise so it runs in streaks, not a curtain.
3. The new age's palette floods in from the top, as if a fresh wash is laid onto wet paper (1.5 to 2.5 s), with the re-forge animation of the weapon happening in the clean centre of the frame where the exclusion mask keeps it crisp.

**Terminus phase 3:** the erase. The paper composite strength rises to 100% inside an expanding circle so the scene inside it becomes blank paper with pencil underdrawing (a separate line-art texture per boss arena).

---

## 4. Asset rules for artists

- **Meshes:** low to mid poly, smooth normals, no hard chamfers. Silhouette matters more than surface detail because surface detail is lost in quantisation.
- **Textures:** environments get one painterly albedo per surface, painted with visible brush direction. Characters get a flat colour and an optional low-frequency detail map. No normal maps anywhere.
- **Colour:** every material's base colour must come from the age's eight-swatch palette. Enforce this with an editor validator that flags materials whose colour is more than a threshold from every swatch.
- **Enemies:** must have a clear silhouette against the darkest and lightest swatches of their age. Test at 25% screen size in greyscale.
- **Telegraphs:** hard-edged decals in a dark warm brown at 60% opacity, drawn to the telegraph ID category so they are exempt from bleed. Never painterly. Telegraphs are not figures, so the no-ink rule does not reach them: they are the one hard edge left in the game and that is deliberate.
- **Particles:** fire, dust, and snow are drawn as painted sprites with the quantisation shader, never additive glows.

---

## 5. Godot notes

Everything above maps to Godot 4 with these substitutions:

- Object-ID buffer: render a second SubViewport with per-object flat colour materials, or encode the category in the alpha of the main colour target with a custom compositor effect.
- Screen-space passes: CompositorEffect scripts on the WorldEnvironment, in the order given.
- Palette assets: Resource types with exported colour arrays, blended with a Tween on transition.
- Expect to write the outline and edge-darkening shaders from scratch; no equivalent of Unity's Renderer Features ships in the box.

---

## 6. Milestone 1 test plan

Three weeks. Deliverables, in order:

1. **Week 1:** one room (the Kill site layout), grey-box meshes, the quantisation shader and palette asset for the Ice Age, paper reserve on a placeholder Alegus capsule. Screenshot review against the reference board.
2. **Week 2:** bleed and wobble with the exclusion mask, paper composite. Three placeholder enemies moving on patrol paths. Profile on the minimum PC target.
3. **Week 3:** enemy death wash, age transition wash to a second palette (Rivers), one fire light. Play at 60 for ten minutes and note every moment an enemy is hard to see.

**Pass criteria:**

- Three people who have not seen the concept art say "watercolour" or "painting" unprompted when shown the room in motion.
- Post-process stays under 3.5 ms on the mid-range target and under 2.5 ms with the two drop passes off.
- No tester loses a moving enemy against the background at 25% screen size.
- The age transition wash gets a reaction. If it does not, the whole direction is reconsidered before milestone 2.
