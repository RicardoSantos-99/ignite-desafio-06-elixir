defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Bookings.Booking

  def create(filename \\ "report.csv") do
    order_list = build_booking_list()

    File.write(filename, order_list)
  end

  defp build_booking_list() do
    {:ok, bookings} = BookingAgent.get_all()

    bookings
    |> Map.values()
    |> Enum.map(&order_string/1)
  end

  defp order_string(%Booking{
         complete_date: complete_date,
         id: _id,
         local_destination: local_destination,
         local_origin: local_origin,
         user_id: user_id
       }) do
    user_name = get_user_name(user_id)

    "#{user_id},#{user_name},#{local_origin},#{local_destination},#{complete_date}\n"
  end

  def get_user_name(user_id) do
    {:ok, users} = UserAgent.get_all()

    users =
      users
      |> Map.values()
      |> Enum.filter(fn user -> user.id == user_id end)

    user = hd(users)

    user.name
  end
end
