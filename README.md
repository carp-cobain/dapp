# Elixir dApp Template

A dApp template with role-based access control (RBAC) and use case auditing.

## Setup

First, install the [asdf version manager](https://asdf-vm.com/guide/getting-started.html).
Then, add the [asdf erlang](https://github.com/asdf-vm/asdf-erlang)
and [asdf elixir](https://github.com/asdf-vm/asdf-elixir)
plugins. 

See `.tool-versions` for version details.

Once the above are installed, run the following command.

```shell
asdf install
```

Run a PostgreSQL database container (assumes docker is installed).

```shell
docker run --rm --name my-postgres -p 5432:5432 -e POSTGRES_PASSWORD=password1 -e POSTGRES_USER=postgres -d postgres
```

Get deps, create the db, run migrations, and seed the database with sample data.

```shell
mix setup
```

Drop into an interactive shell + start the application.

```shell
iex -S mix
```

## Invite / Signup Flow

### Get Roles (admin)

```shell
curl -s -XGET  -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska" http://localhost:8888/dapp/v1/roles | jq
```

Copy the `role_id` for "User" for creating invite.

### Create Invite (admin)

```shell
curl -s -XPOST -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska" -H "content-type: application/json" -d '{"email": "jane.doe@domain.com", "role_id": FIXME}' http://localhost:8888/dapp/v1/invites | jq
```

Copy invite code from response for signup.

### Signup

```shell
curl -s -XPOST -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskc" -H "content-type: application/json" -d '{"name": "Jane Doe", "email": "jane.doe@domain.com", "code": "FIXME"}' http://localhost:8888/dapp/v1/signup | jq
```

### Get Profile

```shell
curl -s -XGET  -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskc" http://localhost:8888/dapp/v1/users/profile | jq
```
