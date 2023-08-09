defmodule Vsrex.Messages.Request do
  defstruct [
    :operation,
    :client_id,
    :request_number,
    type: "REQUEST"
  ]
end
