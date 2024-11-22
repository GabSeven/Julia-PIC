using HiGHS
using JuMP

mod_queijo = Model(HiGHS.Optimizer)

@variable(mod_queijo, x[1:8], Int)
@constraint(mod_queijo, sum(x[i] for i in 1:7) == 10)
@objective(mod_queijo, Min, 60*8 + sum(x[i] * 3 * (9 - i) for i in 1:8))

@variable(mod_queijo, t[1:8], Int)
@constraint(mod_queijo, t[1] == 60 - x[1])
@constraint(mod_queijo, t[2] == t[1] - x[2])
@constraint(mod_queijo, [i in 3:7], t[i] == t[i-1] + 4*x[i-1] - x[i])
@constraint(mod_queijo, t[8] == t[7] + 4*x[6])

@variable(mod_queijo, tb[i=1:2, j=1:8, h=1:40])
@constraint(mod_queijo, [j = 1:8, h = 1:40], sum(tb[i, j, h] for i in 1:2) == t[j])

# add b

@variable(mod_queijo, s[i = 1:2, j=1:7] >= 0, Int)

b = [11 12 13 18 14 18 20 20; 8 8 10 8 12 13 12 12]
p = [10, 6]

@constraint(mod_queijo, [i=1:2], b[i,1] + s[i,1] ==  sum(tb[i,1,h] for h in 1:40) * p[i])
@constraint(mod_queijo, [i=1:2, j=2:7], b[i,j] + s[i,j] == s[i,j-1] + sum(tb[i,j,h] for h in 1:40) * p[i])

@constraint(mod_queijo, [i=1:2, j=2:8], b[i,j] >= s[i,j-1])
 
optimize!(mod_queijo)
termination_status(model)
primal_status(model)
