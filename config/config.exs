import Config

config :dapp,
  ecto_repos: [Dapp.Data.Repo]

# Blockchain address headers
config :dapp,
  address_header: "x-address",
  group_header: "x-group-policy"

# Shows how to configure nanoid size, alphabet.
config :nanoid,
  size: 21,
  alphabet: "23456789abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ"

# Load environment specific configuration last.
import_config "#{config_env()}.exs"
