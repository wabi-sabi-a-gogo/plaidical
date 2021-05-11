defmodule Plaidical.Requests.Balance do
  defmodule Options do
    @derive Jason.Encoder
    defstruct account_ids: nil,
              min_last_updated_datetime: nil

    @type t :: %__MODULE__{
            account_ids: [String.t()],
            min_last_updated_datetime: String.t()
          }
  end

  @spec get_balance(String.t(), String.t()) ::
          {:ok, Plaidical.Responses.Account.t()} | {:error, binary}
  def get_balance(access_token, account_id) do
    do_get_balances(%{access_token: access_token, options: %{account_ids: [account_id]}})
  end

  @spec get_balances(String.t()) :: {:ok, Plaidical.Responses.Account.t()} | {:error, binary}
  def get_balances(access_token) do
    do_get_balances(%{access_token: access_token})
  end

  @spec get_balances(String.t(), Plaidical.Requests.Balance.Options.t() | map) ::
          {:ok, Plaidical.Responses.Account.t()} | {:error, binary}
  def get_balances(access_token, %{options: options})
      when is_struct(options, Plaidical.Requests.Balance.Options) do
    %{options: Map.from_struct(options)}
    |> Map.merge(%{access_token: access_token})
    |> do_get_balances()
  end

  def get_balances(access_token, %{options: _} = options) do
    options
    |> Map.merge(%{access_token: access_token})
    |> do_get_balances()
  end

  def do_get_balances(params) do
    Plaidical.Application.http_client().request(:post, "/accounts/balance/get", params)
    |> case do
      {:ok, map} ->
        {:ok, struct(Plaidical.Responses.Account, map)}

      {:error, _} = error ->
        error
    end
  end
end
