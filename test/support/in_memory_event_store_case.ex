defmodule Support.InMemoryEventStoreCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  setup do
    {:ok, _apps} = Application.ensure_all_started(:bank)
    on_exit(fn -> :ok = Application.stop(:bank) end)
  end
end
