const EXEC_POMDP_SOLVE = Pkg.dir("POMDPSolve", "deps", "pomdp-solve-master", "src", "pomdp-solve")

const STOP_CRITERIA = [:exact, :weak, :bellman]
const VI_VARIATION = [:normal, :zlz, :adjustable_epsilon, :fixed_soln_size]
const METHOD = [:enum, :twopass, :linsup, :witness, :incprune, :grid, :mcgs]
const ALGORITHM = [:none, :domonly, :normal_prune, :epsilon_prune]
const INC_PRUNE = [:normal, :restricted_region, :generalized]
const FG_TYPE = [:simplex, :pairwise, :search, :initial]
const VERBOSITY = [:context, :lp, :global, :timing, :stats, :cmdline, :main, :alpha, :proj,
                   :crosssum, :agenda, :enum, :twopass, :linsup, :witness, :incprune, :lpinterface,
                   :vertexenum, :mdp, :pomdp, :param, :parsimonious, :region, :approx_mcgs,
                   :zlz_speedup, :finite_grid, :mcgs]