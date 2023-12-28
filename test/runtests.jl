using POMDPSolve
using POMDPSolve_jll
using POMDPs
using POMDPModels
using POMDPFiles
using POMDPTools
using SARSOP
using Suppressor
using Test


@testset "POMDPSolve Wrapper" begin
    @testset "Options" begin
        # Option list formatting
        options = Dict{AbstractString, Any}()
        options["A"] = "optionA"
        options["B"] = 2
        order1 = POMDPSolve.get_options_list(options) == ["-A", "optionA", "-B", "2"]
        order2 = POMDPSolve.get_options_list(options) == ["-B", "2", "-A", "optionA"]
        @test order1 || order2
        options = Dict{AbstractString, Any}()
        options["verbose"] = :none
        options["A"] = "optionA"
        @test POMDPSolve.get_options_list(options) == ["-A", "optionA"]
        
        @test_throws ArgumentError POMDPSolve.invalid_option_error("option", :invalid, [:valid])
        @test POMDPSolve.list_options([:valid]) == "\t:valid"
    end
    
    @testset "Constructor" begin
        println("grid method and memory_limit warnings are expected")
        
        @test_logs (:warn, """memory_limit has not been tested successfully using the jll package. Use at your own risk.
        Recommend using `time_limit` and/or `horizon` options instead.
        """) POMDPSolveSolver(; memory_limit=1)
        @test_throws AssertionError POMDPSolveSolver(; discount = 1.1)
        @test_throws AssertionError POMDPSolveSolver(; discount = -0.1)
        @test_throws ArgumentError POMDPSolveSolver(; stop_criteria = :invalid)
        @test_throws AssertionError POMDPSolveSolver(; stop_delta = -0.1)
        @test_throws ArgumentError POMDPSolveSolver(; vi_variation = :invalid)
        @test_throws AssertionError POMDPSolveSolver(; start_epsilon = -0.1)
        @test_throws AssertionError POMDPSolveSolver(; end_epsilon = -0.1)
        @test_throws AssertionError POMDPSolveSolver(; epsilon_adjust = -0.1)
        @test_throws AssertionError POMDPSolveSolver(; max_soln_size = -0.1)
        @test_throws AssertionError POMDPSolveSolver(; prune_epsilon = -0.1)
        @test_throws AssertionError POMDPSolveSolver(; epsilon = -0.1)
        @test_throws AssertionError POMDPSolveSolver(; lp_epsilon = -0.1)
        @test_throws ArgumentError POMDPSolveSolver(; proj_purge = :invalid)
        @test_throws ArgumentError POMDPSolveSolver(; q_purge = :invalid)
        @test_throws ArgumentError POMDPSolveSolver(; method = :invalid)
        @test_throws ArgumentError POMDPSolveSolver(; enum_purge = :invalid)
        @test_throws ArgumentError POMDPSolveSolver(; inc_prune = :invalid)
        @test_throws ArgumentError POMDPSolveSolver(; fg_type = :invalid)
        @test_throws ArgumentError POMDPSolveSolver(; fg_purge = :invalid)
        @test_throws ArgumentError POMDPSolveSolver(; verbose = :invalid)

        @test_throws ArgumentError POMDPSolveSolver(; method = :mcgs)
        @test_logs (:warn, "The grid method requires a .belief file to be generated and this process is not currently automated in POMDPSolve.jl or POMDPFiles.jl.") POMDPSolveSolver(; method = :grid)
        
        solver = POMDPSolveSolver(;
            stdout = "out.txt",
            rand_seed = (1,2,3),
            stat_summary=true,
            memory_limit = 10000,
            time_limit = 10000,
            terminal_values = "temp_holder_for_test",
            horizon = 10,
            discount = 0.9,
            stop_criteria = :bellman,
            stop_delta = 0.01,
            save_all = true,
            vi_variation = :adjustable_epsilon,
            start_epsilon = 0.01,
            end_epsilon = 0.02,
            epsilon_adjust = 0.01,
            max_soln_size = 1000.0,
            history_length = 2,
            history_delta = 1,
            dom_check = false,
            prune_epsilon = 1e-6,
            epsilon = 1e-6,
            lp_epsilon = 1e-6,
            proj_purge = :none,
            q_purge = :domonly,
            witness_points = true,
            alg_rand = 10,
            prune_rand = 10,
            method = :grid,
            enum_purge = :epsilon_prune,
            inc_prune = :generalized,
            fg_type = :pairwise,
            fg_points = 10,
            fg_save = true,
            mcgs_traj_length = 2,
            mcgs_num_traj = 10,
            mcgs_traj_iter_count = 10,
            mcgs_prune_freq = 2,
            fg_purge = :domonly,
            verbose = :cmdline
        )
        @test length(solver.options) == 39
        @test solver.options["memory_limit"] == 10000
        @test solver.options["time_limit"] == 10000
        @test solver.options["terminal_values"] == "temp_holder_for_test"
        @test solver.options["horizon"] == 10
        @test solver.options["enum_purge"] == :epsilon_prune
        
        output = @capture_out POMDPSolveHelp()
        @test occursin("-stdout <string>", output)
        @test occursin("-max_soln_size <double>", output)
    end
    
    pomdp = TigerPOMDP()
    solver = POMDPSolveSolver(; verbose=:none)
    try
        policy = solve(solver, pomdp)
        @test true
    catch err
        @test false
        rethrow(err)
    end
    output = @capture_out test_solver(solver, pomdp)
    @test output == ""
