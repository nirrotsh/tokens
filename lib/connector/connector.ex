defmodule Connector do
  use GenServer

  # Client API
  @doc """
  Creates a new GenServer for this connector
  """
  def start_link(opts) do
    {key, _} = Keyword.pop!(opts, :key) # key is mandatory
    GenServer.start_link(__MODULE__, %{key: key})
  end

  def get(pid, conn, refresh\\:never) do
    GenServer.call(pid, {:get, conn, refresh})
  end

  # Server
  def init(connector) do
   {:ok,connector}
  end

  def handle_call({:get, conn, :never}, _from, state) do
    {res, new_state} = fetch_connector(conn, state)
    {:reply, res, new_state}
  end

  defp repo() do
    Application.get_env(:tokens, :connectors_repo)
  end

  defp fetch_connector(_conn, %{data: data}=state) do
    {{:ok, data}, Map.put(state, :data, data) }
  end

  defp fetch_connector(conn, %{key: key}=state) do
    res = repo().get(conn, key)
    inspect res
    case res  do
      {:ok, data} -> {{:ok, data}, Map.put(state, :data, data) }
      {_, err} -> {{:error, err}, state}
    end
  end
end
