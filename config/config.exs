import Config

config :dapp,
  ecto_repos: [Dapp.Data.Repo]

# Load environment specific configuration last.
import_config "#{config_env()}.exs"
