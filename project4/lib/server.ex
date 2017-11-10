defmodule Server do
    use GenServer

    def init(:ok) do
        # {:ok, %{"users" => [pid1, pid2..], "hashtags" => %{}, "user_details" => %{pid => %{"tweets" => [], "followers" =>[], "notifications" => %{source_pid => [tweet1, ...]}}}}}
        {:ok, %{"users" => [], "user_details" => %{}, "hashtags" => %{}, "mentions" => %{}}}
    end

    def handle_cast({:add_user, user_pid}, state) do
        users = state["users"]
        state = Map.put(state, "users", [user_pid | users])
        user_details = Map.get(state, "user_details")
        user_details = Map.put(user_details, user_pid, %{"tweets" => [], "followers" => [], "notifications" => %{}})
        state = Map.put(state, "user_details", user_details)

        #  IO.inspect(state, label: "State after adding user: ")
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

        # IO.inspect(state, label: "State after adding follower: ")
        {:noreply, state}
    end

    def handle_cast({:send_tweet, user_pid, tweet, hashtags, mentions}, state) do
        user_details_pid = state["user_details"][user_pid]
        tweets = user_details_pid["tweets"]
        user_details_pid = Map.put(user_details_pid, "tweets", [tweet | tweets])
        user_details = state["user_details"]
        user_details = Map.put(user_details, user_pid, user_details_pid)
        state = Map.put(state, "user_details", user_details)

        # Update the hashtags map

        # %{"hashtags" => %{"hashtag": %{pid => []}}
    
        state = Enum.reduce(hashtags, state, fn(hashtag, state) -> 
            hashtags_map = state["hashtags"]
            if hashtags_map[hashtag] == nil do
                hashtags_map = Map.put(hashtags_map, hashtag, %{}) 
            end

            hashtag_details = hashtags_map[hashtag]   

            if(hashtag_details[user_pid] != nil) do
                hashtag_details = Map.put(hashtag_details, user_pid, [tweet | hashtag_details[user_pid]])
            else
                hashtag_details = Map.put(hashtag_details, user_pid, [tweet])    
            end
            
            hashtags_map = Map.put(hashtags_map, hashtag, hashtag_details)
            state = Map.put(state, "hashtags", hashtags_map) 
        end)

        # Update the mentions map
        # %{"mentions" => %{"mention": %{pid => []}}
    
        state = Enum.reduce(mentions, state, fn(mention, state) -> 

            mentions_map = state["mentions"]
            if mentions_map[mention] == nil do
                mentions_map = Map.put(mentions_map, mention, %{}) 
            end

            mention_details = mentions_map[mention]   

            if(mention_details[user_pid] != nil) do
                mention_details = Map.put(mention_details, user_pid, [tweet | mention_details[user_pid]])
            else
                mention_details = Map.put(mention_details, user_pid, [tweet])    
            end
            
            mentions_map = Map.put(mentions_map, mention, mention_details)
            state = Map.put(state, "mentions", mentions_map) 
        end)

        followers = state["user_details"][user_pid]["followers"]
        #Sending tweet to every follower and adding it to their notifications
        #NOTE Outside scope of state not accessed inside Enum - Use recursion or Enum.reduce()
        state = Enum.reduce(followers, state, fn(follower_pid, state) ->
          user_details_pid = state["user_details"][follower_pid]
          notifications = user_details_pid["notifications"]
          if notifications[user_pid] != nil do
              notifications = Map.put(notifications, user_pid, [tweet | notifications[user_pid]])
            else
              notifications = Map.put(notifications, user_pid, [tweet])
          end
          user_details_pid = Map.put(user_details_pid, "notifications", notifications)
          user_details = state["user_details"]
          user_details = Map.put(user_details, follower_pid, user_details_pid)
          send(follower_pid, {:tweet, [tweet] ++ ["Tweet from user: "] ++ [user_pid] ++ ["forwarded to follower: "] ++ [follower_pid] })
          state = Map.put(state, "user_details", user_details)
         end)

        # IO.inspect(state, label: "State after sending a tweet: ")
        {:noreply, state}
    end

    def handle_call({:get_users}, _from, state) do
        {:reply, state["users"], state}
    end

    def handle_call({:get_followers, user_pid}, _from, state) do
        {:reply, state["user_details"][user_pid]["followers"], state}
    end

    def handle_cast(:print_state, state) do
      IO.inspect(state)
      {:noreply, state}
    end
    

end
