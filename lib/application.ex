defmodule Paperwork.Journals.Application do
    use Application

    def start(_type, _args) do
        case Code.ensure_loaded(ExSync) do
            {:module, ExSync = mod} ->
                mod.start()
            {:error, _} ->
                :ok
        end

        children = [
            Paperwork.Ex,
            Paperwork.Journals.Server,
            {Mongo, [name: :mongo, url: Confex.fetch_env!(:paperwork, :mongodb)[:url], pool: DBConnection.Poolboy]},
            Paperwork.Events.Consumer
        ]

        opts = [strategy: :one_for_one, name: Paperwork.Journals.Supervisor]
        Supervisor.start_link(children, opts)
    end
end
