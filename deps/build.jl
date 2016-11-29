using POMDPs

POMDPs.add("POMDPFiles")
POMDPs.add("POMDPModels")
POMDPs.add("POMDPToolbox")


if is_linux()
	download("http://www.pomdp.org/code/pomdp-solve-5.4.tar.gz", "pomdp-solve-5.4.tar.gz")
	println("UNZIPPING"); tic(); run(`tar xvzf pomdp-solve-5.4.tar.gz`); toc()
	rm("pomdp-solve-5.4.tar.gz")

	cd("pomdp-solve-5.4")

	println("CONFIGURE");    tic(); run(`./configure`); toc()
	println("MAKE");         tic(); run(`make`); toc()

	cd(Pkg.dir("POMDPSolve", "deps"))
    mv("pomdp-solve-5.4", "pomdp-solve-master", remove_destination=true)
end


if is_apple()
	download("http://www.pomdp.org/code/pomdp-solve-5.4.tar.gz", "pomdp-solve-5.4.tar.gz")

	println("UNZIPPING"); tic(); run(`tar -zxf pomdp-solve-5.4.tar.gz`); toc()

	rm("pomdp-solve-5.4.tar.gz")
	cd("pomdp-solve-5.4")

	println("CONFIGURE");    tic(); run(`./configure`); toc()
	println("MAKE");         tic(); run(`make`); toc()

	cd(Pkg.dir("POMDPSolve", "deps"))
    mv("pomdp-solve-5.4", "pomdp-solve-master", remove_destination=true)
end

if is_windows()
	cd(Pkg.dir("POMDPSolve", "deps"))
	run(`rm -rf pomdp-solve-5.4`)
	run(`mkdir pomdp-solve-5.4`)
	cd("pomdp-solve-5.4")
	run(`mkdir src`)
	cd("src")
	download("http://web.stanford.edu/group/sisl/resources/pomdp-solve-4.5-cygwin-x64.zip", "pomdp-solve-4.5-cygwin-x64.zip")
	run(`unzip pomdp-solve-4.5-cygwin-x64.zip`)
	rm("pomdp-solve-4.5-cygwin-x64.zip")
	cd(Pkg.dir("POMDPSolve", "deps"))
    mv("pomdp-solve-5.4", "pomdp-solve-master", remove_destination=true)
end
