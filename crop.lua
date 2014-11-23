#!/usr/bin/env th

local jobid = arg[1] or 1
local njobs = arg[2] or 1
print('running: ' .. jobid .. '/' .. njobs)

require 'image'
local col               = require 'async.repl'.colorize
local pixels            = require 'pixels'
local time              = tostring(os.time())
local homeDirectory     = os.getenv('HOME')

local ckoiaDir = '/Users/LAEH/Pictures/ckoia/'

local training = {
   directory = ckoiaDir..'trainingSets/',
   roots = {
      'NA',
      'CO',
      'HU',
      'ST',
      'GR',
      'IN',
      'FD',
      'XX',
      'TX',
   }
}


function processTopDirectory(DIR, NAME)
   -- LOOP | Ontology Roots
   for k,root in pipairs(DIR.roots) do
      local rootDirectory = DIR.directory..root
      print(col.yellow(rootDirectory))

      -- LOOP | Roots Directories
      local rootDirectories = dir.getdirectories(rootDirectory)
      for _,conceptPath in ipairs(rootDirectories) do
         print(col.green(conceptPath))

         -- LOOP | Images within directory
         local conceptFiles = dir.getfiles(conceptPath, '*.jpg')
         for i,imageFile in ipairs(conceptFiles) do
            -- Prog
            xlua.progress(i,#conceptFiles)

            -- RESIZE:
            local fileName = imageFile
            local img = pixels.load(fileName, {minSize = 512, format = 'JPEG'})
            if img then
               local ofile = fileName:gsub(NAME..'Sets', NAME..'SetsResized')
               dir.makepath(path.dirname(ofile))
               pixels.save(ofile,img)

               -- CROP:
               local ofile = fileName:gsub(NAME..'Sets', NAME..'SetsResizedAndCropped')
               dir.makepath(path.dirname(ofile))
               local img2 = pixels.crop(img)
               pixels.save(ofile,img2)
               collectgarbage()
            end
         end
      end
   end
end


-- Process CKOiA Ontology
-- processTopDirectory(ckoia,'training')

-- Process Morguefile
processTopDirectory(morguefile, 'morguefile')



