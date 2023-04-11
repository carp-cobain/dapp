import Config

# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :dapp, Dapp.Data.Repo,
  username: "postgres",
  password: "password1",
  hostname: "localhost",
  database: "dapp_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 8

# Print only warnings and errors during test
config :logger, level: :warn