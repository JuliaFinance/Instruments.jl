using Instruments
using Instruments: currency, symbol, unit, code, name

# using Test

@testset "All currencies" begin
    for sym in Currencies.allsymbols()
        ccy = Currency{sym}()
        # This needs some new tests, since Cash is not yet defined
    end
end
