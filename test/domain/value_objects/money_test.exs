defmodule Domain.ValueObjects.MoneyTest do
  use ExUnit.Case, async: true

  alias Bank.Domain.ValueObjects.Money

  doctest Bank.Domain.ValueObjects.Money, import: true

  describe "new" do
    test "fails if the amount is negative" do
      assert {:error, [amount: _]} = Money.new(amount: -10, currency: :eur)
    end

    test "fails if the amount is not an integer" do
      assert {:error, [amount: _]} = Money.new(amount: 1.0, currency: :eur)
    end

    test "fails if the currency is not valid" do
      assert {:error, [currency: _]} = Money.new(amount: 10, currency: :invalid)
    end
  end
end
