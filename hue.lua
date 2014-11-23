#!/usr/bin/env th

local color = {}

color.base1        = '#ffffff'
color.base         = '#f2f2f2'
color.base001      = '#dddddd'
color.base01       = '#cccccc'
color.base02       = '#888888'
color.base03       = '#333333'
color.violet       = '#530ff5'
color.violet01     = '#e3f9fd'
color.cyan         = '#2cbae7'
color.cyan01       = '#cbebf5'
color.green        = '#65b11a'
color.green01      = '#f0f7ee'
color.pink         = '#fe2973'
color.pink01       = '#fcf1f4'
color.orange       = '#ffa502'
color.orange01     = '#fff6e6'
color.red          = '#ff5533'
color.red01        = '#ffeeeb'
color.yellow       = '#ffd201'
color.yellow01     = '#fffbe6'
color.grey         = '#9fa0a4'
color.grey01       = '#f6f6f6'
color.black        = '#9fa0a4'
color.black01      = '#f6f6f6'
color.lightblue    = '#65d0fc'
color.lightblue01  = '#f0fbff'
color.blue         = '#157efb'
color.blue01       = '#eaf3ff'
color.white        = '#ffffff'
color.white01      = '#000000'
color.black       = '#000000'
color.black01      = '#ffffff'

local scssColor = [[
   $violet        :]]..color.violet..[[;
   $cyan          :]]..color.cyan..[[;
   $green         :]]..color.green..[[;
   $pink          :]]..color.pink..[[;
   $orange        :]]..color.orange..[[;
   $red           :]]..color.red..[[;
   $yellow        :]]..color.yellow..[[;
   $grey          :]]..color.grey..[[;
   $black         :]]..color.black..[[;
   $lightblue     :]]..color.lightblue..[[;
   $blue          :]]..color.blue..[[;
   $white         :]]..color.white..[[;
   $black         :]]..color.black..[[;
   $violet01      :]]..color.violet01..[[;
   $cyan01        :]]..color.cyan01..[[;
   $green01       :]]..color.green01..[[;
   $pink01        :]]..color.pink01..[[;
   $orange01      :]]..color.orange01..[[;
   $red01         :]]..color.red01..[[;
   $yellow01      :]]..color.yellow01..[[;
   $grey01        :]]..color.grey01..[[;
   $black01       :]]..color.black01..[[;
   $lightblue01   :]]..color.lightblue01..[[;
   $blue01        :]]..color.blue01..[[;
   $white01       :]]..color.white01..[[;
   $black01       :]]..color.black01..[[;
]]

return color

