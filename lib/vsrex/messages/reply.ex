defmodule Vsrex.Messages.Reply do
  defstruct [
    :view_number,
    :client_request_number,
    :op_result,
    type: "REPLY"
  ]
end
