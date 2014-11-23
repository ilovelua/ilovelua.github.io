#!/usr/bin/env th
local mad = {}
require 'trepl'
require 'sys'
require 'pl'
require 'xlua'
require 'pixels'
require 'gfx.js'

local fun         = require './fun'
local image       = require 'image'
local pixels      = require 'pixels'
local col         = require 'async.repl'.colorize
local rick        = pixels.load('img/rick.jpg')
local defaultSize = 64
local omg         = {
   distort     = {},
   shuffle     = {},
   create      = {},
   blur        = {},
   color       = {},
}
local mad = omg

local desktop = '~/Desktop/'
desktop = desktop:gsub('^~', os.getenv('HOME'))


function omg.color.invert(img)
   local img  = img or rick
   return -img +1
end

function omg.color.boost (img,opt)
   local opt = opt or {}
   local img = img or rick
   local i3 = img:clone()

   -- (0) normalize the image energy to be 0 mean:
   i3:add(-i3:mean())

   -- (1) normalize all channels to have unit standard deviation:
   i3:div(i3:std())

   -- (2) boost indivudal channels differently (here we give an orange
   --     boost, to warm up the image):
   i3[1]:mul(0.4)
   i3[2]:mul(0.3)
   i3[3]:mul(0.2)

   -- (3) soft clip the image between 0 and 1
   i3:mul(4):tanh():add(1):div(2)
   return i3
end

function omg.blur.aperture(img,opt)
   local opt = opt or {}
   local imgsize = opt.imgsize or defaultSize
   local apertureSize = opt.apertureSize or 32
   local img = img or rick
   local aperture = pixels.load('img/aperture.png', {maxSize = apertureSize})
   aperture:div(aperture:sum())
   local res = image.convolve(img,aperture[1],'same')
   res:div(res:max())
   return res
end

