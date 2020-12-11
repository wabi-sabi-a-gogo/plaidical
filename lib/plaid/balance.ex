defmodule Plaid.Balance do
  @derive Jason.Encoder
  defstruct available: nil,
            current: nil,
            iso_currency_code: nil,
            limit: nil,
            unofficial_currency_code: nil

  @type t :: %__MODULE__{
          available: Decimal.t(),
          current: Decimal.t(),
          iso_currency_code: String.t(),
          limit: Decimal.t(),
          unofficial_currency_code: String.t()
        }
end
