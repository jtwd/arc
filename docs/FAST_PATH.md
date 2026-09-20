> **Superseded in part.** This was written for a team of four to five professionals. The team is now two people and Claude, and `PRODUCTION.md` carries the current plan: Godot rather than Unity, the Stone Age alone rather than five ages, and art authored as code. The reasoning below still holds for why scope beats tooling, and the Steam section is unchanged.

# The fast path: launch scope decisions

Decisions made against one criterion: **shortest time to a finished, good game.** The full design in `GAME_DESIGN.md` is unchanged and remains the target. This document says which part of it ships first and why.

The short version: the engine and platform questions are worth about one month between them. The scope question is worth about seven. Most of this document is therefore about scope.

---

## 1. Decisions

| Decision | Call | Cost of the alternative |
|---|---|---|
| Engine | **Unity, Universal Render Pipeline** | Godot adds roughly 3 weeks to milestone 1 and more later |
| Platform | **Steam only, Windows build** | Switch adds certification, dev kits, and a permanent art ceiling |
| Ages at launch | **Five, plus the Terminus** | Nine ages costs roughly 7 months |
| Lineages at launch | **Three: Blunt, Edge, Sling** | Six costs roughly 3 months |
| Inventors at launch | **Nine** (falls out of the age cut) | — |
| Threads at launch | **One per age** | Unchanged from the original recommendation |

Everything cut is deferred, not deleted. Section 6 is the post-launch order.

---

## 2. Engine: Unity URP

The critical path is the watercolour render stack, not gameplay. Pick the engine that de-risks that.

**Why Unity is faster here:**

- The largest existing body of non-photorealistic rendering work to adapt. Outline passes, edge darkening, and paper compositing are solved problems with published implementations. In Godot you write the compositor effects yourself.
- Shader Graph lets one technical artist iterate on pigment quantisation without hand-writing a shader variant each time.
- The Asset Store covers everything that is not the game: input rebinding, save systems, object pooling, debug overlays, UI. Buying those is days, not weeks.
- A larger contract pool if the team needs a second programmer at alpha.

**The honest counterpoint.** Godot's iteration loop is genuinely better, and Unity's domain reload is a real daily tax. If whoever writes the render stack already knows Godot well, that reverses this decision. Team familiarity beats tooling maturity every time. Absent that, Unity.

**Milestone 1 is unchanged and must not be compressed.** It is three weeks to prove the art direction, and it has a kill criterion in `RENDER_PIPELINE.md`. Cutting it to save two weeks risks discovering at month eight that the look does not work in motion.

---

## 3. Platform: Steam, Windows build only

**Confirmed.** Steam is the only launch platform. Consoles become a quote from a porting house after launch, against a finished game.

Switch was the expensive alternative and none of its cost was visible in a feature list. Certification, dev kits, the NDA, and either a porting partner or in-house porting expertise all sit on the calendar rather than the backlog. It also imposed a 4 to 5 ms post-process budget at 30 frames per second on ARM, which would have capped the art direction from day one.

### 3.1 One build, not three

Ship a **Windows build only**. No native Linux or macOS.

- Steam Deck runs Windows builds through Proton, and Deck Verified is achievable that way. Most verified games ship Windows-only. A native Linux build buys nothing and doubles the QA matrix.
- macOS costs a second graphics backend for a custom render stack, plus notarization and Apple Silicon testing. For a hand-written pass stack that is real risk on a platform that is a small share of this genre's audience.

One build target is the single cheapest platform decision available. Revisit macOS after launch if the numbers justify it.

### 3.2 Steam Deck Verified

Verification has no certification process and no gatekeeper beyond a checklist, but three of its criteria reach back into design and should be handled from the slice rather than retrofitted:

| Criterion | What it means here |
|---|---|
| Full controller support with correct glyphs | Already planned. The game must show Deck glyphs, not generic Xbox ones |
| Legible text at 1280 by 800 | The era-framed UI in `GAME_DESIGN.md` (clay tablet, papyrus, illuminated manuscript) is the risk. Test every UI frame at Deck resolution as it is built |
| Single launch path, no launcher, no compatibility warning | A Unity default if nobody adds a launcher. Keep it that way |

Add a Deck resolution check to the vertical slice acceptance criteria. Finding an illegible UI frame at beta costs an art pass per age.

### 3.3 Steamworks work, and when

None of this is large, but it is all calendar time if left to the end.

| Feature | Milestone | Note |
|---|---|---|
| SteamPipe build and depot upload | Vertical slice | Needed for Steam Playtest, below |
| Steam Playtest | Vertical slice | Distributes test builds and collects testers without manual builds |
| Steam Input | Alpha | Gives Deck glyphs and rebinding nearly free |
| Cloud saves | Beta | Small, and expected |
| Achievements | Polish | Tie to first boss kills, first clear per lineage, first duo |
| Store page, capsule art, trailer | Polish, starting 3 months out | Wishlists need lead time |

**Use Steam Playtest for the slice test.** The production plan calls for ten external testers at two hours each. Playtest handles distribution, keys, and build updates, so the alternative is hand-delivering builds ten times. It also means the alpha 30-run test can use the same channel with a larger group at no extra setup.

---

## 4. Scope: five ages, three lineages

This is where the time actually is.

### 4.1 Ages

Ship **Stone, Rivers, Empires, Faith and Steel, Sail**, then the Terminus. Six bosses, 26 rooms.

Simulated with `tools/run-sim` on the launch scenario:

| Scope | Rooms | Full clear (median) | Expert clear rate |
|---|---|---|---|
| Nine ages | 36 | 49 min | 19% |
| **Five ages** | **26** | **36 min** | **40%** |

