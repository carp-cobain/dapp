defmodule Dapp.Dto.Role do
  @moduledoc "Role data transfer object."
  import Algae

  @derive Jason.Encoder
  defdata do
    id :: non_neg_integer()
    name :: String.t()
  end
end
