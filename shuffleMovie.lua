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
local desktop = '~/Desktop'
desktop = desktop:gsub('^~', os.getenv('HOME'))
local uid = sys.uid()
local moviesDir = desktop..'/'..'out'
dir.makepath(moviesDir)

print(col.green('Creating Shuffle Movie'))
local opt = lapp [[
   --img     (default img/rick.jpg)    img to process
   --nsteps  (default 120)             input dir to process recursively
]]


local nsteps = opt.nsteps
local name = path.basename(opt.img)
local img = pixels.load(opt.img)
local tempdir = moviesDir..'/'..'temp-'..uid
dir.makepath(tempdir)
local movieFile = moviesDir..'/'..uid..'.mp4'

print {
   StepNumbe = col.magenta(nsteps),
   TemporaryDirectory = col.magenta(tempdir),
   MovieFile = col.yellow(movieFile)
}

local maxFrameNo = 120
local n = 1
for spread=0, nsteps do
   local frameNo
   local frameNo = math.ceil(math.max(1, math.min(maxFrameNo, math.log(spread/maxFrameNo+1) - math.log(spread/maxFrameNo)*10)))
   print(frameNo)
   for f=1, frameNo do
      local shuffled = pixels.shuffle(img,{spread = spread})
      local filename = string.format('%06d', (10000-n))
      local ofile = tempdir..'/'..filename..uid..'.jpg'
      pixels.save(ofile, shuffled)
      n = n + 1
      io.write('Spread : '..spread..' | Saving : '..col.green(ofile)..'\r') io.flush()
   end
   collectgage

end
io.write('\r') io.flush()

local space = '" "'
 -- 'sequence -size 360 -fps 30 1.jpg 2.jpg 3.jpg 4.jpg sequence.mp4'
local sequenceCommand = './sequence -fps 60 '..tempdir.. '/*.jpg '..movieFile
os.execute(sequenceCommand)
print(sequenceCommand)
local deleteCommad = 'rm -r '..tempdir
os.execute(deleteCommad)
