#!/usr/bin/env th

require 'trepl'
require 'sys'
require 'pl'
require 'xlua'
local mad = require './mad'
local image = require 'image'
local pixels = require 'pixels'
local col = require 'async.repl'.colorize
local ptable = {}
function mosaic(idir, opt)
   opt = opt or {}
   local ofile = idir..'.jpg'
   local padding = opt.padding or 0
   local ratio = opt.ratio or 1
   local size = opt.size or 64
   local Limit  = opt.Limit or 4096
   local fraction = opt.fraction or 1
   local max = opt.max or false
   local perm = opt.perm or false

   local files
   if limit then
      files = mad.dir.imgs(idir,limit)
      table.insert(ptable, 'Limit:'..limit)
   elseif fraction > 1 then
      files = mad.dir.imgs(idir,math.floor(#files/fraction))
      table.insert(ptable, 'Fraction:1/'..fraction)
   elseif max then
      files = mad.dir.imgs(idir,34*13)
      table.insert(ptable, 'Max:'..max)
   else
      files = mad.dir.imgs(idir)
      table.insert(ptable, 'N:'..#files)
   end

   local n  = #files
   if  perm then
      files = mad.permute(files)
   end


   local size = opt.size or 20
   -- local nh = math.floor(math.sqrt(n/ratio))
   -- local nw = nh * ratio
   -- local w  = (size+padding*2) * nw + padding * 2
   -- local h  = (size+padding*2) * nh + padding * 2


   local nh = 2*13
   local nw = 2*34
   local w  = 2*680
   local h  = 2*260


   print{
      idir = col.cyan(idir),
      total = #files,
      fraction = col.magenta(fraction),
      padding = col.magenta(padding),
      ratio = col.magenta(ratio),
      size = col.magenta(size),
      ofile = col.cyan(ofile),
   }

   -- local map = torch.ByteTensor(3, h, w):zero()
   local map = torch.FloatTensor(3, h, w):uniform(0,1)
   local n = 1
   for i = 1,nh do
      xlua.progress(i,nh)
      for j = 1,nw do
         local file = files[n]
         if file then
            local img = pixels.load(file, {
               minSize = size,
               type = 'float',
               channels = 3,
            })
            -- crop
            if img then
               local oh = math.floor( (img:size(2) - size) / 2 )
               local ow = math.floor( (img:size(3) - size) / 2 )
               img  = img[{ {},{1+oh,oh+size},{1+ow,ow+size} }]

               -- dest coords:
               local t = (i-1)*(size+padding*2) + 1 + padding*2
               local l = (j-1)*(size+padding*2) + 1 + padding*2
               local b = t+size-1
               local r = l+size-1

               -- insert
               map[{ {},{t,b},{l,r} }] = img
            end
         end
         n = n + 1
         collectgarbage()
      end
      collectgarbage()
   end
   pixels.save(ofile, map)
   os.execute('open '..ofile)
end


mosaic('/Volumes/laeh/sat-22-nov-williamsburg-soho-1')
-- mosaic('/Volumes/laeh/sat-22-nov-soho-williamsburg-2.mp4')
-- mosaic('/Volumes/laeh/sat-22-nov-soho-williamsburg-3.mp4')
-- mosaic('/Volumes/laeh/sat-22-nov-soho-williamsburg-4.mp4')
-- mosaic('/Volumes/laeh/sat-22-nov-soho-williamsburg-5.mp4')
