# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Dapp.Repo
alias Dapp.Schema.{Grant, Invite, Role, User}

# Always insert roles
role_admin = Repo.insert!(%Role{name: "Admin"})
role_viewer = Repo.insert!(%Role{name: "Viewer"})

# Insert env-specific seed data
if Mix.env() == :dev do

now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

# Users
viewer = Repo.insert!(
  %User{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskv", 
      name: "Victor Viewer",
      email: "victor@gmail.com",
      verified_at: now 
    }
  )
admin = Repo.insert!(
  %User{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska", 
    name: "Alice Admin",
    email: "alice@gmail.com",
      verified_at: now 
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

# Invites
Repo.insert!(
  %Invite {
    email: "jane.doe@email.com",
    role: role_viewer
  }
)

end
