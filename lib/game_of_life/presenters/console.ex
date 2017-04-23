defmodule GameOfLife.Presenters.Console do
  @doc """
  Print cells to the console output.
  Board is visible only for specified size for x and y.
  Start x and y are in top left corner of the board.

  `x_padding` Must be a prime number. Every x divided by the prime number
  will be visible on x axis.
  `y_padding` Any number. Padding for numbers on y axis.
  """
  alias GameOfLife.GameState
  alias GameOfLife.Presenters

  def print(%GameState{} = state, %Presenters{} = dims \\ %Presenters{}) do
    for y <- Presenters.y_range(dims), x <- Presenters.x_range(dims) do
      # draw y axis
      if x == dims.start_x do
        (y
        |> Integer.to_string
        |> String.rjust(dims.y_padding)) <> "| "
        |> IO.write
      end

      IO.write(if Enum.member?(state.cells, {x, y}), do: "O", else: ",")
      if x == Presenters.end_x(dims), do: IO.puts ""
    end

    # draw x axis
    IO.write String.rjust("| ", dims.y_padding + 2)
    x_length = (round((Presenters.end_x(dims)-dims.start_x)/2))
    for _x <- 0..x_length, do: IO.write "_ "
    IO.puts ""
    IO.write String.rjust("/  ", dims.y_padding + 2)
    for x <- Presenters.x_range(dims) do
      if rem(x, dims.x_padding) == 0 do
        x
        |> Integer.to_string
        |> String.ljust(dims.x_padding)
        |> IO.write
      end
    end
    IO.puts ""
    IO.puts "Generation: #{state.generation_counter}"
    IO.puts "Alive cells: #{GameState.alive_counter(state)}"
  end
end
