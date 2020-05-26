using JSON3

const src = "https://pkgstore.datahub.io/core/country-codes/country-codes_json/data/471a2e653140ecdd7243cdcacfd66608/country-codes_json.json"

inpnam = joinpath("..", "data", "country-codes.json")
outnam = joinpath("..", "deps", "currencies.jl")

println("Downloading currency data: ", src)
download(src, inpnam)

const country_list = (open(inpnam) do io ; JSON3.read(io) ; end)

const Currencies = Dict{String,Tuple{String,Int,Int,String}}()

const SymCurr = Symbol("ISO4217-currency_alphabetic_code")
const SymUnit = Symbol("ISO4217-currency_minor_unit")
const SymName = Symbol("ISO4217-currency_name")
const SymCode = Symbol("ISO4217-currency_numeric_code")

function genfile(io)
    for country in country_list
        (abbrlist = country[SymCurr]) === nothing && continue
        (unitlist = country[SymUnit]) === nothing && continue
        (namelist = country[SymName]) === nothing && continue
        (codelist = country[SymCode]) === nothing && continue
        currencies = split(abbrlist, ',')
        units = split(string(unitlist), ',')
        names = split(namelist, ',')
        codes = split(string(codelist), ',')

        for (curr, unit, code, name) in zip(currencies, units, codes, names)
            length(curr) != 3 && continue
            haskey(Currencies, curr) && continue
            Currencies[curr] = (curr, parse(Int, unit), parse(Int, code), string(name))
        end
    end
    println(io, "const Currencies = Dict(")
    for (curr, val) in Currencies
        println(io, "    :$curr => (Currency{:$curr}, $(val[2]), $(lpad(val[3], 4)), \"$(val[4])\"),")
    end
    println(io, ")\n")
end

open(outnam, "w") do io
    genfile(io)
end
