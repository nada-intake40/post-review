module DeviceHelper



    def get_device_dir (device_id)
        path = "devices/#{device_id}/devices/#{String(Time.now)}#{Random.rand(0...10000)}.png"
        dir = File.dirname("public/#{path}")
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
    
        return path
      end
end