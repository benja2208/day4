# Week 2 - Battleships

Aim of this week is to create a model of battleships. Working slowly from the small features to the higher level features. Will be apllying everything learnt from week 1 into this. Hopefully, TDD comes more natural now.

These are the user stories we will be trying to model.
```
As a player
So that I can prepare for the game
I would like to place a ship in a board location

As a player
So that I can play a more interesting game
I would like to have a range of ship sizes to choose from

As a player
So that I can create a layout of ships to fox my opponent
I would like to be able to choose the directions my ships face in

As a player
So that I can have a coherent game
I would like ships to be constrained to be on the board

As a player
So that I can have a coherent game
I would like ships to be constrained not to overlap

As a player
So that I can win the game
I would like to be able to fire at my opponents board

As a player
So that I can refine my strategy
I would like to know when I have sunk an opponent's ship

As a player
So that I know when to finish playing
I would like to know when I have won or lost

As a player
So that I can consider my next shot
I would like an overview of my hits and misses so far

As a player
So that I can play against a human opponent
I would like to play a two-player game
```
## Domain Model
Objects | Message
------- | -------
User | fire at opponents, won or loss, log of hits and misses, two player game
Board | locations, constraints
Ships | placeable, directions, sizes, be hit or miss, cannot overlap
