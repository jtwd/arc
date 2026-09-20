# Difficulty and accessibility

Two systems that pull in opposite directions from the same place: how hard the run is. **Anachronisms** make it harder for better rewards, after the first clear. **The Firekeeper's Hand** makes it easier, at any time, for anyone. Neither is hidden in a menu the player has to go looking for.

---

## 1. Anachronisms

The Pact of Punishment equivalent, unlocked after the first Terminus clear. The player assembles a set of modifiers at the Hearth before a run. Each rank is worth **Anachronism points**, and the point total is the run's difficulty number for rewards, story gates, and achievements.

The fiction: every modifier is a break in history. The Loom is holding a frayed weave together, and the player is deliberately pulling a thread.

### 1.1 The list

| Modifier | Ranks | Points per rank | Effect per rank |
|---|---|---|---|
| **Hardened History** | 5 | 1 | Enemies have 20% more health |
| **Quick Frayed** | 3 | 1 | Enemy move and attack speed up 15% |
| **Crowded Weave** | 2 | 2 | 30% more enemies per room |
| **Borrowed Arms** | 2 | 3 | Enemies carry weapons from one age later. At rank 2, two ages later |
| **Longer Fray** | 2 | 3 | Bosses gain an extra health bar with a full attack set |
| **Brittle** | 3 | 2 | Alegus takes 20% more damage |
| **Short Fuse** | 3 | 2 | One fewer Death Defiance |
| **Cold Hearth** | 3 | 1 | Fountains heal 50% less. At rank 3 there are no fountains |
| **Lean Years** | 2 | 1 | Shop prices up 50% |
| **Fewer Altars** | 2 | 2 | One fewer Invention altar per age |
| **Common Ideas** | 2 | 2 | Inventions are offered one rarity lower |
| **Tight Weave** | 2 | 1 | Rooms are 15% smaller |
| **The Pull** | 3 | 2 | Each room has a time limit. Exceeding it spawns a wave every 15 s until the room is cleared |
| **Heavy Loom** | 1 | 2 | The Loom will not be refused. Holding a form is disabled |
| **Stubborn Thread** | 1 | 4 | The Loom cannot reach the weapon at all. The Stone Age form is held for the entire run |

Maximum is 48 points, which nobody should be able to clear at launch. Design the reward curve against 20 to 30.

**Heavy Loom and Stubborn Thread are the two promised in `GAME_DESIGN.md` 4.4.** They are opposites and cannot be taken together, which the interface should prevent rather than explain.

### 1.2 Rewards

| Points | Ochre and Amber bonus | Unlocks |
|---|---|---|
| 1 to 4 | +10% | — |
| 5 to 9 | +25% | — |
| 10 to 14 | +50% | Story beat: the Firekeeper on why Alegus keeps making it harder |
| 15 to 19 | +75% | A Hearth cosmetic |
| 20 to 24 | +100% | Story beat: the Terminus addresses the player, not Alegus |
| 25 to 29 | +125% | Final Aspect rank cap raised |
| 30+ | +150% | Achievement, and the run is recorded on the Cave Wall permanently |

**Stubborn Thread has its own achievement** regardless of point total: clear the game having never let the Loom touch the weapon.

### 1.3 Rules

- Anachronisms are set per run and cannot be changed mid-run.
- The set is saved as a loadout so a player grinding a target does not rebuild it every time.
- Anachronism points and the Firekeeper's Hand are independent. A player can run both, and the Hand does not reduce Anachronism rewards. Someone who wants a hard pact with damage resistance is allowed to want that.

---

## 2. The Firekeeper's Hand

The God Mode equivalent, and the thing that decides whether this game is playable by people who want the history and the story but not the difficulty.

**Effect.** Alegus takes 20% less damage. Each time he dies with it on, that rises by 2%, to a maximum of 80%.

**Rules that matter more than the numbers:**

- **Toggleable at any time**, including mid-run, from the pause menu. Not buried in settings.
- **No penalty of any kind.** It does not disable achievements, reduce currency, hide content, or mark the save. A player who finishes the game with it on finished the game.
- **Offered, not hidden.** After three deaths to the same boss, the Firekeeper mentions it once, in character, without pressure. It is never mentioned again.
- **Diegetic name and framing.** It is the fire looking after him, which is exactly what the Firekeeper has been doing since conversation one. It is not called easy mode and it is not framed as a concession.

The Firekeeper's line when it offers, once only:

> "You can put your hand in the fire, you know. It won't burn you. It never has. You only have to ask, and you have never once asked."

---

## 3. Accessibility

Beyond difficulty. Several of these are cheap now and expensive later, so they belong in the slice and alpha rather than in polish.

### 3.1 Needed in the vertical slice

| Feature | Why now |
|---|---|
| Full input remapping, controller and keyboard | Retrofitting hardcoded inputs is expensive |
| Hold or toggle for every held input | Affects the Sling draw and the Blunt charge, which are being designed now |
| **Bleed and wobble intensity slider, 0 to 100%** | The render stack drifts the image continuously. That will cause discomfort for some players. The pass is already droppable, so the slider is nearly free |
| Screen shake and flash intensity sliders | Same reason |
| Text size and high-contrast UI mode | Also required for Steam Deck legibility, so it is not extra work |

### 3.2 Needed by alpha

| Feature | Note |
|---|---|
| Enemy outline colour setting | The game leans hard on per-age palettes. The ink outline is the one thing that must never be ambiguous, so let the player set it |
| Subtitle size, background opacity, speaker names | Alegus talks constantly and much of the story is in barks |
| Global game speed, 50% to 100% | Helps far more players than a damage toggle does, and costs one time scale |
| Aim assist for Sling, off by default, three strengths | The only lineage with a precision requirement |
| Auto-recover Cast | Removes a fiddly retrieval loop for players with motor impairments |

### 3.3 Colour

The palette shifts per age are a core part of the design and cannot be flattened. So the accessibility answer is not a colourblind filter over the whole game, it is guaranteeing that **nothing important is communicated by hue alone**:

- Hostile things have an ink outline. Harmless things never do.
- Elites are gold outline **and** a visibly different silhouette.
- Telegraphs are hard-edged shapes, distinguished by shape rather than colour.
- Hazard floors have a moving pattern, not just a tint.

Audit this at the end of each age's art pass rather than once at the end of the project.

---

## 4. Open

- Whether the Firekeeper's Hand cap of 80% is enough. Hades uses the same ceiling and it is not always sufficient for the last fight. Revisit after the beta Terminus test.
- Whether Anachronism loadouts should be shareable as a code. Cheap, good for community, not needed at launch.
