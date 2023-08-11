# Set the sandbox ownership mode. This ensures that only a
# single connection is used for each test.
# Ecto.Adapters.SQL.Sandbox.mode(Dapp.Repo, :manual)

Hammox.defmock(AuditsMock, for: Dapp.Data.Api.Audits)
Hammox.defmock(InvitesMock, for: Dapp.Data.Api.Invites)
Hammox.defmock(RolesMock, for: Dapp.Data.Api.Roles)
Hammox.defmock(UsersMock, for: Dapp.Data.Api.Users)

Application.put_env(:dapp, :audit_repo, AuditsMock)
Application.put_env(:dapp, :invite_repo, InvitesMock)
Application.put_env(:dapp, :role_repo, RolesMock)
Application.put_env(:dapp, :user_repo, UsersMock)

ExUnit.start()
