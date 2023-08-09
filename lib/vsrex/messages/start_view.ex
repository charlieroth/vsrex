defmodule Vsrex.Messages.StartView do
  defstruct [
    :view_number,
    :log,
    :op_number,
    :commit_number,
    type: "START_VIEW"
  ]
end
