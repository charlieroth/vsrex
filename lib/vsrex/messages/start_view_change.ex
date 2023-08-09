defmodule Vsrex.Messages.StartViewChange do
  defstruct [
    :view_number,
    :replica_id,
    type: "START_VIEW_CHANGE"
  ]
end
