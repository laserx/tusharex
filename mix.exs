defmodule Tusharex.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :tusharex,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      description: description(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      applications: [:httpoison],
      mod: {Tusharex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:jason, "~> 1.1"}
    ]
  end

  defp description do
    "Tushare Pro elixir SDK"
  end
end
