"""
    POMDPSolveSolver
   
Type that holds the options for the `pomdpsolve` program. The options correspond to command-line options for the `pomdp-solve` program.
"""
mutable struct POMDPSolveSolver <: Solver
	options::Dict{AbstractString, Any}
end

"""
    POMDPSolveSolver(; kwargs...)

Constructs a `POMDPSolveSolver` object with the specified options. The options correspond to the command-line options for the `pomdp-solve` program, as described in the [POMDP-Solve documentation](http://www.pomdp.org/code/cmd-line.html).

# Keyword Arguments
- `stdout::Union{Nothing, AbstractString}`: Redirect program's stdout to a file of this name. (default: `nothing`)
- `rand_seed::Union{Nothing, Tuple{Int, Int, Int}}`: Set the random seed for program execution. (default: `nothing`)
- `stat_summary::Bool`: Whether to keep and print internal execution stats. (default: `false`)
- `memory_limit::Int`: Set upper bound memory usage. (default: `-1` which results in no limit)
- `time_limit::Int`: Set upper bound on execution time. (default: `-1` which results in no limit)
- `terminal_values::Union{Nothing,AbstractString}`: Sets the terminal value function (starting point). (default: `nothing`)
- `horizon::Int`: Sets the number of iterations of value iteration. (default: `-1` which results in no limit)
- `discount::Float64`: Set the discount fact to use in value iteration (overrides POMDP discount). (default: `NaN` which doesn't override) 
- `stop_criteria::Symbol`: Sets the value iteration stopping criteria. (default: `:default` -> :weak)
- `stop_delta::Float64`: Sets the precision for the stopping criteria check. (default: `NaN` -> 1e-9)
- `save_all::Bool`: Sets whether or not to save every iteration's solution. (default: `false`)
- `vi_variation::Symbol`: Sets the general category of value iteration to use. (default: `:default` -> :normal)
- `start_epsilon::Float64`: Sets the starting precision for adjustable epsilon VI. (default: `NaN`)
- `end_epsilon::Float64`: Sets the ending precision for adjustable epsilon VI. (default: `NaN`)
- `epsilon_adjust::Float64`: Sets the precision increment for adjustable epsilon VI. (default: `NaN`)
- `max_soln_size::Float64`: Sets the max size for the fixed solution size VI. (default: `NaN`)
- `history_length::Int`: Sets history window to use for adjustable epsilon VI. (default: `-1` -> do not use)
- `history_delta::Int`: Sets solution size delta to use for adjustable epsilon VI. (default: `-1` -> do not use)
- `dom_check::Bool`: Controls whether simple domination check is done or not. (default: `true`)
- `prune_epsilon::Float64`: Sets the precision level for the prune operations. (default: `NaN` -> 1e-9)
- `epsilon::Float64`: General solution precision level setting. (default: `NaN` -> 1e-9)
- `lp_epsilon::Float64`: Precision use in linear programs. (default: `NaN` -> 1e-9)
- `proj_purge::Symbol`: Type of pruning to use for pre-iteration solving. (default: `:default` -> :normal_prune)
- `q_purge::Symbol`: Type of pruning to use for a post-iteration solving. (default: `:default` -> :normal_prune)
- `witness_points::Bool`: Whether to include 'witness points' in solving. (default: `false`)
- `alg_rand::Int`: How many points to use to seed value function creation. (default: `-1` -> do not use)
- `prune_rand::Int`: How many points to use to seed pruning process. (default: `-1` -> do not use)
- `method::Symbol`: Selects the main solution algorithm to use. (default: `:default` -> :incprune)
- `enum_purge::Symbol`: The pruning method to use when using the 'enum' algorithm. (default: `:default` -> :normal_prune)
- `inc_prune::Symbol`: The variation of the incremental pruning algorithm. (default: `:default` -> normal)
- `fg_type::Symbol`: Finite grid method means to generate belief points. (default: `:default` -> :initial)
- `fg_points::Int`: Maximal number of belief points to use in finite grid. (default: `-1` -> 10000)
- `fg_save::Bool`: Whether to save the points used in finite grid. (default: `false`)
- `mcgs_traj_length::Int`: Trajectory length for Monte Carlo belief generation. (default: `-1` -> 100)
- `mcgs_num_traj::Int`: Number of trajectories for Monte Carlo belief generation. (default: `-1` -> 1000)
- `mcgs_traj_iter_count::Int`: Times to iterate on a trajectory for MCGS method. (default: `-1` -> 100)
- `mcgs_prune_freq::Int`: How frequently to prune during MCGS method. (default: `-1` -> 100)
- `fg_purge::Symbol`: Finite grid method means to prune value functions. (default: `:default` -> :normal_prune)
- `verbose::Bool`: Turns on extra debugging output for a module. (default: `:default`)

# More detailed description of options
These are descriptions taken from the [POMDP-Solve documentation](http://www.pomdp.org/code/cmd-line.html).

## `stdout::Union{Nothing, AbstractString}`
The pomdp-solve program displays much status and progress
information to stdout.  If you want to have this redirected to a file
instead, provide the file name as this parameter.  Not specifying
this option will simply make this information go to normal stdout.
  
## `rand_seed::Union{Nothing, Tuple{Int,Int,Int}}`
For any functionality that requires random numbers, we want to be
able to reproduce a given run by executing with the same random
number seed.  This parameter allows you to set the initial random
seed by specifying a string consisting of three integers separated by
a colon (e.g., "34523:12987:50732" ) Not setting this value will
result in the random seed being pseudo-randomized based on the system
clock. 

## `stat_summary::Bool`
The pomdp-solve program is capable of keeping various statistical
information as it solves the problem.  If you want to track these
stats and print them, set this flag to true.

## `memory_limit::Int`
*_This option has not been tested successfully using the jll package._*

This parameter allows you to set an upper bound on the amount of
memory that this program uses. If the memory threshold is met, the
program execution is terminated.  Without specifying this
parameter, there will be no upper bound imposed by the pomdp-solve
program (though the OS will naturally have something to say about
this). 

## `time_limit::Int`
This parameter allows you to set an upper bound on the amount of
time that this program will run. When this amount of time has
elapsed, the program execution is terminated.  Without specifying
this parameter, there will be no upper bound imposed by the pomdp-solve
program.

## `terminal_values::Union{Nothing,AbstractString}`
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

## `horizon::Int`
Value iteration is iterative and thus we may want to find 'finite
horizon' solutions for various reasons.  To make pomdp-solve terminate
after a fixed number of iterations (aka epochs) set this value to be
some positive number.  By default, value iteration will run for as
many iterations as it take to 'converge' on the infinite horizon
solution. 

## `discount::Float64`
_Overrides the POMDP discount factor._

This sets the discount factor to use during value iteration which
dictates the relative usefulness of future rewards compared to
immediate rewards.

## `stop_criteria::Symbol`
At the end of each epoch of value iteration, a check is done to
see whether the solutions have 'converged' to the (near) optimal
infinite horizon solution.  there are more than one way to determine
this stopping condition.  The exact semantics of each are not
described here at this time.

Options: `:exact`, `:weak`, `:bellman`

## `stop_delta::Float64`
When checking the stopping criteria at the end of each value
iteration epoch, some of the stopping condition types use a
tolerance/precision in their calculations.  This parameter allows you
to set that precision.

## `save_all::Bool`
Normally, only the final solution is saved to a file, but if you
would like to write out the solution to every epoch of value
iteration, then set this flag to true.  The epoch number will be
appened to the filenames that are output.

## `vi_variation::Symbol`
Independent of particular algortihms for computing one iteration
of value iteration are a number of variations of value iteration meant
to help speed up convergence.  We do not yet attempt to give a full
description of the semantics of each here.

Options: `:normal`, `:zlz`, `:adjustable_epsilon`, `:fixed_soln_size`

## `start_epsilon::Float64`
When solving using the 'adjustable_epsilon' method of value
iteration, we need to specify both a staring and ending precision.
This is the starting precision.

## `end_epsilon::Float64`
When solving using the 'adjustable_epsilon' method of value
iteration, we need to specify both a staring and ending precision.
This is the ending precision.

## `epsilon_adjust::Float64`
When solving using the 'adjustable_epsilon' method of value
iteration, we need to specify a staring and ending precision as
well as the increment to use for each adjustment.
This is the precision increment.

## `max_soln_size::Float64`
When solving using the 'fixed_soln_size' method we need to define
what the maximal size of a soltuion we will tolerate.  This sets that
limit. 

## `history_length::Int`
When using the 'adjustable_epsilon' value iteration variant, we
need to compare solution sizes from the the rpevious epochs to see
whethere or not the solutions are staying relatively constant in
size.  To do this, we need to define a past window length, as well as
a tolerance on how much variation in solution size we want to care
about.  This parameter defines the length of the epoch window history
to use when determining whether it is time to adjust the precision of
the value iteration solution.

## `history_delta::Int`
When using the 'adjustable_epsilon' value iteration variant, we
need to compare solution sizes from the the previous epochs to see
whether or not the solutions are staying relatively constant in
size.  To do this, we need to define a past window length, as well as
a tolerance on how much variation in solution size we want to care
about.  This parameter defines the tolerance on what we will
consider all solutions to be of the same size.

## `dom_check::Bool`
check that can be done to discover useless components of a value
function.  This is often useful, but there are circumstances in which
it is best to turn this off.

## `prune_epsilon::Float64`
There are a number of ways to prune sets of value function
components.  Each uses a precision actor which is this parameter.

## `epsilon::Float64`
This is the main precision setting parameter which will effect the
preciseness fo the solution procedures.

## `lp_epsilon::Float64`
Many solution procedures employ linear programming in their
algorithms.  For those that do, thisk is the precision level used
inside the linear programming routines.

## `proj_purge::Symbol`
The first step for most algorithms is to compute the forward
projection of the previous iteration solution components.
Combinations of these will comprise the current solution.  Prior
to emplying any algorithm to find which combinations are needed (the
heart of the POMDP solution algorithms) we can employ a process of
pruning the projected set, often reducing the complexity of the
algorithms.  This parameter decides what type of pruning to use at
this step.  Details on the semantics of each type of pruning are not
yet given here.

Options: `:none`, `:domonly`, `:normal_prune`, `:epsilon_prune`
    
## `q_purge::Symbol`
Some algorithms will separately solve the problem for individual
actions, then merge these results together.  The individual action
solutions are referred to as the "Q-functions".  After merging, some
pruning process will likely take place, but we can also choose to do a
pre-merge pruning of these sets which often simplifies the merging
process.  This parameter defines the method to use for this pre-merge
pruning. 

Options: `:none`, `:domonly`, `:normal_prune`, `:epsilon_prune`
    
## `witness_points::Bool`
Keeping 'witness points' means to track individual points that
have been found that gave rise to individual value function
components. These can often be used to help speed up the solution
process.

## `alg_rand::Int`
One can speed up the discovery of the initial shape of the value
function by randomly generating points and finding the value function
components needed for those points.  This technique is used if this
parameter has a non-zero value.

## `prune_rand::Int`
When pruning sets of value function components, we can use a
random set of points to help speed up the pruning process.  This
parameter, if specified and non-zero, will define the number of random
points to use in this way.
    
## `method::Symbol`
The pomdp-solve program implements a number of differnt
algorithms.  This selects the one that should be used. Details of
each method not yet provided here.

Options: `:enum`, `:twopass`, `:linsup`, `:witness`, `:incprune`, `:grid`, `:mcgs`

## `enum_purge::Symbol`
When using the enumeration method, there will be times where the
set of value function components will need to be pruned or purged of
useless components.  This define the pruning method to use for this
algorithm. 

Options: `:none`, `:domonly`, `:normal_prune`, `:epsilon_prune`

## `inc_prune::Symbol`
The incremental pruning algorithm has a number of variations.
This parameter selects the variation.  We do not yet discuss here the
nuances of these variations.

Options: `:normal`, `:restricted_region`, `:generalized`

## `fg_type::Symbol`
The finite grid method needs a set of belief points to compute
over.  There are a number of ways to generate this grid, and this
parameter selects the technique to use.  We do not yet here discuss
the details of each of these.

Options: `:simplex`, `:pairwise`, `:search`, `:initial`

## `fg_points::Int`
The finite grid method needs a set of belief points to compute
over.  There are a number of ways to generate this grid, and this
parameter selects the maximum number of points that should be
generated during this process. 

## `fg_save::Bool`
The finite grid method needs a set of belief points to compute
over.  This parameter will turn on and off the saving of these
belief points to an external file. 

## `mcgs_traj_length::Int`
The Monte-Carlo, Gauss-Seidel method using trajectories through the
belief space to lay down a grid of points that we will compute the
optimal value funciton for.  This parameter defines the lengths of
the trajectories.

## `mcgs_num_traj::Int`
The Monte-Carlo, Gauss-Seidel method using trajectories through the
belief space to lay down a grid of points that we will compute the
optimal value funciton for.  This parameter defines the number of
trajectories to use.

## `mcgs_traj_iter_count::Int`
The Monte-Carlo, Gauss-Seidel method using trajectories through the
belief space to lay down a grid of points that we will compute the
optimal value funciton for.  This parameter defines the number of
value function update iterations to use on a given set of
trajectories.

## `mcgs_prune_freq::Int`
The Monte-Carlo, Gauss-Seidel method using trajectories through the
belief space to lay down a grid of points that we will compute the
optimal value funciton for.  This parameter defines how frequently
we should prune the set of newly created value function facets
during the generation of the value function points.

## `fg_purge::Symbol`
Defines the technique to use during pruning when the finite grid
method is being used.

Options: `:none`, `:domonly`, `:normal_prune`, `:epsilon_prune`

## `verbose::Bool`
Each main module of pomdp-solve can be separately controlled as
far as extra debugging output is concerned. This option can be used
more than once to turn on debugging in more than one module.

The `:none` options is a julia specific option that turns off all output using Suppressor.jl.

Options: `:context`, `:lp`, `:global`, `:timing`, `:stats`, `:cmdline`, `:main`, `:alpha`, `:proj`,
         `:crosssum`, `:agenda`, `:enum`, `:twopass`, `:linsup`, `:witness`, `:incprune`, `:lpinterface`,
         `:vertexenum`, `:mdp`, `:pomdp`, `:param`, `:parsimonious`, `:region`, `:approx_mcgs`,
         `:zlz_speedup`, `:finite_grid`, `:mcgs`, `:none`
"""
function POMDPSolveSolver(;
    stdout::Union{Nothing, AbstractString} = nothing,
    rand_seed::Union{Nothing, Tuple{Int,Int,Int}} = nothing,
    stat_summary::Bool = false,
    memory_limit::Int = -1,
    time_limit::Int = -1,
    terminal_values::Union{Nothing,AbstractString}=nothing,
    horizon::Int = -1,
    discount::Float64 = NaN,
    stop_criteria::Symbol = :default,
    stop_delta::Float64 = NaN,
    save_all::Bool = false,
    vi_variation::Symbol = :default, 
    start_epsilon::Float64 = NaN,
    end_epsilon::Float64 = NaN,
    epsilon_adjust::Float64 = NaN,
    max_soln_size::Float64 = NaN,
    history_length::Int = -1,
    history_delta::Int = -1,
    dom_check::Bool = true,
    prune_epsilon::Float64 = NaN,
    epsilon::Float64 = NaN,
    lp_epsilon::Float64 = NaN,
    proj_purge::Symbol = :default,
    q_purge::Symbol = :default,
    witness_points::Bool = false,
    alg_rand::Int = -1,
    prune_rand::Int = -1,
    method::Symbol = :default,
    enum_purge::Symbol = :default,
    inc_prune::Symbol = :default,
    fg_type::Symbol = :default,
    fg_points::Int = -1,
    fg_save::Bool = false,
    mcgs_traj_length::Int = -1,
    mcgs_num_traj::Int = -1,
    mcgs_traj_iter_count::Int = -1,
    mcgs_prune_freq::Int = -1,
    fg_purge::Symbol = :default,
    verbose::Symbol = :default,
)

    options = Dict{AbstractString, Any}()

    if !isnothing(stdout)
        options["stdout"] = stdout
    end
    
    if !isnothing(rand_seed)
        options["rand_seed"] = @sprintf("%d:%d:%d", rand_seed...)
    end
    
    if stat_summary
        options["stat_summary"] = stat_summary
    end
    
    if memory_limit > 0
        @warn """memory_limit has not been tested successfully using the jll package. Use at your own risk.
        Recommend using `time_limit` and/or `horizon` options instead.
        """
        options["memory_limit"] = memory_limit
    end
    
    if time_limit > 0
        options["time_limit"] = time_limit
    end
    
    if !isnothing(terminal_values)
        options["terminal_values"] = terminal_values
    end
    
    if horizon > 0
        options["horizon"] = horizon
    end
    
    if !isnan(discount)
        @assert discount ≥ 0 && discount ≤ 1 "discount must be ∈ [0,1]"
        options["discount"] = discount
    end
    
    if in(stop_criteria, STOP_CRITERIA)
        options["stop_criteria"] = stop_criteria
    elseif stop_criteria != :default
        invalid_option_error("stop_criteria", stop_criteria, STOP_CRITERIA)
    end
    
    if !isnan(stop_delta)
        @assert stop_delta ≥ 0.0 "stop_delta must be greater than or equal to 0.0"
        options["stop_delta"] = stop_delta
    end
    
    if save_all
        options["save_all"] = save_all
    end
    
    if in(vi_variation, VI_VARIATION)
        options["vi_variation"] = vi_variation
    elseif vi_variation != :default
        invalid_option_error("vi_variation", vi_variation, VI_VARIATION)
    end
    
    if !isnan(start_epsilon)
        @assert start_epsilon ≥ 0.0 "start_epsilon must be greater than or equal to 0.0"
        options["start_epsilon"] = start_epsilon
    end
    
    if !isnan(end_epsilon)
        @assert end_epsilon ≥ 0.0 "end_epsilon must be greater than or equal to 0.0"
        options["end_epsilon"] = end_epsilon
    end
    
    if !isnan(epsilon_adjust)
        @assert epsilon_adjust ≥ 0.0 "epsilon_adjust must be greater than or equal to 0.0"
        options["epsilon_adjust"] = epsilon_adjust
    end
    
    if !isnan(max_soln_size)
        @assert max_soln_size ≥ 0.0 "max_soln_size must be greater than or equal to 0.0"
        options["max_soln_size"] = max_soln_size
    end
    
    if history_length > 0
        options["history_length"] = history_length
    end
    
    if history_delta > 0
        options["history_delta"] = history_delta
    end
    
    if !dom_check
        options["dom_check"] = dom_check
    end
    
    if !isnan(prune_epsilon)
        @assert prune_epsilon ≥ 0.0 "prune_epsilon must be greater than or equal to 0.0"
        options["prune_epsilon"] = prune_epsilon
    end
    
    if !isnan(epsilon)
        @assert epsilon ≥ 0.0 "epsilon must be greater than or equal to 0.0"
        options["epsilon"] = epsilon
    end
    
    if !isnan(lp_epsilon)
        @assert lp_epsilon ≥ 0.0 "lp_epsilon must be greater than or equal to 0.0"
        options["lp_epsilon"] = lp_epsilon
    end
    
    if in(proj_purge, ALGORITHM)
        options["proj_purge"] = proj_purge
    elseif proj_purge != :default
        invalid_option_error("proj_purge", proj_purge, ALGORITHM)
    end
    
    if in(q_purge, ALGORITHM)
        options["q_purge"] = q_purge
    elseif q_purge != :default
        invalid_option_error("q_purge", q_purge, ALGORITHM)
    end
    
    if witness_points
        options["witness_points"] = witness_points
    end
    
    if alg_rand ≥ 0
        options["alg_rand"] = alg_rand
    end
    
    if prune_rand ≥ 0
        options["prune_rand"] = prune_rand
    end
    
    if in(method, METHOD)
        if method == :linsup
            @info "The linsup method requires CPLEX."
        elseif method == :grid
            @warn "The grid method requires a .belief file to be generated and this process is not currently automated in POMDPSolve.jl or POMDPFiles.jl."
        end
        options["method"] = method
    elseif method != :default
        if method == :mcgs
            throw(ArgumentError("The mcgs method is not implmented in 5.4.1."))
        end
        invalid_option_error("method", method, METHOD)
    end
    
    if in(enum_purge, ALGORITHM)
        options["enum_purge"] = enum_purge
    elseif enum_purge != :default
        invalid_option_error("enum_purge", enum_purge, ALGORITHM)
    end
    
    if in(inc_prune, INC_PRUNE)
        options["inc_prune"] = inc_prune
    elseif inc_prune != :default
        invalid_option_error("inc_prune", inc_prune, INC_PRUNE)
    end
    
    if in(fg_type, FG_TYPE)
        options["fg_type"] = fg_type
    elseif fg_type != :default
        invalid_option_error("fg_type", fg_type, FG_TYPE)
    end
    
    if fg_points > 0
        options["fg_points"] = fg_points
    end
    
    if fg_save
        options["fg_save"] = fg_save
    end
    
    if mcgs_traj_length > 0
        options["mcgs_traj_length"] = mcgs_traj_length
    end
    
    if mcgs_num_traj > 0
        options["mcgs_num_traj"] = mcgs_num_traj
    end
    
    if mcgs_traj_iter_count > 0
        options["mcgs_traj_iter_count"] = mcgs_traj_iter_count
    end
    
    if mcgs_prune_freq > 0
        options["mcgs_prune_freq"] = mcgs_prune_freq
    end
    
    if in(fg_purge, ALGORITHM)
        options["fg_purge"] = fg_purge
    elseif fg_purge != :default
        invalid_option_error("fg_purge", fg_purge, ALGORITHM)
    end
    
    if in(verbose, VERBOSITY)
        options["verbose"] = verbose
    elseif verbose != :default
        invalid_option_error("verbose", verbose, VERBOSITY)
    end

    return POMDPSolveSolver(options)
