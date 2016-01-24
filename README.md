# countdown
Adaptation of Numbers round Countdown (game show) with Constraint Programming

## Dependencies
* IBM Ilog Optimization Studio

## How to use it
* Choose a game mode (*mod* file)
* Uncomment or add one instance of game in *countdown.dat*

### Command
`oplrun countdown.mod countdown.dat`

## Code example
The following example use the classic game rules.

### Input
```
n = 6;                          // number of tiles
target = 654;                   // number to find
values = [4, 5, 6, 7, 9, 10];   // tiles available
```

### Output
```
OBJECTIVE: 0; 5
target: 654
values:  [4 5 6 7 9 10]
res:  [0 6 13 130 650 654 654]
operator:  [1 1 3 3 1 5]
index:  [3 4 6 2 1 5]
0 + 6 = 6
6 + 7 = 13
13 * 10 = 130
130 * 5 = 650
650 + 4 = 654
```

## Game Modes
* classic game (countdown.mod)
* exponential operator (countdown_power.mod)
* use all operators (countdown_allops.mod)
* negative numbers (countdown_neg.mod)
* choose number of operations (countdown_ops.mod)

