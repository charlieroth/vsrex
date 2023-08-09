defmodule Vsrex.Messages.Recovery do
  defstruct [
    :replica_id,
    :nonce,
    type: "RECOVERY"
  ]
end
