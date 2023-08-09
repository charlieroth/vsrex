defmodule Vsrex.Messages.PrepareOk do
  defstruct [
    :view_number,
    :op_number,
    :replica_id,
    type: "PREPARE_OK"
  ]
end
