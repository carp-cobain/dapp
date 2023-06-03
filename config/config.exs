import Config

config :dapp,
  ecto_repos: [Dapp.Repo]

# Blockchain address auth headers
config :dapp,
  network_prefix: "pb",
  user_header: "x-address",
  group_header: "x-group-policy",
  trial_ttl_seconds: 16_666_666

# Shows how to configure nanoid size, alphabet.
config :nanoid,
  size: 21,
  alphabet: "23456789abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ"

# Load environment specific configuration last.
import_config "#{config_env()}.exs"
