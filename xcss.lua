#!/usr/bin/env th

local hue = require './hue'

local syntax = {
  {
      selector = 'support.type.property-name',
      name = 'CSS Property Name',
      -- back = hue.white,
      color = hue.black,
      -- style = 'italic'
   },
   {
      selector = 'comment',
      name = 'comment',
      -- back = hue.black,
      color = '#000',
      style = 'bold italic'
   },
   {
      selector = 'support.type, support.class',
      name = 'support.type, support.class',
      -- back = hue.black,
      color = hue.grey,
      style = 'italic'
   },
    {
      selector = 'definition.variable',
      name = 'CSS Property Name',
      -- back = hue.white,
      color = hue.blue,
      -- style = 'italic'
   },
   {
      selector = 'entity.name.tag.css',
      name = 'CSS Selector - Tag',
      back = hue.pink01,
      color = hue.pink,
      style = 'bold',
   },
   {
      selector = 'constant.numeric',
      name = 'Number',
      color = hue.pink,
      style = 'bold',
   },
   {
      selector = 'constant.character, constant.other',
      name = '#000000',
      color = hue.pink,
      back = hue.black01,
      style = 'bold',
   },
   {
      selector = 'entity.other.attribute-name.id',
      name = 'CSS Selector - Id',
      back = hue.pink01,
      color = hue.pink,
      style = 'bold',
   },
   {
      selector = 'entity.other.attribute-name.class',
      name = 'CSS Selector - Class',
      back = hue.green01,
      color = hue.green,
      style = 'bold',
   },
   { -- &:hover
      selector = 'entity.other.attribute-name.pseudo-element, entity.other',
      name = 'CSS Pseudo Class,attribute-name.pseudo-class',
      back = hue.pink01,
      color = hue.pink,
      style = 'bold'
   },
   {
      selector = 'support.constant.property-value',
      name = 'CSS Property Value',
      back = hue.base,
      color = hue.black,
      style = 'bold'
   },
   {
      selector = 'constant.other.color.rgb-value',
      name = 'CSS Color',
      back = hue.white,
      color = hue.black,
      style = 'italic bold'
   },
   {
      selector = 'keyword.operator',
      name = 'CSS Unit',
      color = hue.black,
      style = 'bold'
   },
   {
      selector = 'support.constant.font-name',
      name = 'CSS Font Name',
      back = hue.orange01,
      color = hue.orange,
      style = 'italic'
   },
   {
      selector = 'punctuation.section.property-list.css',
      name = 'CSS Curly Brackets',
      back = hue.pink01,
      color = hue.pink,
      style = 'bold'
   },
   {
      selector = 'punctuation.definition.entity',
      name = '&',
      back = hue.black01,
      color = hue.black,
      style = 'bold italic'
   },
   {
      selector = 'punctuation.section.function.css',
      name = 'CSS Round Brackets',
      back = hue.pink01,
      color = hue.pink,
      style = 'bold'
   },
   {
      selector = 'support.function.misc.css',
      name = 'CSS url() / rgba() / hsla',
      back = hue.pink01,
      color = hue.pink,
   },
   {
      selector = 'variable.parameter.misc.css',
      name = 'CSS Parameter',
      back = hue.pink01,
      color = hue.pink,
   },
   {
      name = 'Less Selector - Tag',
      selector = 'keyword.control',
      back = hue.orange01,
      color = hue.orange,
      style = 'bold'
  },
  {
      name = 'Less Color',
      selector = 'source.css.less constant.other.rgb-value.css',
      back = hue.pink01,
      color = hue.pink,
      style = 'bold'
  },
  {
      name = 'Less Unit',
      selector = 'source.css.less keyword.unit.css',
      back = hue.pink01,
      color = hue.pink,
      style = 'bold'
  },
  {
      name = 'Less Curly Brackets',
      selector = 'source.css.less meta.brace.curly.js',
      back = hue.pink01,
      color = hue.pink,
      style = 'bold'
  },
  {
      name = 'Less Round Brackets',
      selector = 'source.css.less meta.brace.round.js',
      back = hue.pink01,
      color = hue.pink,
      style = 'bold'
  },
  {
      name = 'Less Operator',
      selector = 'keyword.operator.less',
      back = hue.pink01,
      color = hue.pink,
      style = 'bold'
  },
  {
      name = 'Variable',
      selector = 'variable',
      -- back = hue.blue01,
      color = hue.blue,
      style = 'bold'
  },
  {
      name = 'Less url() / rgba() / hsla',
      selector = 'source.css.less support.function',
      back = hue.pink01,
      color = hue.pink,
      style = 'bold'
  },
}
return syntax


