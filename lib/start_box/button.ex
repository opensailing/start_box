defmodule StartBox.Button do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, gpio_button} = Circuits.GPIO.open(17, :input)

    Circuits.GPIO.set_interrupts(gpio_button, :both)
    {:ok, {:prestart, gpio_button}}
  end

  def handle_info(:press, {:prestart, button_pid}) do
    StartBox.race(3)
    {:noreply, {:running, button_pid}}
  end

  def handle_info(:press, {:running, button_pid}) do
    StartBox.abandon()
    {:noreply, {:pre_start, button_pid}}
  end

  def handle_info(:reset, {_state, button_pid}), do: {:noreply, {:prestart, button_pid}}

  def handle_info({:circuits_gpio, 17, _, 1}, state) do
    send(self(), :press)

    {:noreply, state}
  end

  def handle_info({:circuits_gpio, 17, _, 0}, state) do
    Logger.info("17 - 0")

    {:noreply, state}
  end

  def handle_info({:circuits_gpio, 27, _, _}, state), do: {:noreply, state}
end
