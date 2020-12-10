use Mix.Config

config :plaidical,
  http_client: Plaidical.DefaultClient,
  env: System.get_env("PLAID_ENV"),
  client_id: System.get_env("PLAID_CLIENT_ID"),
  secret: System.get_env("PLAID_SECRET"),
  client_name: System.get_env("PLAID_CLIENT_NAME")
