defmodule Plaid.Webhook do
  alias JOSE.{JWK, JWT}

  @derive Jason.Encoder
  defstruct account_id: nil,
            asset_report_id: nil,
            canceled_investments_transactions: nil,
            consent_expiration_time: nil,
            error: nil,
            item_id: nil,
            new_holdings: nil,
            new_investments_transactions: nil,
            new_payment_status: nil,
            new_transactions: nil,
            new_webhook_url: nil,
            old_payment_status: nil,
            payment_id: nil,
            removed_transactions: nil,
            timestamp: nil,
            updated_holdings: nil,
            webhook_code: nil,
            webhook_type: nil

  @type t :: %__MODULE__{
          account_id: String.t(),
          asset_report_id: String.t(),
          canceled_investments_transactions: Integer.t(),
          consent_expiration_time: String.t(),
          error: String.t() | Plaid.Webhook.Error.t(),
          item_id: String.t(),
          new_holdings: Integer.t(),
          new_investments_transactions: Integer.t(),
          new_payment_status: String.t(),
          new_transactions: Integer.t(),
          new_webhook_url: String.t(),
          old_payment_status: String.t(),
          payment_id: String.t(),
          removed_transactions: [String.t()],
          timestamp: String.t(),
          updated_holdings: Integer.t(),
          webhook_code: String.t(),
          webhook_type: String.t()
        }

  defmodule Error do
    @derive Jason.Encoder
    defstruct causes: nil,
              display_message: nil,
              documentation_url: nil,
              error_code: nil,
              error_message: nil,
              error_type: nil,
              request_id: nil,
              status: nil,
              suggested_action: nil

    @type t :: %__MODULE__{
            causes: [String.t()],
            display_message: String.t(),
            documentation_url: String.t(),
            error_code: String.t(),
            error_message: String.t(),
            error_type: String.t(),
            request_id: String.t(),
            status: String.t(),
            suggested_action: String.t()
          }
  end

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

  @spec verify_webhook(binary, binary) :: {:ok, binary} | {:error, Atom.t()}
  def verify_webhook(verification_header, body) do
    with {:ok, key_id} <- get_key_id(verification_header),
         {:ok, key} <- get_verification_key(key_id),
         {:ok, claims} <- verify_claims(key, verification_header) do
      if hash(body) == claims["request_body_sha256"] do
        {:ok, body}
      else
        {:error, :invalid_body_match}
      end
    else
      _ ->
        {:error, :invalid_verification_header}
    end
  end

  @spec get_key_id(binary) :: {:ok, binary} | {:error, Atom.t()}
  defp get_key_id(verification_header) do
    case String.split(verification_header, ".") do
      [protected, _, _] ->
        with {:ok, decoded_header} <- Base.url_decode64(protected, padding: false),
             {:ok, header} <- Jason.decode(decoded_header) do
          %{"kid" => key_id} = header
          {:ok, key_id}
        else
          _ ->
            {:error, :malformed_verification_header}
        end

      _ ->
        {:error, :malformed_verification_header}
    end
  end

  @spec hash(String.t()) :: String.t()
  defp hash(content) do
    :crypto.hash(:sha256, content)
    |> Base.encode16()
    |> String.downcase()
  end

  defp verify_claims(%{key: key}, token) do
    key
    |> to_string_map()
    |> JWK.from()
    |> JWT.verify_strict(["ES256"], token)
    |> case do
      {true, %JWT{fields: claims}, _} ->
        {:ok, claims}

      _ ->
        {:error, :invalid_signature}
    end
  end

  defp to_string_map(map) do
    map |> Enum.reduce(%{}, fn ({k, v}, acc) -> Map.put(acc, Atom.to_string(k), v) end)
  end
end