Thirty-six minutes is squarely in the Hades band. The 40% expert clear rate matters as much as the time: at nine ages, four fifths of skilled runs end in failure, which reads as attrition rather than difficulty.

**The weapon fantasy survives.** Stone club to flintlock pistol is five visible evolutions and still delivers "start with a rock, end with a gun". The Age of Sail is a satisfying stopping point precisely because gunpowder is the last era where a lone person with a hand weapon is plausible.

**The story survives, and improves.** The Terminus premise is that something at the far end of history is pulling the weave apart. If the ages past Sail are already gone, that is the fraying, not a missing feature. Alegus cannot go further because there is nothing left to walk into. The post-launch update is then diegetic: the weave re-knits and more timeline exists. That is a better hook than a roadmap entry.

### 4.2 Lineages

Ship **Blunt** (heavy, free), **Edge** (fast, parry), **Sling** (ranged). Those three cover the whole space; Reach sits between Blunt and Edge, Twin is a faster Edge, and Guard is a defensive variant of Blunt.

### 4.3 What this removes

| Item | Full design | Launch | Saved |
|---|---|---|---|
| Bosses | 9 | 6 | 3 bespoke fights |
| Weapon meshes | 48 | 15 | 33 meshes |
| Movesets to design, animate, and balance | 6 | 3 | 3 |
| Aspects | 24 | 12 | 12 |
| Enemy re-skins | 39 | 22 | 17 |
| Inventors | 12 | 9 | Press, Volt, Atom |
| Duo Inventions | 26 | 15 | 11 |
| Music arrangements | 9 | 6 | 3 |
| Voice lines | ~5,500 | ~3,200 | one recording session |

For the character artist alone, the enemy and weapon cuts are roughly 67 days, about 13 working weeks.

The nine surviving Inventors are Ember, Wheel, Seed, Forge, Glyph, Lens, Salt, Compass, and Powder. Press, Volt, and Atom drop out automatically because they first appear in ages 6 and 8.

---

## 5. The lever nobody asked about: shared boss systems

`BOSSES.md` gives every boss its own arena technology. Breaking ice floes, rising sand, a pitching deck, molten channels, a shrinking safe ring. Written that way, each boss is a new engineering project and the six launch fights are the longest pole in alpha and beta.

Build five shared systems instead, and every boss becomes configuration plus art:

1. **Weak points.** Tagged sub-targets with their own health, damage multiplier, and a staggered state. Serves the Mammoth's spears, the Ironclad's vents, the Landship's engine plate.
2. **Floor state grid.** Tiles that can be solid, cracked, hazardous, or absent, with telegraphs. Serves the ice floes, the rising sand, the Terminus erase, the Legate's closing ring.
3. **Hazard volumes.** Timed or persistent damage areas with a shared telegraph shape. Serves gas, molten metal, fire rings, ice columns.
4. **Objective holds.** A point that must be occupied or struck for N seconds, interruptible. Serves the Sphinx's pillars and the silo consoles.
5. **Add waves.** Timed or health-gated spawns tied to a boss phase. Serves every fight.

The Terminus's second phase replays other bosses' mechanics in miniature. With shared systems that phase is nearly free. Written bespoke, it is a sixth boss on its own.

This is worth more calendar time than the engine choice. Do it before the first boss is built, during the vertical slice.

---

## 6. Revised timeline

| Milestone | Original | Fast path | Change |
|---|---|---|---|
| 1. Render test | 3 weeks | 3 weeks | Do not cut |
| 2. Combat prototype | 4 weeks | 4 weeks | — |
| 3. Evolution prototype | 3 weeks | 3 weeks | — |
| 4. Vertical slice | 10 weeks | 10 weeks | Add the five boss systems here |
| 5. Alpha | 6 months | 4 months | Ages 2 to 4, three lineages |
| 6. Beta | 5 months | 3 months | Age 5 and the Terminus |
| 7. Polish and ship | 3 months | 2.5 months | Less surface to balance |
| **Total** | **~21 months** | **~14 months** | **7 months** |

Team stays at four to five: technical artist, gameplay programmer, systems programmer, character artist and animator, designer and writer, with audio and voice on contract.

### Post-launch order

1. Age of Revolution and Age of Wars, with Volt and Press. The weave re-knits.
2. Reach and Guard lineages.
3. Age of Atoms, with Atom. Completes the original nine.
4. Twin lineage and the remaining Aspects.
5. Second threads per age, in the order already listed in `GAME_DESIGN.md` section 12.

---

## 7. Worth considering: Early Access

If "fast" means time until people are playing rather than time until the game is finished, Early Access beats every decision above. Three ages is roughly month ten on this plan. Hades itself ran in Early Access for two years and used it as its primary design tool.

It buys revenue during development, real balance data instead of the simulator's guesses, and a community before launch. It costs a permanent obligation to ship updates on a visible cadence, and a rougher public first impression.

Deliberately parked. Raise it at the vertical slice review, when there is something to judge. Nothing before that milestone depends on the answer, except that a Steam Playtest branch exists from the slice either way, which is most of the setup an Early Access launch would need.

---

## 8. What not to cut

Three things look like savings and are not.

- **The render test.** It is the whole identity of the game and the only milestone with a kill criterion. Three weeks now against a possible eight-month mistake.
- **The evolution prototype.** Milestone 3 tests the central mechanic, that a weapon changing under you feels like a reward. Everything downstream assumes the answer is yes. Three weeks to find out.
- **Alegus's combat barks.** He is the reason the run has a personality. Scratch audio is fine until beta, but a silent protagonist in the vertical slice will make the slice test the wrong thing.
