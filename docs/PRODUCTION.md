# Production plan

Team, backlog, risks, and decisions for `GAME_DESIGN.md`. Covers milestones 1 to 4 in detail and 5 to 7 in outline.

---

## 1. Team

Minimum team to hit the milestone plan in roughly 20 to 22 months:

| Role | Count | Notes |
|---|---|---|
| Technical artist | 1 | Owns `RENDER_PIPELINE.md`. Hired first. Nothing else starts without a render test. |
| Gameplay programmer | 1 to 2 | Combat, enemies, bosses, Inventions. Second hire at alpha. |
| Systems programmer | 1 | Hub, meta progression, save, UI, platform. Can be shared with gameplay until alpha. |
| 3D artist | 1 | Environments and props. Concept work up front, then production. |
| Character artist and animator | 1 | Alegus, six lineages at eight forms, all enemies and bosses. The largest single content load; see risk 3. |
| Designer and writer | 1 | Levels, encounter tuning, all dialogue, boss design. The role that owns `ALEGUS.md`. |
| Composer and sound | contract | The single motif and its nine arrangements, plus a sound library. |
| Voice | contract | Alegus is the anchor casting. Three sessions per `ALEGUS.md`. |

A solo developer should build the Stone Age only, with one lineage, and treat that as the full first release.

---

## 2. Milestone 1: render test (3 weeks)

Owner: technical artist. Full plan in `RENDER_PIPELINE.md` section 6.

- [ ] Project created in the chosen engine, source control, build pipeline to a PC executable
- [ ] Ice Age palette asset
- [ ] Quantisation shader
- [ ] Object-ID buffer and ink outline
- [ ] Edge darkening
- [ ] Bleed and wobble with exclusion mask
- [ ] Paper composite
- [ ] Death wash
- [ ] Age transition wash to Rivers palette
- [ ] Profile on minimum target
- [ ] Reference board review with three outside viewers

## 3. Milestone 2: combat prototype (4 weeks)

Owner: gameplay programmer. Runs in the render test scene.

- [ ] Alegus controller: move, dash with i-frames, camera follow
- [ ] Blunt Stone club moveset per `VERTICAL_SLICE.md` section 6, with tunable frame data in a data asset
- [ ] Hit reactions, stagger, knockback
- [ ] Frayed Wolf with pack flanking
- [ ] Frayed Boar with charge and wall stun
- [ ] Frayed Hunter with ranged kiting
- [ ] Ember stone Cast and recovery
- [ ] Health, damage, death, restart
- [ ] Ink telegraph decals for every enemy attack
- [ ] Scratch voice for combat barks recorded by the writer
- [ ] Controller and keyboard-and-mouse input
- [ ] Ten-minute internal play session, notes on feel

## 4. Milestone 3: evolution prototype (3 weeks)

Owner: character artist and gameplay programmer together.

- [ ] Alegus rig with weapon socket that swaps meshes without changing animations
- [ ] Bronze mace mesh and the third-hit stun change
- [ ] Re-forge animation: the Loom reshapes the weapon in Alegus's hands
- [ ] Age transition wash wired to the re-forge
- [ ] One Rivers room with the Rivers palette and two re-skinned enemies
- [ ] Play test: five people play Stone Age to the transition, then answer one question, "did you want to keep the club?"

If more than two of five wanted to keep the club, the evolution design needs work before the slice. Options in order: make the new form more visibly powerful, give the player a preview of the next form during the age, or allow locking a form as a Cave Wall unlock.

## 5. Milestone 4: vertical slice (10 weeks)

Owner: whole team. Full spec in `VERTICAL_SLICE.md`.

**Weeks 1 to 3, content.**
- [ ] Ten room layouts, grey-box then art
- [ ] Frayed Cave Bear and three elite modifiers
- [ ] Edge Flint knife moveset with parry
- [ ] Mammoth Mother, all three phases, floe system

**Weeks 4 to 6, systems.**
- [ ] Run generator: door choice, reward types, room pool rules
- [ ] Altar and four Inventors with twenty Inventions and two duos
- [ ] Flint shop, fountain, story room
- [ ] Ochre and Flint economy
- [ ] Hearth: Firekeeper conversations, Cave Wall three rows, lineage rack
- [ ] Save and load

**Weeks 7 to 8, voice and audio.**
- [ ] Alegus session 1 recorded and cut in
- [ ] Firekeeper recorded
- [ ] Stone Age arrangement of the motif, boss variant
- [ ] Sound library pass on all attacks and enemies

**Weeks 9 to 10, polish and test.**
- [ ] Performance pass to acceptance criteria
- [ ] Ten external testers, two hours each, the question list from the slice doc
- [ ] Decision meeting: proceed to alpha, iterate the slice, or stop

## 6. Milestones 5 to 7 in outline

**Alpha (6 months):** ages 2 to 5 on one thread each, four more bosses from `BOSSES.md`, four more lineages, Inventors through Powder, twelve duos, the Cartographer and Archivist, Keys of Ages and Amber, Alegus session 2. Ends with a 30-run external test.

**Beta (5 months):** ages 6 to 9, the Terminus, Anachronisms, keepsakes, Aspects, Wren, all remaining Inventors and duos, all nine music arrangements, Alegus session 3, localisation prep, platform certification if Switch is in.

**Polish and ship (3 months):** balance, accessibility, achievements, store assets, launch.

---

## 7. Risks

Ranked by how much they would hurt.

1. **The watercolour look does not work in motion.** Mitigation: it is milestone 1 and it has a kill criterion. If it fails, fall back to flat-shaded 3D with ink outlines (the Sable approach) and keep the wash events, which work on any base look.
2. **Runs are too long.** Nine ages is more than Hades' four. The simulator in `tools/run-sim` put the first draft at 75 minutes per clear; with shorter rooms, shorter bosses, and 36 rooms it is about 49. Mitigation: that tuned set is now the spec. If the alpha 30-run test shows fatigue, merging Wars and Atoms saves about five minutes and cutting to seven ages saves about ten.
3. **Character art volume.** Six lineages times eight forms is 48 weapon meshes, plus every enemy for nine ages. Mitigation: weapons are socket swaps on one rig, so it is modelling not animation. Enemies share behaviour archetypes across ages and are re-skins of four to five base rigs per archetype. Budget one enemy re-skin at two days.
4. **Evolution feels like loss.** Mitigation: milestone 3 tests exactly this before anything else is built on it.
5. **Voice budget.** Roughly 5,500 lines at launch. Mitigation: Alegus's combat barks are the only lines needed for the slice; everything else can be scratch until beta.
6. **Tone in the Age of Wars.** A warm, funny game walking into the trenches could feel glib. Mitigation: the bible already forbids jokes in that age's intro. Playtest that age's tone specifically at alpha with testers who have opinions about it.

---

## 8. Decisions log

Open decisions, the recommendation, and where the decision is consumed. Update this table when a call is made.

| Decision | Recommendation | Blocks |
|---|---|---|
| Engine | Unity URP | Milestone 1 |
| Target platforms | PC first, Switch decided at alpha | Milestone 1 performance budget |
| Age count at launch | Nine, with 7 and 8 short | Alpha scope |
| Full-clear run length | 45 to 50 minutes, 36 rooms | Alpha 30-run test |
| Threads at launch | One per age | Alpha scope |
| Forced evolution | Yes | Milestone 3 |
| Protagonist | Alegus, voiced | Decided |
| Art direction | 3D watercolour | Decided |
| Tone through late ages | Darkens, stays warm | Alpha writing |
| Alegus's origin | Pre-cultural | Decided in bible, confirm |
