"""
Instruments

This package provides the `Instrument` abstract type together with the `Position` parametric type
for dealing with currencies and other financial instruments.

See [README](https://github.com/JuliaFinance/Instruments.jl.git/README.md) for the full documentation

Copyright 2020, Eric Forgy, Scott P. Jones and other contributors

Licensed under MIT License, see [LICENSE](https://github.com/JuliaFinance/Instruments.jl.git/LICENSE.md)
"""
module Instruments

using Currencies
import Currencies: currency, symbol, unit, code, name

export Instrument, Position

"""
This is an abstract type from which all financial instruments such as `Cash`, `Stock`, etc. should subtype.
"""
abstract type Instrument{S,C<:Currency} end

symbol(::Type{Instrument{S}}) where {S} = S
currency(::Type{Instrument{S,Currency{C}}}) where {S,C} = currency(C)

symbol(::Instrument{S}) where {S} = S
currency(::Instrument{S,Currency{C}}) where {S,C} = currency(C)

"""
`Position` represents ownership of a certain quantity of a particular financial instrument.
"""
struct Position{I<:Instrument,A<:Real}
    amount::A
end
Position{I}(amt) where {I<:Instrument} = Position{I,typeof(amt)}(amt)

(::Type{I})(amt) where {I<:Instrument} = Position{I}(amt)

"""
Returns the financial instrument type of a position.
"""
instrument(::Position{I}) where {I} = I

"""
Returns the amount of the instrument in the `Position` owned.
"""
amount(p::Position) = p.amount

"""
Returns the symbol of the instrument in the `Position`.
"""
symbol(::Position{I}) where {I} = symbol(I)

"""
Returns the currency of the instrument in the `Position`.
"""
currency(::Position{I}) where {I<:Instrument} = currency(I)

Base.zero(::Type{Position{I,A}}) where {I<:Instrument,A<:Real} = Position{I,A}(0)

Base.promote_rule(::Type{Position{I,A1}}, ::Type{Position{I,A2}}) where {I,A1,A2} =
    Position{I,promote_type(A1,A2)}
Base.convert(::Type{Position{I,A}}, x::Position{I,A}) where {I,A} = x
Base.convert(::Type{Position{I,A}}, x::Position{I}) where {I,A} =
    Position{I}(convert(A, x.amount))

Base.:+(::Position{I1}, ::Position{I2}) where {I1,I2} =
    error("Can't add Positions of different Instruments $(I1()), $(I2())")
Base.:+(p1::Position{I}, p2::Position{I}) where {I} =
    Position{I}(p1.amount + p2.amount)

Base.:-(::Position{I1}, ::Position{I2}) where {I1,I2} =
    error("Can't subtract Positions of different Instruments $(I1()), $(I2())")
Base.:-(p1::Position{I}, p2::Position{I}) where {I} =
    Position{I}(p1.amount - p2.amount)
Base.:-(p::Position{I}) where {I} = Position{I}(-p.amount)

Base.:/(::Position{I1}, ::Position{I2}) where {I1,I2} =
    error("Can't divide Positions of different Instruments $(I1()), $(I2())")
Base.:/(p1::Position{I}, p2::Position{I}) where {I} = p1.amount / p2.amount
Base.:/(p::Position{I}, k::Real) where {I} = Position{I}(p.amount / k)

Base.:*(k::Real, p::Position{I}) where {I} = Position{I}(p.amount * k)
Base.:*(p::Position, k::Real) = k * p

Base.:*(val::Real, ::Type{I}) where {I<:Instrument} = Position{I}(val)
Base.:*(::Type{I}, val::Real) where {I<:Instrument} = Position{I}(val)

# Handle instances of Instruments also
Base.:*(val::Real, ::I) where {I<:Instrument} = Position{I}(val)
Base.:*(::I, val::Real) where {I<:Instrument} = Position{I}(val)

Base.show(io::IO, ::I) where {I<:Instrument} = print(io, symbol(I))
Base.show(io::IO, p::Position{I}) where {I<:Instrument} = print(io, p.amount, symbol(I))

end # module Instruments
