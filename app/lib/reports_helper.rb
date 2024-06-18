module ReportsHelper
	def all_devices_with_items(project_id, brand_id = nil, out_of_stock = false)
		item_names=[]
			items = Item::select("items.item_name,devices.device_name,devices.id").
				joins(:devices,:brand).where(brands:{project_id:project_id}).select("items.item_name,devices.device_name,devices.id")


		if brand_id != nil
			items = items.where(brand_id:brand_id)
		end

		if out_of_stock
			items = items.where("sum(branch_devices.quantity) = 0")
		end

		item_names=items.map { |item| 
			{id:item.id  ,name:  "#{item.item_name} -  #{item.device_name}" }

		}
		item_names
	end

	def get_device_sales_in_branch(device_id,branch_id,date_range)
		device_sale=InvoiceDevice.joins(:device,invoice: :retail_company_branch )
			.where(devices: {id: device_id},retail_company_branches: {id:branch_id})
			.where(invoice_devices:date_range)
			.sum("invoice_devices.quantity")
		# device_sale=Device.joins(branch_devices: :retail_company_branch)
		# 	.where(devices: {id: device_id},retail_company_branches: {id:branch_id})
		# 	.sum(:quantity)
			device_sale
	end
	
	def get_device_stock_in_branch(device_id,branch_id,date_range, brand_id = nil, out_of_stock = false)
		device_stock=Device.joins(branch_devices: :retail_company_branch)
			.joins(item: :brand)
			.where(branch_devices: {retail_company_branch_id: branch_id})
			.where(devices:{id:device_id})
			.where("branch_devices.created_at <= ?", date_range[:created_at].end)

			##where branch_devices created_at less than end date
			
			##.where(branch_devices:date_range)


			# if brand_id != nil
			# 	device_stock = device_stock.where("items.brand_id = ?", brand_id)
			# end
			device_stock.sum(:quantity)

	end
	

	def get_attendence_record_in_date(branch,date)
		date_range={}
		date_range[:created_at]=date.beginning_of_day .. date.end_of_day
		check_ins = Promoter.joins(:promoter_check_ins).joins(:retail_company_branch)
		.where(retail_company_branches:{id:branch.id},promoter_check_ins:date_range).count

		all_promoters=Promoter.where(retail_company_branch_id: branch.id).count
		absent=all_promoters - check_ins

		return [date.strftime("%d/%m/%Y") ,branch.retail_company.retail_company_name,branch.branch_name,check_ins,absent,all_promoters]
	end	

	def get_raw_data_in_date(branch,date)
		date_range={}
		date_range[:created_at]=date.beginning_of_day .. date.end_of_day
		sheet_raw=Array.new
		rows=InvoiceDevice.joins(invoice: {retail_company_branch: :retail_company})
				.where(retail_company_branches:{id:branch.id},invoice_devices:date_range)
				.joins(device:{item:[:category,:brand]})
				.select("invoice_devices.*,retail_companies.retail_company_name,retail_company_branches.branch_name,brands.brand_name,items.item_name,devices.device_name,invoice_devices.quantity,invoice_devices.price, invoice_devices.quantity * invoice_devices.price as total")
		rows.map { |row|  
			sheet_raw << [date.strftime("%d/%m/%Y") , row.retail_company_name, branch.branch_name,
					row.brand_name,row.item_name,row.device_name,
					row.quantity,row.price,row.total]

		}
		return sheet_raw
	end
	
	def get_check_late(late)
	  if ! late.nil?
		reminder = late % 60 
		value = late / 60
		return "#{value} hours , #{reminder} minutes"
	  else 
		return " "
	  end
	end

end