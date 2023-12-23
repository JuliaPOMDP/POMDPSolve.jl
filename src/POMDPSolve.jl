module POMDPSolve

using Pkg
try 
    using POMDPSolve_jll
catch 
    Pkg.add(url="https://github.com/dylan-asmar/POMDPSolve_jll.jl.git")
    using POMDPSolve_jll
end

using POMDPs
using POMDPTools
using POMDPFiles
using Printf

export
	POMDPSolveSolver

include("constants.jl")
include("utils.jl")
include("solver.jl")

end # module
