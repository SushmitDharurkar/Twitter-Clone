defmodule Project4 do

  def init_users(server) do
    total_users = 5
    Enum.map(1..total_users, fn x -> pid = spawn(Project4, :listen_for_tweets, [])
      Client.add_user(server, pid)
      pid 
    end)
  end 

  def add_random_followers(server, users) do
    total_users = length(users)
    max_followers = trunc(:math.ceil(total_users * 0.2))

    Enum.each(0..total_users - 1, fn index -> user = Enum.at(users, index)
      total_followers = Enum.random(1..max_followers)
      others = List.delete(users, user)
      followers = Enum.take_random(others, total_followers)
      Enum.each(followers, fn follower -> Client.add_follower(server, user, follower) end)
    end)
  end

  def send_tweet(server, users) do
    Enum.each(users, fn user -> 
      tweet = "This is #mytweet some tweet #sometweet @sushmit @sanket"
      hashtags = extract_data(tweet, "#(\\S+)") #Extract hashtags in a tweet
      mentions = extract_data(tweet, "@(\\S+)") #Extract mentions in a tweet
      Client.send_tweet(server, user, tweet, hashtags, mentions)
    end)
  end

  def extract_data(tweet, regex) do
    {:ok, pattern} = Regex.compile(regex)
    matches = Regex.scan(pattern, tweet)
    Enum.map(matches, fn match -> Enum.at(match, 0) end)
  end

  def main(args \\ []) do

    {_, server} = Client.start_link("")

    users = init_users(server)
    IO.inspect(users)
    add_random_followers(server, users)
    send_tweet(server, users)
    Client.print_state(server)

    """
    user_pid1 = spawn(Project4, :listen_for_tweets, [])

    Client.add_user(server, user_pid1)

    user_pid2 = spawn(Project4, :listen_for_tweets, [])

    Client.add_user(server, user_pid2)

    user_pid3 = spawn(Project4, :listen_for_tweets, [])
    
    Client.add_user(server, user_pid3)

    Client.add_follower(server, user_pid1, user_pid2)

    Client.add_follower(server, user_pid1, user_pid3)

    Client.add_follower(server, user_pid2, user_pid3)

    IO.inspect(Client.get_users(server), label: "Users: ")

    # IO.inspect(Client.get_followers(server, user_pid1), label: "Followers: ")

    Client.send_tweet(server, user_pid1, "First tweet!!")

    Client.send_tweet(server, user_pid2, "Second tweet!!")

    Client.send_tweet(server, user_pid1, "Third tweet!!")

    """

    receive do
      msg -> IO.puts(msg)
    end

  end

  #NOTE Elixir does not have nested functions
  def listen_for_tweets() do
    #Receiving tweet from user following
    receive do
      {:tweet, tweet} -> #IO.inspect(tweet)
    end
    listen_for_tweets()
  end

end
