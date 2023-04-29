# Set the sandbox ownership mode. This ensures that only a
# single connection is used for each test.
Ecto.Adapters.SQL.Sandbox.mode(Dapp.Repo, :manual)
ExUnit.start()
