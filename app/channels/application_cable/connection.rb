module ApplicationCable
  class Connection < ActionCable::Connection::Base
  	identified_by :current_user
 
    def connect
    	puts('hello connected :)')
      # puts(params[:room])
      # self.current_user = find_verified_user

    end

    def send_message(data)
      puts('hi')
    end
   
 
    private
      def find_verified_user
        if verified_user = User.find_by(id: current_user.id)
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  
  end
end
