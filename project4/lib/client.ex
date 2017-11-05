defmodule Client do
    use GenServer

    def start_link(x) do
        GenServer.start_link(Server, :ok)
    end

    def add_user(server, user_pid) do
        GenServer.cast(server, {:add_user, user_pid})
    end
    #
    # def set_neighbors(server, neighbors) do
    #     GenServer.cast(server, {:set_neighbors, neighbors})
    # end
    #
    # def get_count(server) do
    #     {:ok, count} = GenServer.call(server, {:get_count, "count"})
    #     count
    # end
end
