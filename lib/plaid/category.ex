defmodule Plaid.Category do
  @derive Jason.Encoder
  defstruct category_id: nil,
            group: nil,
            hierarchy: nil

  @type t :: %__MODULE__{
          category_id: String.t(),
          group: String.t(),
          hierarchy: [String.t()]
        }

  defmodule Response do
    @derive Jason.Encoder
    defstruct categories: nil,
              request_id: nil

    @type t :: %__MODULE__{
            categories: [Plaid.Category.t()],
            request_id: String.t()
          }
  end

  def get_categories(access_token) do
    params = %{access_token: access_token}

    Plaidical.Application.http_client().request(:post, "/categories/get", params)
    |> case do
      {:ok, map} ->
        {:ok, struct(Plaid.Category.Response, map)}

      {:error, _} = error ->
        error
    end
  end
end
