defmodule Project4 do

  def main(args \\ []) do

    {_, server} = Client.start_link("")
    # IO.inspect(server)

    user_pid1 = spawn(Project4, :listen_for_tweets, [])
    # IO.inspect()
    Client.add_user(server, user_pid1)

    user_pid2 = spawn(Project4, :listen_for_tweets, [])
    # IO.inspect()
    Client.add_user(server, user_pid2)

    # IO.inspect()
    Client.add_follower(server, user_pid1, user_pid2)

    user_pid3 = spawn(Project4, :listen_for_tweets, [])
    # IO.inspect()
    Client.add_user(server, user_pid3)

    Client.add_follower(server, user_pid1, user_pid3)

    Client.add_follower(server, user_pid2, user_pid3)

    IO.inspect(Client.get_users(server), label: "Users: ")

    # IO.inspect(Client.get_followers(server, user_pid1), label: "Followers: ")

    Client.send_tweet(server, user_pid1, "First tweet!!")

    Client.send_tweet(server, user_pid2, "Second tweet!!")

    Client.send_tweet(server, user_pid1, "Third tweet!!")

    receive do
      msg -> IO.puts(msg)
    end

  end

  #NOTE Elixir does not have nested functions
  def listen_for_tweets() do
    #Receiving tweet from user following
    receive do
      {:tweet, tweet} -> IO.inspect(tweet)
    end
    listen_for_tweets()
  end

end
