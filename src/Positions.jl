module Positions

using Reexport
@reexport using FinancialInstruments
export Position

struct Position{P<:Union{Currency,FinancialInstrument}}
    amount::Float64
end
Position(p::P,a::Float64) where P<:Union{Currency,FinancialInstrument} = Position{typeof(p)}(a)

Base.:+(p1::Position{P},p2::Position{P}) where P<:Union{Currency,FinancialInstrument} = Position{P}(p1.amount+p2.amount)
Base.:-(p1::Position{P},p2::Position{P}) where P<:Union{Currency,FinancialInstrument} = Position{P}(p1.amount-p2.amount)

Base.:/(p1::Position{P},p2::Position{P}) where P<:Union{Currency,FinancialInstrument} = p1.amount/p2.amount
Base.:/(p::Position{P},k::R) where P<:Union{Currency,FinancialInstrument} where R<:Real = Position{P}(c.amount/k)

Base.:*(p::Position{P},k::R) where P<:Union{Currency,FinancialInstrument} where R<:Real = Position{P}(p.amount*k)
Base.:*(k::R,p::Position{P}) where P<:Union{Currency,FinancialInstrument} where R<:Real = p*k

end # module
