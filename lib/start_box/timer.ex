defmodule StartBox.Timer do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, {nil, nil}}
  end

  def handle_info(:cancel, {_start, timer_ref}), do: {:noreply, {-1, timer_ref}}

  def handle_info({:start, seconds}, {_seconds, timer_ref}) do
    cancel_timer(timer_ref)
    send(self(), :tick)
    {:noreply, {seconds, nil}}
  end

  def handle_info(:tick, {state, timer_ref}) when state in [nil, -1], do: {:noreply, {nil, timer_ref}}

  def handle_info(:tick, {seconds, _timer_ref}) do
    print_time(seconds)
    timer_ref = Process.send_after(self(), :tick, 1_000)
    {:noreply, {seconds - 1, timer_ref}}
  end

  def cancel_timer(nil), do: nil
  def cancel_timer(timer_ref), do: Process.cancel_timer(timer_ref)

  defp print_time(seconds) do
    minutes =
      (seconds / 60)
      |> Kernel.trunc()
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    seconds =
      seconds
      |> rem(60)
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    send(StartBox.Printer, {:message, "#{minutes}:#{seconds}"})
  end
end
