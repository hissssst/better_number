defmodule BetterNumber do
  @moduledoc """
  `BetterNumber` provides functions to convert numbers into a variety of different
  formats. Ultimately, it aims to be a partial clone of
  [ActionView::Helpers::BetterNumberHelper](http://api.rubyonrails.org/classes/ActionView/Helpers/BetterNumberHelper.html)
  from Rails.

  If you want to import all of the functions provided by `BetterNumber`, simply `use`
  it in your module:

      defmodule MyModule do
        use BetterNumber
      end

  More likely, you'll want to import the functions you want from one of
  `BetterNumber`'s submodules.

      defmodule MyModule do
        import BetterNumber.Currency
      end

  ## Configuration

  Some of `BetterNumber`'s behavior can be configured through Mix. Each submodule
  contains documentation on how to configure it.
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

  defdelegate to_currency(number, opts \\ %{}),
    to: BetterNumber.Currency,
    as: :number_to_currency

  defdelegate to_delimited(number, opts \\ %{}),
    to: BetterNumber.Delimit,
    as: :number_to_delimited

  defdelegate to_phone(number, opts \\ %{}),
    to: BetterNumber.Phone,
    as: :number_to_phone

  defdelegate to_percentage(number, opts \\ %{}),
    to: BetterNumber.Percentage,
    as: :number_to_percentage

  defdelegate to_human(number, opts \\ %{}),
    to: BetterNumber.Human,
    as: :number_to_human

  defdelegate to_ordinal(number),
    to: BetterNumber.Human,
    as: :number_to_ordinal
end
