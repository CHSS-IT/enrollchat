class DepartmentChannel < ApplicationCable::Channel
  def subscribed
    Section.department_list.each do |department|
      if current_user.show_alerts(department)
        stream_from "department_channel_#{department}"
      end
    end
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
