module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verfied_user
    end

    protected

    def find_verfied_user
      if request.session['cas']
        if current_user = User.find_by(username: request.session['cas']['user'].downcase)
          current_user
        else
          reject_unauthorized_connection
        end
      else
        reject_unauthorized_connection
      end
    end
  end
end
