defmodule Vsrex.ReplicaLog do
  defstruct [:log]

  alias Vsrex.ReplicaLog

  @spec init() :: %ReplicaLog{}
  def init() do
    %ReplicaLog{log: []}
  end

  @spec view_number(log :: %ReplicaLog{}) :: integer()
  def view_number(%ReplicaLog{log: []}), do: 0

  def view_number(%ReplicaLog{log: [head | _]}), do: head.view_number

  @spec op_number(log :: %ReplicaLog{}) :: integer()
  def op_number(%ReplicaLog{log: []}), do: 0
  def op_number(%ReplicaLog{log: [head | _]}), do: head.op_number

  @spec commit_number(log :: %ReplicaLog{}) :: integer()
  def commit_number(%ReplicaLog{log: []}), do: 0
  def commit_number(%ReplicaLog{log: [head | _]}), do: head.commit_number
end
