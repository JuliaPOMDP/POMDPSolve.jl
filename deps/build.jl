using POMDPs

#POMDPs.add("POMDPFiles")
#POMDPs.add("POMDPModels")
#POMDPs.add("POMDPToolbox")


if Sys.islinux()
    download("http://www.pomdp.org/code/pomdp-solve-5.4.tar.gz", "pomdp-solve-5.4.tar.gz")
    println("UNZIPPING");  run(`tar xvzf pomdp-solve-5.4.tar.gz`)
    rm("pomdp-solve-5.4.tar.gz")

    cd("pomdp-solve-5.4")

    println("CONFIGURE");     run(`./configure`)
    println("MAKE");          run(`make`)

    cd(@__DIR__)
    mv("pomdp-solve-5.4", "pomdp-solve-master", force=true)
end


if Sys.isapple()
    download("http://www.pomdp.org/code/pomdp-solve-5.4.tar.gz", "pomdp-solve-5.4.tar.gz")

    println("UNZIPPING");  run(`tar -zxf pomdp-solve-5.4.tar.gz`)

    rm("pomdp-solve-5.4.tar.gz")
    cd("pomdp-solve-5.4")

    println("CONFIGURE");     run(`./configure`)
    println("MAKE");          run(`make`)

    cd(@__DIR__)
    mv("pomdp-solve-5.4", "pomdp-solve-master", force=true)
end

if Sys.iswindows()
    cd(@__DIR__)
    if isdir("pomdp-solve-5.4")
        rm("pomdp-solve-5.4", recursive=true)
    end
    mkdir("pomdp-solve-5.4")
    cd("pomdp-solve-5.4")
    mkdir("src")
    cd("src")
    download("http://web.stanford.edu/group/sisl/resources/pomdp-solve-4.5-cygwin-x64.zip", "pomdp-solve-4.5-cygwin-x64.zip")
    exe7z = joinpath(Sys.BINDIR, "7z.exe")
    if isdefined(Base, :LIBEXECDIR)
        exe7z = joinpath(Sys.BINDIR, Base.LIBEXECDIR, "7z.exe")
    end
    run(`$exe7z x pomdp-solve-4.5-cygwin-x64.zip`)
    rm("pomdp-solve-4.5-cygwin-x64.zip")
    cd(@__DIR__)
    mv("pomdp-solve-5.4", "pomdp-solve-master", force=true)
end
