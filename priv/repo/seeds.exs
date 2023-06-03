# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Dapp.Repo
alias Dapp.Schema.{Grant, Role, User, Feature, Toggle, UserFeature}

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

# Features 
global_features = Repo.insert!(
  %Feature{
    name: "global_features"
  }
)
admin_features = Repo.insert!(
  %Feature{
    name: "admin_features",
    global: false
  }
)
trial_features = Repo.insert!(
  %Feature{
    name: "trial_features",
    global: false
  }
)

# Feature toggles
{:ok, expires_at, _} = DateTime.from_iso8601("2100-12-21T00:00:00Z") 
Repo.insert!(
  %Toggle{
    feature: global_features,
    name: "show_user_name",
    enabled: true,
    expires_at: expires_at
  }
)
Repo.insert!(
  %Toggle{
    feature: global_features,
    name: "show_user_timestamps",
    enabled: false,
    expires_at: expires_at
  }
)
Repo.insert!(
  %Toggle{
    feature: admin_features,
    name: "show_user_email",
    enabled: true,
    expires_at: expires_at
  }
)
Repo.insert!(
  %Toggle{
    feature: trial_features,
    name: "user_expiration",
    enabled: true,
    expires_at: expires_at
  }
)
Repo.insert!(
  %Toggle{
    feature: admin_features,
    name: "show_user_role",
    enabled: true,
    expires_at: expires_at
  }
)

# User feature associations
Repo.insert!(
  %UserFeature{
    user: admin,
    feature: admin_features
  }
)
# Uncomment for trial expiration on viewer...
Repo.insert!(
  %UserFeature{
    user: viewer,
    feature: trial_features
  }
)

