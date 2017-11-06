defmodule Project4 do

  def main(args \\ []) do

    {_, server} = Client.start_link("")
    # IO.inspect(server)

    #TODO Add recursion for continuos listening
    user_pid1 = spawn(fn ->
      #Receiving tweet from user following
      receive do
        {:tweet, tweet} -> IO.inspect(tweet)
      end
    end)
    # IO.inspect()
    Client.add_user(server, user_pid1)

    user_pid2 = spawn(fn ->
      #Receiving tweet from user following
      receive do
        {:tweet, tweet} -> IO.inspect(tweet)
      end
    end)
    # IO.inspect()
    Client.add_user(server, user_pid2)

    # IO.inspect()
    Client.add_follower(server, user_pid1, user_pid2)

    user_pid3 = spawn(fn ->
      #Receiving tweet from user following
      receive do
        {:tweet, tweet} -> IO.inspect(tweet)
      end
     end)
    # IO.inspect()
    Client.add_user(server, user_pid3)

    Client.add_follower(server, user_pid1, user_pid3)

    Client.add_follower(server, user_pid2, user_pid1)

    IO.inspect(Client.get_users(server), label: "Users: ")

    # IO.inspect(Client.get_followers(server, user_pid1), label: "Followers: ")

    Client.send_tweet(server, user_pid1, "First tweet!!")

    Client.send_tweet(server, user_pid2, "Second tweet!!")

    receive do
      msg -> IO.puts(msg)
    end

  end

end
