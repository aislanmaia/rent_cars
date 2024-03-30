defmodule RentCars.Repo.Migrations.CreateCarsImages do
  use Ecto.Migration

  def change do
    create table(:cars_images, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :image, :string

      add :car_id,
          references(:cars, on_delete: :delete_all, on_update: :update_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:cars_images, [:car_id])
  end
end
