defmodule Plaid.Item do
  @derive Jason.Encoder
  defstruct available_products: nil,
            billed_products: nil,
            consent_expiration_time: nil,
            error: nil,
            institution_id: nil,
            item_id: nil,
            webhook: nil

  @type t :: %__MODULE__{
          available_products: [String.t()],
          billed_products: [String.t()],
          consent_expiration_time: String.t(),
          error: Plaid.Item.Error.t(),
          institution_id: String.t(),
          item_id: String.t(),
          webhook: String.t()
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
            status: Integer.t(),
            suggested_action: String.t()
          }
  end

  def get_info(access_token) do
    params = %{access_token: access_token}

    Plaidical.Application.http_client().request(:post, "/item/get", params)
    |> case do
      {:ok, map} ->
        attrs = Map.get(map, "item")

        {:ok, struct(Plaid.Item, attrs)}

      {:error, message} ->
        {:error, message}
    end
  end

  def exchange_public_token(public_token) do
    params = %{public_token: public_token}

    Plaidical.Application.http_client().request(:post, "/item/public_token/exchange", params)
    |> case do
      {:ok, map} ->
        {:ok, struct(Plaid.Token, map)}

      {:error, message} ->
        {:error, message}
    end
  end
end
