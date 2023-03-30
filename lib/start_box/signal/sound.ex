defmodule StartBox.Signal.Sound do
  use GenServer

  @pause 250
  @short 125
  @long 1_000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, gpio_relay} = Circuits.GPIO.open(22, :output)

    {:ok, {[], gpio_relay}}
  end

  def handle_info(:cancel, {_signals, gpio_relay}), do: {:noreply, {[], gpio_relay}}

  def handle_info({:run, signals}, {_signals, gpio_relay}) do
    send(self(), :next_signal)

    {:noreply, {signals, gpio_relay}}
  end

  def handle_info(:next_signal, {[], gpio_relay}), do: {:noreply, {[], gpio_relay}}

  def handle_info(:next_signal, {[signal | signals], gpio_relay}) do
    send(StartBox.Printer, {:message, signal})
    Circuits.GPIO.write(gpio_relay, 1)
    :timer.sleep(signal_length(signal))
    Circuits.GPIO.write(gpio_relay, 0)

    Process.send_after(self(), :next_signal, @pause)

    {:noreply, {signals, gpio_relay}}
  end

  defp signal_length(:short), do: @short
  defp signal_length(:long), do: @long
end
