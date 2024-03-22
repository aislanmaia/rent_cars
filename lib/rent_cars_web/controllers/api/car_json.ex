defmodule RentCarsWeb.Api.CarJSON do
  def index(%{cars: cars}) do
    %{data: for(car <- cars, do: RentCarsWeb.Api.Admin.CarJSON.show(%{car: car}))}
  end

  def show(%{car: car}), do: %{data: RentCarsWeb.Api.Admin.CarJSON.show(%{car: car})}
end
