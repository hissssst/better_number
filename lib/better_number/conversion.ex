defprotocol BetterNumber.Conversion do
  @moduledoc "Converts values to formats consumable by BetterNumber."
  @fallback_to_any false

  @doc "Converts a value to a Float."
  def to_float(value)

  @doc "Converts a value to a Decimal."
  def to_decimal(value)

  @doc "Converts a value to an Integer in an Either style."
  def to_integer(value)
end

defimpl BetterNumber.Conversion, for: BitString do
  @moduledoc false

  def to_float(value) do
    case Float.parse(value) do
      {float, _} -> float
      :error -> raise ArgumentError, "could not convert #{inspect(value)} to float"
    end
  end

  def to_decimal(value) do
    string = String.Chars.to_string(value)
    Decimal.new(string)
  end

  def to_integer(value) do
    case Integer.parse(value) do
      {int, ""} -> {:ok, int}
      _ -> {:error, value}
    end
  end
end

defimpl BetterNumber.Conversion, for: Float do
  @moduledoc false

  def to_float(value), do: value

  def to_decimal(value) do
    Decimal.from_float(value)
  end

  def to_integer(value) do
    value
    |> to_decimal()
    |> BetterNumber.Conversion.Decimal.to_integer()
  end
end

defimpl BetterNumber.Conversion, for: Integer do
  @moduledoc false

  def to_float(value), do: value * 1.0

  def to_decimal(value) do
    Decimal.new(value)
  end

  def to_integer(value) do
    {:ok, value}
  end
end

defimpl BetterNumber.Conversion, for: Decimal do
  @moduledoc false

  def to_float(value) do
    {float, _} =
      value
      |> Decimal.to_string()
      |> Float.parse()

    float
  end

  def to_decimal(value) do
    value
  end

  def to_integer(value) do
    {:ok, Decimal.to_integer(value)}
  rescue
    _ ->
      {:error, value}
  end
end
