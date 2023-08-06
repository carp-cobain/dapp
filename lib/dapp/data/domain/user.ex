defmodule Dapp.Data.Domain.User do
  @moduledoc "User domain object."
  import Algae

  @derive Jason.Encoder
  defdata do
    id :: String.t()
    blockchain_address :: String.t()
    name :: String.t()
    email :: String.t()
  end
end
