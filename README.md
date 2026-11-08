# Memory Match

A mobile memory card game. Flip two cards at a time, find every matching pair, and beat your best time and move count.

Built by team **Memory Match** for our mobile app development class.

## Features

- **Classic matching gameplay:** flip two cards per turn. Matches stay face up, and mismatches flip back.
- **Three difficulty levels:** larger grids mean more pairs to find.
- **Timer-based score:** a faster finish earns a higher score, and harder levels earn a higher multiplier.
- **Move counter:** every pair of flips counts as one move.
- **Shuffle from our Klondike game:** card order is randomized with the shuffle routine from our earlier Klondike solitaire project.
## Difficulty levels

| Level  | Grid (columns × rows) | Cards | Pairs |
| ------ | --------------------- | ----- | ----- |
| Easy   | 3 × 4                 | 12    | 6     |
| Medium | 4 × 4                 | 16    | 8     |
| Hard   | 4 × 6                 | 24    | 12    |

## How to play

1. Choose a difficulty from the menu.
2. Tap a card to flip it. The timer starts on your first flip.
3. Tap a second card. If the two match, they stay face up. If not, they flip back.
4. Keep going until every pair is matched.
5. The win screen shows your time, moves, and score.

## Project structure

> Update to match the actual folders.

| Part | Job |
| ---- | --- |
| Card model | Holds each card's pair ID and state (face down, face up, matched) |
| Game logic | Builds and shuffles the deck, checks matches, counts moves, detects a win |
| Shuffle | Randomizes card order, reused from the Klondike project |
| Timer and score | Tracks elapsed time and turns it into a score |
| Screens | Difficulty menu, game board, and win screen |

## Team

- Hailey Campbell
- Ashley Battung

## Build checklist

Work top to bottom: each phase depends on the one before it. When a task is done and checked by a teammate, tick the box and add your initials.

### Phase 1: Setup

- [x] Create the project and push it to the shared GitHub repo (initials: HC)
- [ ] Turn the UI sketches into wireframes for the menu, board, and win screen (initials: ___)
- [ ] Create card designs: face down, face up, and matched (initials: ___)

### Phase 2: Game logic

- [ ] Build the card model (pair ID, and state: face down, face up, or matched) (initials: ___)
- [ ] Find the shuffle from the Klondike project and adapt it to shuffle a list of cards (initials: ___)
- [ ] Write the deck builder: given a grid size, create the pairs and shuffle them (initials: ___)
- [ ] Add flip logic: a tapped card turns face up, and only two can be face up at a time (initials: ___)
- [ ] Add match logic: a matching pair stays face up, and a mismatch flips back after a short pause (initials: ___)
- [ ] Lock taps while two cards are being compared (initials: ___)
- [ ] Add the move counter (two flips = one move) (initials: ___)
- [ ] Add win detection (every pair matched) (initials: ___)

### Phase 3: Game board screen

- [ ] Lay out the card grid so it fits the screen for any grid size (initials: ___)
- [ ] Show the three card looks: face down, face up, and matched (initials: ___)
- [ ] Connect the board to the game logic so taps flip real cards (initials: ___)
- [ ] Milestone: a full Medium (4 × 4) game can be played to the end (initials: ___)

### Phase 4: Difficulty and navigation

- [ ] Build the difficulty menu with Easy, Medium, and Hard (initials: ___)
- [ ] Add the Easy (3 × 4) and Hard (4 × 6) grids (initials: ___)
- [ ] Add Restart and Menu buttons to the board (initials: ___)
- [ ] Connect navigation: menu to board, board back to menu (initials: ___)

### Phase 5: Timer, score, and win screen 

- [ ] Add the timer: starts on the first flip and stops on the last match (initials: ___)
- [ ] Show the time and move count at the top of the board (initials: ___)
- [ ] Write the score formula: faster time scores higher, with a multiplier per difficulty (initials: ___)
- [ ] Build the win screen showing time, moves, and score (initials: ___)
- [ ] Add Play again and Change difficulty buttons to the win screen (initials: ___)
- [ ] Milestone: a player can go from menu to board to win screen on all three levels (initials: ___)

### Phase 6: Core testing checkpoint 

- [ ] Play through Easy, Medium, and Hard on an emulator and fix any bugs (initials: ___)
- [ ] Try edge cases: tapping very fast, tapping the same card twice, leaving the app mid-game, rotating the phone (initials: ___)

### Phase 7: Extra features 

- [ ] Add a pause button that also pauses the timer (initials: ___)
- [ ] Add selectable card themes (animals, shapes, colors) with a way to choose one (initials: ___)
- [ ] Save the best time and fewest moves for each difficulty on the device, and show them in the menu or on the win screen (initials: ___)

### Phase 8: Final testing and polish 

- [ ] Test every level and every extra feature on a real phone (initials: ___)
- [ ] Fix remaining bugs (initials: ___)
- [ ] Playtest and tune the score formula so it feels fair (initials: ___)
- [ ] Polish spacing, colors, and text on every screen (initials: ___)
