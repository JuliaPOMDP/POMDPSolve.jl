using POMDPSolve
using Base.Test

solver = POMDPSolveSolver()
pomdp = POMDPSolveFile(Pkg.dir("POMDPSolve", "test", "tiger.pomdp"))
policy = POMDPSolvePolicy("mypolicy.policy")
solve(solver, pomdp, policy)