#!/usr/bin/env th


local col = require 'async.repl'.colorize
local mad = require './mad'
local col = require 'async.repl'.colorize
local image = require 'image'
local async = require 'async'
local pixels  = require 'pixels'
local opt = lapp [[
   --idir (string) Input Directory
]]

local idir = opt.idir:gsub('%/$','')
local id = path.basename(opt.idir)
local trainingDataDir = '/Volumes/ckoia/training/data'
local trainingImagesDir = '/Volumes/ckoia/training/images'
local imgdir = trainingImagesDir..'/'..id
local datadir = trainingDataDir..'/'..id
dir.makepath(datadir)

local idsFile = datadir..'/'..'ids.json'
local statFile = datadir..'/'..'stats.json'
local hashedFile = datadir..'/'..'hashed.json'

--╔══════════════════════════════════════════╗
--║                                          ║
--║                                          ║
--║                                          ║
--╚══════════════════════════════════════════╝

local ids = {}
if paths.filep(idsFile) then
   print('ids file existing @ ', idsFile)
else
   for _,subdir in ipairs(dir.getdirectories(idir)) do
      local class = path.basename(subdir)
      ids[class] = {}
      local files = mad.dir.imgs(subdir)
      for i, file in ipairs(files) do
         xlua.progress(i,#files)
         table.insert(ids[class], file)
      end
      collectgarbage()
   end
   mad.json.save(idsFile, ids)
end



local hashed = {}
if paths.filep(hashedFile) then
   print('has file existing @ ', hashedFile)
else
   for _,subdir in ipairs(dir.getdirectories(idir)) do
      local class = path.basename(subdir)
      hashed[class] = {}
      local files = mad.dir.imgs(subdir)
      for i, file in ipairs(files) do
         local fname = path.basename(file)
         xlua.progress(i,#files)
         hashed[class][fname] = file
      end
      collectgarbage()
   end
   mad.json.save(hashedFile, hashed)
end

--╔══════════════════════════════════════════╗
--║                                          ║
--║                                          ║
--║                                          ║
--╚══════════════════════════════════════════╝

local stats = {}
if paths.filep(statFile) then
   print(mad.json.load(statFile))
else
   local total = 0
   for class, list in pairs(mad.json.load(idsFile)) do
      total = total + #list
      local nl = 0
      local np = 0
      local ns = 0
      for i, file in ipairs(list) do
         xlua.progress(i, #list)
         local t = 1.1
         local b = 0.9
         local info = pixels.getFileInfo(file)
         if info then
            local w = info.width
            local h = info.height
            local r = w/h
            if r > t then
               nl = nl+1
            elseif r < b then
               np = np+1
            else
               ns = ns+1
            end
         end
      end
      stats[class] = {
         Total = nl+np+ns,
         L = nl,
         P = np,
         S = ns,
      }
   end
   print('Total Images :',total)
   print(stats)
   mad.json.save(statFile, stats)
end


--╔══════════════════════════════════════════╗
--║                                          ║
--║                                          ║
--║                                          ║
--╚══════════════════════════════════════════╝


local dmosaics = trainingDataDir..'/'..id..'/'..'mosaics'
dir.makepath(dmosaics)
local subdirs = dir.getdirectories(imgdir)
for i, subdir in ipairs(subdirs) do
   local fmosaic = dmosaics..'/'..path.basename(subdir)..'.jpg'
   if paths.filep(fmosaic) then
      print(fmosaic)
   else
      local cmd_mosaic = 'th mosaic.lua'
              ..' --idir '..subdir
              ..' --ofile '..fmosaic
      os.execute(cmd_mosaic)
   end
end

local trainingStatistics = mad.json.load(statFile)

local order= {
   'XX',
   'XX.not',
   'HU',
   'IN',
   'FD',
   'CO',
   'NA',
   'GR',
   'ST',
   'TX'
}


--╔══════════════════════════════════════════╗
--║                                          ║
--║                                          ║
--║                                          ║
--╚══════════════════════════════════════════╝


local webTable = {}
function trainingImageNumber()
   local total = 0
   for i, root in ipairs(order) do
      if trainingStatistics[root] then
         local rootTotalImages = trainingStatistics[root]['Total']
         total = total + rootTotalImages
      end
   end
   return total
end

local sizes = {}
for i, root in ipairs(order) do
   if trainingStatistics[root] then
      local n = trainingStatistics[root]['Total']
      local t = trainingImageNumber()
      local percent = math.ceil(n/t*100)
      table.insert(sizes,n/t)
      webTable[root]= {
         percent = percent..'%',
         fraction = n/t,
         total = n,
      }
   end
end
table.sort(sizes)
local maxv = sizes[#sizes]

function webView(idir)
   local files = mad.dir.imgs(idir)
   local imgDIVstrings = {}
   for i, root in ipairs(order) do
      if webTable[root] then
         local fraction = webTable[root].fraction
         local scaled = fraction/maxv
         print(fraction)
         local opacity
         if fraction == maxv then
            print('max :', maxv)
            opacity = 0
         else
            opacity = math.min(1- scaled, .8)
         end
         print(opacity)
         table.insert(imgDIVstrings,
            mad.dom.DIV({
               class = 'box',
               content = table.concat({
                  mad.dom.DIV({
                     class = 'img',
                     url = dmosaics..'/'..root..'.jpg',
                  }),
                  mad.dom.DIV({
                     class = 'mask',
                     style = 'background:rgba(0,0,0,'..opacity..')'
                  }),
                  mad.dom.DIV({
                     class = 'text title',
                     text = root
                  }),
                  mad.dom.DIV({
                     class = 'text total',
                     text = webTable[root].total
                  }),
                  mad.dom.DIV({
                     class = 'text percent',
                     text = webTable[root].percent,
                  })
               })
            })

         )
      end
   end
   local imagesWrap = mad.dom.DIV({
      class ='imagesWrap',
      content = table.concat(imgDIVstrings)
   })
   mad.dom.makeDoc ({
      docName = id..'.html',
      html = mad.dom.knitDoc({
         content = imagesWrap
      }),
   })
   os.execute('open '..id..'.html')
end

webView(dmosaics)
