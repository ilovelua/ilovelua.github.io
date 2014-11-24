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
               class ='donctentid',
            }),
         })
      })
   })
})

local fname = 'contentid.html'
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
