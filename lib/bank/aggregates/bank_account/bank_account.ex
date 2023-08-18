defmodule Bank.Aggregates.BankAccount.BankAccount do
  @moduledoc false

  use TypedStruct
  use Domo, gen_constructor_name: :_new

  alias Bank.Aggregates.BankAccount.Events.BankAccountClosed
  alias Bank.Aggregates.BankAccount.Events.BankAccountOpened
  alias Bank.Commands.CloseBankAccount
  alias Bank.Commands.OpenBankAccount
  alias Bank.Domain.ValueObjects.Money

  typedstruct enforce: true do
    field :id, Uuid.t()
    field :balances, %{optional(Money.currency()) => Money.amount()}
  end

  @doc """
      iex> BankAccount.new(id: Uuid.from_string!("5593696b-5fe3-4d88-9260-1c07d7b5bbfb"))
      {:ok, %BankAccount{id: <<85, 147, 105, 107, 95, 227, 77, 136, 146, 96, 28, 7, 215, 181, 187, 251>>, balances: %{}}}
  """
  def new(args), do: _new(Enum.concat(args, balances: %{}))

  @doc """
      iex> BankAccount.new!(id: Uuid.from_string!("5593696b-5fe3-4d88-9260-1c07d7b5bbfb"))
      %BankAccount{id: <<85, 147, 105, 107, 95, 227, 77, 136, 146, 96, 28, 7, 215, 181, 187, 251>>, balances: %{}}
  """
  def new!(args), do: _new!(Enum.concat(args, balances: %{}))

  @doc """
      iex> BankAccount.new!(id: Uuid.from_string!("5593696b-5fe3-4d88-9260-1c07d7b5bbfb"))
      ...> |> BankAccount.deposit!(Money.new!(amount: 10, currency: :eur))
      %BankAccount{id: <<85, 147, 105, 107, 95, 227, 77, 136, 146, 96, 28, 7, 215, 181, 187, 251>>, balances: %{eur: 10}}
  """
  @spec deposit!(t, Money.t()) :: t | no_return()
  def deposit!(%__MODULE__{} = account, %Money{} = money) do
    update_in(account.balances[money.currency], fn
      nil -> money.amount
      amount -> amount + money.amount
    end)
  end

  @doc """
      iex> BankAccount.new!(id: Uuid.from_string!("5593696b-5fe3-4d88-9260-1c07d7b5bbfb"))
      ...> |> BankAccount.deposit!(Money.new!(amount: 10, currency: :eur))
      ...> |> BankAccount.withdraw(Money.new!(amount: 5, currency: :eur))
      {:ok, %BankAccount{id: <<85, 147, 105, 107, 95, 227, 77, 136, 146, 96, 28, 7, 215, 181, 187, 251>>, balances: %{eur: 5}}}

      iex> BankAccount.new!(id: Uuid.from_string!("5593696b-5fe3-4d88-9260-1c07d7b5bbfb"))
      ...> |> BankAccount.deposit!(Money.new!(amount: 10, currency: :eur))
      ...> |> BankAccount.withdraw(Money.new!(amount: 10, currency: :eur))
      {:ok, %BankAccount{id: <<85, 147, 105, 107, 95, 227, 77, 136, 146, 96, 28, 7, 215, 181, 187, 251>>, balances: %{}}}

  Raises an error if the currency is not present:

      iex> BankAccount.new!(id: Uuid.from_string!("5593696b-5fe3-4d88-9260-1c07d7b5bbfb"))
      ...> |> BankAccount.withdraw(Money.new!(amount: 10, currency: :eur))
      {:error, :unavailable_currency}

  Raises an error if the balance is not sufficient:

      iex> BankAccount.new!(id: Uuid.from_string!("5593696b-5fe3-4d88-9260-1c07d7b5bbfb"))
      ...> |> BankAccount.deposit!(Money.new!(amount: 5, currency: :eur))
      ...> |> BankAccount.withdraw(Money.new!(amount: 10, currency: :eur))
      {:error, :insufficient_balance}
  """
  @spec withdraw(t, Money.t()) :: t | {:error, :unavailable_currency} | {:error, :insufficient_balance}
  def withdraw(%__MODULE__{} = account, %Money{} = money) do
    case account.balances[money.currency] do
      nil -> {:error, :unavailable_currency}
      amount when amount < money.amount -> {:error, :insufficient_balance}
      amount when amount == money.amount -> {:ok, update_in(account.balances, &Map.delete(&1, money.currency))}
      _ -> {:ok, update_in(account.balances[money.currency], &(&1 - money.amount))}
    end
  end

  def execute(%__MODULE__{id: nil}, %OpenBankAccount{id: id}), do: BankAccountOpened.new(id: id)
  def execute(%__MODULE__{}, %OpenBankAccount{}), do: {:error, :account_already_created}

  def execute(%__MODULE__{id: id}, %CloseBankAccount{id: id}), do: BankAccountClosed.new(id: id)
  def execute(%__MODULE__{id: nil}, %CloseBankAccount{}), do: {:error, :inexistent_account}

  def apply(_, %BankAccountOpened{id: id}), do: new!(id: id)
  def apply(_, %BankAccountClosed{}), do: :ok
end
