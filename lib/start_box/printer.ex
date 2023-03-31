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
    print_message(message, Application.get_env(:start_box, :target))
    {:noreply, state}
  end

  defp print_message(message, :target) when is_binary(message) do
    Logger.info(message)
  end

  defp print_message(message, :host) when is_binary(message) do
    IO.puts(message)
  end

  defp print_message(message, target) do
    message
    |> inspect()
    |> print_message(target)
  end
end
