import Config

config :dapp,
  ecto_repos: [Dapp.Repo]

# Network prefix, blockchain address auth headers, and other config
config :dapp,
  network_prefix: "pb",
  user_header: "x-address",
  group_header: "x-group-policy",
  signup_role: "Viewer"

# Shows how to configure nanoid size, alphabet.
config :nanoid,
  size: 21,
  alphabet: "23456789abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ"

# Load environment specific configuration last.
import_config "#{config_env()}.exs"
