defmodule Plaidical.DefaultClient do
  @default_headers [{"Content-Type", "application/json"}]

  @spec request(atom, binary, [tuple], map) :: {:ok, map} | {:error, binary}
  def request(:post, url, headers, body) do
    body =
      Map.merge(default_body(), body)
      |> Jason.encode!()

    url = "https://#{plaid_host()}#{url}"

    Finch.build(:post, url, @default_headers ++ headers, body)
    |> Finch.request(Plaidical.Charm)
    |> process_response()
  end

  @spec request(atom, binary, map) ::
          {:ok, Finch.Response.t()} | {:error, Mint.HTTPError.t() | Mint.TransportError.t()}
  def request(:post, url, body) do
    request(:post, url, [], body)
  end

  defp default_body do
    %{
      client_id: Application.get_env(:plaidical, :client_id),
      secret: Application.get_env(:plaidical, :secret)
    }
  end

  defp plaid_host do
    "#{Application.get_env(:plaidical, :env)}.plaid.com"
  end

  @spec process_response(
          {:ok, Finch.Response.t()}
          | {:error, Mint.HTTPError.t() | Mint.TransportError.t()}
        ) :: {:ok, map} | {:error, binary}
  defp process_response(response) do
    response
    |> case do
      {:ok, %Finch.Response{status: 200, body: response_body}} ->
        Jason.decode(response_body, keys: :atoms)

      {:error, error} ->
        {:error, Exception.message(error)}
    end
  end
end
