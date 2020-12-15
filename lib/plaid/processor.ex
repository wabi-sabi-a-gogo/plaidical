defmodule Plaid.Processor do
  defmodule Token do
    defstruct processor_token: nil,
              request_id: nil

    @type t :: %__MODULE__{
      processor_token: String.t(),
      request_id: String.t()
    }
  end

  @spec get_processor_token(Keyword.t()) :: {:ok, Plaid.Processor.Token.t()} | {:error, Atom.t()}
  def get_processor_token([processor: _, access_token: _, account_id: _] = params) do
    params = Enum.into(params, %{})

    Plaidical.Application.http_client().request(:post, "/processor/token/create", params)
    |> case do
      {:ok, map} ->
        {:ok, struct(Plaid.Processor.Token, map)}

      {:error, message} ->
        {:error, message}
    end
  end

  def get_processor_token(_), do: {:error, :invalid_or_missing_params}
end
