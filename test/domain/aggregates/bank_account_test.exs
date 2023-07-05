defmodule Domain.Aggregates.BankAccountTest do
  use ExUnit.Case, async: true

  alias Bank.Domain.Aggregates.BankAccount
  alias Bank.Domain.ValueObjects.Money

  doctest Bank.Domain.Aggregates.BankAccount, import: true

  test "new" do
    assert %BankAccount{id: id, balances: %{}} = BankAccount.new!()
    assert 4 == Uniq.UUID.info!(id, :keyword)[:version]
  end

  test "deposit" do
    assert %BankAccount{balances: %{:eur => 10}} =
             BankAccount.new!()
             |> BankAccount.deposit!(Money.new!(amount: 10, currency: :eur))
  end

  describe "withdraw" do
    test "succedes if enough money is present" do
      assert {:ok, %BankAccount{balances: %{:eur => 0}}} =
               BankAccount.new!()
               |> BankAccount.deposit!(Money.new!(amount: 10, currency: :eur))
               |> BankAccount.withdraw(Money.new!(amount: 10, currency: :eur))
    end

    test "fails if the currency is not present" do
      assert {:error, :unavailable_currency} =
               BankAccount.new!()
               |> BankAccount.withdraw(Money.new!(amount: 10, currency: :eur))
    end

    test "fails if the balance is insufficient" do
      assert {:error, :insufficient_balance} =
               BankAccount.new!()
               |> BankAccount.deposit!(Money.new!(amount: 5, currency: :eur))
               |> BankAccount.withdraw(Money.new!(amount: 10, currency: :eur))
    end
  end
end
