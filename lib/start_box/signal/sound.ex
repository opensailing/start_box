defmodule StartBox.Signal.Sound do
  use GenServer

  @pause 250
  @short 125
  @long 1_000

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
  def handle_info(:next_signal, [signal | signals]) do
    send(StartBox.Printer, {:message, signal})
    :timer.sleep(signal_length(signal))

    Process.send_after(self(), :next_signal, @pause)

    {:noreply, signals}
  end

  defp signal_length(:short), do: @short
  defp signal_length(:long), do: @long
end
