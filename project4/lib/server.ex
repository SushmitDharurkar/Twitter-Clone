defmodule Server do
    use GenServer

    def init(:ok) do
        #{:ok, %{"users" => [pid1, pid2..], "user_details" => %{pid => %{"tweets" => [], "followers" =>[]}}}}
        {:ok, %{"users" => [], "user_details" => %{} }}
    end

    def handle_cast({:add_user, user_pid}, state) do
        if Map.get(state, "users") != nil do
            user_list = [user_pid | Map.get(state, "users")]
            state = Map.put(state, "users", user_list)
          else
            state = Map.put(state, "users", [user_pid])
        end

        user_details = Map.get(state, "user_details")
        user_details = Map.put(user_details, user_pid, %{"tweets" => [], "followers" => []})
        state = Map.put(state, "user_details", user_details)

         IO.inspect(state, label: "State after adding user: ")
          # IO.inspect(Map.get(state, "users"))
        #  IO.inspect(Map.get(state["user_details"], "tweets"))
        {:noreply, state}
    end

    def handle_cast({:add_follower, user_pid, follower_pid}, state) do
        #TODO Add checks if user doesn't exist

        user_details_pid = state["user_details"][user_pid]
        followers = user_details_pid["followers"]
        user_details_pid = Map.put(user_details_pid, "followers", [follower_pid | followers])
        user_details = state["user_details"]
        user_details = Map.put(user_details, user_pid, user_details_pid)
        state = Map.put(state, "user_details", user_details)

        IO.inspect(state, label: "State after adding follower: ")
        # IO.inspect(Map.get(state, "users"))
        # IO.inspect(state["user_details"][user_pid]["followers"])
        # IO.inspect(Map.get(state["user_details"], "tweets"))
        {:noreply, state}
    end

    # def handle_cast({:send_tweet, user_pid, tweet}, state) do
    #     # Map["user_details"]
    #     {:ok, user_details} = Map.fetch(state, "user_details")
    #     Map.put(user_details, user_pid, %{})
    #     {:ok, followers} = Map.fetch(state, "")
    #
    #     if (length(followers) > 0) do
    #       Enum.each(followers, fun x -> _ = GenServer.cast(x, {:receive_tweet, self()})
    #         end)
    #     end
    #     {:noreply, state}
    # end

    def handle_call({:get_users}, _from, state) do
        {:reply, state["users"], state}
    end

    def handle_call({:get_followers, user_pid}, _from, state) do
        {:reply, state["user_details"][user_pid]["followers"], state}
    end

    # def handle_cast({:set_neighbors, neighbors}, state) do
    #     {:noreply, Map.put(state, "neighbors", neighbors)}
    # end
    #

end
