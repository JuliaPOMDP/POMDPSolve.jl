using POMDPSolve
using POMDPs
using POMDPModels
using POMDPFiles
using POMDPTesting
using POMDPPolicies
using POMDPSimulators: RolloutSimulator
using POMDPModelTools: Deterministic
using Test

pomdp = TigerPOMDP()
solver = POMDPSolveSolver()
policy = solve(solver, pomdp)

show(stdout, MIME("text/plain"), collect(alphapairs(policy)))

# test _get_options_list
options = Dict{AbstractString, Any}()
options["A"] = "optionA"
options["B"] = 2
println(POMDPSolve._get_options_list(options))
@test POMDPSolve._get_options_list(options) == ["-A", "optionA", "-B", "2"] ||
      POMDPSolve._get_options_list(options) == ["-B", "2", "-A", "optionA"]

# NOTe: following are arbitrarily set, values are probably not useful
solver2 = POMDPSolveSolver(
    stdout = "out.txt",                 # Redirect programs stdout to a file of this name
    rand_seed = (1,2,3),                # Set the random seed for program execution
    stat_summary=true,                  # Whether to keep and print internal execution stats
    memory_limit = 10000,               # Set upper bound memory usage
    time_limit = 10000,                 # Set upper bound on execution time
    terminal_values = "???",
    horizon = 10,                       # Sets the number of iterations of value iteration
    discount = 0.9,                     # Set the discount fact to use in value iteration
    stop_criteria = :weak,              # Sets the value iteration stopping criteria
    stop_delta = 0.01,                  # Sets the precision for the stopping criteria check
    save_all = true,                    # Sets whether or not to save every iteration's solution
    vi_variation = :adjustable_epsilon, # Sets the general category of value iteration to use
    start_epsilon = 0.01,               # Sets the starting precision for adjustable epsilon VI
    end_epsilon = 0.02,                 # Sets the ending precision for adjustable epsilon VI
    epsilon_adjust = 0.01,              # Sets the precision increment for adjustable epsilon VI
    max_soln_size = 1000.0,             # Sets the max size for the fixed solution size VI
    history_length = 2,                 # Sets history window to use for adjustable epsilon VI
    history_delta = 1,                  # Sets solution size delta to use for adjustable epsilon VI
    dom_check = false,                  # Controls whether simple domination check is done or not
    prune_epsilon = 1e-6,               # Sets the precision level for the prune operations
    epsilon = 1e-6,                     # General solution precision level setting
    lp_epsilon = 1e-6,                  # Precision use in linear programs
    proj_purge = :normal_prune,         # Type of pruning to use for pre-iteration solving
    q_purge = :normal_prune,            # Type of pruning to use for a post-iteration solving
    witness_points = true,              # Whether to include 'witness points' in solving
    alg_rand = 10,                      # How many points to use to seed value function creation
    prune_rand = 10,                    # How many points to use to seed pruning process
    method = :normal_prune,             # Selects the main solution algorithm to use
    enum_purge = :epsilon_prune,        # The pruning method to use when using the 'enum' algorithm
    inc_prune = :generalized,           # The variation of the incremental pruning algorithm
    fg_type = :pairwise,                # Finite grid method means to generate belief points
    fg_points = 10,                     # Maximal number of belief points to use in finite grid
    fg_save = true,                     # Whether to save the points used in finite grid
    mcgs_traj_length = 2,               # Trajectory length for Monte Carlo belief generation
    mcgs_num_traj = 10,                 # Number of trajectories for Monte Carlo belief generation
    mcgs_traj_iter_count = 10,          # Times to iterate on a trajectory for MCGS method
    mcgs_prune_freq = 2,                # How frequently to prune during MCGS method
    fg_purge = :normal_prune,           # Finite grid method means to prune value functions
    verbose = :witness,                 # Turns on extra debugging output for a module
    )

test_solver(solver, pomdp)

@testset "rollout" begin
    m = MiniHallway()

    p = solve(solver, m)

    sim = RolloutSimulator()
    for s in states(m)
        ret = simulate(sim, m, p, updater(p), Deterministic(s)) # only need to simulate once since MiniHallway is deterministic
        @test_broken ret ≈ value(p, Deterministic(s))
    end
end
