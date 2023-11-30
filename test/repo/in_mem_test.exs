defmodule Repo.InMemTest do
  use ExUnit.Case, async: true

  test "Add and Get connector data by key" do
    {:ok, pid} = Repo.InMem.start_link(%{})
    key = "key_1"
    connector = create_test_connector(key)
    :ok = Repo.InMem.push(pid, connector)
    {:ok, c1} = Repo.InMem.get(pid, key)
    assert c1.cust_id == connector.cust_id
    assert c1.auth_token == connector.auth_token
    assert c1.refresh_token == connector.refresh_token
  end

  test "Fail to get a connector if not in repo" do
    {:ok, pid} = Repo.InMem.start_link(%{})
    {:error, :not_found} = Repo.InMem.get(pid, "no_such_key")
  end

  defp create_test_connector(key) do
    %Connector.Data{
      key: key,
      cust_id: "my customer",
      auth_token: "abcd",
      refresh_token: "efgh"
    }
  end
end
