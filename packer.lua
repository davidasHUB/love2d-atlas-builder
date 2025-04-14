-- created by: github.com/cripboy
-- references: https://codeincomplete.com/articles/bin-packing/
local packer = {}
local fwrite= require("file_writer")
fwrite:init()

packer.blocks = {}
packer.dictionary = {}

function packer.sort(a, b)
	return math.min(a.w, a.h) > math.min(b.w, b.h)
end

function packer:add(image, tag)
	assert(image:type() == "Image", "Packer only acepts images")
	table.insert(self.blocks, {
		image = image,
		x = 0,
		y = 0,
		w = image:getWidth(),
		h = image:getHeight()
	})

	-- a tag is necessary to recovery this image
	-- position after joined into the atlas
	if tag then
		self.dictionary[tag] = self.blocks[#self.blocks]
	end
end

local function newNode(x, y, w, h)
	return {x = x, y = y, w = w, h = h, used = false, right = nil, down = nil}
end

local function findNode(node, w, h)
	-- node filled
	if node.used then
		return findNode(node.right, w, h) or findNode(node.down, w, h)
	
	-- you can place it here
	elseif (w <= node.w) and (h <= node.h) then
		return node

	-- no space to this shape
	else
		return nil
	end
end

-- fill this node and generated two more
-- OBS: down and right can be w = 0 and h = 0
local function splitNode(node, w, h)
	node.used = true
	node.right = newNode(node.x + w, node.y, node.w - w, h)
	node.down =  newNode(node.x, node.y + h, node.w, node.h - h)
end

-- wrap the old node in a new one
local function growRight(node, w, h)
	local growedNode = newNode(node.x, node.y, node.w + w, node.h)
	growedNode.used = true
	growedNode.down = node
	growedNode.right = newNode(node.w, node.y, w, node.h)

	return growedNode
end

-- wrap the old node in a new one
local function growDown(node, w, h)
	local growedNode = newNode(node.x, node.y, node.w, node.h + h)
	growedNode.used = true
	growedNode.down = newNode(node.x, node.h, node.w, h)
	growedNode.right = node

	return growedNode
end

-- choose wich direction are better to growup
local function growNode(node, w, h)
	local canGrowRight = h <= node.h
	local canGrowDown = w <= node.w
	local shouldGrowRight = canGrowRight and node.h >= node.w + w
	local shouldGrowDown = canGrowDown and node.w >= node.h + h

	if shouldGrowRight then
		return growRight(node, w, h)
	elseif shouldGrowDown then
		return growDown(node, w, h)
	elseif canGrowRight then
		return growRight(node, w, h)
	elseif canGrowDown then
		return growDown(node, w, h)
	end
end

function packer:genAtlas()
	assert(#self.blocks > 0, "You can't generate an atlas without images")

	-- sorting (standard sort)
	table.sort(self.blocks, self.sort)

	-- initial size
	local initialNode = newNode(0, 0, self.blocks[1].w, self.blocks[1].h)

	-- put blocks into the initialNode and future nodes
	for _, block in ipairs(self.blocks) do
		-- try to find nearest not used node
		local node = findNode(initialNode, block.w, block.h)

		-- need to growup
		if not node then
			initialNode = growNode(initialNode, block.w, block.h)
			node = findNode(initialNode, block.w, block.h)
		end

		splitNode(node, block.w, block.h)
		block.x = node.x
		block.y = node.y
	end

	-- make the atlas
	self.atlas = love.graphics.newCanvas(initialNode.w, initialNode.h)
	love.graphics.setCanvas(self.atlas)
	love.graphics.setColor(1, 1, 1)

	for _, block in ipairs(self.blocks) do
		love.graphics.draw(block.image, block.x, block.y)
	end

	love.graphics.setCanvas()
end

function packer:getBlock(tag)
	assert(self.dictionary[tag], "Invalid tag " .. tag)
	return self.dictionary[tag]
end

function packer:getRect(tag)
	local block = self:getBlock(tag)
	return block.x, block.y, block.w, block.h
end

-- we don't need generate all quads at same time
function packer:getQuad(tag)
	local block = self:getBlock(tag)

	if not block.quad then
		block.quad = love.graphics.newQuad(
			block.x,
			block.y,
			block.w,
			block.h,
			self.atlas)
	end

	return block.quad
end


local LUA_TABLE='	["%s"] = { x = %i, y = %i, w = %i, h = %i  },\n'
local ANIM_LUA_TABLE='	["%s"] = {\n'
local BLOCK_LUA_TABLE='		{ frame_name = "%s", number = %i , x = %i, y = %i, w = %i, h = %i },\n'


local function LAST_CHAR(_str)
	return tonumber(_str:sub(#_str,#_str))
end

local function REMOVE_NUMBER_AT_THE_END(v)
	local c=""
	
	for i=#v,1,-1 do   
	  if tonumber(v:sub(i,i))==nil then 
		local key=v:sub(1,i)
		local ix=tonumber(c:reverse())
		
		return key,ix
	  end 
	  c=c..v:sub(i,i)
	end
	
end




local function DICT_TO_LIST(dict)
	local list={}
	
	for k,v in pairs(dict) do 
		table.insert(list,{key=k,number=0,x=v.x,y=v.y,w=v.w,h=v.h})
	end
	return list 
end

local function COVERT_LOOPUP_TO_LIST(dict)
	local list={}
	
	for k,v in pairs(dict) do 
		table.insert(list,{name=k,data=v})
	end 
	
	table.sort(list,
		function(a,b)
			return a.name<b.name
		end
	)
	
	for i=1,#list do 
		local len=#list[i].data
		if 	len>1 then 
			table.sort(list[i].data,
			function(a,b)
				return a.number<b.number
			end
			)
			
		end 
	end
	
	
	
	
	return list 
end


local function ANALIZE_TABLE(list)
	local info
	
	for i=1,#list do 
	
	end
end 



local function WRITE_LIST_IN_A_SMART_WAY(list)
	local st=""
	local other=""
	local prev={}
	local value=0
	local tick=0
	local linear=true
	
	for _, v in ipairs(list) do
		local name=v.name
		local data=v.data
		
		value=0
		linear=true
		other=""
		
		if #data>0 and #data>1 then 
			
			
			if tonumber(LAST_CHAR(data[1].key))==1 then 
				
				
			
				for i=1,#v.data do
					local num=v.data[i].number
					
					
					local block=v.data[i]
					
					if num==value+1 and linear then
					
						
						other=other..BLOCK_LUA_TABLE:format(block.key,block.number,block.x,block.y,block.w,block.h)
					else
						
						if linear then
							
							
							if tick==1 then
								st=st..LUA_TABLE:format(prev.key,prev.number,prev.x,prev.y,prev.w,prev.h)
								st=st..LUA_TABLE:format(block.key,block.number,block.x,block.y,block.w,block.h)
							else 
								st=st..ANIM_LUA_TABLE:format(v.name)
								st=st..other
								st=st.."	},\n"
							end
							linear=false
					
						end
						
						
					end 
					
					if not linear then 
						st=st..LUA_TABLE:format(block.key,block.number,block.x,block.y,block.w,block.h)
					end 
					
					value=num
					prev=v.data[i]
					tick=tick+1
				end
				
				if linear then
					st=st..ANIM_LUA_TABLE:format(v.name)
					st=st..other
					st=st.."	},\n"
				end 
			end 
			
		
		elseif #data==0 then 
			local block=v.data
			st=st..LUA_TABLE:format(block.key,block.x,block.y,block.w,block.h)
		elseif #data==1 then 
			local block=v.data[1]
			st=st..LUA_TABLE:format(block.key,block.x,block.y,block.w,block.h)
		end 
		
		
		
	end
	
	return st 
end

-- dirty serialization, but works ~fast~ fine ¯\_(ツ)_/¯
function packer:serialize()
	assert(self.atlas, "Generate an atlas before the serial")
	local list=DICT_TO_LIST(self.dictionary)
	
	table.sort(list,
		function(a,b)
			return a.key<b.key
		end
	)
	
	local lookup={}
	
	for i=1,#list do 
		
		local t=list[i]
		
		
		local v=t.key 
		
		local CHAR=tonumber(LAST_CHAR(v))
		local txt,number=REMOVE_NUMBER_AT_THE_END(v)
		t.number=number
		
		
		if CHAR~=nil then
			
			
			if lookup[txt]==nil then 
				lookup[txt]={}
				table.insert(lookup[txt],t)
			else 
				table.insert(lookup[txt],t)
			end
		else 
			lookup[txt]=t
		end 
		
		
	end 
	
	local o_list=COVERT_LOOPUP_TO_LIST(lookup)
	
	
	
	local content = "return {\n"
	
	content=content..WRITE_LIST_IN_A_SMART_WAY(o_list)

	return content .. "}"
end

function packer:saveAtlas(dir)
	local imageFile, err = fwrite:open(dir)

	if imageFile then
		local imgData = self.atlas:newImageData()
		local fileData = imgData:encode("png")

		imageFile:write(fileData:getString())
		imageFile:close()
	end

	return err
end

function packer:saveSerial(dir)
	local serialFile, err = fwrite:open(dir)
	
	if serialFile then
		serialFile:write(self:serialize())
		serialFile:close()
	end

	return err
end

return packer
