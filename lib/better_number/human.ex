defmodule BetterNumber.Human do
  @moduledoc """
  Provides functions for converting numbers into more human readable strings.
  """

  import BetterNumber.Delimit, only: [number_to_delimited: 2]

  defmacrop sigil_d({:<<>>, _, [number]}, _modifiers) do
    int =
      number
      |> String.replace("_", "")
      |> String.to_integer()

    quote do: Decimal.new(unquote(int))
  end

  @doc """
  Formats and labels a number with the appropriate English word.

  ## Options

  * `:units` - List of units to convert to

  ## Examples

      iex> number_to_human(123)
      "123.00"
      iex> number_to_human(1234)
      "1.23 Thousand"
      iex> number_to_human(999001)
      "999.00 Thousand"
      iex> number_to_human(1234567)
      "1.23 Million"
      iex> number_to_human(1234567890)
      "1.23 Billion"
      iex> number_to_human(1234567890123)
      "1.23 Trillion"
      iex> number_to_human(1234567890123456)
      "1.23 Quadrillion"
      iex> number_to_human(1234567890123456789)
      "1,234.57 Quadrillion"
      iex> number_to_human(Decimal.new("5000.0"))
      "5.00 Thousand"
      iex> number_to_human(123, units: ["B", "KB", "MB", "GB", "TB", "PB"])
      "123.00 B"
      iex> number_to_human(1234, units: ["B", "KB", "MB", "GB", "TB", "PB"])
      "1.23 KB"
      iex> number_to_human(999001, units: ["B", "KB", "MB", "GB", "TB", "PB"])
      "999.00 KB"
      iex> number_to_human(1234567, units: ["B", "KB", "MB", "GB", "TB", "PB"])
      "1.23 MB"
      iex> number_to_human(1234567890, units: ["B", "KB", "MB", "GB", "TB", "PB"])
      "1.23 GB"
      iex> number_to_human(1234567890123, units: ["B", "KB", "MB", "GB", "TB", "PB"])
      "1.23 TB"
      iex> number_to_human(1234567890123456, units: ["B", "KB", "MB", "GB", "TB", "PB"])
      "1.23 PB"
      iex> number_to_human(1234567890123456789, units: ["B", "KB", "MB", "GB", "TB", "PB"])
      "1,234.57 PB"
  """
  @spec number_to_human(BetterNumber.t(), map() | Keyword.t()) :: String.t()
  def number_to_human(number, options \\ %{})

  def number_to_human(%Decimal{} = number, options) do
    %{units: units} = config(options)

    number
    |> Decimal.round(0, :down)
    |> Decimal.to_integer()
    |> case do
      x when x < 1_000 ->
        delimit(number, ~d(1), Enum.at(units, 0, ""), options)

      x when x < 1_000_000 ->
        delimit(number, ~d(1_000), Enum.at(units, 1, "Thousand"), options)

      x when x < 1_000_000_000 ->
        delimit(number, ~d(1_000_000), Enum.at(units, 2, "Million"), options)

      x when x < 1_000_000_000_000 ->
        delimit(number, ~d(1_000_000_000), Enum.at(units, 3, "Billion"), options)

      x when x < 1_000_000_000_000_000 ->
        delimit(number, ~d(1_000_000_000_000), Enum.at(units, 4, "Trillion"), options)

      _ ->
        delimit(number, ~d(1_000_000_000_000_000), Enum.at(units, 5, "Quadrillion"), options)
    end
  end

  def number_to_human(number, options) do
    number
    |> BetterNumber.Conversion.to_decimal()
    |> number_to_human(options)
  end

  @doc """
  Adds ordinal suffix (st, nd, rd or th) for the number

  ## Examples

      iex> BetterNumber.Human.number_to_ordinal(3)
      "3rd"
      iex> BetterNumber.Human.number_to_ordinal(1)
      "1st"
      iex> BetterNumber.Human.number_to_ordinal(46)
      "46th"
      iex> BetterNumber.Human.number_to_ordinal(442)
      "442nd"
      iex> BetterNumber.Human.number_to_ordinal(4001)
      "4001st"
  """
  def number_to_ordinal(number) when is_integer(number) do
    sfx = ~w(th st nd rd th th th th th th)

    Integer.to_string(number) <>
      case rem(number, 100) do
        11 -> "th"
        12 -> "th"
        13 -> "th"
        _ -> Enum.at(sfx, rem(number, 10))
      end
  end

  defp delimit(number, divisor, label, options) when label in ["", nil] do
    number
    |> Decimal.div(divisor)
    |> number_to_delimited(options)
  end

  defp delimit(number, divisor, label, options) do
    delimit(number, divisor, nil, options) <> " " <> label
  end

  defp config(units: units), do: %{units: units}
  defp config(%{units: _} = x), do: x
  defp config(_), do: %{units: []}
end
