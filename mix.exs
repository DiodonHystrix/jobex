defmodule Jobex.MixProject do
  use Mix.Project

  def project do
    [
      app: :jobex,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      name: "Jobex",
      source_url: "https://github.com/DiodonHystrix/jobex",
      homepage_url: "https://github.com/DiodonHystrix/jobex",
      docs: [
        extras: ["README.md"]
      ],
      description: "Elixir Background Job Abstraction Layer",
      deps: deps(),
      package: package()
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
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Adam Zapaśnik"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/DiodonHystrix/jobex"}
    ]
  end
end
