defmodule Vsrex.Messages.Prepare do
  defstruct [
    :view_number,
    :client_message,
    :op_number,
    :commit_number,
    type: "PREPARE"
  ]
end
