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
    send(self(), :run)
    {:noreply, seconds}
  end

  def handle_info(:run, state) when state in [nil, -1], do: {:noreply, nil}
  def handle_info(:run, seconds) do
    print_time(seconds)
    Process.send_after(self(), :run, 1_000)
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
