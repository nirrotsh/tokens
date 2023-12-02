defmodule Connector.ConnectorTest do
  use ExUnit.Case, async: true
  import Mox

  setup :verify_on_exit!

  setup do
    Application.put_env(:tokens, :connectors_repo, ConnectorsRepoMock)
  end

  test "Get Connector Data, No Refresh" do
    c = create_test_connector("key_1")
    ConnectorsRepoMock
    |> expect(:get, fn (_,_) -> {:ok, c} end)
    {:ok, pid} = Connector.start_link([key: c.key])
    allow(ConnectorsRepoMock, self(), pid)
    {:ok, c1} = Connector.get(pid, nil, :never)
    assert c1.key == c.key
    assert c1.auth_token == c.auth_token
    assert c1.refresh_token == c.refresh_token
    assert c1.updated == c.updated
  end

  defp create_test_connector(key) do
    %Connector.Data{
      key: key,
      cust_id: "my customer",
      auth_token: "abcd",
      refresh_token: "efgh",
      updated: ~U[2020-08-20 13:52:11Z]
    }
  end

  defmodule TestRefresher do
    def refresh(%Connector.Data{}=c) do
      %Connector.Data{
        key: c.key,
        cust_id: c.cust_id,
        auth_token: (for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>),
        refresh_token: (for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>),
        updated: DateTime.utc_now()
      }
    end
  end
end
