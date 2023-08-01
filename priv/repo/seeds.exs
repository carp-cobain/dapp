# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Dapp.Repo
alias Dapp.Schema.{Grant, Invite, Role, User}

# Always insert roles
role_root = Repo.insert!(%Role{name: "Root"})
role_user = Repo.insert!(%Role{name: "User"})

# Insert env-specific seed data
if Mix.env() == :dev do

now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

# Users
bob = Repo.insert!(
  %User{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskb", 
      name: "Bob",
      email: "bob@gmail.com"
    }
  )
alice = Repo.insert!(
  %User{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska", 
    name: "Alice",
    email: "alice@gmail.com"
  }
)
# Grants
Repo.insert!(
  %Grant {
    user: bob,
    role: role_user
  }
)
Repo.insert!(
  %Grant {
    user: alice,
    role: role_root
  }
)

# Invites
Repo.insert!(
  %Invite {
    id: "TzyircqKjfgAtHNpjiiLI",
    email: "jane.doe@email.com",
    role: role_user
  }
)

end
