module PromoterHelper
  def make_filter_statment(conditions)
    filter_count=Integer(0)
    filter_statment=""
    if(conditions[:category_id])
      filter_count=filter_count+1
      filter_statment="items.category_id=#{conditions[:category_id]}"
    end

    if(conditions[:brand_id])
      filter_count=filter_count+1
      if(filter_count>1)
        filter_statment=filter_statment+" AND items.brand_id=#{conditions[:brand_id]}"
      else
        filter_statment="items.brand_id=#{conditions[:brand_id]}"
      end
    end
    return filter_statment

  end

  def get_power_of_wings_type_photo_dir (power_wing_type_id,ext)
    path = "power_wings_types/#{power_wing_type_id}/power_wing_type.#{ext}"
    dir = File.dirname("public/#{path}")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    return path
  end

  def get_power_of_wings_photo_dir (jcp_id)
    path = "JCP/#{jcp_id}/power_of_wings/#{String(Time.now)}#{Random.rand(0...10000)}.png"
    dir = File.dirname("public/#{path}")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    return path
  end

  def get_selfie_dir (project_id,branch_id)
    path="projects/#{project_id}/branchs/#{branch_id}/#{Date.today.strftime("%y-%m-%d")}/selfie/#{String(Time.now)}#{Random.rand(0...10000)}.png"
    dir = File.dirname("public/#{path}")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    return path

  end

  def get_gallary_image_dir (project_id,branch_id)
    path="projects/#{project_id}/branchs/#{branch_id}/#{Date.today.strftime("%y-%m-%d")}/gallary/#{String(Time.now)}#{Random.rand(0...10000)}.png"
    dir = File.dirname("public/#{path}")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    return path

  end

  def get_planogram_before_image_dir (jcp_id,category_id)
    path="JCP/#{jcp_id}/categories/#{category_id}/images_before/#{String(Time.now)}#{Random.rand(0...10000)}.png"
    dir = File.dirname("public/#{path}")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    return path

  end

  def get_planogram_after_image_dir (jcp_id,category_id)
    path="JCP/#{jcp_id}/categories/#{category_id}/images_after/#{String(Time.now)}#{Random.rand(0...10000)}.png"
    dir = File.dirname("public/#{path}")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    return path

  end

  def get_planogram_image_dir (category_id,ext)
    path="planograms/#{category_id}/#{String(Time.now)}#{Random.rand(0...10000)}.#{ext}"
    dir = File.dirname("public/#{path}")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    return path

  end

  def get_item_image_dir (item_id,ext)
    path="items/#{item_id}/item.#{ext}"
    dir = File.dirname("public/#{path}")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    return path

  end

  def get_category_dir (category_id,ext)
    path="categories/#{category_id}/category.#{ext}"
    dir = File.dirname("public/#{path}")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    return path

  end

  def get_working_hours_range(project_id)
    return true
    project=Project.find(project_id)
    start_time = Time.parse(project.start_shift_from.to_s(:time))
    end_time = Time.parse(project.shift_end_in.to_s(:time))
    Time.now.between?(start_time,end_time)

  end

  def get_working_hours_range_of_promoter(promoter_id)
    promoter=Promoter.find(promoter_id)
    project=promoter.retail_company_branch.retail_company.project
    start_time = Time.parse(project.start_shift_from.to_s(:time))
    end_time = Time.parse(project.shift_end_in.to_s(:time))
    start_time .. end_time
  end

  def get_project_day_range(project_id)
    #   project=Project.find(project_id)
      date_range={}
    #   date_time_string="#{Date.today.strftime("%Y-%m-%d")} #{project.shift_end_in.strftime("%H:%M:%S")}"
    #   end_time = DateTime.parse(date_time_string) + 6.hours
    #   date_time_string="#{Date.today.strftime("%Y-%m-%d")} #{project.start_shift_from.strftime("%H:%M:%S")}"
    # start_time = DateTime.parse(date_time_string) - 2.hours
    date_range[:created_at]=Date.today.beginning_of_day + 2.hours .. Date.today.end_of_day + 2.hours
    date_range

    end

    def get_token_range(token)
      token=PromoterToken.find_by_token(token)
      if ! token.present?
        return {}
      end
      date_range={}

      date_range[:created_at]=token.created_at .. token.expiration_time
      date_range


    end

end
