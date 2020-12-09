defmodule Plaidical.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Finch, name: Plaidical.Charm}
    ]

    opts = [strategy: :one_for_one, name: Plaidical.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def http_client, do: Application.get_env(:plaidical, :http_client)
end
