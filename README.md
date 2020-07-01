[travis-url]:   https://travis-ci.org/JuliaFinance/Instruments.jl
[travis-img]: https://travis-ci.org/JuliaFinance/Instruments.jl.svg

[codecov-url]:  https://codecov.io/gh/JuliaFinance/Instruments.jl
[codecov-img]:  https://codecov.io/gh/JuliaFinance/Instruments.jl/branch/master/graph/badge.svg

[![][travis-img]][travis-url] [![][codecov-img]][codecov-url]

# Instruments.jl

This package provides an abstract interface to be implemented for all financial instruments in JuliaFinance. Examples of financial instruments can include cash, stocks, bonds, loans, derivatives, insurance policies, cryptocurrencies, etc.

## `Instrument{S,C<:Currency}`

`Instrument{S,C}` is an abstract parametric type that is to be implemented for all financial instruments, where `S` the instrument's symbol identifier and `C` is its `Currency`.

For examples of concrete implementations of `Instrument`, see [Assets.jl](https://github.com/JuliaFinance/Assets.jl.git).

