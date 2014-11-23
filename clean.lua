#!/usr/bin/env th
require 'trepl'
require 'sys'
require 'pl'
require 'xlua'

local mad = require './mad'
local pixels = require 'pixels'
local col = require 'async.repl'.colorize
local l1 = string.len('14145477657717XPP4IT.jpg')
local l2 = string.len('BrnFnyGCcAAFtA5.jpg')

local opt = lapp [[
   --idir     (string)    input dir to process recursively
]]
local stats = {}
local roots = dir.getdirectories(opt.idir)
print(roots)
for _,root in ipairs(roots) do
   print(root)
   local files = mad.dir.imgs(root)

   for i, file in ipairs(files) do
      local fname = path.basename(file)
      local fdir = path.dirname(file)
      local lfname = string.len(fname)
      if lfname == l1 or lfname == l2 then
         print('goodfile : '..fname)
      else
         local to = fdir..'/'..sys.uid()..'.jpg'
         mad.file.move(file,to)
         print('badfile : '..file,to)
      end
   end
end

local command = [[
   th clean.lua -idir /Volumes/black/ckoia/ckoia-008/train/CO
   th clean.lua -idir /Volumes/black/ckoia/ckoia-008/train/FD
   th clean.lua -idir /Volumes/black/ckoia/ckoia-008/train/GR
   th clean.lua -idir /Volumes/black/ckoia/ckoia-008/train/HU
   th clean.lua -idir /Volumes/black/ckoia/ckoia-008/train/IN
   th clean.lua -idir /Volumes/black/ckoia/ckoia-008/train/NA
   th clean.lua -idir /Volumes/black/ckoia/ckoia-008/train/ST
   th clean.lua -idir /Volumes/black/ckoia/ckoia-008/train/TX
   th clean.lua -idir /Volumes/black/ckoia/ckoia-008/train/XX
   th clean.lua -idir /Volumes/black/ckoia/ckoia-008/train/XX.not
]]

