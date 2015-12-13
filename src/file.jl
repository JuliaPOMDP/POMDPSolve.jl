type POMDPSolveFile <: POMDP
	filename::AbstractString

	function POMDPSolveFile(filename::AbstractString)
		@assert isfile(filename) "POMDP file $(filename) does not exist"
		@assert splitext(filename)[2] == ".pomdp" "Is not a .pomdp file"
		new(filename)
	end
	# function POMDPSolveFile(pomdp::POMDP, filename="model.pomdp")
	# 	@assert splitext(filename)[2] == ".pomdp" "Is not a .pomdp file"
	# 	pomdp_filetype = POMDPFIleType(filename)
	# 	if !isfile(filename)
	# 		println("Generating a pomdp file: $(filename)")
	# 		write(pomdp, pomdp_filetype)
	# 	end
	# 	new(filename)
	# end
end