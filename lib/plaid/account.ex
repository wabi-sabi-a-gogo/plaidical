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
          balances: Plaid.Account.Balance.t(),
          mask: String.t(),
          name: String.t(),
          official_name: String.t(),
          subtype: String.t(),
          type: String.t()
        }

  defmodule Balance do
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

    defmodule Options do
      @derive Jason.Encoder
      defstruct account_ids: nil

      @type t :: %__MODULE__{
              account_ids: [String.t()]
            }
    end
  end

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

  @spec get_balance(binary, Plaid.Balance.Options | map) ::
          {:ok, [Plaid.Account.t()]} | {:error, binary}
  def get_balance(access_token, %{options: options})
      when is_struct(options, Plaid.Account.Balance.Options) do
    get_balance(access_token, %{options: Map.from_struct(options)})
  end

  def get_balance(access_token, %{options: _} = options) do
    options
    |> Map.merge(%{access_token: access_token})
    |> do_get_balance()
  end

  def get_balance(access_token, options) when is_struct(options, Plaid.Account.Balance.Options) do
    get_balance(access_token, %{options: Map.from_struct(options)})
  end

  def get_balance(access_token, options) do
    get_balance(access_token, %{options: options})
  end

  defp do_get_balance(params) do
    Plaidical.Application.http_client().request(:post, "/accounts/balance/get", params)
    |> case do
      {:ok, map} ->
        {:ok, struct(Plaid.Link, map)}

      {:error, message} ->
        {:error, message}
    end
  end
end
