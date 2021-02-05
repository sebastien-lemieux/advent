include("../sl_common.jl")

lines = readFile("input.txt", line -> (dir=line[1], l=int(line[2:end])))

f_action(translate, rotate) = Dict(
    'N' => translate((0, +1)), 'S' => translate((0, -1)),
    'W' => translate((-1, 0)), 'E' => translate((+1, 0)),
    'L' => rotate(+1), 'R' => rotate(-1),
    'F' => ((pos, dir, l) -> (pos .+ dir .* l, dir))
)

execute(init_dir) = last(accumulate(
  ((pos, dir), inst) ->
  action[inst.dir](pos, dir, inst.l), lines; init=((0, 0), init_dir)
))[1]


## part 1

translate(vec) = (pos, dir, l) -> (pos .+ vec .* l, dir)
rotate(cw) = (pos, dir, l) ->
    (pos, (round(Int, cos(deg2rad(cw*l)) * dir[1] - sin(deg2rad(cw*l)) * dir[2]),
           round(Int, sin(deg2rad(cw*l)) * dir[1] + cos(deg2rad(cw*l)) * dir[2])))

action = f_action(translate, rotate)

pos = execute((1, 0))

println("$(sum(abs.(pos)))") ## 757


## part 2

translate_wp(vec) = (pos, wp, l) -> (pos, wp .+ vec .* l)
rotate_wp(cw) = (pos, wp, l) ->
    (pos, (round(Int, cos(deg2rad(cw*l)) * wp[1] - sin(deg2rad(cw*l)) * wp[2]),
           round(Int, sin(deg2rad(cw*l)) * wp[1] + cos(deg2rad(cw*l)) * wp[2])))

action = f_action(translate_wp, rotate_wp)

pos = execute((10, 1))

println("$(sum(abs.(pos)))") ## 51249
