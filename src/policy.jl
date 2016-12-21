"Handles POMDPs"
type POMDPSolvePolicy <: Policy
	filename::AbstractString
	alphas::Alphas
	pomdp::POMDP
	action_map::Vector{Any}

	POMDPSolvePolicy(filename::AbstractString, alphas::Alphas, pomdp::POMDP) = new(filename, alphas, pomdp)
	function POMDPSolvePolicy(filename="out.policy")
		self = new()
        self.filename = filename
        if isfile(filename)
            self.alphas = POMDPAlphas(filename)
        else
            self.alphas = POMDPAlphas()
        end
        self
    end
end

"getter for action"
function action(policy::POMDPSolvePolicy, b::DiscreteBelief)
    vectors = alphas(policy)
    actions = action_idxs(policy)
    utilities = prod(vectors, b)
    a = actions[indmax(utilities)] + 1
    return a
end

"""
Returns the expected utility of a belief
"""
function value(policy::POMDPSolvePolicy, b::DiscreteBelief)
    vectors = alphas(policy)
    actions = action_idxs(policy)
    utilities = prod(vectors, b)
    v =  maximum(utilities)
    return v
end

"""
    updater(policy::SARSOPPolicy)

Returns the belief updater (DiscreteUpdater) for SARSOP policies.
"""
updater(p::POMDPSolvePolicy) = DiscreteUpdater(p.pomdp)


"getter for alpha-vectors"
alphas(policy::POMDPSolvePolicy) = policy.alphas.alpha_vectors

action_idxs(policy::POMDPSolvePolicy) = policy.alphas.alpha_actions
