"Handles POMDPs"
type POMDPSolvePolicy <: Policy
	filename::AbstractString
	alphas::Alphas
	pomdp::POMDP
	action_map::Vector{Action}

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
function action(policy::POMDPSolvePolicy, b::Belief)
    return action(policy.alphas, b)
end

"getter for alpha-vectors"
alphas(policy::POMDPSolvePolicy) = policy.alphas.alpha_vectors