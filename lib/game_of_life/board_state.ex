defmodule GameOfLife.BoardState do
  alias GameOfLife.BoardState

  @type tref :: {atom, reference}

  defstruct alive_cells: 0, tref: nil, generation_counter: 0
  @type t :: %BoardState{alive_cells: integer, tref: tref, generation_counter: integer}

  @spec new(String.t, tref, number) :: BoardState.t
  def new(alive_cells, tref, generation_counter) do
    %BoardState{alive_cells: alive_cells,
                tref: tref,
                generation_counter: generation_counter}
  end

end
