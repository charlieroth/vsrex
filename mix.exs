defmodule Vsrex.MixProject do
  use Mix.Project

  def project do
    [
      app: :vsrex,
      version: "0.0.1",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      source_url: "https://github.com/charlieroth/vsrex"
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
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp docs() do
    [
      main: "Vsrex",
      extras: ["README.md"]
    ]
  end

  defp description() do
    "Library to enable the creation of distributed systems via the Viewstamped Replication Protocol."
  end

  defp package() do
    [
      name: "vsrex",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/charlieroth/vsrex"}
    ]
  end
end
