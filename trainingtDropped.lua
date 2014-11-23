#!/usr/bin/env th


--●●●●●●●●●
--●       ●
--●       ●
--●       ●
--●●●●●●●●●


local col = require 'async.repl'.colorize
local mad = require './mad'
local col = require 'async.repl'.colorize
local image = require 'image'
local async = require 'async'
local pixels  = require 'pixels'
local black = '/Volumes/black/'
local desktop = '~/Desktop/'
desktop = desktop:gsub('^~', os.getenv('HOME'))



--●●●●●●●●●
--●       ●
--●       ●
--●       ●
--●●●●●●●●●


local dropped_012 = require '../../Desktop/ckoia-012-ranking.lua'
local dropped_XX = dropped_012['XX']
local dropped_NOT = dropped_012['NOT']

--●●●●●●●●●
--●       ●
--●       ●
--●       ●
--●●●●●●●●●


local hashed_013 = mad.json.load('/Volumes/ckoia/training/data/013/hashed.json')
local images = '/Volumes/ckoia/training/images'
local expno = '013'
local newexp = images..'/'..expno
local newexp_XX = newexp..'/'..'XX'
local newexp_NOT = newexp..'/'..'XX.not'
print(hashed_013['XX'])

local newexp_dropped_XX = newexp_XX..'.PB'
local newexp_dropped_NOT = newexp_NOT..'.PB'
dir.makepath(newexp_dropped_XX)
dir.makepath(newexp_dropped_NOT)



--●●●●●●●●●
--●       ●
--●       ●
--●       ●
--●●●●●●●●●

local n = 0
for i, elt in ipairs(dropped_XX) do
	n = n+1
	if n > 100 then break end
	local id = elt.file
	print(id)
	local from = hashed_013['XX'][id]
	print(from)
	local to = newexp_dropped_XX..'/'..elt.file
	mad.file.move(from,to)
		print(from,to)
	if from then
		mad.file.move(from,to)
		print(from,to)
	end
end
print(n)

--●●●●●●●●●
--●       ●
--●       ●
--●       ●
--●●●●●●●●●

-- local n = 0
-- for i, elt in ipairs(dropped_NOT) do
-- 	n = n+1
-- 	local from = hashed_013['XX.not'][elt.file]
-- 	local to = newexp_dropped_NOT..'/'..elt.file
-- 	if from then
-- 		-- mad.file.move(from,to)
-- 		print(from,to)
-- 	end
-- end
-- print(n)
