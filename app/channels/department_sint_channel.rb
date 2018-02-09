class DepartmentSintChannel < ApplicationCable::Channel
  def subscribed
    if current_user.departments_of_interest.include?('SINT')
      stream_from "department_sint_channel"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
