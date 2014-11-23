#!/usr/bin/env th

require 'trepl'
require 'sys'
require 'pl'
require 'xlua'
local mad = require './mad'
local image = require 'image'
local pixels = require 'pixels'
local col = require 'async.repl'.colorize
local async = require 'async'
local opt = lapp [[
   --idir   (string)  input dir to process recursively
]]

local idir = opt.idir
local size = 10000
local odir = idir..'-bucket' dir.makepath(odir)
local dirname = path.basename(idir)
local files = mad.dir.imgs(idir)
local total = #files
local s = size
local n = math.ceil(total/s)
local newRootPath = odir..'/'..dirname
dir.makepath(newRootPath)

print {
   total = total,
   s = s,
   n = n,
   newRootPath = newRootPath,
}
local counter = 1
for i=1, n do
   local vmin = (i-1) * s
   local vmax = (i-0) * s
   if i == n then
      s = total - vmin
      vmax = total
   end

   local obucket = newRootPath..'/'..i
   dir.makepath(obucket)
   local nbad = 0
   for j=1, s do
      local file = files[counter]
      counter = counter + 1
      local name = path.basename(file)
      local l = string.len(name)
      l1 = string.len('BxqNAJHCcAAKgfb.jpg')
   l2 = string.len('14145482860150HJKMXV.jpg')
      local to
      if l == l1 or l ==l2 then
         to = obucket..'/'..name
      else
         nbad = nbad +1
         to = obucket..'/'..sys.uid()..'.jpg'
      end
      print(file, to)
      mad.file.copy(file,to)
   end
end

local command = [[
   th bin.lua -idir /Volumes/ckoia/009/CO
   th bin.lua -idir /Volumes/ckoia/009/FD
   th bin.lua -idir /Volumes/ckoia/009/GR
   th bin.lua -idir /Volumes/ckoia/009/HU
   th bin.lua -idir /Volumes/ckoia/009/IN
   th bin.lua -idir /Volumes/ckoia/009/NA
   th bin.lua -idir /Volumes/ckoia/009/ST
   th bin.lua -idir /Volumes/ckoia/009/TX
   th bin.lua -idir /Volumes/ckoia/009/XX
   th bin.lua -idir /Volumes/ckoia/009/XX.not
]]
