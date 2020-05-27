# Instruments.jl

This is a base package for the JuliaFinance ecosytem.

It provides a singleton type `Currency` based on standard ISO 4167 currency codes to be used primarily for dispatch in other JuliaFinance packages together with four methods:

- `symbol`: The ISO 4167 3 letter symbol for the currency.
- `name`: The name of the currency.
- `code`: The ISO 4167 code for the currency.
- `unit`: The minor unit, i.e. number of decimal places, for the currency.

This is provided from the [Currencies](https://github.com/JuliaFinance/Currencies.jl.git) package.

These are simple labels, such as `Currency{:USD}`, `Currency{:EUR}`.

In addition, this package provides an abstract type `AbstractInstrument`.

A financial instrument is a tradeable monetary contract that creates an asset for some parties while, at same time, creating a liability for others.

Examples of financial instruments include stocks, bonds, loans, derivatives, etc. However, the most basic financial instruments are currencies.

When a currency is thought of as a financial instrument (as opposed to a mere label used in UI component), we choose to refer to it as `Cash` (as it would appear in a balance sheet).
The `Cash` type keeps track of the number of minor units as part of the type, for performance and dispatching reasons.

Short constants are set up, matching the ISO 4167 names, so that you can use `USD` instead of `Cash{:USD,2}()`.

`Position` represents ownership of a financial instrument including the quantity of that financial instrument. For example, Microsoft stock (MSFT) is a financial instrument. A position could be 1,000 shares of MSFT.

In the case of currency, `Instruments.USD` would be a financial instrument and owning $1,000 would mean you own 1,000 units of the financial instrument `Instruments.USD`.

If you are building a financial application that requires adding, subtracting, multiplying and dividing currencies, then you want to use `Instruments`.

For example:
```julia
julia> using Instruments

julia> import Instruments: USD, JPY

julia> 10USD
10.00USD

julia> 10USD+20USD
30.00USD

julia> 5*20USD
100.00USD

julia> 100USD/5
20.00USD

julia> 100USD/5USD
FixedDecimal{Int64,2}(20.00)

julia> 100JPY/5JPY
FixedDecimal{Int64,0}(20)

julia> 100USD+100JPY
ERROR: promotion of types Position{Cash{Currency{:USD}},FixedPointDecimals.FixedDecimal{Int64,2}} and Position{Cash{Currency{:JPY}},FixedPointDecimals.FixedDecimal{Int64,0}} failed to change any arguments
```

Note that algebraic operations of currency positions require the positions to be of the same financial instrument. In this case, they must be the same currency as indicated by the error in the last command above.

See also:

- [Currencies.jl](https://github.com/JuliaFinance/Currencies.jl.git)
- [Markets.jl](https://github.com/JuliaFinance/Markets.jl.git)
- [GeneralLedgers.jl](https://github.com/JuliaFinance/GeneralLedgers.jl.git)
