#!/usr/bin/env th

require 'sys'
require 'xlua'
require('pl.text').format_operator()
local pixels  = require 'pixels'
local image = require 'image'
local col = require 'async.repl'.colorize
local json = require 'cjson'
local mad = {
   dir = {},
   file = {},
   rdm = {},
   img = {},
   video = {},
   json = {},
   math = {},
   string = {},
   test = {},
   time = {},
   dom = {},
}

local desktop = '~/Desktop'
desktop = desktop:gsub('^~', os.getenv('HOME'))

--╔══════════════════════════════════════════╗
--║                                          ║
--║                              Directories ║
--║                                          ║
--╚══════════════════════════════════════════╝

function mad.video.frames(ifile)
   local ffmpeg = require 'ffmpeg'
   local pdir = path.dirname(ifile)
   local odir = ifile:gsub('%.mp4$','')
   dir.makepath(odir)
   ffmpeg.Video({
      path = ifile,
      width = 512,
      fps = 30,
      destFolder = odir,
      encoding = 'jpg',
   })
end

function mad.dir.clean(idir)
   local ngood = 0
   local nbad = 0
   for file in dir.dirtree(idir) do
      local isValidImg = image.guessTypeFromFile(filename)
      if file:lower():find('%.jpg') or
         file:lower():find('%.JPG') or
         file:lower():find('%.PNG') or
         file:lower():find('%.png') then
         local img = pixels.load(file, {
            type = 'byte',
            channels = 3,
         })
         if not img then
            os.remove(file)
            nbad = nbad + 1
         end
            ngood = ngood + 1
         else
         counter = counter + 1
      end
      io.write(col._green(ngood..' Good Files'), col._red(nbad..' Bad Files\r')) io.flush()
      collectgarbage()
   end
end

function mad.dir.clone(idir)
   dir.clonetree(idir, idir..'-clone')
end

function mad.dir.imgs(idir, limit)
   local files = {}
   local n = 1
   for file in dir.dirtree(idir) do
      if limit then if n > limit then break end end
         if file:lower():find('%.jpg') or
            file:lower():find('%.JPG') then
            n = n+1
            table.insert(files, file)
         end
      end
   table.sort(files)
   return files
end

function mad.dir.vids(idir, limit)
   local files = {}
   local n = 1
   for file in dir.dirtree(idir) do
      if limit then if n > limit then break end end
         if file:lower():find('%.m4v') or
            file:lower():find('%.mp4') or
            file:lower():find('%.mov') or
            file:lower():find('%.mpg') then
            n = n+1
            table.insert(files, file)
         end
      end
   table.sort(files)
   return files
end

