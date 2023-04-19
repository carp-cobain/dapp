# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Dapp.Data.Repo
alias Dapp.Data.Schema.{Grant, Role, User, Feature, Toggle}

# Roles
role_admin = Repo.insert!(%Role{name: "Admin"})
role_viewer = Repo.insert!(%Role{name: "Viewer"})

# Users
viewer = Repo.insert!(
  %User{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskv", 
    email: "victor@gmail.com",
    name: "Victor Viewer"
  }
)
admin = Repo.insert!(
  %User{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska", 
    email: "alice@gmail.com",
    name: "Alice Admin"
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

# Feature Toggles
feature = Repo.insert!(
  %Feature{
    name: "get_secret"
  }
)
Repo.insert!(
  %Toggle{
    feature: feature,
    name: "show_user_email",
    enabled: true
  }
)

