# Elixir dApp Template

A dApp template with:

  - Role-based access control (RBAC)
  - Dark features

## Setup

Install Elixir

```shell
brew install elixir
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

An authorized viewer

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskv" http://localhost:8888/dapp/v1/profile
```

An authorized admin

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska" http://localhost:8888/dapp/v1/users
```

## Unauthorized Access

Viewer unauthorized to access users route.

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskv" http://localhost:8888/dapp/v1/users
```

Unauthorized user (no DB entry)

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskt" http://localhost:8888/dapp/v1/profile
```

Unknown user is unauthorized

```sh
curl -is -XGET http://localhost:8888/dapp/v1/profile
```
