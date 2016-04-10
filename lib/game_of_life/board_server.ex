defmodule GameOfLife.BoardServer do
  use GenServer

  @name {:global, __MODULE__}

  # Client

  def start_link(alive_cells) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, alive_cells, name: @name)
  end

  def alive_cells do
    GenServer.call(@name, :alive_cells)
  end

  def tick do
    GenServer.cast(@name, :tick)
  end

  def print_board do
    GameOfLife.Presenters.Console.print(alive_cells)
  end

  # Server (callbacks)

  def handle_call(:alive_cells, _from, alive_cells) do
    {:reply, alive_cells, alive_cells}
  end

  def handle_cast(:tick, alive_cells) do
    keep_alive_task = Task.async(GameOfLife.Board, :keep_alive_tick, [alive_cells])
    become_alive_task = Task.async(fn ->
      dead_neighbours = GameOfLife.Cell.dead_neighbours(alive_cells)
      GameOfLife.Board.become_alive_tick(alive_cells, dead_neighbours)
    end)

    keep_alive_cells = Task.await(keep_alive_task)
    born_cells = Task.await(become_alive_task)

    alive_cells = keep_alive_cells ++ born_cells

    {:noreply, alive_cells}
  end
end
