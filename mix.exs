defmodule Number.Mixfile do
  use Mix.Project

  @source_url "https://github.com/hissssst/better_number"
  @version "1.0.0"

  def project do
    [
      app: :better_number,
      description: description(),
      version: @version,
      elixir: "~> 1.0",
      build_embedded: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
      ],
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end


  def application do
    []
  end

  defp deps do
    [
      {:decimal, "~> 2.0"},

      {:credo, "~> 1.7", only: :dev},
      {:excoveralls, ">= 0.0.0", only: :test},
      {:dialyxir, "~> 1.1", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev, :test]},
      {:inch_ex, ">= 0.0.0", only: [:dev, :test]}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      extras: ["CHANGELOG.md", "README.md"]
    ]
  end

  defp description do
    "Convert numbers to various string formats, such as currency"
  end

  defp package do
    [
      description: description(),
      licenses: ["MIT"],
      files: ["lib", "mix.exs", "README.md", "CHANGELOG.md", "LICENSE"],
      maintainers: ["Georgy Sychev"],
      links: %{
        Changelog: "https://hexdocs.pm/better_number/changelog.html",
        GitHub: @source_url
      }
    ]
  end
end
