# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Dapp.Data.Repo

alias Dapp.Data.Schema.Grant
alias Dapp.Data.Schema.Role
alias Dapp.Data.Schema.User

# Roles
role_admin = Repo.insert!(%Role{name: "Admin"})
role_viewer = Repo.insert!(%Role{name: "Viewer"})

# Users
viewer = Repo.insert!(
  %User{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskv", 
    email: "viewer-noreply@figure.com",
    name: "Viewer"
  }
)
admin = Repo.insert!(
  %User{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska", 
    email: "admin-noreply@figure.com",
    name: "Admin"
  }
)

# Grants
Repo.insert!(
  %Grant {
    user: viewer,
    role: role_viewer
  }
)
Repo.insert!(
  %Grant {
    user: admin,
    role: role_admin
  }
)
