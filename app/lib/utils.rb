module Utils
	def encode_from_base64(file_path,string)
		content = string
		decode_base64_content = Base64.decode64(content) 
		File.open(file_path, "wb") do |f|
		f.write(decode_base64_content)
		end 

	end

end
