defmodule Vsrex.Replica.State do
  defstruct [
    :replica,
    :replica_number,
    :view_number,
    :status,
    :op_number,
    :log,
    :commit_number,
    :client_table
  ]

  require Logger

  alias Vsrex.Replica.{State, ClientTable, Log}

  def init(%State{} = state) do
    log = Log.init()
    client_table = ClientTable.init()

    replica_state = %{
      state
      | replica: Node.self(),
        view_number: Log.view_number(log),
        status: :recovering,
        op_number: Log.op_number(log),
        log: log,
        commit_number: Log.commit_number(log),
        client_table: client_table
    }

    if Log.view_number(replica_state.log) == replica_state.view_number do
      transition(replica_state, :normal)
    else
      transition(replica_state, :view_change)
    end
  end

  @spec transition(replica_state :: %State{}, to :: atom()) :: %State{}
  def transition(%State{status: :recovering} = state, :normal = to) do
    Logger.debug(
      "[#{inspect(state.replica)}] transition(#{inspect(state.status)}, #{inspect(to)}), view=#{state.view_number}"
    )

    cond do
      Vsrex.is_primary?(state) ->
        %{state | status: :normal}

      Vsrex.is_backup?(state) ->
        %{state | status: :normal}

      Vsrex.is_view_change?(state) ->
        %{state | status: :normal}

      true ->
        state
    end
  end

  def transition(%State{} = state, to) do
    Logger.debug("unsupported state transition from #{inspect(state.status)} to #{inspect(to)}")
    state
  end
end
