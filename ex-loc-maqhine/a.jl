using HiGHS
using JuMP

mod_a = Model(HiGHS.Optimizer)

@variable(mod_a, x[1:2], Int)

dist = [3 0 -2 1; 1 -3 2 4]


@objective(mod_a, Min, abs(x[1] - 3) + abs(x[2] - 1) + abs(x[1]) + abs(x[2] + 3) + abs(x[1] + 2) + abs(x[2] - 2) + abs(x[1] - 1) + abs(x[2] - 4))
# @objective(mod_a, Min, sum((abs(x[1] - dist[1, i]) + abs(x[2] - dist[2, i])) for i in 1:4))