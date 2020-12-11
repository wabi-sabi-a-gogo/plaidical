defmodule Plaid.Webhook do
  defmodule VerificationKey do
    @derive Jason.Encoder
    defstruct alg: nil,
              created_at: nil,
              crv: nil,
              expired_at: nil,
              kid: nil,
              kty: nil,
              use: nil,
              x: nil,
              y: nil

    @type t :: %__MODULE__{
            alg: String.t(),
            created_at: String.t(),
            crv: String.t(),
            expired_at: String.t(),
            kid: String.t(),
            kty: String.t(),
            use: String.t(),
            x: String.t(),
            y: String.t()
          }
  end

  defmodule Verification do
    defstruct key: nil,
              request_id: nil

    @type t :: %__MODULE__{
            key: Plaid.Webhook.VerificationKey.t(),
            request_id: String.t()
          }
  end

  @spec get_verification_key(binary) :: {:ok, Plaid.Webhook.Verification.t()} | {:error, binary}
  def get_verification_key(key_id) do
    params = %{key_id: key_id}

    Plaidical.Application.http_client().request(:post, "/webhook_verification_key/get", params)
    |> case do
      {:ok, map} ->
        {:ok, struct(Plaid.Webhook.Verification, map)}

      {:error, message} ->
        {:error, message}
    end
  end
end
