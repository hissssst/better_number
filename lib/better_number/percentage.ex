defmodule BetterNumber.Percentage do
  @moduledoc """
  Provides functions for converting numbers into percentages.
  """

  import BetterNumber.Delimit, only: [number_to_delimited: 2]

  @defaults %{
    precision: 2,
    delimiter: ",",
    separator: ".",
    trim_zero_fraction: false
  }

  @doc """
  Formats a number into a percentage string.

  ## Parameters

  * `number` - A value to convert. Can be any value that implements
    `BetterNumber.Conversion.to_float/1`.

  * `options` - A keyword list of options. See the documentation below for all
    available options.

  ## Options

  * `:precision` - The number of decimal places to include. Default: 2

  * `:delimiter` - The character to use to delimit the number by thousands.
    Default: ","

  * `:separator` - The character to use to separate the number from the decimal
    places. Default: "."

  * `:trim_zero_fraction` - Whether to trim the zeroes in fraction part of number.
    Default: "false"

  ## Examples

      iex> BetterNumber.Percentage.number_to_percentage(100)
      "100.00%"

      iex> BetterNumber.Percentage.number_to_percentage("98")
      "98.00%"

      iex> BetterNumber.Percentage.number_to_percentage(100, precision: 0)
      "100%"

      iex> BetterNumber.Percentage.number_to_percentage(1000, delimiter: '.', separator: ',')
      "1.000,00%"

      iex> BetterNumber.Percentage.number_to_percentage(302.24398923423, precision: 5)
      "302.24399%"

      iex> BetterNumber.Percentage.number_to_percentage(Decimal.from_float(59.236), precision: 2)
      "59.24%"
  """
  @spec number_to_percentage(BetterNumber.t(), Keyword.t() | map()) :: String.t()
  def number_to_percentage(number, options \\ @defaults)

  def number_to_percentage(number, options) do
    options = config(options)
    number = number_to_delimited(number, options)
    number <> "%"
  end

  defp config(
         %{
           precision: _,
           delimiter: _,
           separator: _,
           trim_zero_fraction: _
         } = options
       ) do
    options
  end

  defp config(options) do
    Map.merge(@defaults, Map.new(options))
  end
end
