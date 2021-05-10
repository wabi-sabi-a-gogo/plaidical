defmodule Plaid.Transaction do
  @derive Jason.Encoder
  defstruct account_id: nil,
            amount: nil,
            iso_currency_code: nil,
            unofficial_currency_code: nil,
            category: nil,
            category_id: nil,
            date: nil,
            datetime: nil,
            authorized_date: nil,
            authorized_datetime: nil,
            location: nil,
            name: nil,
            merchant_name: nil,
            payment_meta: nil,
            payment_channel: nil,
            pending: nil,
            pending_transaction_id: nil,
            account_owner: nil,
            transaction_id: nil,
            transaction_code: nil,
            transaction_type: nil

  @type t :: %__MODULE__{
          account_id: String.t(),
          amount: Decimal.t(),
          iso_currency_code: String.t(),
          unofficial_currency_code: String.t(),
          category: [String.t()],
          category_id: String.t(),
          date: String.t(),
          datetime: String.t(),
          authorized_date: String.t(),
          authorized_datetime: String.t(),
          location: Plaid.Location.t(),
          name: String.t(),
          merchant_name: String.t(),
          payment_meta: Plaid.PaymentMeta.t(),
          payment_channel: String.t(),
          pending: Boolean.t(),
          pending_transaction_id: String.t(),
          account_owner: String.t(),
          transaction_id: String.t(),
          transaction_code: String.t(),
          transaction_type: String.t()
        }

  defmodule Options do
    @derive Jason.Encoder
    defstruct account_ids: nil,
              count: nil,
              offset: nil

    @type t :: %__MODULE__{
            account_ids: [String.t()],
            count: Integer.t(),
            offset: Integer.t()
          }
  end

  defmodule Response do
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

  @spec get_transactions(binary, Plaid.Balance.Options | map) ::
          {:ok, Plaid.Transaction.Response.t()} | {:error, binary}
  def get_transactions(access_token, %{options: options})
      when is_struct(options, Plaid.Transaction.Options) do
    get_transactions(access_token, %{options: Map.from_struct(options)})
  end

  def get_transactions(access_token, %{options: _} = options) do
    params =
      options
      |> Map.merge(%{access_token: access_token})

    Plaidical.Application.http_client().request(:post, "/transactions/get", params)
    |> case do
      {:ok, map} ->
        {:ok, struct(Plaid.Transaction.Response, map)}

      {:error, _} = error ->
        error
    end
  end
end
