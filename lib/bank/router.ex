defmodule Bank.Router do
  use Commanded.Commands.Router

  alias Bank.Commands.CloseBankAccount
  alias Bank.Aggregates.BankAccount.BankAccount
  alias Bank.Commands.OpenBankAccount

  identify BankAccount, by: :id

  dispatch [OpenBankAccount, CloseBankAccount],
    to: BankAccount,
    lifespan: Bank.Aggregates.BankAccount.Lifespan
end
