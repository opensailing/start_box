defmodule StartBox.Racer do
  use GenServer

  @one_minute 60 * 1_000
  @thirty_seconds 30 * 1_000
  # @twenty_seconds 20 * 1_000
  @fifteen_seconds 15 * 1_000
  @ten_seconds 10 * 1_000
  @five_seconds 5 * 1_000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_info(:cancel, _state), do: {:noreply, []}

  def handle_info({:race, :"3_minute"}, _state) do
    script = [
      # {:print, "03:00", 0},
      {:countdown, 15, 0},
      {:alert, [sound: List.duplicate(:short, 5)], @fifteen_seconds},
      {:countdown, 3 * 60, 0},
      # 3 minutes
      {:signal, [sound: [:long, :long, :long]], @one_minute},
      # 2 minutes
      {:signal, [sound: [:long, :long]], @thirty_seconds},
      # 1 minute, 30 seconds
      {:signal, [sound: [:long, :short, :short, :short]], @thirty_seconds},
      # 1 minute
      {:signal, [sound: [:long]], @thirty_seconds},
      # 30 seconds
      {:signal, [sound: [:short, :short, :short]], @ten_seconds},
      # 20 seconds
      {:signal, [sound: [:short, :short]], @ten_seconds},
      # 10 seconds
      {:signal, [sound: [:short]], @five_seconds},
      # 5 seconds
      {:signal, [sound: [:short]], 1_000},
      # 4 seconds
      {:signal, [sound: [:short]], 1_000},
      # 3 seconds
      {:signal, [sound: [:short]], 1_000},
      # 2 seconds
      {:signal, [sound: [:short]], 1_000},
      # 1 seconds
      {:signal, [sound: [:short]], 1_000},
      # race started
      {:signal, [sound: [:long]], 0}
    ]

    send(self(), :run)

    {:noreply, script}
  end

  def handle_info(:run, []), do: {:noreply, []}
  def handle_info(:run, [{command, data, wait} | script]) do
    handle_step(command, data)
    Process.send_after(self(), :run, wait)
    {:noreply, script}
  end

  def handle_step(:alert, signals) do
    StartBox.Signal.run(signals)
  end
  def handle_step(:print, message) do
    send(StartBox.Printer, {:message, message})
  end
  def handle_step(:countdown, seconds) do
    send(StartBox.Timer, {:start, seconds})
  end
  def handle_step(:signal, signals) do
    StartBox.Signal.run(signals)
  end
end
