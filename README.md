# Better Number

`BetterNumber` is an [Elixir](https://github.com/elixir-lang/elixir) library which
provides functions to convert numbers into a variety of different formats. It is
a fork of Daniel Berkompas's Number but it

1. Has slightly more features

2. Does not perform any configuration lookups and therefore each function is __100% pure__

3. Has no `__using__` (why would anyone want to have this?)

```elixir
alias BetterNumber, as: Number

Number.Currency.number_to_currency(2034.46)
"$2,034.46"

Number.Phone.number_to_phone(1112223333, area_code: true, country_code: 1)
"+1 (111) 222-3333"

Number.Percentage.number_to_percentage(100, precision: 0)
"100%"

Number.Human.number_to_human(1234)
"1.23 Thousand"

Number.Delimit.number_to_delimited(12345678)
"12,345,678"
```

## Installation

Get it from Hex:

```elixir
defp deps do
  [
    {:better_number, github: "hissssst/better_number"}
  ]
end
```

Then run `mix deps.get`.

## Usage

If you want to import all of the functions provided by `BetterNumber`, simply `use`
it in your module:

```elixir
defmodule MyModule do
  use BetterNumber
end
```

See the [Hex documentation](http://hexdocs.pm/number/) for more information
about the modules provided by `Number`.

## License
MIT. See [LICENSE](https://github.com/hissssst/number/blob/master/LICENSE) for more details.
