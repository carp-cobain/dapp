defmodule Dapp.Data.Domain.Role do
  @moduledoc "Role domain object."
  import Algae

  @derive Jason.Encoder
  defdata do
    id :: non_neg_integer()
    name :: String.t()
  end
end
