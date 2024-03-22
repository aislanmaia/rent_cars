defmodule RentCarsWeb.Api.CarJSON do
  alias RentCarsWeb.Api.Admin.CarJSON

  def index(%{cars: cars}) do
    %{data: for(car <- cars, do: CarJSON.show(%{car: car}))}
  end

  def show(%{car: car}), do: %{data: CarJSON.show(%{car: car})}
end
