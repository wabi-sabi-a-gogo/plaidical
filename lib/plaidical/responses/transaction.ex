defmodule Plaidical.Responses.Transaction do
  @derive Jason.Encoder
  defstruct accounts: nil,
            transactions: nil,
            item: nil,
            total_transactions: nil,
            request_id: nil

  @type t :: %__MODULE__{
          accounts: [Plaid.Account.t()],
          transactions: [Plaid.Transaction.t()],
          item: Plaid.Item.t(),
          total_transactions: Integer.t(),
          request_id: String.t()
        }
end
