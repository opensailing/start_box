defmodule StartBox.Signal do
  def run(signals) do
    sound_signals = Keyword.get(signals, :sound, [])
    visual_signals = Keyword.get(signals, :visual, [])

    send(StartBox.Signal.Sound, {:run, sound_signals})
    send(StartBox.Signal.Visual, {:run, visual_signals})
  end
end
