defmodule StartBox.Printer do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, nil}
  end

  def handle_info({:message, message}, state) do
    IO.puts(message)
    {:noreply, state}
  end
end
