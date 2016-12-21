type POMDPSolveSolver

	options::Dict{AbstractString, Any}

	function POMDPSolveSolver(;
		stdout::Union{Void,AbstractString} = nothing,         # Redirect programs stdout to a file of this name
		rand_seed::Union{Void, Tuple{Int,Int,Int}} = nothing, # Set the random seed for program execution
		stat_summary::Bool = false,                           # Whether to keep and print internal execution stats
		memory_limit::Int = -1,                               # Set upper bound memory usage
		time_limit::Int = -1,                                 # Set upper bound on execution time
		terminal_values::Union{Void,AbstractString}=nothing,  # Sets the terminal value function (starting point.)
		horizon::Int = -1,                                    # Sets the number of iterations of value iteration
		discount::Float64 = NaN,                              # Set the discount fact to use in value iteration
		stop_criteria::Symbol = :default,                     # Sets the value iteration stopping criteria
		stop_delta::Float64 = NaN,                            # Sets the precision for the stopping criteria check
		save_all::Bool = false,                               # Sets whether or not to save every iteration's solution
		vi_variation::Symbol = :default,                      # Sets the general category of value iteration to use
		start_epsilon::Float64 = NaN,                         # Sets the starting precision for adjustable epsilon VI
		end_epsilon::Float64 = NaN,                           # Sets the ending precision for adjustable epsilon VI
		epsilon_adjust::Float64 = NaN,                        # Sets the precision increment for adjustable epsilon VI
		max_soln_size::Float64 = NaN,                         # Sets the max size for the fixed solution size VI
		history_length::Int = -1,                             # Sets history window to use for adjustable epsilon VI
		history_delta::Int = -1,                              # Sets solution size delta to use for adjustable epsilon VI
		dom_check::Bool = true,                               # Controls whether simple domination check is done or not
		prune_epsilon::Float64 = NaN,                         # Sets the precision level for the prune operations
		epsilon::Float64 = NaN,                               # General solution precision level setting
		lp_epsilon::Float64 = NaN,                            # Precision use in linear programs
		proj_purge::Symbol = :default,                        # Type of pruning to use for pre-iteration solving
		q_purge::Symbol = :default,                           # Type of pruning to use for a post-iteration solving
		witness_points::Bool = false,                         # Whether to include 'witness points' in solving
		alg_rand::Int = -1,                                   # How many points to use to seed value function creation
		prune_rand::Int = -1,                                 # How many points to use to seed pruning process
		method::Symbol = :default,                            # Selects the main solution algorithm to use
		enum_purge::Symbol = :default,                        # The pruning method to use when using the 'enum' algorithm
		inc_prune::Symbol = :default,                         # The variation of the incremental pruning algorithm
		fg_type::Symbol = :default,                           # Finite grid method means to generate belief points
		fg_points::Int = -1,                                  # Maximal number of belief points to use in finite grid
		fg_save::Bool = false,                                # Whether to save the points used in finite grid
		mcgs_traj_length::Int = -1,                           # Trajectory length for Monte Carlo belief generation
		mcgs_num_traj::Int = -1,                              # Number of trajectories for Monte Carlo belief generation
		mcgs_traj_iter_count::Int = -1,                       # Times to iterate on a trajectory for MCGS method
		mcgs_prune_freq::Int = -1,                            # How frequently to prune during MCGS method
		fg_purge::Symbol = :default,                          # Finite grid method means to prune value functions
		verbose::Symbol = :default,                           # Turns on extra debugging output for a module
		)

		options = Dict{AbstractString, Any}()

		if isa(stdout, AbstractString)
			options["stdout"] = stdout
		end
		if isa(rand_seed, Tuple{Int,Int,Int})
			options["rand_seed"] = @sprintf("%d:%d:%d", rand_seed...)
		end
		if stat_summary
			options["stat_summary"] = stat_summary
		end
		if memory_limit > 0
			options["memory_limit"] = memory_limit
		end
		if time_limit > 0
			options["time_limit"] = time_limit
		end
		if isa(terminal_values, AbstractString)
			options["terminal_values"] = terminal_values
		end
		if horizon > 0
			options["horizon"] = horizon
		end
		if !isnan(discount)
			options["discount"] = discount
		end
		if in(stop_criteria, STOP_CRITERIA)
			options["stop_criteria"] = stop_criteria
		end
		if !isnan(stop_delta)
			options["stop_delta"] = stop_delta
		end
		if save_all
			options["save_all"] = save_all
		end
		if in(vi_variation, VI_VARIATION)
			options["vi_variation"] = vi_variation
		end
		if !isnan(start_epsilon)
			options["start_epsilon"] = start_epsilon
		end
		if !isnan(end_epsilon)
			options["end_epsilon"] = end_epsilon
		end
		if !isnan(epsilon_adjust)
			options["epsilon_adjust"] = epsilon_adjust
		end
		if !isnan(max_soln_size)
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
			options["prune_epsilon"] = prune_epsilon
		end
		if !isnan(epsilon)
			options["epsilon"] = epsilon
		end
		if !isnan(lp_epsilon)
			options["lp_epsilon"] = lp_epsilon
		end
		if in(proj_purge, ALGORITHM)
			options["proj_purge"] = proj_purge
		end
		if in(q_purge, ALGORITHM)
			options["q_purge"] = q_purge
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
		if in(method, ALGORITHM)
			options["method"] = method
		end
		if in(enum_purge, ALGORITHM)
			options["enum_purge"] = enum_purge
		end
		if in(inc_prune, INC_PRUNE)
			options["inc_prune"] = inc_prune
		end
		if in(fg_type, FG_TYPE)
			options["fg_type"] = fg_type
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
		end
		if in(verbose, VERBOSITY)
			options["verbose"] = verbose
		end

		new(options)
	end
end

"""
generates a new optimal value function coefficients file (`.alpha`) and
a the resulting policy graph file (`.pg`).
"""
function solve(solver::POMDPSolveSolver, pomdp::POMDPSolveFile, policy::POMDPSolvePolicy=create_policy(solver, pomdp))

	policy_fileprefix = splitext(policy.filename)[1]

	if isempty(solver.options)
		run(`$EXEC_POMDP_SOLVE -pomdp $(pomdp.filename) -o $(policy_fileprefix)`)
    else
        options_list = _get_options_list(solver.options)
        run(`$EXEC_POMDP_SOLVE -pomdp $(pomdp.filename) -o $(policy_fileprefix) $options_list`)
    end

    alpha_vectors, alpha_actions = read_alpha(policy_fileprefix * ".alpha")
    policy.alphas = POMDPAlphas(alpha_vectors, alpha_actions)
end

create_policy(solver::POMDPSolveSolver, pomdp::Union{POMDP,POMDPSolveFile}, filename::AbstractString="out.policy") = POMDPPolicy(pomdp, filename)
