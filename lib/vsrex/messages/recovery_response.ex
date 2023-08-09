defmodule Vsrex.Messages.RecoveryResponse do
  defstruct [
    :view_number,
    :nonce,
    :log,
    :op_number,
    :commit_number,
    :replica_id,
    type: "RECOVERY_RESPONSE"
  ]
end
