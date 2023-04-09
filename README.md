# Elixir dApp

A prototype dApp that demonstrates in-app role-based access control (RBAC).

## Authorized Access

An authorized viewer

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskv" http://localhost:8080/dapp/v1/protected/resource
```

An authorized admin

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska" http://localhost:8080/dapp/v1/protected/secret
```
## Unauthorized Access

Viewer unauthorized to access secret route.

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskv" http://localhost:8080/dapp/v1/protected/secret
```

Unknown caller is unauthorized

```sh
curl -is -XGET -H "x-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskt" http://localhost:8080/dapp/v1/protected/resource
```

Unauthorized caller

```sh
curl -is -XGET http://localhost:8080/dapp/v1/protected/resource
```
