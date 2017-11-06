defmodule Client do
    use GenServer

    def start_link(x) do
        GenServer.start_link(Server, :ok)
    end

    def add_user(server, user_pid) do
        GenServer.cast(server, {:add_user, user_pid})
    end

    def add_follower(server, user_pid, follower_pid) do
        GenServer.cast(server, {:add_follower, user_pid, follower_pid})
    end

    def send_tweet(server, user_pid, tweet) do
        GenServer.cast(server, {:send_tweet, user_pid, tweet})
    end

    def get_users(server) do
        GenServer.call(server, {:get_users})  #Returns a list of users
    end

    def get_followers(server, user_pid) do
        GenServer.call(server, {:get_followers, user_pid})  #Returns a list of user followers
    end
end
