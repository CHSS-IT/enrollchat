class DepartmentChannel < ApplicationCable::Channel
  def subscribed
    if current_user.departments_of_interest.include?('BIS')
      stream_from "department_bis_channel"
    end
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
