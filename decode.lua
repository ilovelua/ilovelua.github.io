opt = lapp [[
Decode a video.
   --idir       (default '.')    Video path -- any format.
   --codir      (default '')    Codes out dir.
   --fps        (default '30')  FPS.
   --width      (default '')   Frame width
   --height     (default '128')   Frame height
]]

function encode(str)
   local code = {}
   for i = 1,#str do
      local char = str:sub(i,i)
      local hex = string.format('%02X',string.byte(char))
      code[i] = hex
   end
   return table.concat(code)
end

function decode(code)
   local str = {}
   for i = 1,#code,2 do
      local hex = code:sub(i,i+1)
      local char = string.char(tonumber(hex,16))
      table.insert(str,char)
   end
   return table.concat(str)
end

local fps = tonumber(opt.fps)
print('ifname: ', ifname)
print('odir: ', odir)

local width = nil
if opt.width ~= '' then
   width = tonumber(opt.width)
end

height = tonumber(opt.height)

local include = {}
table.insert(include,'mp4')
table.insert(include,'m4v')
table.insert(include,'mov')
table.insert(include,'avi')

local fileList = dir.getfiles(opt.idir)
for i, file in ipairs(fileList) do
   local process = false
   local bname = path.basename(file)
   for j,format in ipairs(include) do
      process = process or bname:find(format)
   end
   if not bname:find("^%.") and process then
      local fname = encode(path.basename(file))
      local cmd = 'ffmpeg -i "' .. file .. '" -r ' .. fps .. ' -map 0:v:0 -vf scale=-1:'
.. opt.height .. ' -qscale 1 ' ..'"' .. path.dirname(file)  .. '/' .. fname ..'_'
.. fps .. '-fps' .. '_%09d.jpg"  2> /dev/null'
      print(cmd)
      os.execute('mkdir ' .. file)
      os.execute(cmd)
   end
end
