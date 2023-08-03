defmodule Vsrex.Replica.Log do
  defstruct [:log]

  alias Vsrex.Replica.Log

  @spec init() :: %Log{}
  def init() do
    %Log{log: []}
  end

  @spec view_number(log :: %Log{}) :: integer()
  def view_number(%Log{log: []}), do: 0

  def view_number(%Log{log: [head | _]}), do: head.view_number

  @spec op_number(log :: %Log{}) :: integer()
  def op_number(%Log{log: []}), do: 0
  def op_number(%Log{log: [head | _]}), do: head.op_number

  @spec commit_number(log :: %Log{}) :: integer()
  def commit_number(%Log{log: []}), do: 0
  def commit_number(%Log{log: [head | _]}), do: head.commit_number
end
