using HiGHS
using JuMP

mod_a = Model(HiGHS.Optimizer)

@variable(mod_a, x[1:2])

dist = [3 0 -2 1; 1 -3 2 4]
peso = [6 4 7 2]

@objective(mod_a, Min, sum(peso[i] * (abs(x[1] - dist[1, i]) + abs(x[2] - dist[2, i])) for i in 1:4))
@constraint(-1 <= x[1] <=2)
@constraint(0 <= x[2] <= 1)

@constraint(abs(x[1] - dist[1, 1]) + abs(x[2] - dist[1, 2]) <= 2)