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

## Authorized Access

An authorized user can see thier profile.

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskv" http://localhost:8888/dapp/v1/users/profile
```

An authorized admin can see any user's profile.

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska" http://localhost:8888/dapp/v1/users/{user_id}/profile
```

## Unauthorized Access

User unauthorized to access other user's profiles.

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskv" http://localhost:8888/dapp/v1/users/{user_id}/profile
```

Unauthorized users (no DB entry) have no profile (must call signup route first).

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskt" http://localhost:8888/dapp/v1/users/profile
```

Unknown user is unauthorized

```sh
curl -is -XGET http://localhost:8888/dapp/v1/users/profile
```
