using HiGHS
using JuMP

mod_a = Model(HiGHS.Optimizer)

@variable(mod_a, x[1:2], Int)

dist = [3 0 -2 1; 1 -3 2 4]
peso = [6 4 7 2]

@variable(mod_a, z[i=1:2, j=1:4], Int)
@constraint(mod_a, [i=1:2, j=1:4], z[i,j] >= x[i] - dist[i,j])
@constraint(mod_a, [i=1:2, j=1:4], z[i,j] >=  -x[i] + dist[i,j])
@objective(mod_a, Min, sum(sum(z[i,j] for i in 1:2)*peso[j] for j in 1:4))
@constraint(mod_a, -1 <= x[1] <=2)
@constraint(mod_a, 0 <= x[2] <= 1)
@constraint(mod_a, z[1,1] + z[1,2] <= 2)

optimize!(mod_a)
termination_status(mod_a)
primal_status(mod_a)

# Ele não resolve nos inteiros