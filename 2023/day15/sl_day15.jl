# include("../../sl_common.jl")

v = split(readline("input.txt"), ",")

aHash(str) = reduce((h, c) -> 17 * (h + Int(c)) % 256, str; init=0)

aHash("HASH")

[aHash(str) for str in v] |> sum