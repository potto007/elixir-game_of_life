defmodule GameOfLife.Presenters do
  alias GameOfLife.Presenters

  defstruct start_x: -10, x_size: 60, x_padding: 5,
            start_y:  15, y_size: 20, y_padding: 5

  def end_x(%Presenters{} = dims) do
    dims.start_x + dims.x_size
  end

  def end_y(%Presenters{} = dims) do
    dims.start_y - dims.y_size
  end

  def x_range(%Presenters{} = dims) do
    dims.start_x..end_x(dims)
  end

  def y_range(%Presenters{} = dims) do
    dims.start_y..end_y(dims)
  end
end
