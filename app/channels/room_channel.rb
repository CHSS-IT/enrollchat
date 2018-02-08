class RoomChannel < ApplicationCable::Channel
  def subscribed
    if current_user.departments_of_interest.include?('BIS')
      stream_from "room_channel"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
