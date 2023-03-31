defmodule StartBox.Timer do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, nil}
  end

  def handle_info(:cancel, _start), do: {:noreply, -1}

  def handle_info({:start, seconds}, _state) do
    IO.puts("++ timer start ++")
    send(self(), :tick)
    {:noreply, seconds}
  end

  def handle_info(:tick, state) when state in [nil, -1] do
    IO.puts("-- timer end --")
    {:noreply, nil}
  end

  def handle_info(:tick, seconds) do
    print_time(seconds)
    Process.send_after(self(), :tick, 1_000)
    {:noreply, seconds - 1}
  end

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
