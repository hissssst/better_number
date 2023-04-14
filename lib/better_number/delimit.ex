defmodule BetterNumber.Delimit do
  @moduledoc """
  Provides functions to delimit numbers into strings.
  """

  alias BetterNumber.Conversion

  @defaults %{
    precision: 2,
    delimiter: ",",
    separator: ".",
    trim_zero_fraction: false
  }

  @doc """
  Formats a number into a string with grouped thousands using `delimiter`.

  ## Parameters

  * `number` - A float or integer to convert.

  * `options` - A keyword list of options. See the documentation of all
    available options below for more information.

  ## Options

  * `:precision` - The number of decimal places to include. Default: 2

  * `:delimiter` - The character to use to delimit the number by thousands.
    Default: ","

  * `:separator` - The character to use to separate the number from the decimal
    places. Default: "."

  * `:trim_zero_fraction` - Whether to trim the zeroes in fraction part of number.
    Default: "false"

  ## Examples

      iex> number_to_delimited(nil)
      nil

      iex> number_to_delimited(998.999)
      "999.00"

      iex> number_to_delimited(-234234.234)
      "-234,234.23"

      iex> number_to_delimited("998.999")
      "999.00"

      iex> number_to_delimited("-234234.234")
      "-234,234.23"

      iex> number_to_delimited(12345678)
      "12,345,678.00"

      iex> number_to_delimited(12345678.05)
      "12,345,678.05"

      iex> number_to_delimited(12345678, delimiter: ".")
      "12.345.678.00"

      iex> number_to_delimited(12345678, delimiter: ",")
      "12,345,678.00"

      iex> number_to_delimited(12345678.05, separator: " ")
      "12,345,678 05"

      iex> number_to_delimited(98765432.98, delimiter: " ", separator: ",")
      "98 765 432,98"

      iex> number_to_delimited(Decimal.from_float(9998.2))
      "9,998.20"

      iex> number_to_delimited "123456789555555555555555555555555"
      "123,456,789,555,555,555,555,555,555,555,555.00"

      iex> number_to_delimited Decimal.new "123456789555555555555555555555555"
      "123,456,789,555,555,555,555,555,555,555,555.00"

      iex> number_to_delimited(123456, trim_zero_fraction: true)
      "123,456"

      iex> number_to_delimited(123456.5, trim_zero_fraction: true)
      "123,456.50"
  """
  @spec number_to_delimited(nil, any()) :: nil
  @spec number_to_delimited(BetterNumber.t(), Keyword.t() | Map.t()) :: String.t()
  def number_to_delimited(number, options \\ @defaults)
  def number_to_delimited(nil, _options), do: nil

  def number_to_delimited(number, options) do
    float = Conversion.to_float(number)
    %{} = options = config(options)
    prefix = if float < 0, do: "-", else: ""

    delimited =
      case Conversion.to_integer(number) do
        {:ok, number} ->
          number = delimit_integer(number, options.delimiter)

          case options do
            %{precision: x, trim_zero_fraction: false} when x != 0 ->
              decimals = String.duplicate("0", options.precision)
              to_string(number) <> to_string(options.separator) <> decimals

            _ ->
              number
          end

        {:error, other} ->
          other
          |> to_string()
          |> Conversion.to_decimal()
          |> delimit_decimal(options)
      end

    delimited = String.Chars.to_string(delimited)
    prefix <> delimited
  end

  defp delimit_integer(number, delimiter) do
    number
    |> abs()
    |> Integer.to_charlist()
    |> :lists.reverse()
    |> delimit_integer(delimiter, [])
  end

  defp delimit_integer([a, b, c, d | tail], delimiter, acc) do
    delimit_integer([d | tail], delimiter, [delimiter, c, b, a | acc])
  end

  defp delimit_integer(list, _, acc) do
    :lists.reverse(list) ++ acc
  end

  @doc false
  def delimit_decimal(decimal, %{
        delimiter: delimiter,
        separator: separator,
        precision: precision,
        trim_zero_fraction: trim_zero_fraction
      }) do
    [number, decimals] =
      decimal
      |> Decimal.round(precision)
      |> Decimal.to_string(:normal)
      |> String.split(".")
      |> case do
        [number, decimals] -> [number, decimals]
        [number] -> [number, ""]
      end

    decimals = String.pad_trailing(decimals, precision, "0")

    integer =
      number
      |> String.to_integer()
      |> delimit_integer(delimiter)

    if trim_zero_fraction and decimals == String.duplicate("0", precision) do
      integer
    else
      to_string(integer) <> separator <> decimals
    end
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
