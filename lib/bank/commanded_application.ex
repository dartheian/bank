defmodule Bank.CommandedApplication do
  @moduledoc false

  use Commanded.Application, otp_app: :bank

  router(Bank.Router)
end
