[pkg-url]: https://github.com/JuliaFinance/Instruments.jl.git

[release]:      https://img.shields.io/github/release/JuliaFinance/Instruments.jl.svg
[release-date]: https://img.shields.io/github/release-date/JuliaFinance/Instruments.jl.svg

[license-img]:  http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat
[license-url]:  LICENSE.md
[julia-url]:          https://github.com/JuliaLang/julia
[julia-release]:      https://img.shields.io/github/release/JuliaLang/julia.svg

[travis-url]:   https://travis-ci.org/JuliaFinance/Instruments.jl
[travis-s-img]: https://travis-ci.org/JuliaFinance/Instruments.jl.svg
[travis-m-img]: https://travis-ci.org/JuliaFinance/Instruments.jl.svg?branch=master

[contrib]:    https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat

[codecov-url]:  https://codecov.io/gh/JuliaFinance/Instruments.jl
[codecov-img]:  https://codecov.io/gh/JuliaFinance/Instruments.jl/branch/main/graph/badge.svg

| **Julia Version** | **Unit Tests** | **Code Coverage** |
|:------------------:|:------------------:|:---------------------:|
| [![][julia-release]][julia-url] | [![][travis-s-img]][travis-url] | [![][codecov-img]][codecov-url]
| Latest | [![][travis-m-img]][travis-url] | [![][codecov-img]][codecov-url]

# Instruments.jl

This package provides an abstract interface to be implemented for all financial instruments in JuliaFinance. Examples of financial instruments can include cash, stocks, bonds, loans, derivatives, insurance policies, cryptocurrencies, etc.

## `Instrument{S,C<:Currency}`

`Instrument{S,C}` is an abstract parametric type that is to be implemented for all financial instruments, where `S` the instrument's symbol identifier and `C` is its `Currency`.

For examples of concrete implementations of `Instrument`, see [Assets.jl](https://github.com/JuliaFinance/Assets.jl.git).

