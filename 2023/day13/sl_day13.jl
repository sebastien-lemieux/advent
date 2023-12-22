include("../../sl_common.jl")

charToBit(c) = (c == '#') ? true : false

puzzle = readGrids(charToBit, "input.txt");

grid = puzzle[1]

function findMirror(grid)
    nrow, ncol = size(grid)
    for i=1:(ncol-1)
        Δ = 0
        while (i - Δ) >= 1 && (i + Δ + 1) <= ncol && grid[:,i - Δ] == grid[:,i + Δ + 1]
            Δ += 1
        end
        Δ > 0 && ((i - Δ) == 0 || (i + Δ + 1) > ncol) && return i
    end
    return 0
end

[findMirror(g) + 100*findMirror(g') for g in puzzle] |> sum

## Part 2

nbMis(a, b) = sum(a .!= b)

function findMirror(grid)
    nrow, ncol = size(grid)
    for i=1:(ncol-1)
        Δ = 0
        nbSmudge = 0
        while (i - Δ) ≥ 1 && (i + Δ + 1) ≤ ncol && nbSmudge ≤ 1
            nbSmudge +=  nbMis(grid[:,i - Δ], grid[:,i + Δ + 1])
            Δ += 1
        end
        nbSmudge == 1 && ((i - Δ) == 0 || (i + Δ + 1) > ncol) && return i
    end
    return 0
end

[findMirror(g) + 100*findMirror(g') for g in puzzle] |> sum
