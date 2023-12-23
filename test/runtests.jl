using POMDPSolve

using Pkg
try 
    using POMDPSolve_jll
catch 
    Pkg.add(url="https://github.com/dylan-asmar/POMDPSolve_jll.jl.git")
    using POMDPSolve_jll
end

using POMDPs
using POMDPModels
using POMDPFiles
using POMDPTools
using NativeSARSOP
using Suppressor
using Test

@testset "Solver jll Test" begin
    
    mktempdir() do dir
        @testset "Tiger" begin
            
            pomdp = TigerPOMDP()
            
            fname = joinpath(dir, "tiger_test")
            run(`$(pomdpsolve()) -pomdp tiger.pomdp -o $fname`)
            @test isfile(joinpath(dir, "tiger_test.alpha"))
            @test isfile(joinpath(dir, "tiger_test.pg"))
            
            alpha_vectors, alpha_actions = POMDPSolve.read_alpha(fname * ".alpha")
            ord_acts = ordered_actions(pomdp)
            p1 = AlphaVectorPolicy(pomdp, alpha_vectors, ord_acts[alpha_actions.+1])
            @test length(p1.alphas) == 9
            
            solver = POMDPSolveSolver()
            p2 = solve(solver, pomdp)
            @test length(p2.alphas) == 9
            for (α1, α2) in zip(p1.alphas, p2.alphas)
                @test isapprox(α1, α2; atol=1e-6)
            end
            
            solver_sarsop = SARSOPSolver()
            p_ss = solve(solver_sarsop, pomdp)
            
            v_ip = value(p2, initialstate(pomdp))
            v_ss = value(p_ss, initialstate(pomdp))
            @test isapprox(v_ip, v_ss; atol=1e-3)
            
        end
        @testset "4x4.95" begin
            fname = joinpath(dir, "4x4.95_test")
            run(`$(pomdpsolve()) -pomdp 4x4.95.pomdp -o $fname`)
            @test isfile(joinpath(dir, "4x4.95_test.alpha"))
            @test isfile(joinpath(dir, "4x4.95_test.pg"))
            
            alpha_vectors, alpha_actions = POMDPSolve.read_alpha(fname * ".alpha")
            ord_acts = [:up, :down, :left, :right] # N0 S0 E0 W0 in file
            alpha_actions = ord_acts[alpha_actions.+1]
            # All actions should be :down or :left (15th state is bottom left)
            @test all((alpha_actions .== :down) .| (alpha_actions .== :left))
        end
        
        @testset "Baby POMDP" begin
            pomdp = BabyPOMDP()
            solver_sarsop = SARSOPSolver()
            policy_sarsop = solve(solver_sarsop, pomdp)
            v_sarsop = value(policy_sarsop, initialstate(pomdp))
            
            solver_ip = POMDPSolveSolver()
            policy_ip = solve(solver_ip, pomdp)
            v_ip = value(policy_ip, initialstate(pomdp))
            
            @test isapprox(v_sarsop, v_ip; atol=1e-3)
        end
        
        @testset "Stopping Options" begin
            p = TigerPOMDP()
            solver = POMDPSolveSolver(; time_limit=1)
            start_time = time()
            policy = solve(solver, p)
            end_time = time()
            @test end_time - start_time < 1.5
            @test policy isa AlphaVectorPolicy
            
            solver = POMDPSolveSolver(; horizon=19)
            output = @capture_out begin
                policy = solve(solver, p)
            end
            @test occursin("Epoch: 1", output)
            @test occursin("Epoch: 19", output)
            @test !occursin("Epoch: 20", output)    
        end
        
    end
    
end


# show(stdout, MIME("text/plain"), collect(alphapairs(policy)))

# # test _get_options_list
# options = Dict{AbstractString, Any}()
# options["A"] = "optionA"
# options["B"] = 2
# println(POMDPSolve._get_options_list(options))
# @test POMDPSolve._get_options_list(options) == ["-A", "optionA", "-B", "2"] ||
#       POMDPSolve._get_options_list(options) == ["-B", "2", "-A", "optionA"]

