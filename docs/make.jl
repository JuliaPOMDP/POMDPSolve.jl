using POMDPSolve
using Documenter

makedocs(;
    modules=[POMDPSolve],
    sitename="POMDPSolve.jl",
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
        "API Reference" => "reference.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaPOMDP/POMDPSolve.jl.git",
    devbranch = "master",
    devurl = "latest",
)