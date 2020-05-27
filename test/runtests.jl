using Instruments
import Instruments: USD, EUR, JPY, CNY, currency, symbol, unit, code, name

using Test

instruments = [USD, EUR, JPY, CNY]
currencies = [Currency{s}() for s in [:USD, :EUR, :JPY, :CNY]]
units = [2,2,2,2]
names = ["US Dollar","Euro","Yen","Yuan Renminbi"]
codes = [840,608,344,702]

for (cash,ccy,u,n,c) in zip(instruments,currencies,units,names,codes)
    @test cash == Cash(ccy)
    @test cash == Cash(symbol(ccy))
    @test currency(cash) == ccy
    @test symbol(cash) == symbol(ccy)
    @test unit(cash) == unit(ccy)
    @test code(cash) == code(ccy)
    @test name(cash) == name(ccy)
    
    position = Position(cash,1)
    @test currency(position) == currency(cash)
    @test currency(1cash) == ccy
    @test 1cash == position
    @test cash*1 == position
    @test 1cash+1cash == Position(cash,2)
    @test 1cash-1cash == Position(cash,0)
    @test 20cash/4cash == FixedDecimal{Int,unit(cash)}(5)
    @test 20cash/4 == Position(cash,5)
    # @test unit(ccy) == u
    # @test name(ccy) == n
    # @test code(ccy) == c
end
