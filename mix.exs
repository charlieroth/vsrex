defmodule Vsrex.MixProject do
  use Mix.Project

  def project do
    [
      app: :vsrex,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Vsrex",
      source_url: "https://github.com/charlieroth/vsrex",
      docs: [
        main: "Vsrex",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Vsrex.Application, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
    ]
  end
end
