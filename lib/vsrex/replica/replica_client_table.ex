defmodule Vsrex.ReplicaClientTable do
  @moduledoc """
  Records for each client:
  - The number of its most recent request
  - If request has been executed
  - Result sent to the client
  """
  defstruct [:client_table]

  alias Vsrex.ReplicaClientTable

  @spec init() :: %ReplicaClientTable{}
  def init() do
    %ReplicaClientTable{client_table: %{}}
  end
end
