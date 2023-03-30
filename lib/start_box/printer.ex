defmodule StartBox.Printer do
  use GenServer

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, nil}
  end

  def handle_info({:message, message}, state) do
    print_message(message)
    {:noreply, state}
  end

  defp print_message(message) when is_binary(message) do
    Logger.info(message)
  end

  defp print_message(message) do
    message
    |> inspect()
    |> print_message()
  end
end
