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

function scrollable_portrait_images()

   -- Files
   local divs = {}
   local files = mad.permute(mad.dir.imgs('img/collections', 100))
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

   -- Images
   local scroll_section_content = table.concat(divs)
   local scroll_section_content = mad.dom.DIV({
      class = 'scroll_section_content',
      content = table.concat(divs)
   })


   -- Header
   local scroll_section_header = mad.dom.DIV({
      class = 'scroll_section_header',
      content = mad.dom.DIV({
         class = 'title',
         text = mad.rdm.title()
      })
   })

   -- Wrap
   local scroll_section = mad.dom.DIV({
      class = 'scroll_section',
      content = table.concat({
         scroll_section_header,
         scroll_section_content,
      })
   })
   print(scroll_section)
   return scroll_section
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
   ╔═══════╗
   ║       ║
   ║       ║
   ╚═══════╝
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
            scrollable_portrait_images(),
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