# # NOTe: following are arbitrarily set, values are probably not useful
# solver2 = POMDPSolveSolver(
#     stdout = "out.txt",                 # Redirect programs stdout to a file of this name
#     rand_seed = (1,2,3),                # Set the random seed for program execution
#     stat_summary=true,                  # Whether to keep and print internal execution stats
#     memory_limit = 10000,               # Set upper bound memory usage
#     time_limit = 10000,                 # Set upper bound on execution time
#     terminal_values = "???",
#     horizon = 10,                       # Sets the number of iterations of value iteration
#     discount = 0.9,                     # Set the discount fact to use in value iteration
#     stop_criteria = :weak,              # Sets the value iteration stopping criteria
#     stop_delta = 0.01,                  # Sets the precision for the stopping criteria check
#     save_all = true,                    # Sets whether or not to save every iteration's solution
#     vi_variation = :adjustable_epsilon, # Sets the general category of value iteration to use
#     start_epsilon = 0.01,               # Sets the starting precision for adjustable epsilon VI
#     end_epsilon = 0.02,                 # Sets the ending precision for adjustable epsilon VI
#     epsilon_adjust = 0.01,              # Sets the precision increment for adjustable epsilon VI
#     max_soln_size = 1000.0,             # Sets the max size for the fixed solution size VI
#     history_length = 2,                 # Sets history window to use for adjustable epsilon VI
#     history_delta = 1,                  # Sets solution size delta to use for adjustable epsilon VI
#     dom_check = false,                  # Controls whether simple domination check is done or not
#     prune_epsilon = 1e-6,               # Sets the precision level for the prune operations
#     epsilon = 1e-6,                     # General solution precision level setting
#     lp_epsilon = 1e-6,                  # Precision use in linear programs
#     proj_purge = :normal_prune,         # Type of pruning to use for pre-iteration solving
#     q_purge = :normal_prune,            # Type of pruning to use for a post-iteration solving
#     witness_points = true,              # Whether to include 'witness points' in solving
#     alg_rand = 10,                      # How many points to use to seed value function creation
#     prune_rand = 10,                    # How many points to use to seed pruning process
#     method = :normal_prune,             # Selects the main solution algorithm to use
#     enum_purge = :epsilon_prune,        # The pruning method to use when using the 'enum' algorithm
#     inc_prune = :generalized,           # The variation of the incremental pruning algorithm
#     fg_type = :pairwise,                # Finite grid method means to generate belief points
#     fg_points = 10,                     # Maximal number of belief points to use in finite grid
#     fg_save = true,                     # Whether to save the points used in finite grid
#     mcgs_traj_length = 2,               # Trajectory length for Monte Carlo belief generation
#     mcgs_num_traj = 10,                 # Number of trajectories for Monte Carlo belief generation
#     mcgs_traj_iter_count = 10,          # Times to iterate on a trajectory for MCGS method
#     mcgs_prune_freq = 2,                # How frequently to prune during MCGS method
#     fg_purge = :normal_prune,           # Finite grid method means to prune value functions
#     verbose = :witness,                 # Turns on extra debugging output for a module
#     )

# test_solver(solver, pomdp)

# @testset "rollout" begin
#     m = MiniHallway()

#     p = solve(solver, m)

#     sim = RolloutSimulator()
#     for s in states(m)
#         ret = simulate(sim, m, p, updater(p), Deterministic(s)) # only need to simulate once since MiniHallway is deterministic
#         @test ret ≈ value(p, Deterministic(s))
#     end
# end

# m = TigerPOMDP()

# # solver = POMDPSolveSolver(; method=:normal_prune, stop_delta=1e-3, horizon=20)
# solver = POMDPSolveSolver(; time_limit=1, horizon=5)
# # m = MiniHallway()
# p = solve(solver, m)

# using IncrementalPruning
# solver_ip = PruneSolver(; max_iterations=20, tolerance=1e-3, verbose=true)
# p_ip = solve(solver_ip, m)
