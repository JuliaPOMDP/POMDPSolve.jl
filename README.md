# POMDP-Solve

This is a Julia wrapper for the POMDP-Solve program, orginally developed at Brown University.
his package uses the code available from the (pomdp-solve github page)[https://github.com/cmansley/pomdp-solve].

The pomdp-solve program solves partially observable Markov decision
processes (POMDPs), taking a model specifical and outputting a value
function and action policy.  It employs many different algorithms,
some exact and some approximate.

## Get It:

`Pkg.clone("this package")`

## Usage:

``

## Parameters:

`stdout <filename>`
The pomdp-solve program displays status and progress information during exectution.
Using this option redirects that output to a file instead. Not specifying
this option will simply make this information go to normal stdout.

`rand_seed "34523:12987:50732"`
POMDP-solve uses random number. In order to reproduce runs one can set the random number seed.
The seed is specified using a string consisting of three integers separated by a colon (e.g., "34523:12987:50732").
Not setting this value will result in the random seed being pseudo-randomized based on the system clock.

`stat_summary <bool>`
Whether to keep and print internal execution status

`memory_limit <int [bytes]>`
Set upper bound on memory usage, in bytes.

`time_limit <int [s]>`
Set upper bound on the execuution time, in seconds.

`pomdp <filename>`
Set the POMDP model input file name to use.

`terminal_values <filename>`
Value iteration assumes that at the end of the lifetime of the
decision maker that no more reward will be accrued.  This corresponds
to a terminal value function of all zeroes.  This is essentially the
default starting point for the program.  However, with this parameter,
you can set a different terminal value function, which serves as the
seed or initial starting point for value iteration.  Effectively, this
allows you to take the output of one value iteration run and send it
as input to the next.  The file format for this input file is
identical to the output file format of this program (the ".alpha"
file).

`horizon <int>`
Set the number of iterations for value iteration.

`discount <double>`
Set the discount factor used in value iteration, 0 < gamma < 1.

`stop_criteria <exact, weak, bellman>`
Set the value iteration stopping criteria.

