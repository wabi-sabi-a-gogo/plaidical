defmodule Plaid.Webhook do
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
end
