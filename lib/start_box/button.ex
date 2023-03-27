defmodule StartBox.Button do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, :prestart}
  end

  def handle_info(:press, :prestart) do
    StartBox.race(3)
    {:noreply, :running}
  end

  def handle_info(:press, :running) do
    StartBox.abandon()
    {:noreply, :pre_start}
  end

  def handle_info(:reset, _state), do: {:noreply, :prestart}
end
