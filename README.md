# Better Number

`BetterNumber` is an Elixir library which provides functions to convert numbers into a variety of different formats. It is a fork of [Daniel Berkompas's Number](https://github.com/danielberkompas/number) but it

1. Has slightly more features

2. Does not perform any configuration lookups and therefore each function is __100% pure__.

3. Has no `__using__` to import functions

4. Has correct type specifications

5. Actively maintained

## Features

* Conversion to currency, where everything is customizable

```elixir
BetterNumber.to_currency(2034.46)
"$2,034.46"
```

* Conversion to international phone format

```elixir
BetterNumber.to_phone(1112223333, area_code: true, country_code: 1)
"+1 (111) 222-3333"
```

* Conversion to percentage

```elixir
BetterNumber.to_percentage(100, precision: 0)
"100%"
```

* Conversion to human readable format

```elixir
BetterNumber.to_human(1234)
"1.23 Thousand"
```

* Just splitting the number with commas

```elixir
BetterNumber.to_delimited(12345678)
"12,345,678"
```

> Note:
>
> Every function is extremely customizable, and has a ton of options

## Installation

Get it from Hex:

```elixir
defp deps do
  [
    {:better_number, "~> 1.0.1"}
  ]
end
```

Then run `mix deps.get`.

## Usage


```elixir
defmodule MyModule do
  alias BetterNumber, as: Number

  ...
end
```

See the [Hex documentation](http://hexdocs.pm/better_number/) for more information
about the modules provided by `BetterNumber`.

## License

MIT. See [LICENSE](https://github.com/hissssst/better_number/blob/master/LICENSE) for more details.
