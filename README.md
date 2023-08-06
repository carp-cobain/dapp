# Elixir dApp Template

A dApp template with role-based access control (RBAC) and use case auditing.

## Setup

Install erlang and elixir (assumes asdf package manager). See `.tool-versions` for info.

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

## Example Requests

### Create Invite (admin)

```shell
curl -s -XPOST -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska" -H "content-type: application/json" -d '{"email": "jane.doe@gmail.com", "role_id": 2}' http://localhost:8888/dapp/v1/invites | jq
```

### Signup

```shell
curl -s -XPOST -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskc" -H "content-type: application/json" -d '{"name": "Jane Doe", "email": "jane.doe@gmail.com", "code": "FIXME"}' http://localhost:8888/dapp/v1/signup | jq
```

### Get Profile

```shell
curl -s -XGET  -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskc" http://localhost:8888/dapp/v1/users/profile | jq
```

