defmodule Vsrex.ReplicaState do
  defstruct [
    :topology,
    :replica_number,
    :view_number,
    :status,
    :op_number,
    :log,
    :commit_number,
    :client_table
  ]

  require Logger

  alias Vsrex.Topology

  alias Vsrex.{
    Vsr,
    ReplicaState,
    ReplicaClientTable,
    ReplicaTopology,
    ReplicaLog
  }

  def init(%ReplicaState{} = state, configuration) do
    topology = ReplicaTopology.init(configuration, [Node.self()])
    log = ReplicaLog.init()
    client_table = ReplicaClientTable.init()

    replica_state = %{
      state
      | topology: topology,
        replica_number: ReplicaTopology.replica_number(topology, Node.self()),
        view_number: 0,
        status: :recovering,
        op_number: ReplicaLog.op_number(log),
        log: log,
        commit_number: ReplicaLog.commit_number(log),
        client_table: client_table
    }

    if ReplicaLog.view_number(replica_state.log) == replica_state.view_number do
      transition(replica_state, :normal)
    else
      transition(replica_state, :view_change)
    end
  end

  @spec transition(replica_state :: %ReplicaState{}, to :: atom()) ::
          %ReplicaState{}
  def transition(%ReplicaState{status: :recovering} = state, :normal = to) do
    Logger.debug(
      "#{state.replica_number}: transition(#{inspect(state.status)}, #{inspect(to)}), view=#{state.view_number}"
    )

    cond do
      is_primary?(state) ->
        %{state | status: :normal}

      is_backup?(state) ->
        %{state | status: :normal}

      is_view_change?(state) ->
        %{state | status: :normal}

      true ->
        state
    end
  end

  def transition(%ReplicaState{} = state, to) do
    Logger.debug("unsupported state transition from #{inspect(state.status)} to #{inspect(to)}")
    state
  end

  defp is_backup?(%ReplicaState{} = state), do: not is_primary?(state)

  defp is_primary?(%ReplicaState{} = state) do
    %{replicas: replicas} = Topology.state()

    Vsr.primary_index(state.view_number, length(replicas)) ==
      Vsr.replica_index(replicas, state.replica_number)
  end

  defp is_view_change?(%ReplicaState{} = _state), do: false
end
