# Set the sandbox to the correct ownership mode.
# This ensures that only using a single connection for each test.
Ecto.Adapters.SQL.Sandbox.mode(Dapp.Repo, :manual)
ExUnit.start()
