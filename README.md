# Instruments.jl

[travis-url]:   https://travis-ci.org/JuliaFinance/Instruments.jl
[travis-s-img]: https://travis-ci.org/JuliaFinance/Instruments.jl.svg
[travis-m-img]: https://travis-ci.org/JuliaFinance/Instruments.jl.svg?branch=main

[![][travis-s-img]][travis-url] [![][travis-m-img]][travis-url]

This package provides an abstract interface to be implemented for all financial instruments in JuliaFinance. Examples of financial instruments can include cash, stocks, bonds, loans, derivatives, insurance policies, cryptocurrencies, etc. 

## `Instrument{S,C<:Currency}`

`Instrument{S,C}` is an abstract parametric type that is to be implemented for all financial instruments, where `S` the instrument's symbol identifier and `C` is its `Currency`.

For examples of concrete implementations of `Instrument`, see

- [Assets.jl](https://github.com/JuliaFinance/Assets.jl.git)
