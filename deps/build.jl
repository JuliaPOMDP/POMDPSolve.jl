@unix_only begin
	
	Pkg.clone("https://github.com/sisl/POMDPs.jl.git")
	Pkg.clone("https://github.com/sisl/POMDPFiles.jl.git")

	download("https://github.com/cmansley/pomdp-solve/archive/master.zip", "pomdp-solve.zip")

	println("UNZIPPING"); tic(); run(`unzip pomdp-solve.zip`); toc()

	rm("pomdp-solve.zip")
	cd("pomdp-solve-master")

	println("CONFIGURE");    tic(); run(`./configure`); toc()
	println("MAKE");         tic(); run(`make`); toc()
	println("MAKE INSTALL"); tic(); run(`sudo make install`); toc()

	cd(Pkg.dir("POMDPSolve", "deps"))
end
