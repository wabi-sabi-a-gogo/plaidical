defmodule Plaid.Token do
  @derive Jason.Encoder
  defstruct access_token: nil,
            item_id: nil,
            request_id: nil

  @type t :: %__MODULE__{
    access_token: String.t(),
    item_id: String.t(),
    request_id: String.t()
  }
end
