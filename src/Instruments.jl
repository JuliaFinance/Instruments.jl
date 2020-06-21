"""
Instruments

This package provides the `Instrument` abstract type together with the `Position` parametric type for dealing with currencies and other financial instruments.

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

symbol(::TI) where {TI<:Type{I}} where {I<:Instrument{S}} where {S} = S
currency(::TI) where {TI<:Type{I}} where {I<:Instrument{S,Currency{CS}}} where {S,CS} = currency(CS)

symbol(::Instrument{S}) where {S} = S
currency(::Instrument{S,Currency{CS}}) where {S,CS} = currency(CS)

"""
`Position` represents ownership of a certain quantity of a particular financial instrument.
"""
struct Position{I<:Instrument,A}
    amount::A
end
Position{I}(a) where {I<:Instrument} = Position{I,typeof(a)}(a)

if VERSION >= v"1.3"
    (instrument::Instrument)(amount) = Position{typeof(instrument)}(amount)
end

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
symbol(::Position{I,A}) where {I,A} = symbol(I)

"""
Returns the currency of the instrument in the `Position`.
"""
currency(::Position{I}) where {I<:Instrument}= currency(I)

Base.promote_rule(::Type{Position{I,A1}}, ::Type{Position{I,A2}}) where {I,A1,A2} =
    Position{I,promote_type(A1,A2)}
Base.convert(::Type{Position{I,A}}, x::Position{I,A}) where {I,A} = x
Base.convert(::Type{Position{I}}, x::Position{I}) where {I,A} =
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

Base.:*(val::Real, ::I) where {I<:Instrument} = Position{I}(val)
Base.:*(::I, val::Real) where {I<:Instrument} = Position{I}(val)

Base.show(io::IO, ::I) where {I<:Instrument} = print(io, symbol(I))
Base.show(io::IO, ::MIME"text/plain", ::I) where {I<:Instrument} = print(io, symbol(I))

Base.show(io::IO, p::Position{I}) where {I<:Instrument} = print(io, p.amount, symbol(I))
Base.show(io::IO, ::MIME"text/plain", p::Position{I}) where {I<:Instrument} = print(io, amount(p), symbol(I))

end # module Instruments
