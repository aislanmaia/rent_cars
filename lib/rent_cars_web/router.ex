defmodule RentCarsWeb.Router do
  use RentCarsWeb, :router
  alias RentCarsWeb.Middleware.EnsureAuthenticated
  alias RentCarsWeb.Middleware.IsAdmin

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RentCarsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :is_admin do
    plug IsAdmin
  end

  pipeline :authenticated do
    plug EnsureAuthenticated
  end

  scope "/", RentCarsWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  scope "/api", RentCarsWeb.Api, as: :api do
    pipe_through :api

    get "/cars", CarController, :index
    get "/cars/:id", CarController, :show

    scope "/admin", Admin, as: :admin do
      pipe_through :is_admin

      get "/users", UserController, :index

      resources "/categories", CategoryController
      post "/categories/import", CategoryController, :import

      resources "/specifications", SpecificationController
      post "/cars/", CarController, :create
      put "/cars/:id", CarController, :update
      get "/cars/:id", CarController, :show
      patch "/cars/:id/images", CarController, :create_images
    end

    scope "/" do
      pipe_through :authenticated
      post("/sessions/me", SessionController, :me)
      get "/users/:id", UserController, :show
      patch "/users/photo", UserController, :upload_photo

      get("/rentals", RentalController, :index)
      post("/rentals", RentalController, :create)
      post("/rentals/return/:id", RentalController, :return)
    end

    post "/users", UserController, :create
    post("/sessions", SessionController, :create)
    post("/sessions/forgot_password", SessionController, :forgot_password)
    post("/sessions/reset_password", SessionController, :reset_password)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:rent_cars, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RentCarsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
