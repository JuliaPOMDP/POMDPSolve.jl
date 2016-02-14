@linux_only begin

	download("https://github.com/cmansley/pomdp-solve/archive/master.zip", "pomdp-solve.zip")

	println("UNZIPPING"); tic(); run(`unzip pomdp-solve.zip`); toc()

	rm("pomdp-solve.zip")
	cd("pomdp-solve-master")

	println("CONFIGURE");    tic(); run(`./configure`); toc()
	println("MAKE");         tic(); run(`make`); toc()

	cd(Pkg.dir("POMDPSolve", "deps"))
end


@osx_only begin

	download("http://www.pomdp.org/code/pomdp-solve-5.4.tar.gz", "pomdp-solve-5.4.tar.gz")

	println("UNZIPPING"); tic(); run(`tar -zxf pomdp-solve-5.4.tar.gz`); toc()

	rm("pomdp-solve-5.4.tar.gz")
	cd("pomdp-solve-5.4")

	println("CONFIGURE");    tic(); run(`./configure`); toc()
	println("MAKE");         tic(); run(`make`); toc()

	cd(Pkg.dir("POMDPSolve", "deps"))

    mv("pomdp-solve-5.4", "pomdp-solve-master", remove_destination=true)
end
