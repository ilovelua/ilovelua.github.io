#!/usr/bin/env th



local col = require 'async.repl'.colorize
local mad = require './mad'
local image = require 'image'
local async = require 'async'
local pixels  = require 'pixels'
local topbar = mad.dom.DIV({
      class ='topbar',
      content = table.concat({
         mad.dom.DIV({
            class = 'option',
            text = mad.rdm.word()
         }),
         mad.dom.DIV({
            class = 'option',
            text = mad.rdm.word()
         }),
         mad.dom.DIV({
            class = 'option',
            text = mad.rdm.word()
         }),
      }),
   })

--[[
   ╔═══════╗
   ║       ║
   ║       ║
   ╚═══════╝
--]]


function banner()
   local divs = {}
   local files = mad.permute(mad.dir.imgs('img/baner'))
   for i, file in ipairs(files) do
      table.insert(divs,
         mad.dom.DIV({
            class = 'box',
            content = table.concat({
               mad.dom.DIV({
                  class = 'img',
                  url = file,
                  content = mad.dom.DIV({
                     class = 'overlay',
                  }),
               }),
            })
         })
      )
   end
   return table.concat(divs)
end

--[[
   ╔═══════╗
   ║       ║
   ║       ║
   ╚═══════╝
--]]

function scroll()
   local divs = {}
   local alldirs = dir.getdirectories('img')
   local rdmdir = mad.sample(alldirs)
   local files = mad.permute(mad.dir.imgs(rdmdir))
   for i, file in ipairs(files)do
      table.insert(divs,
         mad.dom.DIV({
            class = 'box',
            content = table.concat({
               mad.dom.DIV({
                  class = 'img',
                  url = file,
                  content = mad.dom.DIV({
                     class = 'overlay',
                  }),
               }),
               mad.dom.DIV({
                  class = 'text',
                  text = mad.rdm.title()
               }),
            })
         })
      )
   end
   return table.concat(divs)
end

--[[
   ╔═══════╗
   ║       ║
   ║       ║
   ╚═══════╝
--]]

function links()
   local divs = {}
   local files = mad.dir.imgs('/Users/laeh/laeh/io/img')
   for i, file in ipairs(files) do
      print(i)
      table.insert(divs,
         mad.dom.DIV({
            class = 'box',
            content = table.concat({
               mad.dom.DIV({
                  class = 'text',
                  text = mad.rdm.title()
               }),
            })
         })
      )
   end
   return table.concat(divs)
end


--[[
   ╔══════════════════════╗
   ║                      ║
   ║                      ║
   ╚══════════════════════╝
--]]


local page = mad.dom.DIV({
   class ='screen',
   content = table.concat({
      topbar,
      mad.dom.DIV({
         class ='display',
         content = table.concat({
            mad.dom.DIV({
               class ='banner',
               content = banner()
            }),
            mad.dom.DIV({
               class ='scroll',
               content = scroll()
            }),
            mad.dom.DIV({
               class ='links',
               content = links()
            }),
         })
      })
   })
})

local fname = 'index.html'
mad.dom.makeDoc ({
   docName = fname,
   html = mad.dom.knitDoc({
      content = page,
      fcss = 'collection.css'
   }),
})
os.execute('open '..fname)
