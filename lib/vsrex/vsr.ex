defmodule Vsrex.Vsr do
  def primary_index(view_number, num_replicas), do: Integer.mod(view_number, num_replicas)

  def replica_index(replicas, replica_name) do
    Enum.find_index(replicas, fn replica -> replica == replica_name end)
  end
end
