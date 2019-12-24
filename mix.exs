defmodule Goldfish.MixProject do
  use Mix.Project

  @description "Goldfish is a database session store."
  @version "0.1.0"

  def project do
    [
      app: :goldfish,
      version: @version,
      description: @description,
      elixir: "~> 1.8",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/arghmeleg/goldfish"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    %{
      maintainers: ["Steve DeGele"],
      licenses: ["MIT"],
      files: [
        "lib",
        "test",
        "mix.exs",
        "README.md",
        "LICENSE",
      ],
      links: %{
        "GitHub" => "https://github.com/arghmeleg/goldfish"
      }
    }
  end
end
