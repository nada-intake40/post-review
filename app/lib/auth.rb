require 'digest'
module Auth 
    def check_token
    token=request.headers["HTTP_ACCESS_TOKEN"]
    user=request.headers["HTTP_USER_ID"]
     
      @user=UserToken.find_by_access_token(token)
      createdTime = @user.created_at
      dateTimeNow = DateTime.now.utc
      diffTime = (dateTimeNow.to_i - createdTime.to_i) / (60 * 60 * 24)

      if(diffTime < 1)
       return "200"
      elsif(diffTime >= 1 && diffTime < 2)
       refresh_token(user)
      else
        return "400"
      end

    end

    def refresh_token(user)
        user = PromoterToken.find_by(user_id: user)
        new_access_token =  access_token:Digest::MD5.hexdigest(String(Time.now))
        user.access_token = new_access_token
        user.save
    end


  def generate_user_token(promoter_id)
    promoter=Promoter.find(promoter_id)
    # project=Project.find(promoter.retail_company_branch.retail_company.project_id)

    # date_time_string="#{Date.current.tomorrow.strftime("%Y-%m-%d")} #{(project.shift_end_in+2*60*60).strftime("%H:%M:%S")}"
    token=PromoterToken.new({promoter_id:promoter_id,
      token:Digest::MD5.hexdigest(String(Time.now)),
      expiration_time: Date.today.end_of_day + 6.hours
    })
    token.save
    return token
  end
end
