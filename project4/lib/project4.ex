defmodule Project4 do

  def main(args \\ []) do

    {_, server} = Client.start_link("")
    # IO.inspect(server)
    user_pid1 = spawn(fn -> 1 end) #This process ends after function executes
    # IO.inspect()
    Client.add_user(server, user_pid1)

    user_pid2 = spawn(fn -> 2 end) #This process ends after function executes
    # IO.inspect()
    Client.add_user(server, user_pid2)

    # IO.inspect()
    Client.add_follower(server, user_pid1, user_pid2)

    user_pid3 = spawn(fn -> 3 end) #This process ends after function executes
    # IO.inspect()
    Client.add_user(server, user_pid3)

    Client.add_follower(server, user_pid1, user_pid3)

    IO.inspect(Client.get_users(server), label: "Users: ")

    IO.inspect(Client.get_followers(server, user_pid1), label: "Followers: ")

    receive do
      msg -> IO.puts(msg)
    end

  end

end
