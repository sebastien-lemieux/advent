include("../sl_common.jl")

function valHgt(str)
    m = match(r"^([0-9]+)(cm|in)$", str)
    m == nothing && return false
    (n, u) = m.captures
    ((u == "cm" && between(int(n), 150, 193)) ||
     (u == "in" && between(int(n), 59, 76))) && return true
    return false
end

val = Dict(
    "byr" => str -> (str != "" && between(int(str), 1920, 2002)),
    "iyr" => str -> (str != "" && between(int(str), 2010, 2020)),
    "eyr" => str -> (str != "" && between(int(str), 2020, 2030)),
    "hgt" => valHgt,
    "hcl" => str -> occursin(r"^#[0-9a-f]{6}$", str),
    "ecl" => str -> occursin(r"^(amb|blu|brn|gry|grn|hzl|oth)$", str),
    "pid" => str -> occursin(r"^[0-9]{9}$", str)
)

function validate(d)
    for (field, vfunc) in val
        (!haskey(d, field) || !vfunc(d[field])) && return false
    end
    return true
end

lines = readFile("input.txt", line -> split(line, " "))
countValid = 0

entries = map(tmp -> vcat(tmp...), split(lines, [""]))

for e in entries
    d = Dict(map(tmp -> split(tmp, ":"), e))
    validate(d) && (countValid += 1)
end

println(countValid) ## 109
