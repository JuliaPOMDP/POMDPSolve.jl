# POMDP-Solve

This is a Julia wrapper for the POMDP-Solve program, orginally developed at Brown University.
his package uses the code available from the (pomdp-solve github page)[https://github.com/cmansley/pomdp-solve].

The pomdp-solve program solves partially observable Markov decision
processes (POMDPs), taking a model specifical and outputting a value
function and action policy.  It employs many different algorithms,
some exact and some approximate.

## Get It:

`Pkg.clone("https://github.com/sisl/POMDPSolve.jl")`

## Usage:

```julia
solver = POMDPSolveSolver()
pomdp = POMDPSolveFile(Pkg.dir("POMDPSolve", "test", "tiger.pomdp"))
policy = POMDPSolvePolicy("mypolicy.policy")
solve(solver, pomdp, policy) # creates a .alpha and a .pd file; loads results into policy
```

Note that you can generate `.pomdp` files using (POMDPFiles)[https://github.com/sisl/POMDPFiles.jl]

```julia
using POMDPFiles
using POMDPModels
fout = open("tiger.pomdp")
write(fout, TigerPOMDP())
close(fout)
pomdp = POMDPSolveFile("tiger.pomdp")
```

## Parameters:

The following parameters come from http://www.pomdp.org/code/cmd-line.html:

```
stdout <filename>
	type    = AbstractString
    units   = filename
    default = STDOUT
```
    
The pomdp-solve program displays much status and progress
information to stdout.  If you want to have this redirected to a file
instead, provide the file name as this parameter.  Not specifying
this option will simply make this information go to normal STDOUT.

```
rand_seed <seed1:seed2:seed3>
	type    = Tuple{Int,Int,Int}
    default = init via system time
```
For any functionality that requires random numbers, we want to be
able to reproduce a given run by executing with the same random
number seed.  This parameter allows you to set the initial random
seed by specifying a string consisting of three integers separated by
a colon (e.g., "34523:12987:50732" ) Not setting this value will
result in the random seed being pseudo-randomized based on the system
clock.

```
stat_summary <flag>
	type    = Bool
    default = false
```

The pomdp-solve program is capable of keeping various statistical
information as it solves the problem.  If you want to track these
stats and print them, set this flag to true.

```
memory_limit <limit>
	type    = Int
    units   = bytes
    valid   = 1:typemax(Int)
    default = Inf
```

This parameter allows you to set an upper bound on the amount of
memory that this program uses. If the memory threshold is met, the
program execution is terminated.  Without specifying this
parameter, there will be no upper bound imposed by the pomdp-solve
program (though the OS will naturally have something to say about
this).

```
time_limit <limit>
	type    = Int
    units   = seconds
    valid   = 1:typemax(Int)
    default = Inf
```

This parameter allows you to set an upper bound on the amount of
time that this program will run. When this amount of time has
elapsed, the program execution is terminated.  Without specifying
this parameter, there will be no upper bound imposed by the pomdp-solve
program.

```
terminal_values <initial_policy_filename>
	type    = AbstractString
    units   = filename

```

Value iteration assumes that at the end of the lifetime of the
decision maker that no more values will be accrued.  This corresponds
to a terminal value function of all zeroes.  This is essentially the
default starting point for the program.  However, with this parameter,
you can set a different terminal value function, which serves as the
seed or initial starting point for value iteration.  Effectively, this
allows you to take the output of one value iteration run and send it
as input to the next.  The file format for this input file is
identical to the output file format of this program (the ".alpha"
file).

```
horizon <value>
	type    = Int
    units   = iteration
    valid   = 1:typemax(Int)
    default = run until convergence
```

Value iteration is iterative and thus we may want to find 'finite
horizon' solutions for various reasons.  To make pomdp-solve terminate
after a fixed number of iterations (aka epochs) set this value to be
some positive number.  By default, value iteration will run for as
many iterations as it take to 'converge' on the infinite horizon
solution.

```
discount <value>
	type    = Float64
    valid   = (0:1)
    default = -1
```

This sets the discount factor to use during value iteration which
dictates the relative usefulness of future rewards compared to
immediate rewards.

```
stop_criteria <value>
	type    = Symbol
    valid   = {:exact, :weak, :bellman}
    default = :weak
```

At the end of each epoch of value iteration, a check is done to
see whether the solutions have 'converged' to the (near) optimal
infinite horizon solution.  there are more than one way to determine
this stopping condition.  The exact semantics of each are not
described here at this time.

```
stop_delta <value>
	type    = Float64
    valid   = 0:Inf
    default = 1e-9
```

When checking the stopping criteria at the end of each value
iteration epoch, some of the stopping condition types use a
tolerance/precision in their calculations.  This parameter allows you
to set that precision.

```
save_all <flag>
	type    = Bool
    default = false
```

Normally, only the final solution is saved to a file, but if you
would like to write out the solution to every epoch of value
iteration, then set this flag to true.  The epoch number will be
appened to the filenames that are output.

```
vi_variation <flag>
	type    = Symbol
	valid   = {:normal, :zlz, :adjustable_epsilon, :fixed_soln_size}
    default = :normal
```

Independent of particular algortihms for computing one iteration
of value iteration are a number of variations of value iteration meant
to help speed up convergence.  We do not yet attempt to give a full
description of the semantics of each here.

```
start_epsilon <value>
	type    = Float64
	valid   = 0:typemax{Float64}
```

When solving using the 'adjustable_epsilon' method of value
iteration, we need to specify both a staring and ending precision.
This is the starting precision.

```
end_epsilon <value>
	type    = Float64
	valid   = 0:typemax{Float64}
```

When solving using the 'adjustable_epsilon' method of value
iteration, we need to specify both a staring and ending precision.
This is the ending precision.

```
epsilon_adjust <value>
	type    = Float64
	valid   = 0:typemax{Float64}
```

When solving using the 'adjustable_epsilon' method of value
iteration, we need to specify a staring and ending precision as
well as the increment to use for each adjustment.
This is the precision increment.

```
max_soln_size <value>
	type    = Float64
	valid   = 0:typemax{Float64}
```

When solving using the 'fixed_soln_size' method we need to define
what the maximal size of a soltuion we will tolerate.  This sets that
limit.

```
history_length <value>
	type    = Int
	units   = epochs
	valid   = 1:typemax{Int}
```

When using the 'adjustable_epsilon' value iteration variant, we
need to compare solution sizes from the the rpevious epochs to see
whethere or not the solutions are staying relatively constant in
size.  To do this, we need to define a past window length, as well as
a tolerance on how much variation in solution size we want to care
about.  This parameter defines the length of the epoch window history
to use when determining whether it is time to adjust the precision of
the value iteration solution.

```
history_delta <value>
	type    = Int
	valid   = 1:typemax{Int}
```

When using the 'adjustable_epsilon' value iteration variant, we
need to compare solution sizes from the the previous epochs to see
whether or not the solutions are staying relatively constant in
size.  To do this, we need to define a past window length, as well as
a tolerance on how much variation in solution size we want to care
about.  This parameter defines the tolerance on what we will
consider all solutions to be of the same size.

```
dom_check <flag>
	type    = Bool
	default = true
```

There is a computationally simple, but not precision domination
check that can be done to discover useless components of a value
function.  This is often useful, but there are circumstances in which
it is best to turn this off.

```
prune_epsilon <value>
	type    = Float64
	valid   = 0:typemax{Float64}
	default = 1e-9
```

There are a number of ways to prune sets of value function
components.  Each uses a precision actor which is this parameter.

```
epsilon <value>
	type    = Float64
	valid   = 0:typemax{Float64}
	default = 1e-9
```

This is the main precision setting parameter which will effect the
preciseness for the solution procedures.

```
lp_epsilon <value>
	type    = Float64
	valid   = 0:typemax{Float64}
	default = 1e-9
```

Many solution procedures employ linear programming in their
algorithms.  For those that do, thisk is the precision level used
inside the linear programming routines.

```
proj_purge <value>
	type    = Symbol
	valid   = {:none, :domonly, :normal_prune, :epsilon_prune}
	default = :normal_prune
```

The first step for most algorithms is to compute the forward
projection of the previous iteration solution components.
Combinations of these will comprise the current solution.  Prior
to emplying any algorithm to find which combinations are needed (the
heart of the POMDP solution algorithms) we can employ a process of
pruning the projected set, often reducing the complexity of the
algorithms.  This parameter decides what type of pruning to use at
this step.  Details on the semantics of each type of pruning are not
yet given here.

```
q_purge <value>
	type    = Symbol
	valid   = {:none, :domonly, :normal_prune, :epsilon_prune}
	default = :normal_prune
```

Some algorithms will separately solve the problem for individual
actions, then merge these results together.  The individual action
solutions are referred to as the "Q-functions".  After merging, some
pruning process will likely take place, but we can also choose to do a
pre-merge pruning of these sets which often simplifies the merging
process.  This parameter defines the method to use for this pre-merge
pruning.

```
witness_points <flag>
	type    = Bool
	default = false
```

Keeping 'witness points' means to track individual points that
have been found that gave rise to individual value function
components. These can often be used to help speed up the solution
process.

```
alg_rand <valid>
	type    = Int
	units   = points
	valid   = 0:typemax{Int}
```

One can speed up the discovery of the initial shape of the value
function by randomly generating points and finding the value function
components needed for those points.  This technique is used if this
parameter has a non-zero value.

```
prune_rand <valid>
	type    = Int
	units   = points
	valid   = 0:typemax{Int}
```

When pruning sets of value function components, we can use a
random set of points to help speed up the pruning process.  This
parameter, if specified and non-zero, will define the number of random
points to use in this way.

```
method <value>
	type    = Symbol
	valid   = {:enum, :twopass, :linsup, :witness, :incprune, :grid, :mcgs}
	default = :incprune
```

The pomdp-solve program implements a number of differnt
algorithms.  This selects the one that should be used. Details of
each method not yet provided here.

```
enum_purge <value>
	type    = Symbol
	valid   = {:none, :domonly, :normal_prune, :epsilon_prune}
	default = :normal_prune
```

When using the enumeration method, there will be times where the
set of value function components will need to be pruned or purged of
useless components.  This define the pruning method to use for this
algorithm.

```
inc_prune <value>
	type    = Symbol
	valid   = {:normal, :restricted_region, :generalized}
	default = :normal
```

The incremental pruning algorithm has a number of variations.
This parameter selects the variation.  We do not yet discuss here the
nuances of these variations.

```
fg_type <value>
	type    = Symbol
	valid   = {:simplex, :pairwise, :search, :initial}
	default = :initial
```

The finite grid method needs a set of belief points to compute
over.  There are a number of ways to generate this grid, and this
parameter selects the technique to use.  We do not yet here discuss
the details of each of these.

```
fg_points <value>
	type    = Int
	valid   = 1:typemax{Int}
	default = 10000
```

The finite grid method needs a set of belief points to compute
over.  There are a number of ways to generate this grid, and this
parameter selects the maximum number of points that should be
generated during this process.

```
fg_save <flag>
	type    = Bool
	default = false
```

The finite grid method needs a set of belief points to compute
over.  This parameter will turn on and off the saving of these
belief points to an external file.

```
mcgs_traj_length <value>
	type    = Int
	valid   = 1:typemax{Int}
	default = 100
```

The Monte-Carlo, Gauss-Seidel method using trajectories through the
belief space to lay down a grid of points that we will compute the
optimal value funciton for.  This parameter defines the lengths of
the trajectories.

```
mcgs_num_traj <value>
	type    = Int
	valid   = 1:typemax{Int}
	default = 1000
```

The Monte-Carlo, Gauss-Seidel method use trajectories through the
belief space to lay down a grid of points that we will compute the
optimal value funciton for.  This parameter defines the number of
trajectories to use.

```
mcgs_traj_iter_count <value>
	type    = Int
	valid   = 1:typemax{Int}
	default = 100
```

The Monte-Carlo, Gauss-Seidel method using trajectories through the
belief space to lay down a grid of points that we will compute the
optimal value funciton for.  This parameter defines the number of
value function update iterations to use on a given set of
trajectories.

```
mcgs_prune_freq <value>
	type    = Int
	valid   = 1:typemax{Int}
	default = 100
```

The Monte-Carlo, Gauss-Seidel method using trajectories through the
belief space to lay down a grid of points that we will compute the
optimal value funciton for.  This parameter defines how frequently
we should prune the set of newly created value function facets
during the generation of the value function points.

```
fg_purge <value>
	type    = Symbol
	valid   = {:none, :domonly, :normal_prune, :epsilon_prune}
	default = :normal_prune
```

Defines the technique to use during pruning when the finite grid
method is being used.

```
verbose <value>
	type    = Symbol
	valid   = {:context, :lp, :global, :timing, :stats, :cmdline, :main, :alpha, :proj, :crosssum, :agenda, :enum, :twopass, :linsup, :witness, :incprune, :lpinterface, :vertexenum, :mdp, :pomdp, :param, :parsimonious, :region, :approx_mcgs, :zlz_speedup, :finite_grid, :mcgs}
```

Each main module of pomdp-solve can be separately controlled as
far as extra debugging output is concerned. This option can be used
more than once to turn on debugging in more than one module.
This input is technically repeatable in pomdp-solve.
