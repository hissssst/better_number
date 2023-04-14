defmodule BetterNumber.SI do
  @moduledoc """
  Provides functions for formatting numbers using SI notation.
  """

  @prefixes [
    # yotta
    {8, "Y"},
    # zetta
    {7, "Z"},
    # exa
    {6, "E"},
    # peta
    {5, "P"},
    # tera
    {4, "T"},
    # giga
    {3, "G"},
    # mega
    {2, "M"},
    # kilo
    {1, "k"},
    {0, ""},
    # milli
    {-1, "m"},
    # micro
    {-2, "µ"},
    # nano
    {-3, "n"},
    # pico
    {-4, "p"},
    # femto
    {-5, "f"},
    # atto
    {-6, "a"},
    # zepto
    {-7, "z"},
    # ycoto
    {-8, "y"}
  ]

  @defaults %{
    base: 1000,
    separator: "",
    unit: "",
    precision: 2,
    trim: false
  }

  @doc """
  Format numbers using SI notation

  ## Parameters

  * `number` - A value to convert. Can be any value that implements
    `BetterNumber.Conversion.to_float/1`.

  * `options` - A keyword list of options. See the documentation below for all
    available options.

  ## Options

  * `:base` - Use 1024 if you wish to format bytes.  Default: 1000

  * `:separator` - The string to place between the scaled number and the `prefix
    + unit`. Perhaps you want a space here. Default: ""

  * `:unit` - The unit of measurement, e.g. "M" for Meters. Default: ""

  * `:precision` - The number of decimal places to include. Default: 2

  * `:trim` - Trim trailing zeros. Default: false

  ## Examples

      iex> BetterNumber.SI.number_to_si(1210000000, unit: "W")
      "1.21GW"

      iex> BetterNumber.SI.number_to_si(1210000000, unit: "W", precision: 1)
      "1.2GW"

      iex> BetterNumber.SI.number_to_si(1210000000, unit: "W", precision: 3, separator: " ")
      "1.210 GW"

      iex> BetterNumber.SI.number_to_si(1210000000, unit: "W", precision: 5, trim: true)
      "1.21GW"

      iex> BetterNumber.SI.number_to_si(1210000000)
      "1.21G"

      iex> BetterNumber.SI.number_to_si(Decimal.new(1210000000))
      "1.21G"
  """
  @spec number_to_si(BetterNumber.t(), Map.t() | Keyword.t()) :: String.t()
  def number_to_si(number, options \\ @defaults)

  def number_to_si(number, options) when is_number(number) do
    options = config(options)
    exp = compute_exponent(number, options.base)
    prefix = exponent_to_prefix(exp)
    scaled_number = number / :math.pow(options.base, exp)
    display_number = :erlang.float_to_binary(scaled_number, [{:decimals, options.precision}])
    final_number = if options.trim, do: trim(display_number), else: display_number
    final_number <> options.separator <> prefix <> options.unit
  end

  def number_to_si(number, options) do
    number
    |> BetterNumber.Conversion.to_float()
    |> number_to_si(options)
  end

  defp compute_exponent(number, _) when number == 0, do: 0

  defp compute_exponent(number, base) do
    (:math.log(abs(number)) / :math.log(base))
    |> Float.floor()
    |> trunc()
    |> max(-8)
    |> min(8)
  end

  @doc false
  for {num, text} = _p <- @prefixes do
    def exponent_to_prefix(unquote(num)), do: unquote(text)
  end

  defp trim(display_number) do
    if String.contains?(display_number, ".") do
      display_number
      |> String.trim_trailing("0")
      |> String.trim_trailing(".")
    else
      display_number
    end
  end

  defp config(
         %{
           base: _,
           separator: _,
           unit: _,
           precision: _,
           trim: _
         } = options
       ) do
    options
  end

  defp config(options) do
    Map.merge(@defaults, Map.new(options))
  end
end
