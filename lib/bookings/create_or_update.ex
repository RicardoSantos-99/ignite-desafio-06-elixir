defmodule Flightex.Bookings.CreateOrUpdate do
  alias Flightex.Bookings.Booking
  alias Flightex.Bookings.Agent, as: BookingsAgent

  def call(%{
        complete_date: complete_date,
        local_origin: local_origin,
        local_destination: local_destination,
        user_id: user_id
      }) do
    with {:ok, booking} <- Booking.build(complete_date, local_origin, local_destination, user_id) do
      BookingsAgent.save(booking)
    else
      error -> error
    end
  end
end
