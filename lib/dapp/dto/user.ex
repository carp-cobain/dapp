defmodule Dapp.Dto.User do
  @moduledoc "User data transfer object."
  import Algae

  @derive Jason.Encoder
  defdata do
    id :: String.t()
    blockchain_address :: String.t()
    name :: String.t()
    email :: String.t()
  end
end
