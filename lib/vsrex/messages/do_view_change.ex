defmodule Vsrex.Messages.DoViewChange do
  defstruct [
    :view_number,
    :log,
    :view_number,
    :op_number,
    :commit_number,
    :replica_id,
    type: "DO_VIEW_CHANGE"
  ]
end