function omg.blur.gaussian(img,opt)
   opt = opt or {}
   local imgsize = opt.imgsize or defaultSize
   local img = img or rick
   local kernelsize = opt.kernelsize or 32
   -- Gaussian Kernel + Transpose
   local g1 = image.gaussian1D(kernelsize):resize(1,kernelsize):float()
   local g2 = g1:t() --transpose(1,2)
   -- Check Dimensiosn

   print(#g1)
   print(#g2)
   -- Resize & Clone
   local i = image.scale(img, imgsize)
   c = i:clone():fill(1)
   print{c,g1}
   -- Convolution
   c = image.convolve(c, g1, 'same')
   c = image.convolve(c, g2, 'same')
   i = image.convolve(i, g1, 'same')
   i = image.convolve(i, g2, 'same')
   -- Component-wise division + retransform
   i:cdiv(c)
   return i
end

function omg.shuffle.global(img)
   local img = img or rick
   local channels = img:size(1)
   local height = img:size(2)
   local width = img:size(3)
   local matrix = img:view(channels, width*height)
   local perm = torch.randperm(width*height):long()
   local pixels = matrix:index(2,perm)
   local result = pixels:view(channels, height, width)
   return result
end

function omg.shuffle.binned(img,opt)
   local opt  = opt or {}
   local img  = opt.img or rick
   local imgh = opt.imgh or defaultSize
   local imgw = opt.imgw or defaultSize
   local verbose = opt.verbose or false
   local wBlocksNo   = opt.wBlocksNo or 16
   local hBlocksNo   = opt.hBlocksNo or 16
   local img         = image.scale(img,imgh,imgw)[{{1,3}}]
   local imgdims     = #img
   local blockw      = imgdims[3]/wBlocksNo
   local blockh      = imgdims[2]/hBlocksNo
   local imgHSL      = image.rgb2hsv(img)*0.99
   local blocks      = imgHSL:unfold(3,blockw,blockw):unfold(2,blockh,blockh)
   local allBlocks   = blocks:reshape((#blocks)[1],
                                   (#blocks)[2]*(#blocks)[3],
                                   (#blocks)[4]*(#blocks)[5])

   if verbose then
      h1('Bins tensors Dimensions = ')
      print(imgw..'*'..imgh..'*'.. wBlocksNo..'*'..wBlocksNo..'*'..hBlocksNo)
   end
   for i = 1, (#allBlocks)[2] do


      local rdmPositions = torch.randperm((#allBlocks)[3]) --Randomize Bins
      for j = 1, (#allBlocks)[3] do
         allBlocks[{ 1,i,j }] = allBlocks[{ 1,i,rdmPositions[j] }]
         allBlocks[{ 2,i,j }] = allBlocks[{ 2,i,rdmPositions[j] }]
         allBlocks[{ 3,i,j }] = allBlocks[{ 3,i,rdmPositions[j] }]
      end
   end
   img = allBlocks:reshape((#blocks)[1],
                           (#blocks)[2],
                           (#blocks)[3],
                           (#blocks)[4],
                           (#blocks)[5])
   if verbose then
      print('Shuffle -> #img=',#img)
      img = image.hsv2rgb(img:transpose(3,4):reshape(3,imgh,imgw))
      print('Reorganize -> #img=',#img)
   end
   return img
end

function omg.shuffle.binnedColors(img,opt)
   local opt = opt or {}
   local img = img or rick
   local imgh = opt.imgh or defaultSize h2('imgh') print(imgh)
   local imgw = opt.imgw or defaultSize h2('imgh') print(imgw)
   local imgc = opt.imgc or 3 h2('imgc') print(imgh)
   local imgb = opt.imgb or 32 h2('imgb')print(imgw) -- == 16 bins
   local img = image.scale(img,imgh,imgw)[{{1,3}}]
   local img = image.rgb2hsl(img)
   local img = img:reshape(3,imgh*imgw)
   local img = img:transpose(2,1)
   local colors = torch.Tensor(100,3)
   for i = 1, 100 do
      colors[{i}] = img[torch.random(1,imgh*imgw)]
   end
   local wBlocksNo = imgw / imgb
   local hBlocksNo = imgh / imgb
   local blockPixelsNo = imgb * imgb
   local totalBlocksNo = wBlocksNo * hBlocksNo
   local blocksHSL = torch.Tensor(totalBlocksNo,blockPixelsNo,imgc)
   for i = 1,(#blocksHSL)[1] do
      xlua.progress(i,(#blocksHSL)[1])
      local inHSL   = colors[math.floor(torch.uniform(1,(#colors)[1]+1))]
      local ssclaor = torch.uniform(1,1)
      local lscalor = torch.uniform(1,1)
      for j = 1,(#blocksHSL)[2] do
         blocksHSL[i][j][1] = 1
         blocksHSL[i][j][2] = torch.uniform(1,1.5)
         blocksHSL[i][j][3] = torch.uniform(0,1.5)
         blocksHSL[i][j]:cmul(inHSL)
      end
   end
   local img = blocksHSL:transpose(2,3)
                        :transpose(1,2)
                        :reshape(imgc,wBlocksNo,hBlocksNo,imgb,imgb)
                        :transpose(3,4)
                        :reshape(3,imgw,imgh)
   local img = image.hsl2rgb(img)
   return img
end

function omg.create.dagrad(opt)
   local function R() return torch.random(0,255)/255 end
   local function G() return torch.random(0,255)/255 end
   local function B() return torch.random(0,255)/255 end
   opt = opt or {}
   local w = opt.w or s
   local h = opt.h or s

   local colors = {
      {R(),G(),B()},
      {R(),G(),B()},
      {R(),G(),B()},
      {R(),G(),B()},
   }
   local tl = opt.tl or colors[1]
   local tr = opt.tr or colors[2]
   local br = opt.br or colors[3]
   local bl = opt.bl or colors[4]

   local img = torch.FloatTensor({{tl,tr},{br,bl}})
   img = img:transpose(1,3)
   img = img:transpose(2,3)
   img = image.scale(img,w,h)
   return img
end

function omg.create.ckograd()
   -- gradient
   local img = omg.create.dagrad()

   -- load mask:
   local cko = pixels.load('img/cko.png')
   image.scale(cko, img:size(3), img:size(2))

   -- mul
   return img:cmul(cko)
end

function omg.create.uniform(opt)
   opt = opt or {}
   local size = opt.size or 256
   local nb = opt.nb or  1000

   local t = torch.ByteTensor(3,size,size)

   dir.makepath('TX.uniform')

   for i = 1,nb do
      xlua.progress(i,nb)
      -- uniform colors
      t[1] = torch.uniform(0,255)
      t[2] = torch.uniform(0,255)
      t[3] = torch.uniform(0,255)

      -- force gray (statistically too low otherwise)
      if i % 20 == 0 then
         t[2] = t[1]
         t[3] = t[1]
      end

      -- save
      pixels.save('TX.uniform/'..t[1][1][1]..'-'..t[2][1][1]..'-'..t[3][1][1]..'.jpg', t)
   end
end

function omg.test()
   local img = image.lena()
   local newimg = mad.color.boost(img)
   local ofile = desktop..'test.jpg'
   pixels.save(ofile, newimg)
   os.execute('open '..ofile)
end


return mad






