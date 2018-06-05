defmodule Scraper.MixProject do
  use Mix.Project

  def project do
    [
      app: :scraper,
      version: "0.1.0",
      elixir: "~> 1.5",
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
      {:scrape, "~> 2.0", [override: true, path: "../elixir-scrape"]},
      {:jason, "~> 1.0"},
      {:csv, "~> 1.2.3"},
      {:hound, "~> 1.0"},
      {:floki, "~> 0.20.0"},
      {:html5ever, "~> 0.5.0", [override: true, path: "../html5ever_elixir"]},
    ]
  end
end
