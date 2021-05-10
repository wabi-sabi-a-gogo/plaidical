defmodule Plaidical.Requests.Transaction do
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

  @spec get_transactions(binary, Plaidical.Requests.Transaction.Options | map) ::
          {:ok, Plaidical.Responses.Transaction.t()} | {:error, binary}
  def get_transactions(access_token, %{options: options})
      when is_struct(options, Plaidical.Response.Transaction.Options) do
    get_transactions(access_token, %{options: Map.from_struct(options)})
  end

  def get_transactions(access_token, %{options: _} = options) do
    params = Map.merge(options, %{access_token: access_token})

    Plaidical.Application.http_client().request(:post, "/transactions/get", params)
    |> case do
      {:ok, map} ->
        {:ok, struct(Plaidical.Responses.Transaction, map)}

      {:error, _} = error ->
        error
    end
  end
end
