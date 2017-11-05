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

    receive do
      msg -> IO.puts(msg)
    end

  end

end
