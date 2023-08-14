defprotocol Dapp.UseCase.Dto do
  @doc "Create a data transfer object from a schema struct."
  def from_schema(struct)
end
