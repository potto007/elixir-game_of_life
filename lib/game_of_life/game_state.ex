defmodule GameOfLife.GameState do
  alias GameOfLife.GameState

  defstruct cells: [], generation_counter: 0

  def alive_counter(%GameState{} = state) do
    state.cells |> Enum.count
  end
end
