defmodule Paperwork.Journals.Endpoints.Internal.Journals do
    use Paperwork.Journals.Server
    use Paperwork.Helpers.Response

    pipeline do
    end

    namespace :internal do
        namespace :journals do

            params do
                optional :resource,           type: String
                optional :relevant_to,        type: String
                optional :newer_than_id,      type: String
            end
            get do
                query =
                    %{}
                    |> Paperwork.Collections.Journal.query_resource(Map.get(params, :resource))
                    |> Paperwork.Collections.Journal.query_relevant_to(Map.get(params, :relevant_to) |> Paperwork.Id.from_gid())
                    |> Paperwork.Collections.Journal.query_newer_than_id(Map.get(params, :newer_than_id) |> Paperwork.Id.from_gid())

                IO.inspect params
                IO.inspect query

                response = Paperwork.Collections.Journal.list(query)
                conn
                |> resp(response)
            end

            route_param :key do
                get do
                    case Paperwork.Collections.Journal.show(params[:key]) do
                        {:ok, config} ->
                            conn
                            |> resp({:ok, config})
                        {:notfound, nil} ->
                            conn
                            |> resp({:notfound, %{}})
                    end
                end
            end
        end
    end
end
