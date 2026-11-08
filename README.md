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
## Roadmap

- [ ] Game logic and shuffle
- [ ] Difficulty menu and grid sizes
- [ ] Timer, score, and move counter
- [ ] Win screen
- [ ] Testing and polish

  Ideas for later: saved best scores, a pause button, and selectable card themes.
