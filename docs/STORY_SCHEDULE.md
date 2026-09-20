# Story unlock schedule

`GAME_DESIGN.md` section 7 sets the target: something new in the hub after nearly every run for the first thirty runs. This is how that is delivered.

The Firekeeper's first ten conversations are scripted in `FIREKEEPER_DIALOGUE.md`. This document places them among everything else and carries the schedule to the end of the launch game.

---

## 1. The four gate types

Mixing gate types is what makes progression feel responsive rather than metered. Hades does this and it is the single most copyable thing about its pacing.

| Gate | Feels like | Use for |
|---|---|---|
| **Run count** | Steady drip | Baseline conversations, so there is always something |
| **First-time event** | The game noticed | Boss kills, first duo, first death to a new enemy, reaching a new age |
| **Brought back** | Alegus did something | Codex entries, discoveries, an item taken from a boss |
| **Gift** | The player chose | Tallow spent on a cast member opens their next beat |

Rule: **no run should be gated on run count alone if a first-time event is available.** The run-count beats are the safety net for a player who is not progressing, not the main channel.

---

## 2. Runs 1 to 10, the Stone Age

The vertical slice window. Everything here is in the slice build.

| Trigger | Unlock |
|---|---|
| Run 1 return | Firekeeper 1. The Hearth exists |
| Run 2 return | Firekeeper 2 |
| Run 3 return | Firekeeper 3. Cave Wall rows 1 to 3 open |
| Run 4 return | Firekeeper 4. The Frayed are named |
| First Mammoth Mother kill | Firekeeper 5. First handprint added to Alegus's arm. First Key of Ages |
| After the kill | Firekeeper 6. Edge lineage unlocks on the rack |
| Run 7 | Firekeeper 7. The Age of Rivers is named for the first time |
| First death with Edge | Firekeeper 8 |
| Cave Wall reaches 5 total ranks | Firekeeper 9 |
| Second Mammoth Mother kill, or run 15 | Firekeeper 10. **The Age of Rivers unlocks** |

## 3. Runs 10 to 20, opening up

| Trigger | Unlock |
|---|---|
| First entry to the Age of Rivers | **The Cartographer arrives.** Charts currency introduced |
| First re-forge completed | Keepsake system explained. The First Coal awarded |
| First Sphinx kill | Firekeeper: what Alegus carried, the answer promised in conversation 10 |
| 20 distinct enemy kills | **The Archivist arrives.** Codex opens |
| First duo Invention | Archivist beat 1. Inventor keepsakes unlock |
| 2 Keys of Ages | Sling lineage available |
| First entry to the Age of Empires | **Form holding unlocks.** The Firekeeper explains that the Loom's hand can be refused |
| First held form | Firekeeper: the first thing Alegus has done that is entirely his own |
| Gift, 1 Tallow to the Cartographer | Cartographer beat 1. Dog-Ear keepsake |

## 4. Runs 20 to 35, the middle

This is where a player either settles in or drifts off, so the density is highest here.

| Trigger | Unlock |
|---|---|
| First Legate kill | Firekeeper on empires. Amber currency introduced, Aspects open |
| Run 22 | **Wren arrives.** She has already beaten his best and will mention it |
| First Wren's mark found in a run | Wren beat 1 |
| First shared room with Wren | Wren beat 2. Wren's Knot keepsake |
| 3 Aspects unlocked | Archivist beat 2, on Alegus changing shape |
| First entry to the Age of Faith and Steel | Tonal pivot. The Firekeeper stops testing him |
| First Hollow Knight kill | The largest beat before the endgame. "Who was it for?" is answered by nobody |
| 50 distinct enemy kills | Archivist beat 3. The Tally keepsake |
| Gift, 2 Tallow to Wren | Wren beat 3, on how she died |
| Gift, 2 Tallow to the Archivist | Archivist beat 4, on never having seen any of it |
| Three deaths to the same boss | **The Firekeeper's Hand is offered.** Once, in character, never again |

## 5. Runs 35 to 50, the end

| Trigger | Unlock |
|---|---|
| First entry to the Age of Sail | The Cartographer's handwriting is on the charts. Alegus does not remark on it |
| First Admiral kill | **The Terminus becomes reachable** |
| First Terminus attempt | The Terminus speaks to Alegus for the first time and offers him a title |
| Third Terminus attempt | Cartographer beat 2. They work out what the table is, and say nothing |
| First Terminus clear | **Ending.** Alegus wakes at the Hearth, adds a handprint, and the Firekeeper says the first line of the game again |
| After the first clear | **Anachronisms unlock.** The Quiet keepsake from the Terminus |

## 6. After the first clear

The epilogue runs on the Hades model: the game does not stop, and the cast keeps talking. A beat fires roughly every two or three runs until the cast is exhausted, then settles to rare.

| Trigger | Unlock |
|---|---|
| Each subsequent clear, up to ten | One epilogue beat, rotating through the cast |
| 10 Anachronism points in a cleared run | Firekeeper: why Alegus keeps making it harder |
| 20 Anachronism points in a cleared run | The Terminus addresses the player rather than Alegus |
| Stubborn Thread clear | Achievement, and Wren has one line about it that she has clearly been saving |
| All cast beats seen | The Hearth gains its final state. Everyone is there at once, which has not happened before |

---

## 7. Density check

| Window | Beats | Runs | Beats per run |
|---|---|---|---|
| Runs 1 to 10 | 10 | 10 | 1.0 |
| Runs 10 to 20 | 9 | 10 | 0.9 |
| Runs 20 to 35 | 11 | 15 | 0.73 |
| Runs 35 to 50 | 6 | 15 | 0.4 |

The taper is intended. Early runs need a reason to start again; by run forty the reason is the game itself. If alpha testing shows drop-off in the 35 to 50 window, the fix is more first-time-event gates on Aspects and duos, not more conversations.

---

## 8. Writing order

For the production plan, beats are needed in this order:

1. **Slice:** Firekeeper 1 to 10. Roughly 160 lines.
2. **Alpha:** Cartographer, Archivist, sections 3 and 4 of this schedule. Roughly 900 lines.
3. **Beta:** Wren, the Terminus, the ending, section 5 and the epilogue. Roughly 1,100 lines.

Wren lands last and is the largest single writing task after Alegus himself, which is a scheduling risk worth naming: she carries the late-game tone and she is written under the most schedule pressure. Consider writing her beats early even if they are recorded late.