function mad.dir.flatten(idir)
   local odir = idir..'-clean'
   dir.makepath(odir)
   local files = mad.dir.imgs(idir)
   print(col.blue('Flattening images in directory :'..idir))
   print(col.green(#files),col.red(' files'))
   for i, file in ipairs(files) do
      xlua.progress(i,#files)
      local ofile = odir..'/'..path.basename(file)
      mad.file.copy(file, odir)
   end
end

function mad.dir.move(from, to)
   local from = from or error('!!from directory')
   local to = to or error('!!to directory')
   local files = mad.dir.imgs(from)
   for i, file in ipairs(files) do
      xlua.progress(i,#files)
      local name = path.basename(file)
      mad.file.move(file, to..name)
   end
end

function mad.dir.thumbnails(idir)
   local max = 1024
   print(max)
   local idir = '/Volumes/ckoia/012/mosaics'
   local odir = '/Volumes/ckoia/012/mosaics/thumbnails'
   dir.makepath(odir)
   local files = mad.dir.imgs(idir)
   print(files)
   for i, file in ipairs(files) do
      local fname = path.basename(file)
      print(fname)
      local ofile = odir..'/'..fname
      local img = pixels.load(file, {
         type = 'byte',
         channels = 3,
         maxSize = max,
      })
      if img then
         pixels.save(ofile, img)
      end
   end
end


--╔══════════════════════════════════════════╗
--║                                          ║
--║                                    Files ║
--║                                          ║
--╚══════════════════════════════════════════╝


function mad.json.save(name, table)
   local j = json.encode(table)
   local f = io.open(name, 'w')
   f:write(j)
   f:close()
end

function mad.json.load(path)
   return json.decode(io.open(path):read('*all') )
end

function mad.img.scale(fimg)
   local img = pixels.load(fimg, {
      type = 'byte',
      channels = 3,
      maxSize = size,
   })
   if img then
      pixels.save(file, img)
   end
end

function mad.file.move(from, to)
   os.execute('mv "'..from..'" "'..to..'"')
end

function mad.file.copy(from, to)
   os.execute('cp "'..from..'" "'..to..'"')
end

function mad.file.write (path, string)
   local file = io.open(path,'w')
   file:write(string)
   file:close()
end

function mad.file.totext(fname, table)
   local f = io.open(fname, 'w')
   f:write(table.concat(table,'\n'))
   f:close()
end

function mad.file.tar(fileBaseName, toTar)
   local fname = fileBaseName..'.tgz'
   print(fname)
   local command = 'tar czvf '..fname..' '..toTar

   os.execute(command)
end

function mad.img.infos(imagePath)
   local f = io.popen('identify -format "%m %w %h" "'..imagePath..'"')
   local res = f:read('*all')
   f:close()
   local info = stringx.split(res, ' ')
   return {
      format = info[1],
      width = tonumber(info[2]),
      height = tonumber(info[3]),
   }
end


--╔══════════════════════════════════════════╗
--║                                          ║
--║                                   String ║
--║                                          ║
--╚══════════════════════════════════════════╝

function mad.string.padded(n,i)
   return string.format('%0'..n..'d',i)
end

function mad.string.split(s, p)
   local temp = {}
   local index = 0
   local last_index = string.len(s)
   while true do
      local i, e = string.find(s, p, index)
      if i and e then
         local next_index = e + 1
         local word_bound = i - 1
         table.insert(temp, string.sub(s, index, word_bound))
         index = next_index
         else
         if index > 0 and index <= last_index then
            table.insert(temp, string.sub(s, index, last_index))
            elseif index == 0 then
            temp = nil
         end
         break
      end
   end
   return temp
end

function mad.string.noextension(file)
   local fileBaseName = path.basename(file)
   fileBaseName = fileBaseName:gsub(' ','_')
   local name = fileBaseName:gsub('%.m4v$',''):gsub('%.mp4$',''):gsub('%.MOV$',''):gsub('%.JPG$',''):gsub('%.mov$',''):gsub('%.mpg$','')
   -- print(name)
   return name
end

function mad.string.encode(str)
   local code = {}
   for i = 1,#str do
      local char = str:sub(i,i)
      local hex = string.format('%02X',string.byte(char))
      code[i] = hex
   end
   return table.concat(code)
end

function mad.string.decode(code)
   local str = {}
   for i = 1,#code,2 do
      local hex = code:sub(i,i+1)
      local char = string.char(tonumber(hex,16))
      table.insert(str,char)
   end
   return table.concat(str)
end

function mad.string.checkpattern(pattern)
   if name:find('%.jpg.jpg$') then
      return true
   else
      return false
   end
end

--╔══════════════════════════════════════════╗
--║                                          ║
--║                          Tables & Arrays ║
--║                                          ║
--╚══════════════════════════════════════════╝

function mad.sample(array)
   return array[torch.random(1, #array)]
end

function mad.permute(array)
   for i = 1, #array do
      local  j = torch.random(i,#array)
      array[i], array[j] = array[j], array[i]
   end
   return array
end

function mad.range(min,max,step)
   local step = step or 1
   local min = min or 1
   local nsteps = max/step
   local range = {}
   for i=min,nsteps do
      range[i]=i*step
   end
   return range
end

function mad.math.grid(ncol, nrow)
   local samples = {}
   for i = 1, ncol do
      for j = 1, nrow do
         local gridPositions = {
         ['a'] = {
         ['x'] = i,
         ['y'] = j,
         },
         ['b'] = {
         ['x'] = i+1,
         ['y'] = j+1,
         }
         }
         table.insert(samples,gridPositions)
      end
   end
   return samples
end

--╔══════════════════════════════════════════╗
--║                                          ║
--║                                     Math ║
--║                                          ║
--╚══════════════════════════════════════════╝

function mad.math.trueFalse(t,f)
   local t = t or 1
   local f = f or 1
   local pool = {}
   for i=1,t do
      table.insert(pool,true)
   end
   for i=1,f do
      table.insert(pool,false)
   end
   local res = mad.permute(pool)[1]
   return res
end

function mad.math.bernoulli(prob)
   return torch.bernoulli(prob) == 1
end

function mad.math.factorial(n)
   if n == 0 then
   return 1
   else
   return n * mad.factorial(n - 1)
   end
end

function mad.math.max(list)
   local list = list or {1,2,3,4}
   return torch.Tensor(list):max()
end

function mad.time.micro()
   local a = require 'async'
   local string = tostring(a.hrtime()*1000000)
   return string
end

--╔══════════════════════════════════════════╗
--║                                          ║
--║                                      Dom ║
--║                                          ║
--╚══════════════════════════════════════════╝

function mad.dom.addClass(class)
   return ' class="' .. class .. '"'
end

function mad.dom.addStyle(style)
   return ' style="' .. style .. '"'
end

function mad.dom.addImg(url)
   return 'style="background-image: url('..url..')"'
end

function mad.dom.addLink(opt)
   local opt = opt or {}
   local link = opt.link
   local content = opt.content
   return '<a href="'..link.. '" target="displayFrame">'..content..'</a>'
end

function mad.dom.DIV(opt)
   local opt = opt or {}
   local url = opt.url
   local link = opt.link
   local text = opt.text
   local style = opt.style
   local class = opt.class
   local content = opt.content
   local DIV = {}
   table.insert(DIV, '<DIV')
   if class then table.insert(DIV, mad.dom.addClass(class)) end
   if style then table.insert(DIV, mad.dom.addStyle(style)) end
   if url then
      local img ='background-image: url(' .. url .. ');'
      local style = ' style="'..img..'"'
      table.insert(DIV, mad.dom.addImg(url))
   end
   table.insert(DIV, '>')
   if video then table.insert(DIV, video) end
   if text then table.insert(DIV, text) end
   if content then table.insert(DIV, content) end
   table.insert(DIV, '</DIV>')
   DIV = table.concat(DIV)
   if link then
      return mad.dom.addLink({
         link = link,
         content = DIV,
      })
      else
      return DIV
   end
end

function mad.dom.knitDoc(opt)
   local opt = opt or {}
   local content = opt.content or error('!!content')
   local fcss = opt.fcss or 'style.css'
   local shiv = [[
      <script type="text/javascript">
         document.createElement('video');document.createElement('audio');document.createElement('track');
      </script>
   ]]
   print(fcss)
   return '<html>'
   ..'<head>'
   ..'<link rel="stylesheet" type="text/css" href="'..fcss..'"/>'
   ..'<link href="//vjs.zencdn.net/4.10/video-js.css" rel="stylesheet">'
   ..'<script src="//vjs.zencdn.net/4.10/video.js"></script>'
   ..shiv
   ..'</head>'
   ..'<body>'
   ..content
   ..'</body>'
   ..'</html>'
end

function mad.dom.makeDoc(opt)
   local opt = opt or {}
   local docName = opt.docName or error('!!file')
   local html = opt.html or error('!!html')
   local file = io.open(docName,'w')
   file:write(html)
   file:close()
   -- os.execute('open '..docName)
end

function mad.date()
   -- date = os.date():gsub(' ','_')
   -- tostring(async.hrtime()
   -- tostring(sys.clock() * 1e4)
end

function mad.dir.slashProtection (idir)
   idir:gsub('%/$','')
end


--╔══════════════════════════════════════════╗
--║                                          ║
--║                                      rdm ║
--║                                          ║
--╚══════════════════════════════════════════╝


function mad.rdm.letter()
   local alphabet = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
   return mad.sample(alphabet)
end

function mad.rdm.glue()
   local strings = {}
   local idx = math.floor(torch.uniform(2,3))
   for i=1, idx do
      table.insert(strings, mad.rdm.letter())
   end
   local word_string = table.concat(strings)
   return word_string
end

function mad.rdm.word()
   local strings = {}
   local idx = math.floor(torch.uniform(5,13))
   for i=1, idx do
      table.insert(strings, mad.rdm.letter())
   end
   local word_string = table.concat(strings)
   return word_string
end

function mad.rdm.symbol()
   return mad.sample({
      mad.rdm.glue(),
      mad.rdm.word(),
      mad.rdm.word(),
      mad.rdm.word()
   })
end

function mad.rdm.title()
   local strings = {}
   for i = 1, 3 do
      table.insert(strings, mad.rdm.symbol()..' ')
   end
   return table.concat(strings)
end

--********************************************
--********************************************
--********************************************
--********************************************
--********************************************

return mad









-- ffmpeg -i "/Users/laeh/Sparkle.2012.SCAM.iMR@n.1.3gp" -r 30 -map 0:v:0 -vf scale=512:-1 -qscale 1 "sparkle/frame-%06d.jpg" 2> /dev/null
