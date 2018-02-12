class DepartmentChannel < ApplicationCable::Channel
  def subscribed
    # changes to departments_of_interest or selected departments would not affect subscriptions until the next time they sign in with this setup.
    if current_user.show_alerts('BIS')
      stream_from "department_channel_BIS"
    end
    if current_user.show_alerts('COMM')
      stream_from "department_channel_COMM"
    end
    if current_user.show_alerts('CRIM')
      stream_from "department_channel_CRIM"
    end
    if current_user.show_alerts('CULT')
      stream_from "department_channel_CULT"
    end
    if current_user.show_alerts('ECON')
      stream_from "department_channel_ECON"
    end
    if current_user.show_alerts('ENGL')
      stream_from "department_channel_ENGL"
    end
    if current_user.show_alerts('HE')
      stream_from "department_channel_HE"
    end
    if current_user.show_alerts('HIST')
      stream_from "department_channel_HIST"
    end
    if current_user.show_alerts('HNRS')
      stream_from "department_channel_HNRS"
    end
    if current_user.show_alerts('LA')
      stream_from "department_channel_LA"
    end
    if current_user.show_alerts('MAIS')
      stream_from "department_channel_MAIS"
    end
    if current_user.show_alerts('MCL')
      stream_from "department_channel_MCL"
    end
    if current_user.show_alerts('PHIL')
      stream_from "department_channel_PHIL"
    end
    if current_user.show_alerts('PSYC')
      stream_from "department_channel_PSYC"
    end
    if current_user.show_alerts('RELI')
      stream_from "department_channel_RELI"
    end
    if current_user.show_alerts('SINT')
      stream_from "department_channel_SINT"
    end
    if current_user.show_alerts('SOAN')
      stream_from "department_channel_SOAN"
    end
    if current_user.show_alerts('WMST')
      stream_from "department_channel_WMST"
    end
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
