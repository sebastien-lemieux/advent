fuel_req(mass::String) = fuel_req(parse(Int, mass))
fuel_req(mass::Int) = max(Int(floor(mass / 3) - 2), 0)

sum(fuel_req.(readlines("input.txt"))) ## 3394689

## Part 2

fuel_req(mass::String) = fuel_req_all(parse(Int, mass))
function fuel_req_all(mass::Int)
    f = fuel_req(mass)
    if f > 0  f += fuel_req_all(f) end
    return f
end

sum(fuel_req.(readlines("input.txt"))) ## 5089160
