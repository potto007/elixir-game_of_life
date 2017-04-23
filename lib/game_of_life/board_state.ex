defmodule GameOfLife.BoardState do
  alias GameOfLife.BoardState
  alias GameOfLife.TRef

  defstruct alive_cells: [], tref: nil, generation_counter: 0
  @type t :: %BoardState{alive_cells: [{integer, integer}], tref: TRef.t, generation_counter: integer}

  @spec new([{integer, integer}], TRef.t | nil, integer) :: BoardState.t
  def new(alive_cells, tref, generation_counter) do
    %BoardState{alive_cells: alive_cells,
                tref: tref,
                generation_counter: generation_counter}
  end
end
