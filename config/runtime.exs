import Config

# When running a prod build, database URL and connection pool size from
# environment variables at runtime.
if config_env() == :prod do
  db_url =
    System.get_env("DB_URL") ||
      raise "DB_URL not defined. Example: ecto://USER:PASS@HOST/DATABASE"

  db_pool_size = System.get_env("DB_POOL_SIZE") || "10"

  network_prefix =
    System.get_env("NETWORK_PREFIX") ||
      raise "NETWORK_PREFIX not defined. Must be 'tp' or 'pb'"

  config :dapp, Dapp.Repo,
    url: db_url,
    pool_size: String.to_integer(db_pool_size)

  # Cloud deployment network prefix
  config :dapp,
    network_prefix: network_prefix
end
