# Set the sandbox ownership mode. This ensures that only a
# single connection is used for each test.
Ecto.Adapters.SQL.Sandbox.mode(Dapp.Repo, :manual)

Hammox.defmock(AuditsMock, for: Dapp.Data.Api.Audits)
Hammox.defmock(InvitesMock, for: Dapp.Data.Api.Invites)
Hammox.defmock(RolesMock, for: Dapp.Data.Api.Roles)
Hammox.defmock(UsersMock, for: Dapp.Data.Api.Users)

ExUnit.start()
