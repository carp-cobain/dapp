# Elixir dApp Template

A dApp elixir template with in-app role-based access control (RBAC) and feature toggle support.

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
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskv" http://localhost:8888/dapp/api/v1/resource
```

An authorized admin

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska" http://localhost:8888/dapp/api/v1/secret
```

## Unauthorized Access

Viewer unauthorized to access secret route.

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskv" http://localhost:8888/dapp/api/v1/secret
```

Unknown caller is unauthorized

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskt" http://localhost:8888/dapp/api/v1/resource
```

Unauthorized caller

```sh
curl -is -XGET http://localhost:8888/dapp/api/v1/resource
```