end

@testset "Solver jll Test" begin
    
    mktempdir() do dir
        @testset "Tiger" begin
            print("Testing TigerPOMDP...")
            pomdp = TigerPOMDP()
            fname = joinpath(dir, "tiger_test")
            @suppress run(`$(pomdpsolve()) -pomdp tiger.pomdp -o $fname`)
            @test isfile(joinpath(dir, "tiger_test.alpha"))
            @test isfile(joinpath(dir, "tiger_test.pg"))
            
            alpha_vectors, alpha_actions = POMDPSolve.read_alpha(fname * ".alpha")
            ord_acts = ordered_actions(pomdp)
            p1 = AlphaVectorPolicy(pomdp, alpha_vectors, ord_acts[alpha_actions.+1])
            @test length(p1.alphas) == 9
            
            solver = POMDPSolveSolver(; verbose=:none)
            p2 = solve(solver, pomdp)
            @test length(p2.alphas) == 9
            for (α1, α2) in zip(p1.alphas, p2.alphas)
                @test isapprox(α1, α2; atol=1e-6)
            end
            
            local p_ss
            solver_sarsop = SARSOPSolver()
            @suppress p_ss = solve(solver_sarsop, pomdp)
            
            v_ip = value(p2, initialstate(pomdp))
            v_ss = value(p_ss, initialstate(pomdp))
            @test isapprox(v_ip, v_ss; atol=1e-3)
            println("done!")
        end
        @testset "4x4.95" begin
            print("Testing 4x4.95...")
            fname = joinpath(dir, "4x4.95_test")
            @suppress run(`$(pomdpsolve()) -pomdp 4x4.95.pomdp -o $fname`)
            @test isfile(joinpath(dir, "4x4.95_test.alpha"))
            @test isfile(joinpath(dir, "4x4.95_test.pg"))
            
            alpha_vectors, alpha_actions = POMDPSolve.read_alpha(fname * ".alpha")
            ord_acts = [:up, :down, :left, :right] # N0 S0 E0 W0 in file
            alpha_actions = ord_acts[alpha_actions.+1]
            # All actions should be :down or :left (15th state is bottom left)
            @test all((alpha_actions .== :down) .| (alpha_actions .== :left))
            println("done!")
        end
        
        @testset "Baby POMDP" begin
            print("Testing BabyPOMDP...")
            pomdp = BabyPOMDP()
            solver_sarsop = SARSOPSolver()
            local policy_sarsop
            @suppress policy_sarsop = solve(solver_sarsop, pomdp)
            v_sarsop = value(policy_sarsop, initialstate(pomdp))
            
            solver_ip = POMDPSolveSolver(; verbose=:none)
            policy_ip = solve(solver_ip, pomdp)
            v_ip = value(policy_ip, initialstate(pomdp))
            
            @test isapprox(v_sarsop, v_ip; atol=1e-3)
            println("done!")
        end
        
        @testset "Stopping Options" begin
            print("Testing stopping options...")
            p = TigerPOMDP()
            solver = POMDPSolveSolver(; time_limit=1, verbose=:none)
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
            println("done!")
        end
        
        @testset "Methods" begin
            p = TigerPOMDP()
            
            # NOT TESTING :linsup because it requires CPLEX
            # NOT TESTING :grid because it requires a .belief file
            
            print("Testing :inc_prune on TigerPOMDP...")
            solver = POMDPSolveSolver(; method=:incprune, verbose=:none)
            policy = solve(solver, p)
            v_incprune = value(policy, initialstate(p))
            println("done!")
            
            print("Testing :enum on TigerPOMDP...")
            solver = POMDPSolveSolver(; method=:enum, verbose=:none)
            policy = solve(solver, p)
            v_enum = value(policy, initialstate(p))
            println("done!")
            
            print("Testing :witness on TigerPOMDP...")
            solver = POMDPSolveSolver(; method=:witness, verbose=:none)
            policy = solve(solver, p)
            v_witness = value(policy, initialstate(p))
            println("done!")
            
            print("Testing :twopass on TigerPOMDP with 30 sec timer...")
            solver = POMDPSolveSolver(; method=:twopass, time_limit=30, verbose=:none)
            policy = solve(solver, p)
            v_twopass = value(policy, initialstate(p))
            println("done!")
            @test v_twopass > 0.0
            
            @test isapprox(v_incprune, v_enum; atol=1e-3)
            @test isapprox(v_incprune, v_witness; atol=1e-3)
            @test v_incprune > v_twopass    
        end
    end
end
