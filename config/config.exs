import Config

config :bank, Bank.CommandedApplication,
  event_store: [
    serializer: Commanded.Serialization.JsonSerializer
  ]

#     adapter: Commanded.EventStore.Adapters.Extreme,
#     extreme: [
#       db_type: :node,
#       host: "localhost",
#       port: 1113,
#       username: "admin",
#       password: "changeit",
#       reconnect_delay: 2_000,
#       max_attempts: :infinity
#     ],
#     stream_prefix: "bank",
#     consistency: :eventual
#   ]
#   pubsub: :local,
#   registry: :local

import_config "#{config_env()}.exs"
