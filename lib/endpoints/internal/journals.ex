defmodule Paperwork.Journals.Endpoints.Internal.Journals do
    use Paperwork.Journals.Server
    use Paperwork.Helpers.Response

    pipeline do
    end

    namespace :internal do
        namespace :journals do
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
