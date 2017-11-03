defmodule Client do
    use GenServer

    def start_link(x) do
        GenServer.start_link(Server, x)
    end

    def send_message(server) do
        GenServer.cast(server, {:send_message})
    end

    def set_neighbors(server, neighbors) do
        GenServer.cast(server, {:set_neighbors, neighbors})
    end

    def get_count(server) do
        {:ok, count} = GenServer.call(server, {:get_count, "count"})
        count
    end
end
