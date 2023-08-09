defmodule Vsrex.Messages.Commit do
  defstruct [
    :view_number,
    :commit_number,
    :op_number,
    type: "COMMIT"
  ]
end
