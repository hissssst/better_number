defmodule BetterNumber.Currency do
  @moduledoc """
  Provides functions for converting numbers into formatted currency strings.
  """

  alias BetterNumber.Conversion
  import BetterNumber.Delimit, only: [number_to_delimited: 2]

  @doc ~S[
  Converts a number to a formatted currency string.

  ## Parameters

  * `number` - A float or integer to convert.

  * `options` - A keyword list of options. See the documentation of all
    available options below for more information.

  ## Options

  * `:unit` - The currency symbol to use. Default: "$"

  * `:precision` - The number of decimal places to include. Default: 2

  * `:delimiter` - The character to use to delimit the number by thousands.
    Default: ","

  * `:separator` - The character to use to separate the number from the decimal
    places. Default: "."

  * `:format` - Function which converts number and unit to the final string.
    Default: `fn unit, number -> unit <> number end`

  * `:negative_format` - The format of the number when it is negative. Uses the
    same formatting placeholders as the `:format` option. Default value is derived
    from `:format` option just with "-" prefix.

  * `:trim_zero_fraction` - Whether to trim the zeroes in fraction part of number.
    Default: "false"

  ## Examples

      iex> number_to_currency(nil)
      nil

      iex> number_to_currency(1000)
      "$1,000.00"

      iex> number_to_currency(1000, unit: "£")
      "£1,000.00"

      iex> number_to_currency(-1000)
      "-$1,000.00"

      iex> number_to_currency(-234234.23)
      "-$234,234.23"

      iex> number_to_currency(1234567890.50)
      "$1,234,567,890.50"

      iex> number_to_currency(1234567890.506)
      "$1,234,567,890.51"

      iex> number_to_currency(1234567890.506, precision: 3)
      "$1,234,567,890.506"

      iex> number_to_currency(-1234567890.50, negative_format: &"(#{&1}#{&2})")
      "($1,234,567,890.50)"

      iex> number_to_currency(1234567890.50, unit: "R$", separator: ",", delimiter: "")
      "R$1234567890,50"

      iex> number_to_currency(1234567890.50, unit: "R$", separator: ",", delimiter: "", format: &"#{&2} #{&1}")
      "1234567890,50 R$"

      iex> number_to_currency(Decimal.from_float(50.0))
      "$50.00"

      iex> number_to_currency(Decimal.from_float(-100.01))
      "-$100.01"

      iex> number_to_currency(Decimal.from_float(-100.01), unit: "$", separator: ",", delimiter: ".", negative_format: &"- #{&1} #{&2}")
      "- $ 100,01"
  ]
  @spec number_to_currency(BetterNumber.t(), Keyword.t() | Map.t()) :: String.t()
  def number_to_currency(number, options \\ [])
  def number_to_currency(nil, _options), do: nil

  def number_to_currency(number, options) do
    %{unit: unit} = options = config(options)
    {number, format} = get_format(number, options)
    number = number_to_delimited(number, options)

    format.(unit, number)
  end

  @zero_decimal Decimal.new(0)

  defp get_format(number, %{} = options) do
    number = Conversion.to_decimal(number)

    number
    |> Decimal.compare(@zero_decimal)
    |> case do
      :lt -> {Decimal.abs(number), options.negative_format}
      _ -> {number, options.format}
    end
  end

  defp config(
         %{
           unit: _,
           precision: _,
           delimiter: _,
           separator: _,
           format: _,
           trim_zero_fraction: _,
           negative_format: _
         } = options
       ) do
    options
  end

  defp config(options) do
    %{
      unit: "$",
      precision: 2,
      delimiter: ",",
      separator: ".",
      format: fn unit, number -> unit <> number end,
      trim_zero_fraction: false
    }
    |> Map.merge(Map.new(options))
    |> case do
      %{negative_format: _} = options ->
        options

      %{format: format} = options ->
        Map.put(options, :negative_format, fn unit, number -> "-" <> format.(unit, number) end)
    end
  end
end
