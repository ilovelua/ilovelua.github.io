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
   local files = mad.permute(mad.dir.imgs('img/collections', 1000))
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
   local images_portrait_content = table.concat(divs)
   local images_portrait_content = mad.dom.DIV({
      class = 'images_portrait_content',
      content = table.concat(divs)
   })


   -- Header
   local images_portrait_header = mad.dom.DIV({
      class = 'images_portrait_header',
      content = mad.dom.DIV({
         class = 'title',
         text = mad.rdm.title()
      })
   })

   -- Wrap
   local images_portrait = mad.dom.DIV({
      class = 'images_portrait',
      content = table.concat({
         images_portrait_header,
         images_portrait_content,
      })
   })
   print(images_portrait)
   return images_portrait
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
            mad.dom.DIV({
               class ='under',
               content = table.concat({
                  scrollable_portrait_images(),
                  mad.dom.DIV({
                     class ='links',
                     content = links()
                  }),
               }),
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
      fcss = 'portal.css'
   }),
})
os.execute('open '..fname)


--[[
   ╔═══════╗
   ║       ║
   ║       ║
   ╚═══════╝
--]]

--  <!doctype html>
-- <head>
--     <title>Video.JS Example</title>
--     <link href="//vjs.zencdn.net/4.1/video-js.css" rel="stylesheet">
--     <script src="//vjs.zencdn.net/4.1/video.js"></script>
-- </head>
-- <body>
--     <div style="width:700px;margin:0px auto;">
--         <video id="example_video_1" class="video-js vjs-default-skin"
--                controls preload="auto" width="640" height="264"
--                poster="http://video-js.zencoder.com/oceans-clip.png"
--                data-setup='{"controls":true}'>
--             <source src="http://video-js.zencoder.com/oceans-clip.mp4" type='video/mp4' />
--             <source src="http://video-js.zencoder.com/oceans-clip.webm" type='video/webm' />
--             <source src="http://video-js.zencoder.com/oceans-clip.ogv" type='video/ogg' />
--         </video>
--     </div>
-- </body>
