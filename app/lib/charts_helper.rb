module ChartsHelper
	def get_date_range(start_date_string,end_date_string,project_id)
		if (start_date_string==""||!start_date_string)
			project=Project.find(project_id)
			start_date=Date.today-7
		else
			start_date=Date.parse(start_date_string)
		end

		if (end_date_string==""||!end_date_string)
			end_date=Date.today
		else
			end_date=Date.parse(end_date_string)
		end
		date_array={}
		date_array["date_range"]=start_date .. end_date
		date_array["date_range_formatted"]=date_array["date_range"].map { |date| date.strftime("%Y-%m-%d") }
		return date_array["date_range_formatted"]
	end

	def get_devices_in_project(project_id,device_id,start_date_string,end_date_string)
		if (start_date_string==""||!start_date_string)
			project=Project.find(project_id)
			start_date=Date.today-7
		else
			start_date=Date.parse(start_date_string)
		end

		if (end_date_string==""||!end_date_string)
			end_date=Date.today
		else
			end_date=Date.parse(end_date_string)
		end
		if(device_id)
			Device.joins(:invoice_devices,item: [:brand,:category]) 
			.where(brands:{project_id: project_id})
			.where(invoice_devices:{created_at: start_date.beginning_of_day .. end_date.end_of_day })
			.where("devices.id =#{params[:device_id]}")
			
		else
			Device.joins(:invoice_devices,item: [:brand,:category]) 
			.where(brands:{project_id: project_id})
			.where(invoice_devices:{created_at: start_date.beginning_of_day .. end_date.end_of_day })
			.where("invoice_devices.quantity > 0")

		end

	end



	def get_items_in_project(project_id,start_date_string,end_date_string)
		if (start_date_string==""||!start_date_string)
			project=Project.find(project_id)
			start_date=Date.today-7
		else
			start_date=Date.parse(start_date_string)
		end

		if (end_date_string==""||!end_date_string)
			end_date=Date.today
		else
			end_date=Date.parse(end_date_string)
		end

		Item.joins(:brand)
		.joins(devices: :invoice_devices)
		.where(brands:{project_id: project_id})
		.where(invoice_devices:{created_at: start_date.beginning_of_day .. end_date.end_of_day })
		.where("invoice_devices.quantity > 0")

	end


	def item_sales_in_date_range(item,date_range,filter)
		branch_conditions = {}
		retail_conditions = {}
		city_conditions = {}
	    retail_conditions[:id] = filter[:retail_id].blank? ?  RetailCompany.where(project_id:current_user.project_id).map(&:id) : filter[:retail_id] 
	    city_conditions[:id] = filter[:city_id].blank? ? City.where(project_id:current_user.project_id).map(&:id) :  filter[:city_id]
	    branch_conditions[:id] = filter[:branch_id].blank? ? RetailCompanyBranch.joins(:retail_company)
	    .where(retail_companies: {project_id: current_user.project_id}).map(&:id) : filter[:branch_id]

		item_obj={}
		item_obj["name"]=item.item_name
		item_obj["data"]=date_range.map { |date_string| 
			date=Date.parse(date_string) 
			InvoiceDevice.joins(device: :item)
			.joins(invoice: {retail_company_branch: [:retail_company,:city]})
			.where("items.id=#{item.id}")
			.where(invoice_devices:{created_at:date.beginning_of_day .. date.end_of_day})
			.where(retail_company_branches:branch_conditions)
			.where(retail_companies: {project_id: current_user.project_id})
			.where(retail_company_branches: branch_conditions)
			.where(cities: city_conditions)
			.sum(:quantity)
			
		}
		return item_obj
	end

	def device_sales_in_date_range(device,date_range,filter)
		branch_conditions = {}
		retail_conditions = {}
		city_conditions = {}
		brand_conditions={}
		category_conditions={}
		device_conditions={}
		item_conditions={}
	    retail_conditions[:id] = filter[:retail_id].blank? ?  RetailCompany.where(project_id: current_user.project_id).map(&:id) : filter[:retail_id] 
	    city_conditions[:id] = filter[:city_id].blank? ? City.where(project_id:current_user.project_id).map(&:id) :  filter[:city_id]
	    branch_conditions[:id] = filter[:branch_id].blank? ? RetailCompanyBranch.joins(:retail_company).where(retail_companies: {project_id: current_user.project_id}).map(&:id) : filter[:branch_id]

		brand_conditions[:id] = filter[:brand_id].blank? ? Brand.where(project_id:current_user.project_id).map(&:id) :  filter[:brand_id]
		category_conditions[:id] = filter[:category_id].blank? ? Category.where(project_id:current_user.project_id).map(&:id) :  filter[:category_id]
	    item_conditions[:id] = filter[:item_id].blank? ? Item.joins(:brand,:category).where(brands: {project_id: current_user.project_id}).where(categories: {project_id: current_user.project_id}).map(&:id) :  filter[:item_id]
		device_conditions[:id] = filter[:device_id].blank? ? Device.joins(item: [:brand,:category]).where(brands: {project_id: current_user.project_id}).where(categories: {project_id: current_user.project_id}).map(&:id) :  filter[:device_id]
		device_obj={}
		device_obj["name"]=device.device_name
		device_obj["data"]=date_range.map { |date_string| 
			date=Date.parse(date_string) 
			InvoiceDevice.joins(device: {item: [:category,:brand]})
			.joins(invoice: {retail_company_branch: [:retail_company,:city]})
			.where("devices.id=#{device.id}")
			.where(invoice_devices:{created_at:date.beginning_of_day .. date.end_of_day})
			.where(retail_company_branches:branch_conditions)
			.where(retail_companies: {project_id: current_user.project_id})
			.where(retail_company_branches: branch_conditions)
			.where(cities: city_conditions)
			.where(brands:brand_conditions)
			.where(categories:category_conditions)
			.where(items:item_conditions)
			.sum(:quantity)
			
		}
		return device_obj
	end

	def item_stock_in_date_range(item,date_range,filter)
		branch_conditions = {}
		retail_conditions = {}
		city_conditions = {}
	    retail_conditions[:id] = filter[:retail_id].blank? ?  RetailCompany.where(project_id:current_user.project_id).map(&:id) : filter[:retail_id] 
	    city_conditions[:id] = filter[:city_id].blank? ? City.where(project_id:current_user.project_id).map(&:id) :  filter[:city_id]
	    branch_conditions[:id] = filter[:branch_id].blank? ? RetailCompanyBranch.joins(:retail_company)
	    .where(retail_companies: {project_id: current_user.project_id}).map(&:id) : filter[:branch_id]

		item_obj={}
		item_obj["name"]=item.item_name
		item_obj["data"]=date_range.map { |date_string|

			date=Date.parse(date_string) 
			# print('hhhhhhhhhhhhhhhhhkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk')
 		# 	print(date)
			 BranchDevice.joins(device: :item)
			.joins(retail_company_branch: [:retail_company,:city])
			.where("items.id=#{item.id}")
			.where(branch_devices:{created_at:date.beginning_of_day .. date.end_of_day})
			.where(retail_company_branches:branch_conditions)
			.where(retail_companies: {project_id: current_user.project_id})
			.where(cities: city_conditions)
			.sum(:quantity)
						# .select("sum(branch_devices.quantity) as total_no")

			
				
			
		}
		# item_obj["data"].map { |item|
		# if (item != 0) 
		# 	return item_obj
		  
		# }

		return item_obj
	end


end