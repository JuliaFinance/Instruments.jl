"""
Instruments

This package provides the `Instrument` abstract type together with the `Position` parametric type for dealing with currencies and other financial instruments.

See [README](https://github.com/JuliaFinance/Instruments.jl.git/README.md) for the full documentation

Copyright 2020, Eric Forgy, Scott P. Jones and other contributors

Licensed under MIT License, see [LICENSE](https://github.com/JuliaFinance/Instruments.jl.git/LICENSE.md)
"""
module Instruments

using Currencies

export Instrument, Position, symbol, currency, instrument, position, amount

"`Instrument` is an abstract type from which all financial instruments such as `Cash`, `Stock`, etc. should subtype."
abstract type Instrument{S,C<:Currency} end

"`Position` represents ownership of a certain quantity of a particular financial instrument."
struct Position{I<:Instrument,A<:Real}
    amount::A
end

Position(::Type{I},amt) where {I<:Instrument} = Position{I,typeof(amt)}(amt)

Currencies.symbol(::Type{I}) where {S,I<:Instrument{S}} = S

Currencies.symbol(::Type{P}) where {I,P<:Position{I}} = symbol(I)

Currencies.currency(::Type{I}) where {S,C,I<:Instrument{S,C}} = C

Currencies.currency(::Type{P}) where {I,P<:Position{I}} = currency(I)

"""
Returns the financial instrument type of a position.
"""
function instrument end

instrument(::Type{I}) where {I<:Instrument} = I

instrument(::Type{P}) where {I,P<:Position{I}} = I

"""
Returns the type of a position.
"""
function position end

position(::Type{P}) where {P<:Position} = P

"""
Returns the amount of the instrument in the `Position` owned.
"""
amount(p::Position) = p.amount

Base.zero(::Type{Position{I,A}}) where {I<:Instrument,A<:Real} = Position{I,A}(0)

Base.promote_rule(::Type{Position{I,A1}}, ::Type{Position{I,A2}}) where {I,A1,A2} =
    Position{I,promote_type(A1,A2)}
Base.convert(::Type{Position{I,A}}, x::Position{I,A}) where {I,A} = x
Base.convert(::Type{Position{I,A}}, x::Position{I}) where {I,A} =
    Position(I,convert(A, x.amount))

Base.:+(::Position{I1}, ::Position{I2}) where {I1,I2} =
    error("Can't add Positions of different Instruments $(I1()), $(I2())")
Base.:+(p1::Position{I}, p2::Position{I}) where {I} =
    Position(I,p1.amount + p2.amount)

Base.:-(::Position{I1}, ::Position{I2}) where {I1,I2} =
    error("Can't subtract Positions of different Instruments $(I1()), $(I2())")
Base.:-(p1::Position{I}, p2::Position{I}) where {I} =
    Position(I,p1.amount - p2.amount)
Base.:-(p::Position{I}) where {I} = Position(I,-p.amount)

Base.:/(::Position{I1}, ::Position{I2}) where {I1,I2} =
    error("Can't divide Positions of different Instruments $(I1()), $(I2())")
Base.:/(p1::Position{I}, p2::Position{I}) where {I} = p1.amount / p2.amount
Base.:/(p::Position{I}, k::Real) where {I} = Position(I,p.amount / k)

Base.:*(k::Real, p::Position{I}) where {I} = Position(I,p.amount * k)
Base.:*(p::Position, k::Real) = k * p

Base.:*(val::Real, ::Type{P}) where {I,P<:Position{I}} = Position(I,val)

Base.show(io::IO, ::I) where {I<:Instrument} = print(io, symbol(I))
Base.show(io::IO, p::Position{I}) where {I<:Instrument} = print(io, p.amount, symbol(I))

end # module Instruments
