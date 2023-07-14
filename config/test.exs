import Config

config :bank, Bank.CommandedApplication,
  event_store: [
    adapter: Commanded.EventStore.Adapters.InMemory,
    consistency: :strong
  ]

config :logger,
  level: :warning
