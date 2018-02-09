class DepartmentChannel < ApplicationCable::Channel
  def subscribed
    # changes to departments_of_interest or selected departments would not affect subscriptions until the next time they sign in with this setup.
    if current_user.departments_of_interest.include?('BIS')
      stream_from "department_channel_BIS"
    end
    if current_user.departments_of_interest.include?('COMM')
      stream_from "department_channel_COMM"
    end
    if current_user.departments_of_interest.include?('CRIM')
      stream_from "department_channel_CRIM"
    end
    if current_user.departments_of_interest.include?('CULT')
      stream_from "department_channel_CULT"
    end
    if current_user.departments_of_interest.include?('ECON')
      stream_from "department_channel_ECON"
    end
    if current_user.departments_of_interest.include?('ENGL')
      stream_from "department_channel_ENGL"
    end
    if current_user.departments_of_interest.include?('HE')
      stream_from "department_channel_HIST"
    end
    if current_user.departments_of_interest.include?('HIST')
      stream_from "department_channel_HIST"
    end
    if current_user.departments_of_interest.include?('HNRS')
      stream_from "department_channel_HNRS"
    end
    if current_user.departments_of_interest.include?('LA')
      stream_from "department_channel_LA"
    end
    if current_user.departments_of_interest.include?('MAIS')
      stream_from "department_channel_MAIS"
    end
    if current_user.departments_of_interest.include?('MCL')
      stream_from "department_channel_MCL"
    end
    if current_user.departments_of_interest.include?('PHIL')
      stream_from "department_channel_PHIL"
    end
    if current_user.departments_of_interest.include?('PSYC')
      stream_from "department_channel_RELI"
    end
    if current_user.departments_of_interest.include?('RELI')
      stream_from "department_channel_RELI"
    end
    if current_user.departments_of_interest.include?('SINT')
      stream_from "department_channel_SINT"
    end
    if current_user.departments_of_interest.include?('SOAN')
      stream_from "department_channel_SOAN"
    end
    if current_user.departments_of_interest.include?('WMST')
      stream_from "department_channel_WMST"
    end
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
