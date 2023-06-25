# Elixir dApp Template

A dApp template with role-based access control (RBAC).

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

Before commit, run

```shell
mix format && mix compile --warnings-as-errors --all-warnings
mix quality
```
