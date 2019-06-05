use Mix.Config

config :paperwork_service_journals, Paperwork.Journals.Server,
    adapter: Plug.Cowboy,
    plug: Paperwork.Journals,
    scheme: :http,
    ip: {0,0,0,0},
    port: {:system, :integer, "PORT", 8884}

config :paperwork_service_journals,
    maru_servers: [Paperwork.Journals.Server]

config :paperwork, :server,
    app: :paperwork_service_journals,
    cache_ttl_default: 86_400,
    cache_janitor_interval: 60

config :paperwork, :mongodb,
    url: {:system, :string, "MONGODB_URL", "mongodb://localhost:27017/journals"}

config :paperwork, :internal,
    cache_ttl: 60,
    configs:     {:system, :string, "INTERNAL_RESOURCE_CONFIGS",     "http://localhost:8880/internal/configs"},
    users:       {:system, :string, "INTERNAL_RESOURCE_USERS",       "http://localhost:8881/internal/users"},
    notes:       {:system, :string, "INTERNAL_RESOURCE_NOTES",       "http://localhost:8882/internal/notes"},
    attachments: {:system, :string, "INTERNAL_RESOURCE_ATTACHMENTS", "http://localhost:8883/internal/attachments"},
    journals:    {:system, :string, "INTERNAL_RESOURCE_JOURNALS",    "http://localhost:8884/internal/journals"}

config :paperwork, :events,
    url: {:system, :string, "EVENTS_URL", "amqp://localhost"},
    reconnect_interval: {:system, :integer, "EVENTS_RECONNECT_INTERVAL", 10_000},
    exchange: {:system, :string, "EVENTS_EXCHANGE", "journals_exchange"},
    queue: {:system, :string, "EVENTS_QUEUE", "journals_queue"},
    dead_letter_exchange: {:system, :string, "EVENTS_DEAD_LETTER_EXCHANGE", "journals_dead_letter_exchange"},
    dead_letter_queue: {:system, :string, "EVENTS_DEAD_LETTER_QUEUE", "journals_dead_letter_queue"},
    handler: Paperwork.Journals.Consumer

config :logger,
    backends: [:console]
