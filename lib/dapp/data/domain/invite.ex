defmodule Dapp.Data.Domain.Invite do
  @moduledoc "Invite domain object."
  import Algae

  @derive Jason.Encoder
  defdata do
    code :: String.t()
    email :: String.t()
  end
end
