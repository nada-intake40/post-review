class UpdateLocation < ApplicationCable::Channel
	include  MapHelper,PromoterHelper
  # Called when the consumer has successfully
  # become a subscriber to this channel.
  def subscribed
    stream_from "UpdateLocation_#{params[:room]}"
    # promoters_array = Promoter.left_outer_joins(:promoter_check_in).where(retail_company_branch_id:params[:room]).select('promoter_check_ins.latitude','promoter_check_ins.longitude',:id,:username)
    # ActionCable.server.broadcast( "UpdateLocation_#{params[:room]}", { promoters_array:promoters_array})
    # puts(promoters_array)
    # puts(params[:room])

  end
  
  def unsubscribed
  end
  
  def connected

  	puts('heloooooooooooooooooooooooooooooooooooooooo')
  	# puts(params[:room])
  end

  def receive(data)
  	puts('recieeeevedddd')
  # 	promoter=Promoter.find(data['promoter_id'])

  # 	range=get_project_day_range(promoter.retail_company_branch.retail_company.project_id)
  # 	if ( ! is_promoter_inside(data['lat'],data['long'],data['branch_id']) )
		# check_in=PromoterCheckIn.find_by(promoter_id:data['promoter_id'],created_at: range[:created_at])
		# 	# .where(get_project_day_range(promoter.retail_company_branch.retail_company.project_id))
		# check_in.check_in_state_id = 2
		# check_in.save
  # 	end
	# puts(data)
    ActionCable.server.broadcast( "UpdateLocation_#{ data['branch_id'] }", { lat: data['lat'], long: data['long'] , promoter_id: data['promoter_id']})

  end


end
