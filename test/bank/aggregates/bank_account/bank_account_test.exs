defmodule Bank.Aggregates.BankAccount.BankAccountTest do
  use Support.InMemoryEventStoreCase, async: true

  import Commanded.Assertions.EventAssertions

  alias Bank.Aggregates.BankAccount.BankAccount
  alias Bank.Aggregates.BankAccount.Events.BankAccountClosed
  alias Bank.Aggregates.BankAccount.Events.BankAccountOpened
  alias Bank.CommandedApplication
  alias Bank.Commands.CloseBankAccount
  alias Bank.Commands.OpenBankAccount
  alias Bank.Domain.ValueObjects.Money

  doctest Bank.Aggregates.BankAccount.BankAccount, import: true

  test "new fails if the id is not a binary uuid" do
    assert {:error, [id: _]} = BankAccount.new(id: "00000000-0000-0000-0000-000000000000")
  end

  describe "opening an account" do
    test "succedes if an account with that id does not exist" do
      command = OpenBankAccount.new!(id: Uuid.new())
      assert :ok = CommandedApplication.dispatch(command)

      assert_receive_event(CommandedApplication, BankAccountOpened, fn event ->
        assert command.id == event.id
      end)
    end

    test "fails if an account with the same id already exist" do
      command = OpenBankAccount.new!(id: Uuid.new())
      :ok = CommandedApplication.dispatch(command)
      assert {:error, :account_already_created} = CommandedApplication.dispatch(command)
    end
  end

  describe "closing an account" do
    test "succedes if an account with that id does exist" do
      id = Uuid.new()
      command = OpenBankAccount.new!(id: id)
      :ok = CommandedApplication.dispatch(command)
      command = CloseBankAccount.new!(id: id)
      assert :ok = CommandedApplication.dispatch(command)

      assert_receive_event(CommandedApplication, BankAccountClosed, fn event ->
        assert command.id == event.id
      end)
    end

    test "fails if an account with that id does not exist" do
      command = CloseBankAccount.new!(id: Uuid.new())
      assert {:error, :inexistent_account} = CommandedApplication.dispatch(command)
    end
  end
end
