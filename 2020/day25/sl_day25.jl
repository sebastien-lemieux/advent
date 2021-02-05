# input:
cpk = 14012298
dpk = 74241

# cpk = 5764801 ## demo : 11
# dpk = 17807724 ## demo : 8

## A custom iterator that applies one loop
struct Key  sn::Int  end
Base.iterate(k::Key, state=k.sn) = (state, (state * k.sn) % 20201227)

findfirst(f, sn::Int) = for (i, x) in enumerate(Key(sn))
    f(i, x) && return i, x
end

find_ls(key::Int) = findfirst((i, x) -> x == key, 7)[1]
apply_ls(sn::Int, ls::Int) = findfirst((i, x) -> i == ls, sn)[2]

dls = find_ls(dpk)
cls = find_ls(cpk)

apply_ls(cpk, dls)

# 18608573
