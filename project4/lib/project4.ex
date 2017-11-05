defmodule Project4 do

  def main(args \\ []) do

    {_, server} = Client.start_link("")
    # IO.inspect(server)
    user_pid = spawn(fn -> 1 end) #This process ends after function executes
    # IO.inspect()

    IO.inspect(Client.add_user(server, user_pid))
  end

end
