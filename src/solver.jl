type POMDPSolveSolver

	options::Dict{AbstractString, Any}

	function POMDPSolveSolver(;
		# TODO(tim): add options
		)

		options = Dict{AbstractString, Any}()
		new(options)
	end
end

"""
generates a new optimal value function coefficients file (`.alpha`) and
a the resulting policy graph file (`.pg`).
"""
function solve(solver::POMDPSolveSolver, pomdp::POMDPSolveFile, policy::POMDPSolvePolicy)

	policy_fileprefix = splitext(policy.filename)[1]

	if isempty(solver.options)
		run(`$EXEC_POMDP_SOLVE -pomdp $(pomdp.filename)`) # -o $(policy_fileprefix)`)
    else
        options_list = _get_options_list(solver.options)
        run(`$EXEC_POMDP_SOLVE -pomdp $(pomdp.filename) -o $(policy_fileprefix) $options_list`)
    end

    # policy.alphas = POMDPAlphas(policy_fileprefix * ".alpha")
end
