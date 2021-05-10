defmodule Plaidical.Responses.Account do
  @derive Jason.Encoder
  defstruct accounts: nil,
            item: nil,
            request_id: nil

  @type t :: %__MODULE__{
          accounts: [Plaid.Account.t()],
          item: Plaid.Item.t(),
          request_id: String.t()
        }
end
