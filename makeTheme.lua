#!/usr/bin/env th
local col = require 'async.repl'.colorize
local hue = require './hue'
local mad = require './mad'

local syntaxes = {'lua','jade','md','css'}
print(syntaxes)
local syntaxSelectors = {}
for _,syntaxName in ipairs(syntaxes) do
   print(syntaxName)
   syntaxSelectors[syntaxName] = require('./x'..syntaxName)
end


generalSettings_selectors = {
   { selector = 'background',        color = hue.base },
   { selector = 'invisibles',        color = hue.base },
   { selector = 'lineHighlight',     color = hue.white },
   { selector = 'gutterForeground',  color = hue.base01 },
   { selector = 'foreground',        color = hue.base03 },
   { selector = 'selection',         color = hue.white },
   { selector = 'selectionBorder',   color = hue.black },
   { selector = 'caret',             color = hue.black },
   { selector = 'brackets',          color = hue.base02 },
   { selector = 'guide',             color = '#e0e0e0' },
   { selector = 'activeGuide',       color = hue.white },
   { selector = 'inactiveSelection', color = hue.yellow },
   { selector = 'findHighlight',     color = hue.yellow },
}



function generalSettingsXML ()
   local strings = {}
   for _,scope in ipairs(generalSettings_selectors) do
      print(scope.color)
      table.insert(strings,
         [[<key>]]..scope.selector..[[</key>
         <string>]]..scope.color..[[</string>
      ]])
   end
   return [[
      <dict>
         <key>settings</key>
         <dict>]]
               ..table.concat(strings)..[[
         </dict>
      </dict>
   ]]
end


function syntaxSpecificXML(syntax)
   local strings = {}
   local syntax = syntax or 'lua'
   local keyList = syntaxSelectors[syntax]
   for _,scope in ipairs(keyList) do
      local scopeStrings = {}
      local name = scope.name
      local color = scope.color
      local selector = scope.selector
      local style, back = ' ', ' '
      if scope.style then style = scope.style end
      if scope.back  then back = scope.back end
      table.insert(strings,
         [[ <dict>
               <key>name</key>
               <string>]]..name..[[</string>
               <key>scope</key>
               <string>]]..selector..[[</string>
               <key>settings</key>
                  <dict>
                     <key>foreground</key>
                     <string>]]..color..[[</string>
                     <key>fontStyle</key>
                     <string>]]..style..[[</string>
                     <key>background</key>
                     <string>]]..back..[[</string>
               </dict>
            </dict>
         ]]
      )
   end
   return table.concat(strings)
end


function makeTheme(language)

   local generalSettingStrings = generalSettingsXML()
   local syntaxSpecificStrings = syntaxSpecificXML(language)

   local xml = [[
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist
         PUBLIC '-//Apple Computer//DTD PLIST 1.0//EN'
         'http://www.apple.com/DTDs/PropertyList-1.0.dtd'>
         <plist version="1.0">
         <dict>
            <key>name</key>
            <string>MAD01</string>
            <key>settings</key>
            <array>]]
               ..generalSettingStrings
               ..syntaxSpecificStrings
               ..[[
            </array>
            <key>uuid</key>
            <string>13E579BF-40AB-42E2-9EAB-0AD3EDD88532</string>
            <key>colorSpaceName</key>
            <string>sRGB</string>
            <key>semanticClass</key>
            <string>theme.mad</string>
            <key>author</key>
            <string>MADenvironment</string>
         </dict>
      </plist>
   ]]
   print(col._blue(xml))

   local themeName = 'MAD-'..sys.uid()
   local me = os.getenv('HOME')
   local time = os.time()
   local packagePath = me..'/Library/Application Support/Sublime Text 3/Packages/MAD/'
   dir.makepath(packagePath)
   -- os.execute('mkdir -p "' .. packagePath..'"')
   local themeFile = themeName..'.tmTheme'
   local themePath = packagePath..themeFile
   mad.file.write(themePath,xml)
   print(col.blue('Theme Path'),col.red(themePath))
end

makeTheme('lua')
-- makeTheme('md')
-- makeTheme('jade')
-- makeTheme('css')

