#!/usr/bin/env th
local mad    = require './mad'
local pixels = require 'pixels'
local col    = require 'async.repl'.colorize
local async  = require 'async'
require 'trepl'
require 'sys'
require 'pl'
require 'xlua'

local opt = lapp [[
   --idir  (string) Input Directory
]]
local idir = opt.idir:gsub('%/$','')
local idsFile = idir..'-ids.json'
local statFile = idir..'-stats.json'

local ids = {}
function ckoiaTrainingIds()
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

stats = {}
if paths.filep(idsFile) then
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
else
   ckoiaTrainingIds()
end
