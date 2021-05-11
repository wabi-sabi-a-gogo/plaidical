defmodule Plaidical.Requests.Account do
  defmodule Options do
    @derive Jason.Encoder
    defstruct account_ids: nil

    @type t :: %__MODULE__{
            account_ids: [String.t()]
          }

    @spec get_account(String.t(), String.t()) ::
            {:ok, Plaidical.Responses.Account.t()} | {:error, binary}
    def get_account(access_token, account_id) do
      do_get_accounts(%{access_token: access_token, options: %{account_ids: [account_id]}})
    end

    @spec get_accounts(String.t()) :: {:ok, Plaidical.Responses.Account.t()} | {:error, binary}
    def get_accounts(access_token) do
      do_get_accounts(%{access_token: access_token})
    end

    @spec get_accounts(String.t(), Plaidical.Requests.Account.Options.t() | map) ::
            {:ok, Plaidical.Responses.Account.t()} | {:error, binary}
    def get_accounts(access_token, %{options: options})
        when is_struct(options, Plaidical.Requests.Account.Options) do
      %{options: Map.from_struct(options)}
      |> Map.merge(%{access_token: access_token})
      |> do_get_accounts()
    end

    def get_accounts(access_token, %{options: _} = options) do
      options
      |> Map.merge(%{access_token: access_token})
      |> do_get_accounts()
    end

    @spec do_get_accounts(map) :: {:ok, Plaidical.Responses.Account.t()} | {:error, binary}
    def do_get_accounts(params) do
      Plaidical.Application.http_client().request(:post, "/accounts/get", params)
      |> case do
        {:ok, map} ->
          {:ok, struct(Plaidical.Responses.Account, map)}

        {:error, _} = error ->
          error
      end
    end
  end
end
