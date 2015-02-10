---
layout: post
category: project
title: "Candidate Topics"
date: 2015-02-10T09:10:00-05:00
---

# Hidden Markov Music

Music will be represented as a hidden markov model, in order to teach a program to play original music. The basic structure of the program is the following pipeline:

- input
- preprocessor
- HMM
- postprocessor
- output

The pipeline will be designed such that `input`, `preprocessor`,
`postprocessor`, and `output` are all functions given as parameters. As the most trivial example, `input` reads from a midi controller, `preprocessor` converts the midi sequence to the binary format that HMM expects, `postprocessor` is the inverse of `preprocessor`, and `output` is a function which plays midi notes through the speakers.

The beauty of this system is that the HMM does not care what the binary actually represents, but will learn the conditional probability of one number following another, allowing it to generate a new sequence.

The midi example will probably not produce very good music, but will act as the first proof-of-concept. After that is working, more interesting `pre-` and `post-` processors will be implemented, which will transform midi sequences into more abstract representations, and back.

In the end, I plan to have a GUI which allows the user to switch between different pipeline functions, save/load HMMs, provide input via a keyboard or midi file, and save generated songs to either a midi or audio file. If the HMM runs fast enough, the user should be able to begin playing a song, and the program will respond once they stop playing. `start-of-song` and `end-of-song` will also be given a binary representation, so that the program may end its song, and also play something without the user providing the first few notes.


# Game of Life: Evolved!

A genetic algorithm is to be applied to Conway's Game of Life, in order discover "chaos-producing" initial states. What that essentially means is it takes a long time to either terminate or get stuck in a loop.

The individuals in this GA are the initial game states. At each iteration, these games are run in parallel, each one storing a history of its states (state hashes are stored in place of the actual state), and counting the number of steps until a state is repeated. The count is used as the fitness metric of the individual.

Mutations are made by inverting the state of each cell with a certain small probability, "p", meaning a "live" cell may become "dead", and a "dead" cell may become "live". Crossovers are made by randomly selecting a proportion "q" of the "father" individual's cells, and the other "1-q" of the "mother" individual's cells.

An issue arises when we encounter an initial state which either takes a long period of time (forever?) to terminate. For this reason, a "max iterations" parameter is necessary. However, this means that we are setting an upper bound on the fitness of our generated individuals. To remedy this, those individuals which reach "max iterations" are not placed back into the population, but are instead transported to the "shelter". Once the population in that shelter reaches the size of the total population, a "mass extinction" wipes out all other individuals, and the population of the "shelter" replaces them. At this point, "max iterations" is in fact the lowest possible fitness of the population, and so it is increased significantly (perhaps in powers of two?), and the process repeats.

Eventually, "max iterations" reaches its limit, and the individuals in the "shelter" are evaluated one last time. The individuals are sorted in order of lifetime, and representations of each initial board are saved to files, where they can be loaded for visualization.