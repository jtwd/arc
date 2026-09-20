# The Cave Wall and the Ochre economy

The permanent upgrade tree (the Mirror of Night equivalent) and the currency curve that feeds it. Covers the full launch tree; the slice uses rows 1 to 3.

---

## 1. How it works

Alegus presses an ochre handprint onto the wall. Each row is one handprint with two positions, left and right. The player buys ranks in one position with Ochre and can switch to the other at any time for free; ranks bought in either position are kept. Rows unlock in order, and rows 7 onward also need a Key of Ages.

This is the Hades design and it is copied because it works: every row is a real choice, no choice is permanent, and switching is free so players experiment.

---

## 2. The tree

Costs are per rank and are cumulative within a position.

| Row | Left | Right | Ranks | Cost per rank | Unlock |
|---|---|---|---|---|---|
| 1 | **Ember's Grace.** One extra Death Defiance per run | **First Strike.** The first hit in each room deals +50% | 3 / 5 | 30, 60, 120 / 20, 30, 40, 50, 60 | Start |
| 2 | **Second Step.** One extra dash charge | **Long Step.** Dash i-frames +2 frames per rank | 1 / 4 | 50 / 30 each | Start |
| 3 | **Red Earth.** +10% Ochre found per rank | **Sharp Flint.** +10% Flint found per rank | 5 / 5 | 40 each | Start |
| 4 | **Thick Hide.** +5 max health per rank | **Quick Blood.** Heal 2% of damage dealt while below 30% health, +1% per rank | 10 / 5 | 25 each / 60 each | Row 1 rank 1 |
| 5 | **Steady Hand.** Attack damage +3% per rank | **Sure Hand.** Special damage +5% per rank | 10 / 10 | 40 each | Row 3 rank 1 |
| 6 | **Far Throw.** Cast damage +10% per rank | **Two Stones.** One extra Ember stone, then +1 Cast damage per rank after | 5 / 1+4 | 50 each / 200, then 60 each | Row 5 rank 3 |
| 7 | **Kindled.** Call meter fills +10% faster per rank | **Banked.** Start each run with 25% Call meter, +10% per rank | 5 / 5 | 80 each | Key of Ages |
| 8 | **Old Paths.** See the reward behind two doors instead of one | **Cartographer's Favour.** One free Invention reroll per run, +1 per rank | 1 / 3 | 300 / 150 each | Key of Ages |
| 9 | **Deep Ochre.** Common Inventions offered are Rare 10% of the time per rank | **Chosen.** One Inventor of choice always appears in the first altar | 5 / 1 | 100 each / 400 | Key of Ages |
| 10 | **Long Memory.** Keep 10% of Flint between runs per rank | **Warm Start.** Begin each run in room 2 with room 1's reward granted | 5 / 1 | 120 each / 800 | Key of Ages, first Age 5 clear |
| 11 | **Fray's Edge.** Enemies below 15% health die instantly, +3% per rank | **Loom's Mercy.** Death Defiance restores 60% health instead of 50%, +5% per rank | 5 / 4 | 150 each / 200 each | Key of Ages, first Age 7 clear |
| 12 | **Handprint.** +2% damage per age cleared this run, per rank | **Thread.** Your weapon evolves one age early | 5 / 1 | 250 each / 2,000 | Key of Ages, first Terminus clear |

Row 12 right is the one deliberately controversial choice: it lets a player skip an age's weapon form. It exists to give players who dislike a particular form some agency without breaking the forced-evolution rule for everyone. It costs enough that it is a late decision.

**Total Ochre to max the wall:** roughly 21,000. Hades' Mirror costs about 27,000 darkness. This is intentionally lower because the game also has Keys, Amber, and Charts competing for attention.

---

## 3. Ochre income

Ochre comes from rooms, bosses, and story rooms. Base values before the Red Earth bonus.

| Source | Ochre | Notes |
|---|---|---|
| Ochre door room | 15 + 5 per age | So 20 in age 1, 60 in age 9 |
| Elite room bonus | +10 | On top of the door reward |
| Story room | 25 | Fixed |
| Boss first kill | 100 per age | Once |
| Boss repeat kill | 20 per age | Every time |
| Run end (death or clear) | 5 per room cleared | Consolation, always |

Simulated in `tools/run-sim`: a full clear that picks Ochre at roughly a third of doors earns about 700 to 850 Ochre with repeat boss kills, and about 4,800 if every boss is a first kill. A slice run earns about 40 to 70 whether it dies at the Mammoth Mother or clears, plus 100 on the first kill.

---

## 4. The curve

Target: the player should always be able to buy something after a run for the first 30 runs, and should reach the Key-gated rows around the time they unlock.

| Runs | Cumulative Ochre (typical) | What is affordable |
|---|---|---|
| 1 | 45 | Row 1 rank 1 |
| 3 | 150 | Rows 1 to 3, one rank each |
| 5 (first boss kill, slice) | 400 | Row 1 full, row 2 dash, row 3 started |
| 10 | 1,000 | Rows 1 to 5 in progress |
| 20 | 2,800 | Rows 1 to 6 mostly done; first Key rows opening |
| 30 | 5,000 | Rows 7 to 9 in progress |
| 50 | 10,500 | Row 10 and 11 |
| 80 | 19,000 | Everything but the last ranks of row 12 |

The curve is built from the simulator's mid and expert profiles, with first-kill bonuses added as ages unlock. Anachronism bonuses (not in the slice) add 20 to 50% Ochre per run for players who take them, so a skilled player maxes the wall in roughly 65 to 80 runs, in line with Hades.

---

## 5. Slice tuning

The slice has rows 1 to 3 and a run income of 40 to 70 Ochre. Over ten runs a tester earns roughly 600 including the first-kill bonus and can fill row 1, buy the second dash, and put several ranks into row 3. That is enough to feel progression every run and to make the second dash a visible milestone around run four.

If testers are maxing all three rows before run eight, halve the elite bonus. If they are not filling row 1 by run four, raise the death consolation to 8 per room.
