defmodule StartBox do
  @codes %{
    3 => :"3_minute"
  }

  def race(code) do
    send(StartBox.Racer, {:race, lookup(code)})
  end

  def abandon do
    send(StartBox.Timer, :cancel)
    send(StartBox.Printer, {:message, ""})
    send(StartBox.Button, :reset)
    send(StartBox.Racer, :cancel)
    send(StartBox.Signal.Sound, {:run, [:short, :short, :short]})
    send(StartBox.Signal.Visual, :cancel)
  end

  def press_button() do
    send(StartBox.Button, :press)
  end

  defp lookup(code), do: Map.get(@codes, code)
end
