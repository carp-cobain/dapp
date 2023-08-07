# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Dapp.Data.Schema.{Role, User}
alias Dapp.Repo

# Roles
root = Repo.insert!(%Role{name: "Root"})
user = Repo.insert!(%Role{name: "User"})

# Users
Repo.insert!(
  %User{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska", 
    name: "Alice",
    email: "alice@gmail.com",
    role: root
  }
)
Repo.insert!(
  %User{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskb", 
    name: "Bob",
    email: "bob@gmail.com",
    role: user
  }
)

