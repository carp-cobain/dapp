defmodule Dapp.Dto.Invite do
  @moduledoc "Invite data transfer object."
  import Algae

  @derive Jason.Encoder
  defdata do
    code :: String.t()
    email :: String.t()
  end
end
