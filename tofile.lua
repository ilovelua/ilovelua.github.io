local opt = lapp [[
Build training set from index:
   --index       (string)                           dataset index (json list)
   --idfile      (string)                           id file, csv format
   --blobstore   (default /ckoia_images/training)   blobstore base address
   --threads     (default 32)                       nb of threads to download
   --odir        (default data)                     output dir
]]

local pixels = require 'pixels'
local async = require 'async'

local index = require('./'..opt.index)
local base = 'http://ton.smf1.twitter.com/' .. opt.blobstore
local threads = opt.threads

local f = io.open(opt.idfile):read('*all')
local list = stringx.split(f,'\n')
local blob2tweet = {}
for _,e in ipairs(list) do
   local blobid,mediaid,tweetid = unpack(stringx.split(e,','))
   if blobid then
      blob2tweet[blobid:lower()] = tweetid
   end
end

local fetch = {}

local errors = 0
local ok = 0

local err = io.open(opt.odir..'.err.log','w')

local classes = {}

for class,list in pairs(index) do
   classes[class] = {}
   for i,e in ipairs(list) do
      local fname = paths.basename(e):lower()
      if fname:find('jpg$') or fname:find('png$') then
         local tweetid = blob2tweet[fname]
         if tweetid and tweetid ~= 'Unknown' then
            io.write(class..','..fname..','..tweetid..'\n')
         end
      end
   end
end
