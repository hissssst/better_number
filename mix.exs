defmodule Number.Mixfile do
  use Mix.Project

  @source_url "https://github.com/hissssst/number"
  @version "1.0.0"

  def project do
    [
      app: :number,
      description: "Convert numbers to various string formats, such as currency",
      version: @version,
      elixir: "~> 1.0",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.travis": :test
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
      {:excoveralls, ">= 0.0.0", only: :test},
      {:credo, "~> 1.7", only: :dev},
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

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "CHANGELOG.md", "LICENSE"],
      maintainers: ["Hissssst"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/better_number/changelog.html",
        "GitHub" => @source_url
      }
    ]
  end
end
