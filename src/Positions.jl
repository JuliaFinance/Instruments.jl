module Positions

using FinancialInstruments, FixedPointDecimals

export Currencies, Currency
export Countries, Country
export FinancialInstruments, FinancialInstrument, Cash
export Position

abstract type AbstractPosition end

struct Position{F<:FinancialInstrument,A<:Real} <: AbstractPosition
    amount::A
end
Position(p,a) = Position{typeof(p),typeof(a)}(a)
Position(c::Cash{C},a) where C = Position{Cash{C},FixedDecimal{Int,Currencies.unit(C())}}(FixedDecimal{Int,Currencies.unit(C())}(a))

Base.promote_rule(::Type{Position{F,A1}}, ::Type{Position{F,A2}}) where {F,A1,A2} = Position{F,promote_type(A1,A2)}
Base.convert(::Type{Position{F,A}}, x::Position{F,A}) where {F,A} = x
Base.convert(::Type{Position{F,A}}, x::Position{F,<:Real}) where {F,A} = Position{F,A}(convert(A,x.amount))

Base.:+(p1::Position{F,A},p2::Position{F,A}) where {F,A} = Position{F,A}(p1.amount+p2.amount)
Base.:+(p1::AbstractPosition,p2::AbstractPosition) = +(promote(p1,p2)...)

Base.:-(p1::Position{F,A},p2::Position{F,A}) where {F,A} = Position{F,A}(p1.amount-p2.amount)
Base.:-(p1::AbstractPosition,p2::AbstractPosition) = -(promote(p1,p2)...)

Base.:/(p1::Position{F,A},p2::Position{F,A}) where {F,A} = p1.amount/p2.amount
Base.:/(p1::AbstractPosition,p2::AbstractPosition) = /(promote(p1,p2)...)

# TODO: Should scalar multiplication and division respect the Position type or do normal promotion?

# Base.:/(p::Position{F,A},k::R) where {F,A,R<:Real} = Position{F,promote_type(A,R)}(p.amount/k)
Base.:/(p::Position{F,A},k::R) where {F,A,R<:Real} = Position{F,A}(p.amount/k)

# Base.:*(k::R,p::Position{F,A}) where {F,A,R<:Real} = Position{F,promote_type(A,R)}(p.amount*k)
Base.:*(k::R,p::Position{F,A}) where {F,A,R<:Real} = Position{F,A}(p.amount*k)
Base.:*(p::Position{F,A},k::R) where {F,A,R<:Real} = k*p

Base.show(io::IO,c::Position{Cash{C}}) where C = print(io,c.amount," ",C())
Base.show(io::IO,::MIME"text/plain",c::Position{Cash{C}}) where C = print(io,c.amount," ",C())

Base.zero(::Type{Position{F,A}}) where {F,A} = Position{F,A}(zero(A))
Base.one(::Type{Position{F,A}}) where {F,A} = Position{F,A}(one(A))

for (sym,ccy) in Currencies.list
    @eval Positions begin
        $sym = Position(Cash($ccy),1)
    end
end

end # module
