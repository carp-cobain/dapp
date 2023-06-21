alias Dapp.Dto.Role, as: RoleDto
alias Dapp.Dto.User, as: UserDto

alias Dapp.Schema.Role, as: RoleSchema
alias Dapp.Schema.User, as: UserSchema

defprotocol Dapp.Dto do
  @doc "Create a DTO from a schema struct."
  def from_schema(struct)
end

defimpl Dapp.Dto, for: UserSchema do
  @doc "Create a DTO from a user schema struct."
  def from_schema(user) do
    UserDto.new(user.id, user.blockchain_address, user.name, user.email)
  end
end

defimpl Dapp.Dto, for: RoleSchema do
  @doc "Create a DTO from a role schema struct."
  def from_schema(role) do
    RoleDto.new(role.id, role.name)
  end
end

# Add more impls for schema types here...
