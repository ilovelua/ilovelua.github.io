#!/usr/bin/env th

local hue = require './hue'
--┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
--┃                                                                         ┃
--┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local syntax = {
   {
      name     = 'Markdown punctuation',
      selector = [[markup.list, text.html.markdown punctuation.definition, meta.separator.markdown]],
      back     = hue.pink01,
      color    = hue.pink,
   },
   {
      name = 'Markdown heading',
      selector = [[markup.heading]],
      back = hue.white,
      color = hue.black,
      style = 'bold',
   },
   {
      name = 'Markdown text inside some block element',
      selector = [[markup.quote, meta.paragraph.list]],
      color = hue.violet,
      back = hue.violet01,
      style = 'regular',
   },
   {
      name = 'Markdown reference',
      selector = [[markup.underline.link.markdown, meta.link.inline punctuation.definition.metadata, meta.link.referencmarkdowdefinition.constant, meta.link.reference.markdown constant.other.reference']] ,
      back = hue.blue01,
      color = hue.blue,
      style = 'regular',
   },
   {
      name = 'Markdown linebreak',
      selector = [[meta.paragraph.markdown meta.dummy.line-break]],
      back = hue.orange01,
      color = hue.orange,
      style = 'regular',
   },
   {
      name = 'Markdown Titles',
      selector = [[entity.name.section.markdown]],
      back = hue.red01,
      color = hue.red,
      style = 'italic',
   },
   {
      name = 'Markdown Title Hash',
      selector = [[punctuation.definition.heading.markdown]],
      color = hue.orange,
   },
   {
      name = 'Markdown Raw',
      selector = [[markup.raw.inline.markdown]],
      color = hue.cyan,
   },
   {
      name = 'Markdown bold stars',
      selector = [[punctuation.definition.bold.markdown, punctuation.definition.italic.markdown]],
      color = hue.orange,
   },
   {
      name = 'Markdown link title braces',
      selector = [[punctuation.definition.string.begin.markdown, punctuation.definition.string.end.markdown]],
      color = hue.red,
   },
   {
      name = 'Markdown link braces',
      selector = [[punctuation.definition.metadata.markdown]],
      color = hue.orange,
   },
   {
      name = 'Markdown link',
      selector = [[markup.underline.link.markdown, markup.underline.link.image.markdown, meta.image.inline.markdown]],
      color = hue.black,
      style= 'bold'
   },
   {
      name = 'Markdown em',
      selector = [[markup.italic, punctuation.definition.italic]],
      back = hue.green01,
      color = hue.green,
   },
   {
      name = 'Markdown strong',
      selector = [[markup.bold, punctuation.definition.bold]],
      back = hue.violet01,
      color = hue.violet,
   },
   {
      name = 'Markdown bold/italic',
      selector = [[markup.italic.markdown]],
      color = hue.pink,
   },
   {
      name = 'Markdown bold/italic',
      selector = [[markup.bold.markdown]],
      color = hue.pink,
   },
   {
      name = 'Markdown pre',
      selector = [[markup.raw.block.markdown]],
      color = hue.red,
   },
}
-- print(syntax)
return syntax
