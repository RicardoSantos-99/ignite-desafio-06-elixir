defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def create(date_init, date_final, filename \\ "report.csv") do
    order_list = build_booking_list(date_init, date_final)

    File.write(filename, order_list)
  end

  defp build_booking_list(date_init, date_final) do
    {:ok, bookings} = BookingAgent.get_all()

    bookings
    |> Map.values()
    |> Enum.map(&filter_by_dates(&1, date_init, date_final))
    |> Enum.filter(&is_struct(&1))
    |> Enum.map(&order_string/1)
  end

  defp order_string(%Booking{
         complete_date: complete_date,
         id: _id,
         local_destination: local_destination,
         local_origin: local_origin,
         user_id: user_id
       }) do
    "#{user_id},#{local_origin},#{local_destination},#{complete_date}\n"
  end

  defp filter_by_dates(booking, date_init, date_final) do
    booking
    |> validate_date(date_init, date_final)
  end

  defp validate_date(booking, date_init, date_final) do
    date_init = NaiveDateTime.compare(booking.complete_date, date_init)
    date_final = NaiveDateTime.compare(booking.complete_date, date_final)

    if date_init == :gt and date_final == :lt do
      booking
    end
  end
end
