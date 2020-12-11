defmodule Plaid.Account do
  @derive Jason.Encoder
  defstruct account_id: nil,
            balances: nil,
            mask: nil,
            name: nil,
            official_name: nil,
            subtype: nil,
            type: nil

  @type t :: %__MODULE__{
          account_id: String.t(),
          balances: Plaid.Balance.t(),
          mask: String.t(),
          name: String.t(),
          official_name: String.t(),
          subtype: String.t(),
          type: String.t()
        }

  def get_account(account_id, access_token) do
    params = %{
      access_token: access_token,
      options: %{
        account_ids: [account_id]
      }
    }

    Plaidical.Application.http_client().request(:post, "/accounts/get", params)
    |> case do
      {:ok, map} ->
        [account_attrs | _] = Map.get(map, "accounts")

        {:ok, struct(Plaid.Account, account_attrs)}

      {:error, message} ->
        {:error, message}
    end
  end
end
