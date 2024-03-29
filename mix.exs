defmodule Dapp.MixProject do
  use Mix.Project

  def project do
    [
      app: :dapp,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      preferred_cli_env: [quality: :test],
      aliases: aliases(),
      test_coverage: [
        summary: [
          threshold: 80
        ],
        ignore_modules: [
          Dapp.Mock.Audit,
          Dapp.Mock.Db,
          Dapp.Mock.DbState,
          Dapp.Mock.InviteRepo,
          Dapp.Mock.RoleRepo,
          Dapp.Mock.UserRepo,
          TestUtil
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Dapp, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.9.2"},
      {:postgrex, "~> 0.16.5"},
      {:plug_cowboy, "~> 2.6.1"},
      {:jason, "~> 1.4"},
      {:ecto_identifier, "~> 0.2.0"},
      {:algae, "~> 1.3.1"},
      {:hammox, "~> 0.7", only: :test},
      {:credo, "~> 1.7.0", only: [:dev, :test], runtime: false}
    ]
  end

  # Add mocks to path in test
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Helpful mix aliases
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      quality: ["test", "credo --strict"]
    ]
  end
end
