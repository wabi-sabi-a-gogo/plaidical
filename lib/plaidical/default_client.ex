defmodule Plaidical.DefaultClient do
  @default_body %{
    client_id: Application.get_env(:plaidical, :plaid)[:client_id],
    secret: Application.get_env(:plaidical, :plaid)[:secret]
  }

  @default_headers [{"Content-Type", "application/json"}]

  @plaid_host "#{Application.get_env(:plaidical, :plaid)[:env]}.plaid.com"

  # Finch.start_link(name: Plaidical.Charm)

  @spec request(atom, binary, [tuple], map) ::
          {:ok, Finch.Response.t()} | {:error, Mint.HTTPError.t() | Mint.TransportError.t()}
  def request(:post, url, headers, body) do
    body =
      Map.merge(@default_body, body)
      |> Jason.encode!()

    IO.inspect body, label: "BODY"

    url = "https://#{@plaid_host}#{url}"

    IO.inspect url, label: "URL"

    Finch.build(:post, url, @default_headers ++ headers, body)
    |> Finch.request(Plaidical.Charm)
  end

  @spec request(atom, binary, map) ::
          {:ok, Finch.Response.t()} | {:error, Mint.HTTPError.t() | Mint.TransportError.t()}
  def request(:post, url, body) do
    request(:post, url, [], body)
  end
end
