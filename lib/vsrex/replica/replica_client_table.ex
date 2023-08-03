defmodule Vsrex.Replica.ClientTable do
  @moduledoc """
  Records for each client:
  - The number of its most recent request
  - If request has been executed
  - Result sent to the client
  """
  defstruct [:client_table]

  alias Vsrex.Replica.ClientTable

  @spec init() :: %ClientTable{}
  def init() do
    %ClientTable{client_table: %{}}
  end
end
