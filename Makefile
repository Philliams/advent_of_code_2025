day?=1
part?=1

run:
	echo day${day}-part${part}
	julia --project=./ ./day${day}/part${part}.jl
