#!/usr/bin/env th

local hue = require './hue'
local syntax = {

   --╔══════════════════════════════════════════╗
   --║                                          ║
   --║                              LANGUAGE    ║
   --║                                          ║
   --╚══════════════════════════════════════════╝
   {
      name = 'Keywords"',
      color = hue.orange,
      back = hue.orange01,
      style = 'bold',
      selector='keyword.control',
   },
   {
      name ='Support',
      color=hue.blue,
      back=hue.blue01,
      style='italic',
      selector='support.function',
   },
   {
      name = 'Constants',
      color = hue.blue,
      back = hue.blue01,
      style = 'bold',
      selector = 'constant.language',
   },

   --╔══════════════════════════════════════════╗
   --║                                          ║
   --║                              USER        ║
   --║                                          ║
   --╚══════════════════════════════════════════╝

   {
      name = 'Function User',
      back = hue.base,
      color = hue.violet,
      style = 'italic bold',
      selector = 'entity.name.function',
   },
   {
      name = 'Function User Args',
      color = hue.cyan,
      back = hue.cyan01,
      style = 'bold',
      selector  = 'variable.parameter',
   },
   {
      name = 'Signs',
      back = hue.blue01,
      color = hue.blue,
      style = 'bold',
      selector='keyword.operator',
   },
   {
      name = 'Numbers',
      color = hue.pink,
      back = hue.pink01,
      style = 'bold',
      selector = 'constant',
   },
   {
      name= 'Variables',
      color= hue.base03,
      back = hue.base,
      style='italic',
      selector = 'variable',
   },

   --╔══════════════════════════════════════════╗
   --║                                          ║
   --║        Strings, Quotes & Comments        ║
   --║                                          ║
   --╚══════════════════════════════════════════╝
   {
      name ='String Block',
      color = hue.green,
      back = hue.base,
      style ='bold italic',
      selector = 'string.quoted.single',
   },

   {
      name = 'String',
      color =hue.black,
      back = hue.base,
      style ='black',
      selector = 'string.quoted.double',
   },
   {
      name = 'String',
      -- style='bold',
      color = hue.black,
      selector= 'punctuation',
   },
   {
      name = 'Quote Block',
      color = hue.green,
      back = hue.base001,
      style = 'bold',
      selector= 'constant.character, string'
   },

   {
      name = 'Comment',
      selector = 'comment, comment punctuation',
      color = hue.black,
      back = hue.base,
      style='bold italic',
   },
   {
      name = 'Block Comments',
      color = hue.pink,
      back = hue.base,
      style='bold italic',
      selector = 'comment.block',
   },
}

return syntax
