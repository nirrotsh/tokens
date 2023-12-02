ExUnit.start()

Mox.defmock(ConnectorsRepoMock, for: Repo.Connectors)
Application.put_env(:tokens, :connectors_repo, ConnectorsRepoMock)
