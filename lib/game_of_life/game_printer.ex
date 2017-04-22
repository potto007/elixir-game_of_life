defmodule GameOfLife.GamePrinter do
  @moduledoc """
  ## Example
      iex> GameOfLife.GamePrinter.start_printing_board
      :printing_started
      iex> GameOfLife.GamePrinter.start_printing_board
      :already_printing
      iex> GameOfLife.GamePrinter.stop_printing_board
      :printing_stopped
      iex> GameOfLife.GamePrinter.stop_printing_board
      :already_stopped
  """

  @print_speed 1000

  def start_link do
    Agent.start_link(fn -> nil end, name: __MODULE__)
  end

  def start_sdl_board do
    Agent.get_and_update(__MODULE__, __MODULE__, :do_start_sdl_board, [])
  end

  def start_printing_board do
    Agent.get_and_update(__MODULE__, __MODULE__, :do_start_printing_board, [])
  end

  def do_start_sdl_board(nil = _tref) do
    GameOfLife.Presenters.SDL.Window.start()
    # {:ok, tref} = :time.apply_interval(@print_speed, __MODULE__, :update_board, [])
    {:sdl_updates_started, nil}
  end

  def do_start_sdl_board(tref), do: {:already_displaying_board, tref}

  def update_board do
    {alive_cells, generation_counter} = GameOfLife.BoardServer.state
    alive_counter = alive_cells |> Enum.count
    GameOfLife.Presenters.SDL.Renderer.update(alive_cells, generation_counter, alive_counter)
  end

  def stop_sdl_board do
    Agent.get_and_update(__MODULE__, __MODULE__, :do_stop_sdl_board, [])
  end

  def do_stop_sdl_board(nil = _tref), do: {:already_stopped, nil}

  def do_stop_sdl_board(tref) do
    {:ok, :cancel} = :timer.cancel(tref)
    {:sdl_updates_stopped, nil}
  end

  def do_start_printing_board(nil = _tref) do
    {:ok, tref} = :timer.apply_interval(@print_speed, __MODULE__, :print_board, [])
    {:printing_started, tref}
  end

  def do_start_printing_board(tref), do: {:already_printing, tref}

  def print_board do
    GameOfLife.BoardServer.state()
    |> GameOfLife.Presenters.Console.print()
  end

  def old_print_board do
    {alive_cells, generation_counter} = GameOfLife.BoardServer.state
    alive_counter = alive_cells |> Enum.count
    GameOfLife.Presenters.Console.print(alive_cells, generation_counter, alive_counter)
  end

  def stop_printing_board do
    Agent.get_and_update(__MODULE__, __MODULE__, :do_stop_printing_board, [])
  end

  def do_stop_printing_board(nil = _tref), do: {:already_stopped, nil}

  def do_stop_printing_board(tref) do
    {:ok, :cancel} = :timer.cancel(tref)
    {:printing_stopped, nil}
  end
end
