defmodule BetterNumber.Phone do
  @moduledoc """
  Provides functions to convert numbers into formatted phone number strings.
  """

  defguardp is_blank(value) when value in [" ", "", nil]

  @defaults %{
    area_code: false,
    delimiter: "-",
    extension: nil,
    country_code: nil
  }

  @doc """
  Formats a number into a US phone number (e.g., (555) 123-9876). You can
  customize the format in the options list.

  ## Parameters

  * `number` - A float or integer to convert.

  * `options` - A keyword list of options. See the documentation of all
    available options below for more information.

  ## Options

  * `:area_code` - Adds parentheses around the area code if `true`.

  * `:delimiter` - Specifies the delimiter to use (defaults to “-”).

  * `:extension` - Specifies an extension to add to the end of the generated number.

  * `:country_code` - Sets the country code for the phone number.

  ## Examples

      iex> BetterNumber.Phone.number_to_phone(nil)
      nil

      iex> BetterNumber.Phone.number_to_phone(5551234)
      "555-1234"

      iex> BetterNumber.Phone.number_to_phone("5551234")
      "555-1234"

      iex> BetterNumber.Phone.number_to_phone(1235551234)
      "123-555-1234"

      iex> BetterNumber.Phone.number_to_phone(1235551234, area_code: true)
      "(123) 555-1234"

      iex> BetterNumber.Phone.number_to_phone(1235551234, delimiter: " ")
      "123 555 1234"

      iex> BetterNumber.Phone.number_to_phone(1235551234, area_code: true, extension: 555)
      "(123) 555-1234 x 555"

      iex> BetterNumber.Phone.number_to_phone(1235551234, area_code: true, extension: 555, country_code: 1)
      "+1 (123) 555-1234 x 555"

      iex> BetterNumber.Phone.number_to_phone(1235551234, country_code: 1)
      "+1-123-555-1234"

      iex> BetterNumber.Phone.number_to_phone("123a456")
      "123a456"

      iex> BetterNumber.Phone.number_to_phone(1235551234, country_code: 1, extension: 1343, delimiter: ".")
      "+1.123.555.1234 x 1343"
  """
  @spec number_to_phone(BetterNumber.t(), Keyword.t() | map()) :: String.t()
  def number_to_phone(number, options \\ @defaults)
  def number_to_phone(nil, _options), do: nil

  def number_to_phone(number, options) do
    %{
      delimiter: delimiter,
      area_code: area_code,
      country_code: country_code,
      extension: extension
    } = config(options)

    number
    |> to_string()
    |> delimit_number(delimiter, area_code)
    |> prepend_country_code(country_code, delimiter, area_code)
    |> append_extension(extension)
  end

  defp delimit_number(number, delimiter, false) do
    leading_delimiter = Regex.compile!("^#{Regex.escape(delimiter)}")

    number
    |> String.replace(~r/(\d{0,3})(\d{3})(\d{4})$/, "\\1#{delimiter}\\2#{delimiter}\\3")
    |> String.replace(leading_delimiter, "")
  end

  defp delimit_number(number, delimiter, true) do
    String.replace(number, ~r/(\d{1,3})(\d{3})(\d{4}$)/, "(\\1) \\2#{delimiter}\\3")
  end

  defp prepend_country_code(number, country_code, _, _) when is_blank(country_code), do: number

  defp prepend_country_code(number, country_code, delimiter, area_code) do
    if area_code do
      "+#{country_code} #{number}"
    else
      "+#{country_code}#{delimiter}#{number}"
    end
  end

  defp append_extension(number, extension) when is_blank(extension), do: number

  defp append_extension(number, extension) do
    "#{number} x #{extension}"
  end

  defp config(
         %{
           area_code: _,
           delimiter: _,
           extension: _,
           country_code: _
         } = options
       ) do
    options
  end

  defp config(options) do
    Map.merge(@defaults, Map.new(options))
  end
end
