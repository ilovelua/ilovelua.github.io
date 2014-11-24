#!/usr/bin/env th

local col = require 'async.repl'.colorize
local mad = require './mad'
local image = require 'image'
local async = require 'async'
local pixels  = require 'pixels'
local ffmpeg = require 'ffmpeg'
local desktop = '~/Desktop/'
desktop = desktop:gsub('^~', os.getenv('HOME'))


--************
--*          *
--*          *
--*          *
--************


function flatten(idir)
   local vids = mad.dir.vids(idir)
   for i, file in ipairs(vids) do
      local fname = path.basename(file)
      mad.file.move(file,idir..'/'..fname)
   end
end

function sequential(idir, ext)
   local ext = ext or ('!!extension')
   local vids = mad.dir.vids(idir)
   for i, file in ipairs(vids) do
      local fname = path.basename(file)
      local number = string.format('%06d',i)
      local to = path.dirname(file)..'/'..path.basename(idir)..'_'..number..ext
      mad.file.move(file,to)
   end
end

-- sequential('/Volumes/ckoia/training/videos/music','.m4v')
--************
--*          *
--*          *
--*          *
--************

-- local ifile = '"/Volumes/ckoia/training/videos/originals/music1/music_000007.m4v"'
-- local odir = '"/Volumes/ckoia/training/videos/originals/music1/music_000007"'
-- local command = 'ffmpeg -i '..ifile..' -r 30 -map 0:v:0 -vf scale=512:-1 -qscale 1 -f psp '..odir
-- os.execute(command)

function frames(ifile)
   local ffmpeg = require 'ffmpeg'
   local fname = mad.string.noextension(path.basename(ifile))
   local pdir = path.dirname(ifile)
   local vid = ffmpeg.Video({
      path = ifile,
      width = 1024,
      delete = false,
      fps = 1,
      encoding = 'jpg',
   })
   local from = vid[1].path
   local to = '/Volumes/laeh'..'/'..fname
   mad.file.move(from,to)
   os.execute('th mosaic.lua --idir '..to..' --ofile '..to..'.jpg')
end

-- frames('/Volumes/laeh/sat-22-nov-soho-williamsburg-1.mp4')
-- frames('/Volumes/laeh/sat-22-nov-soho-williamsburg-2.mp4')
-- frames('/Volumes/laeh/sat-22-nov-williamsburg-soho-1.mp4')
-- frames('/Volumes/laeh/sat-22-nov-williamsburg-soho-2.mp4')
-- frames('/Volumes/laeh/sat-22-nov-williamsburg-soho-3.mp4')
-- frames('/Volumes/laeh/sat-22-nov-williamsburg-soho-4.mp4')
-- frames('/Volumes/laeh/sat-22-nov-williamsburg-soho-5.mp4')



--************
--*          *
--*          *
--*          *
--************

function distort(idir)
   local angle = math.floor(torch.uniform(10,45))
   local blur = math.floor(torch.uniform(1,20))
   local distortions = {
      {type='color',    prob = 1 },
      {type='contrast', prob = 1 },
      {type='flip',     prob = 1 },
      {type='grayscale',prob = 1 },
      {type='negative', prob = 1 },
      {type='blur',     prob = 1, min=blur,  max=blur},
      {type='crop',     prob = 1, min=1./4., max=1./4.},
      {type='frame',    prob = 1, min=1./4., max=1./4.},
      {type='occlusion',prob = 1, min=1./5., max=1./5.},
      {type='rot',      prob = 1, min=angle, max=angle},
      {type='scale',    prob = 1, min=1./8., max=1./8.},
      {type='translate',prob = 1, min=1./4., max=1./4.},
   }

	local distortion = mad.permute(distortions)[1]
   local fname = path.basename(idir)
   local files = mad.dir.imgs(idir)
   local nfile = #files
   if nfile > 600 then
      local rdmlength = math.ceil(torch.uniform(900)+300)
      local time = math.floor(rdmlength / 30)


   	local odir = path.basename(idir)..'/distorted/'..path.basename(idir)..'-DISTORT-'..distortion['type']..'_'..time..'s'
   	dir.makepath(odir)
   	local rdmstart = math.floor(torch.uniform(0,nfile-rdmlength))
   	local rdmend = rdmstart + rdmlength
   	print(col.yellow('Total:')..nfile)
      print(col.yellow('Sample:')..rdmlength)
   	print(col.yellow('istart:')..rdmstart)
   	print(col.yellow('iend:')..rdmend)
   	print(col.yellow('odir:')..odir)
      print{distortion}
   	for i=rdmstart,rdmend do
   	     xlua.progress(i-rdmstart,rdmlength)
   	     local file = files[i]
           local name = path.basename(file)
           local ofile = odir..'/'..name
   	     local img = pixels.load(file)
   	     img = pixels.distort(img, distortion):clone()
   	     pixels.save(ofile,img)
   	end
   	local movieFile = odir..'.mp4'
   	local sequenceCommand = './sequence -fps 30 '..odir.. '/*.jpg '..movieFile
   	os.execute(sequenceCommand)
      local deleteCommad = 'rm -r '..odir
      os.execute(deleteCommad)
   	-- local mosaicFile = odir..'.jpg'
   	-- local mosaicCommand = 'th mosaic.lua --idir '..odir
   	-- os.execute(mosaicCommand)

   end
end

            distort('/Volumes/laeh/test/sat-22-nov-soho-williamsburg-1')
-- print(mad.dir.imgs('/Volumes/laeh/test/sat-22-nov-soho-williamsburg-1'))

-- function process(idir)
-- 	for i = 1, 100 do
-- 		distort(idir)
-- 	end
-- end

-- process('/Users/laeh/Movies/la/rahan')
-- wget "http://r2.o2.vc/Hollywood%20Movies/Sparkle%20(2012)/Sparkle.2012.SCAM.iMR@n.1.3gp"

