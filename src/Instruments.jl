"""
Instruments

This package provides the `AbstractInstrument` abstract type together with `Cash` and `Position` parametric types for dealing with currencies and other financial instruments.

See [README](https://github.com/JuliaFinance/Instruments.jl.git/README.md) for the full documentation

Copyright 2020, Eric Forgy, Scott P. Jones and other contributors

Licensed under MIT License, see [LICENSE](https://github.com/JuliaFinance/Instruments.jl.git/LICENSE.md)
"""
module Instruments

using Currencies, FixedPointDecimals
import Currencies: symbol, unit, code, name

export Position, FixedDecimal
export AbstractInstrument, Cash
export Currencies, Currency

"""
This is an abstract type from which all financial instruments such as `Cash`, `Stock`, etc. should subtype.
"""
abstract type AbstractInstrument{S,C<:Currency} end

symbol(::AbstractInstrument{S}) where {S} = S
currency(::AbstractInstrument{S,C}) where {S,C} = C()

"""
`Position` represents ownership of a certain quantity of a particular financial instrument.
"""
struct Position{I<:AbstractInstrument,A}
    instrument::I
    amount::A
end

"""
Returns the financial instrument (as an instance) for a position.
"""
instrument(p::Position) = p.instrument

"""
Returns the amount of the instrument in the `Position` owned.
"""
amount(p::Position) = p.amount

"""
Returns the currency of the instrument in the `Position`.
"""
currency(p::Position) = currency(instrument(p))

Base.promote_rule(::Type{Position{F,A1}}, ::Type{Position{F,A2}}) where {F,A1,A2} =
    Position{F,promote_type(A1,A2)}
Base.convert(::Type{Position{F,A}}, x::Position{F,A}) where {F,A} = x
Base.convert(::Type{Position{F,A}}, x::Position{F,<:Real}) where {F,A} =
    Position{F,A}(convert(A, x.amount))

Base.:+(p1::Position{F1}, p2::Position{F2}) where {F1,F2} =
    error("Can't add Positions of different Instruments $(F1()), $(F2())")
Base.:+(p1::Position{F}, p2::Position{F}) where {F} =
    Position(p1.instrument, p1.amount + p2.amount)

Base.:-(p1::Position{F1}, p2::Position{F2}) where {F1,F2} =
    error("Can't subtract Positions of different Instruments $(F1()), $(F2())")
Base.:-(p1::Position{F}, p2::Position{F}) where {F} =
    Position(p1.instrument, p1.amount - p2.amount)

Base.:/(p1::Position, p2::Position) = p1.amount / p2.amount
Base.:/(p::Position, k::Real) = Position(p.instrument, p.amount / k)

Base.:*(k::Real, p::Position) = Position(p.instrument, p.amount * k)
Base.:*(p::Position, k::Real) = k * p

Base.:*(val::Real, inst::AbstractInstrument) = Position(inst, val)
Base.:*(inst::AbstractInstrument, val::Real) = Position(inst, val)

Base.show(io::IO, inst::AbstractInstrument) = print(io, symbol(inst))
Base.show(io::IO, ::MIME"text/plain", inst::AbstractInstrument) = print(io, symbol(inst))

Base.show(io::IO, p::Position) = print(io, p.amount, instrument(p))
Base.show(io::IO, ::MIME"text/plain", p::Position) = print(io, amount(p), instrument(p))

Base.zero(::Type{Position{F,A}}) where {F,A} = Position{F,A}(zero(A))
Base.one(::Type{Position{F,A}}) where {F,A} = Position{F,A}(one(A))

include(joinpath(@__DIR__,"Cash.jl"))

end # module Instruments
