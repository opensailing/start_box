defmodule StartBox.Signal.Visual do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, []}
  end
  def handle_info(:cancel, _state), do: {:noreply, []}

  def handle_info({:run, signals}, _state) do
    send(self(), :next_signal)

    {:noreply, signals}
  end

  def handle_info(:next_signal, []), do: {:noreply, []}
end
