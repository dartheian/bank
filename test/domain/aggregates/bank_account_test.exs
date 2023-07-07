defmodule Domain.Aggregates.BankAccountTest do
  use ExUnit.Case, async: true

  alias Bank.Domain.Aggregates.BankAccount
  alias Bank.Domain.ValueObjects.Money
  alias Bank.Domain.ValueObjects.Uuid

  doctest Bank.Domain.Aggregates.BankAccount, import: true

  test "new fails if the id is not a binary uuid" do
    assert {:error, [id: _]} = BankAccount.new(id: "00000000-0000-0000-0000-000000000000")
  end
end
