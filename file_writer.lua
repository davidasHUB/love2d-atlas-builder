
local nativefs = require("nativefs")
local FILE_WRITER={file=nil}


local function set_directory(dir)
	local real_path=love.filesystem.getRealDirectory(dir)
	local real_full_path=real_path:gsub("\\","/").."/"..dir
	nativefs.setWorkingDirectory(real_full_path)
end

function FILE_WRITER:init(dir)
	set_directory(dir or "")
end


local function FILE_WRITER_file_exists(file_name,type)
	return love.filesystem.getInfo(file_name,type)
end


function FILE_WRITER:open(file_name)
	
	self.file,err=nativefs.newFile(file_name)
	self.file:open("w")
	
	return self,err
end 

function FILE_WRITER:write(txt)
	self.file:write(txt)
end 

function FILE_WRITER:close()
		
	self.file:close()
	
end 

return FILE_WRITER