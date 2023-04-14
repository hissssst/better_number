defmodule BetterNumber do
  @moduledoc """
  `BetterNumber` provides functions to convert numbers into a variety of different formats.
  """

  @type t :: number() | Decimal.t()

  @doc false
  defmacro __using__(_) do
    quote do
      import BetterNumber.Currency
      import BetterNumber.Delimit
      import BetterNumber.Phone
      import BetterNumber.Percentage
      import BetterNumber.Human
    end
  end

  @doc """
  Converts number to currency
  """
  defdelegate to_currency(number, opts \\ %{}),
    to: BetterNumber.Currency,
    as: :number_to_currency

  @doc """
  Delimits number with seprator
  """
  defdelegate to_delimited(number, opts \\ %{}),
    to: BetterNumber.Delimit,
    as: :number_to_delimited

  @doc """
  Converts number to phone number format
  """
  defdelegate to_phone(number, opts \\ %{}),
    to: BetterNumber.Phone,
    as: :number_to_phone

  @doc """
  Converts number to percentage
  """
  defdelegate to_percentage(number, opts \\ %{}),
    to: BetterNumber.Percentage,
    as: :number_to_percentage

  @doc """
  Converts number to specified units
  """
  defdelegate to_human(number, opts \\ %{}),
    to: BetterNumber.Human,
    as: :number_to_human

  @doc """
  Converts number to english ordinal.
  """
  defdelegate to_ordinal(number),
    to: BetterNumber.Human,
    as: :number_to_ordinal
end
