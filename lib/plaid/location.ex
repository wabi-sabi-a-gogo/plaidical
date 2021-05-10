defmodule Plaid.Location do
  defstruct address: nil,
            city: nil,
            region: nil,
            postal_code: nil,
            country: nil,
            lat: nil,
            lon: nil,
            store_number: nil

  @type t :: %__MODULE__{
          address: String.t(),
          city: String.t(),
          region: String.t(),
          postal_code: String.t(),
          country: String.t(),
          lat: Decimal.t(),
          lon: Decimal.t(),
          store_number: String.t()
        }
end
