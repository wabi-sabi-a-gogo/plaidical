defmodule Plaidical.MixProject do
  use Mix.Project

  def project do
    [
      app: :plaidical,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:finch, "~> 0.6.0"},
      {:jose, "~> 1.11"}
    ]
  end
end
