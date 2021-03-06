defmodule TcpServer do
  use GenServer

  def start_link() do
    ip = Application.get_env :tcp_server, :ip, {127,6,3,0}
    port = Application.get_env :tcp_server, :port, 6666
    GenServer.start_link(__MODULE__, [ip, port], [])
  end

  def init [ip,port] do
    {:ok, listen_socket}= :gen_tcp.listen(port,[:binary, {:packet, 0},{:active,true},{:ip,ip}])
    {:ok, socket } = :gen_tcp.accept listen_socket
    {:ok, %{ip: ip, port: port, socket: socket}}
  end

  def handle_info({:tcp, socket, packet},state) do
    IO.inspect packet, label: "incoming packet"
    :gen_tcp.send socket,"Hi Blackode \n"
    {:noreply, state}
  end

  def handle_info({:tcp_closed, _socket}, state) do
    IO.inspect "Socket has been closed"
    {:noreply, state}
  end

  def handle_info({:tcp_error, socket, reason}, state) do
    IO.inspect socket, label: "connection closed dut to #{reason}"
    {:noreply, state}
  end

end