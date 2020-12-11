defmodule Plaid.Link do
  @derive Jason.Encoder
  defstruct link_token: nil,
            expiration: nil,
            request_id: nil

  @type t :: %__MODULE__{
          link_token: String.t(),
          expiration: String.t(),
          request_id: String.t()
        }

  defmodule Params do
    # ALSO: deposit_switch, payment_initiation
    @derive Jason.Encoder
    defstruct access_token: nil,
              account_filters: nil,
              client_name: nil,
              country_codes: nil,
              language: nil,
              link_customization_name: nil,
              products: nil,
              redirect_uri: nil,
              user: nil,
              webhook: nil

    @type t :: %__MODULE__{
            access_token: String.t(),
            account_filters: Plaid.Link.Params.AccountFilters.t(),
            client_name: String.t(),
            country_codes: [String.t()],
            language: String.t(),
            link_customization_name: String.t(),
            products: [String.t()],
            redirect_uri: String.t(),
            user: Plaid.Link.Params.User.t(),
            webhook: String.t()
          }

    defmodule AccountFilters do
      @derive Jason.Encoder
      defstruct depository: nil,
                credit: nil,
                loan: nil,
                investment: nil

      @type t :: %__MODULE__{
              depository: [String.t()],
              credit: [String.t()],
              loan: [String.t()],
              investment: [String.t()]
            }
    end

    defmodule User do
      @derive Jason.Encoder
      defstruct client_user_id: nil,
                email_address: nil,
                email_address_verified_time: nil,
                legal_name: nil,
                phone_number: nil,
                phone_number_verified_time: nil

      @type t :: %__MODULE__{
              client_user_id: String.t(),
              email_address: String.t(),
              email_address_verified_time: String.t(),
              legal_name: String.t(),
              phone_number: String.t(),
              phone_number_verified_time: String.t()
            }
    end
  end

  @spec create_link_token(Plaid.Link.Params.t()) :: {:ok, Plaid.Link.t()} | {:error, binary}
  def create_link_token(params) do
    params = Map.from_struct(params)

    Plaidical.Application.http_client().request(:post, "/link/token/create", params)
    |> case do
      {:ok, map} ->
        {:ok, struct(Plaid.Link, map)}

      {:error, message} ->
        {:error, message}
    end
  end
end
