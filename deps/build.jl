using Currencies
import Currencies: unit

outputname = joinpath(@__DIR__, "cashinstruments.jl")

function genfile(io)
    for symbol in keys(Currencies.list)
        println(io,"$symbol = Cash(:$symbol)")
    end
end

open(io -> genfile(io), outputname, "w")