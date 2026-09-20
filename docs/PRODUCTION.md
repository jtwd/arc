# Production plan

Rewritten for the real team. The previous version assumed four to five professionals over fourteen months and is preserved in git history. Nothing in it survives except the milestone discipline.

---

## 1. The team

| Who | Role | Real constraint |
|---|---|---|
| **James** | Programmer, integrator, the only person who can run the build | The hours. Everything queues behind this |
| **Edward** | Creative director | Owns taste, tone, and the kill criteria. Not a bottleneck, and should never be treated as one |
| **Claude** | Code, design, writing, art authoring, tools | No hours limit, no judgement about whether the result is fun |

Roughly a day or two a week between the two humans. Call it twelve hours.

**What Claude cannot do**, and the plan must respect: play the game, judge whether it feels good, hear the audio, decide what is fun, or make anything outside a text file. Every one of those is Edward's or James's.

**What that means structurally.** Human hours go to directing, testing and deciding, not to typing. So the plan is built from small increments that each end in something runnable, rather than from large phases that end in a review. A session that ends with nothing to play is a wasted session.

---

## 2. The art problem, and why it is solved

This was the wall. Two people cannot produce roughly two person-years of modelled, rigged and animated 3D character work, and Claude cannot make image files.

**The render test answers it.** That prototype contains **zero image assets**. Alegus, the Frayed, the ground, the rocks, the death wash and the age transition are all generated from code: polygon definitions, a noise function, and a painting routine. The whole thing is 39KB of text.

So the art is **authored as code, not as files**, and Claude authors it. That is the single decision that makes this project possible with this team.

| | Conventional | This project |
|---|---|---|
| A character | Model, rig, skin, animate | A list of part polygons and pivots |
| An enemy variant | Re-texture and re-export | Change a palette entry |
| A weapon form | New mesh | A different polygon list |
| An age | New asset set | A new palette object |
| Who makes it | Character artist | Claude |

**Edward's job in this arrangement is larger, not smaller.** Code-authored art has one failure mode: everything drifts toward the same geometric sameness, because nobody is looking at it with an eye. He is the eye. He directs the shapes, judges the results, tunes the palettes and says when something reads as cheap.

**The honest limits.** Complex one-off shapes, the Mammoth Mother above all, are laborious in code and will look worse than a drawn version. Environments risk repetition. If either bites, the fallback is a hand-made or AI-assisted texture painted onto a code-defined rig, which keeps the animation free and buys back the richness. Decide that at the boss, not before.

---

## 3. Engine: Godot 4

**This reverses the earlier Unity recommendation.** That call was made for a team that no longer exists, building an art direction that no longer exists. Both premises changed:

- Unity was chosen for its depth of non-photorealistic shader references. The hardest pass, the screen-space ink outline, has been cut. What remains is pigment banding, a silhouette dilate and a paper multiply, none of which needs a reference library.
- Unity was chosen partly for its asset store and hiring pool. With code-authored art and no hiring, neither applies.
- What matters now is weight, iteration speed and how quickly one part-time programmer can become productive. Godot wins all three, and costs nothing.

Godot also gives away free what a browser build would make James hand-roll: gamepad handling, audio mixing, save resources, scene management, and a first-class Steam export.

**Keep the browser prototype as the sandbox.** It stays in `tools/render-test`. Risky visual or feel experiments happen there first because iteration is instant and Claude can publish a playable link in minutes. Once an idea survives that, it gets built properly in Godot. Two tracks, one throwaway and one real.

---

## 4. Scope: the Stone Age is the whole first release

Five ages was already the reduced scope. For this team it is still four ages too many.

Ship **the Stone Age, Ice Age thread**, essentially the vertical slice in `VERTICAL_SLICE.md` treated as the finished product rather than a fragment:

- 6 rooms per run drawn from a pool of 8 to 10 layouts, then the boss
- The Mammoth Mother
- Blunt free, Edge unlocked by the first clear
- 4 Inventors, 20 Inventions, 2 duos
- The Hearth: Firekeeper, Cave Wall rows 1 to 3
- Runs of 7 to 9 minutes
- **Text dialogue, no voice.** The 4,400 line budget is unreachable and the writing all works as text
- Music and sound licensed or commissioned, not composed in-house

That is a real roguelike, one biome deep. Plenty of good ones launched exactly there and grew. Ages 2 to 5 become the content plan, and the story already supports it: the weave past the Stone Age is frayed, which is why Alegus cannot walk further yet.

---

## 5. The ladder

Each rung ends with something playable. Hours are total build effort, most of it Claude's; the calendar column assumes about twelve human hours a week going to direction, integration and testing.

| # | Rung | You can | Hours | Calendar |
|---|---|---|---|---|
| 0 | Browser prototype | Move, swing, see the look | done | done |
| 1 | **The look, running** | Walk a room with the full render stack | 60 | done, in the browser |
| 2 | **Combat feel** | Fight three Frayed types with the Blunt club and die | 110 | built, plus a character and faces pass |
| 3 | **A run** | Clear six rooms through doors with rewards, then restart | 60 | built |
| 4 | **Inventions** | Build a run out of 20 boons from four Inventors | 60 | built, rewritten once after playtest |
| 5 | **The boss** | Fight the Mammoth Mother through three phases | 80 | built, awaiting a verdict |
| 6 | **The Hearth** | Die, come back, spend Ochre, read the Firekeeper, go again | 70 | 6 weeks |
| 7 | **Content and feel** | Play ten runs without repeating a room or getting bored | 140 | 12 weeks |
| 8 | **Ship** | Buy it on Steam | 120 | 10 weeks |

