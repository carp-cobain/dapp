import Config

config :dapp, Dapp.Repo,
  database: "dapp_dev",
  username: "postgres",
  password: "password1",
  hostname: "localhost",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 8

# Test network prefix
config :dapp,
  network_prefix: "tp",
  trial_ttl_seconds: 666