end

"""
    POMDPSolveHelp()

This function runs the `pomdpsolve` command with the `-h` option, which displays help information for `pomdpsolve`. 
"""
function POMDPSolveHelp()
    try 
        run(`$(pomdpsolve()) -h`)
    catch err
        if !isa(err, ProcessFailedException)
            rethrow()
        end
    end
end

""" 
    POMDPs.solve(solver::POMDPSolveSolver, pomdp::POMDP)

Solves the given `pomdp` using the `pomdpsolve` program and`AlphaVectorPolicy`. The solver 
depends on translating the POMDP to the `.pomdp` file format. Please reference POMDPFiles.jl
for any issues with the translation.
"""
function POMDPs.solve(solver::POMDPSolveSolver, pomdp::POMDP)
    # Check for verbose option of :none
    verbose_override = false
    if haskey(solver.options, "verbose")
        if solver.options["verbose"] == :none
            verbose_override = true
        end
    end
    
    fileprefix = tempname()
    pomdp_filename = fileprefix*".pomdp"
    open(pomdp_filename, "w") do f
        write(f, pomdp)
    end

    run_cmd = `$(pomdpsolve()) -pomdp $(pomdp_filename) -o $(fileprefix)`
    if !isempty(solver.options)
        options_list = get_options_list(solver.options)
        run_cmd = `$(run_cmd) $options_list`
    end
    
    if verbose_override
        @suppress run(run_cmd)
    else
        run(run_cmd)
    end

    alpha_vectors, alpha_actions = read_alpha(fileprefix * ".alpha")

    oa = ordered_actions(pomdp)
    return AlphaVectorPolicy(pomdp, alpha_vectors, oa[alpha_actions.+1])
end