Roughly **800 hours, 12 to 18 months**, and the spread is entirely about how many hours the two of you actually find.

**Rung 1 is written and unverified.** Godot is not installed in the container Claude works in, so it is the first code on the project nobody has seen execute. `game/README.md` carries the failure list and the one-line fix for each. Getting it running is the first job of the next session.

**Rung 2 is the gate.** If the combat does not feel good, nothing after it matters and the project should stop or change. Edward decides, and he should be ruthless about it. It is much cheaper to fail at week fourteen than at month twelve.

**Rung 7 is where projects like this die.** The work stops being new and becomes ten room layouts and a balance pass. Budget it honestly, which is why it is the largest rung on the ladder.

---

## 6. How a session should work

The shape that suits this team:

1. **Claude writes ahead.** Between sessions, code, design and art definitions land on the branch.
2. **James pulls and runs it.** The first thing that happens in a session is playing the current build.
3. **Edward judges it.** Out loud, specifically: what feels wrong, what reads badly, what is boring.
4. **That becomes the next instruction.** Not a backlog, one or two concrete things.
5. **The session ends with the build running.** Never leave it broken between sessions; a broken build costs a whole session of the twelve hours.

Keep a single running note of what Edward said in each session. Taste judgements are easy to make and easy to forget, and they are the scarcest input on the project.

---

## 7. Risks

1. **Hours evaporate.** The commonest way a project like this dies. Mitigation: the ladder is built so that stopping after any rung leaves something that runs, and rung 7 has a smaller honest version if needed.
2. **Code-authored art hits its ceiling at the boss.** Mitigation named in section 2: a painted texture on a code-defined rig. Decide at rung 5, not earlier.
3. **The combat is not fun.** Mitigation: it is rung 2, it is the gate, and Edward owns the call.
4. **Godot's learning curve eats the early weeks.** Mitigation: rung 1 is deliberately generous at five weeks for sixty hours of work, most of which is Claude's.
5. **Scope creeps back to five ages.** Mitigation: it is written down here that it will not, and the story reason for stopping at one age is already in the design.
6. **Audio has no owner.** Nobody on this team makes music and Claude cannot hear. Mitigation: license it. Decide at rung 6, budget real money for it, and treat it as a purchase rather than a task.

---

## 7a. The hardware constraint, and the route through it

The development machine is a **Chromebook**. Claude recommended Godot without
asking, which was a mistake.

Godot does run there, through the ChromeOS Linux environment, but inside a
container with software-assisted graphics, so any frame rate measured on it says
nothing about a Windows target. And a Steam build cannot be produced or tested
on a Chromebook at all. That is true of any engine, not just Godot.

**Decided: build in the browser now, Steam later.**

The game is written in JavaScript and runs in a browser tab, which the
Chromebook does perfectly. Claude publishes each build as a link; James opens it
and plays. No install, no build step, no local server, nothing to set up. The
source lives in this repository as normal.

Steam stays the goal. Reaching it means wrapping the finished game with Electron
or Tauri, which needs a desktop machine for an afternoon, once, near the end.

### What keeps Steam open

These are constraints on how the browser build is written, and they cost nothing
now while a wrap later would be expensive without them:

| Rule | Why |
|---|---|
| Game logic stays free of the DOM | Only the shell touches the page, so the shell is the only thing a wrap replaces |
| Saving goes through one storage interface | `localStorage` behind it now, a real file later, one file changed |
| Input goes through one input interface | Keyboard and touch now; the Gamepad API is the same in a wrap, and Deck needs it |
| Audio through the Web Audio API | Works unchanged inside Electron and Tauri |
| Art stays code, never files | Already true, and it ports to anything |
| No framework the wrap has to fight | Plain modules and a canvas |

### The Godot port is parked, not deleted

`game/` stays as it is. It proved the look ports to a real engine and it is the
fallback if the browser route hits a ceiling. Nobody should work on it.

---

## 8. Decisions log

| Decision | Call | Status |
|---|---|---|
| Team | James, Edward, Claude. About twelve human hours a week | Given |
| Art production | Authored as code, no image assets. Claude writes it | Decided, and proven by the render test |
| Art direction | Watercolour, paper puppets, no ink outline, no edge darkening | Decided by Edward from the interactive test |
| Figure readability | Paper reserve taken from the whole silhouette | Replaces the ink outline |
| Engine | **Reopened.** Godot was chosen before Claude knew the development machine is a Chromebook | Open. See the hardware note below |
| Prototyping | Browser sandbox in `tools/render-test`, Godot for real | Decided |
| Platform | Steam, Windows build, Deck Verified | Confirmed earlier, unchanged |
| First release scope | The Stone Age alone | Decided |
| Voice acting | None. Text dialogue | Decided by budget |
| Music and sound | Licensed or commissioned | Open, decide at rung 5 |
| Forced evolution | No. Players can hold a form | Decided |
| Tone | Darkens subtractively, warmth relocates to the Hearth | Decided |
| Early Access | Open, deliberately deferred | Revisit at rung 7, where it fits this team better than it did the old plan |

---

## 9. What the other documents are now

They were written for a bigger project. They are still correct as design, and they are the content plan for everything after the Stone Age. Read them that way rather than as a schedule.

The three that govern the first release are `VERTICAL_SLICE.md`, `RENDER_PIPELINE.md` and `WEAPONS.md`. `FIREKEEPER_DIALOGUE.md` is the only dialogue needed at launch. Everything else is for later.
