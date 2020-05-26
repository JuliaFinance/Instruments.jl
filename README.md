# Positions.jl

[![Build Status](https://travis-ci.org/JuliaFinance/Positions.jl.svg?branch=master)](https://travis-ci.org/JuliaFinance/Positions.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/chnj7xc6r0deux92/branch/master?svg=true)](https://ci.appveyor.com/project/EricForgy/currencies-jl/branch/master)

This is a base package for the JuliaFinance ecosytem.

It provides a singleton type `Currency` based on standard ISO 4167 currency codes to be used primarily for dispatch in other JuliaFinance packages together with three methods:

- `name`: The name of the currency.
- `code`: The ISO 4167 code for the currency.
- `unit`: The minor unit, i.e. number of decimal places, for the currency.

(this functionality used to be from the Currencies.jl package)

These are simple labels, such as `Currency{:USD}`, `Currency{:EUR}`.

In addition, this package provides an abstract type `FinancialInstrument`.

A financial instrument is a tradeable monetary contract that creates an asset for some parties while, at same time, creating a liability for others.

Examples of financial instruments include stocks, bonds, loans, derivatives, etc. However, the most basic financial instruments are currencies.

When a currency is thought of as a financial instrument (as opposed to a mere label used in UI component), we choose to refer to it as `Cash` (as it would appear in a balance sheet).
The `Cash` type keeps track of the number of minor units as part of the type, for performance and dispatching reasons.

Short constants are set up, matching the ISO 4167 names, so that you can use
`USD` instead of `Cash{Currency{:USD},2}()`

Finally, this package also provides an `AbstractPosition` type, as well as a `Position` concrete type.
`Position` represents ownership of a financial instrument including the quantity of that financial instrument. For example, Microsoft stock (MSFT) is a financial instrument. A position could be 1,000 shares of MSFT.

In the case of currency, `Positions.USD` would be a financial instrument and owning $1,000 would mean you own 1,000 units of the financial instrument `Positions.USD`.

If you are building a financial application that requires adding, subtracting, multiplying and dividing currencies, then you want to use `Positions`.

For example:
```julia
julia> using Positions

julia> using Positions: USD, JPY

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

- [Markets.jl](https://github.com/JuliaFinance/Markets.jl)
- [GeneralLedgers.jl](https://github.com/JuliaFinance/GeneralLedgers.jl)

## Data Source

Data for this package was obtained from https://datahub.io/core/country-codes.

