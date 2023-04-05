defmodule StartBox.ButtonLight do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, gpio_button_light} = Circuits.GPIO.open(5, :output)

    Circuits.GPIO.write(gpio_button_light, 1)
    send(StartBox.Printer, {:message, "StartBox Ready"})
    {:ok, gpio_button_light}
  end
end
