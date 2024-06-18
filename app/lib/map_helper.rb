module MapHelper 
    def is_promoter_inside(latitude,longitude,branch_id)
    #THIS SHOULD BE REMOVED IN PRODUCTION 
        # return true
        promoter_current_location=Geokit::LatLng.new(latitude,longitude);
        branch=RetailCompanyBranch.find(branch_id)
        polygon_lat_long_array=Array.new
        branch.branch_boundries.each do |indicator|
        	polygon_lat_long_array << Geokit::LatLng.new(indicator.latitude,indicator.longitude)
        end
        branch_polygon=Geokit::Polygon.new(polygon_lat_long_array)
        return branch_polygon.contains?(promoter_current_location)
    end
    
        

end
