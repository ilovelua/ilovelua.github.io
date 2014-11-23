

local package = [[

]]
brew install ffmpeg
local block = [[
   tar czvf /Users/LAEH/Desktop/exp-007.tgz /Users/LAEH/Desktop/exp-007
   tar czvf CKOiA-006_test_th.tgz /Volumes/black/CKOiA-006/CKOiA-006_test_th
   tar czvf CKOiA-006_train_json.tgz /Volumes/black/CKOiA-006/CKOiA-006_train_json
   tar czvf CKOiA-006_test_json.tgz /Volumes/black/CKOiA-006/CKOiA-006_test_json


   th pack.lua --idir /Volumes/black/ckoia-007/train/CO
   th pack.lua --idir /Volumes/black/ckoia-007/train/FD
   th pack.lua --idir /Volumes/black/ckoia-007/train/GR
   th pack.lua --idir /Volumes/black/ckoia-007/train/HU
   th pack.lua --idir /Volumes/black/ckoia-007/train/IN
   th pack.lua --idir /Volumes/black/ckoia-007/train/NA
   th pack.lua --idir /Volumes/black/ckoia-007/train/ST
   th pack.lua --idir /Volumes/black/ckoia-007/train/TX
   th pack.lua --idir /Volumes/black/ckoia-007/train/XX
   th pack.lua --idir /Volumes/black/ckoia-007/train/XX.not

   th idir.mosaic.lua --idir /Volumes/black/ckoia-007/train/CO
   th idir.mosaic.lua --idir /Volumes/black/ckoia-007/train/FD
   th idir.mosaic.lua --idir /Volumes/black/ckoia-007/train/GR
   th idir.mosaic.lua --idir /Volumes/black/ckoia-007/train/HU
   th idir.mosaic.lua --idir /Volumes/black/ckoia-007/train/IN
   th idir.mosaic.lua --idir /Volumes/black/ckoia-007/train/NA
   th idir.mosaic.lua --idir /Volumes/black/ckoia-007/train/ST
   th idir.mosaic.lua --idir /Volumes/black/ckoia-007/train/TX
   th idir.mosaic.lua --idir /Volumes/black/ckoia-007/train/XX
   th idir.mosaic.lua --idir /Volumes/black/ckoia-007/train/XX.not


]]


local makeGlobalScript = [[
   chmod +x file
   cd ~/bin
   ln -s /Users/LAEH/laeh/io/json.lua .
]]

local gitReset = [[
   GIT restart
   Save repo content somwhere
   cd repo
   rm -rf .git
   find . | grep .git | xargs rm -rf
   git init .
   git remote add origin https://git.twitter.biz/laeh
   git add -A
   git commit -a -m 'Fresh Start’
   git push -f origin master
   git clone https://git.twitter.biz/laeh
   git push -u origin master
]]



local server = [[
   scp -r /Users/LAEH/Desktop/exp-007.tgz sfo2-aag-03-sr1.perf.twttr.net:
   scp -r /Users/LAEH/Desktop/shuffledHU.th sfo2-aag-03-sr1.perf.twttr.net:
   scp -r /Users/LAEH/Desktop/shuffledGR.th sfo2-aag-03-sr1.perf.twttr.net:
   scp -r /Users/LAEH/Desktop/shuffledST.th sfo2-aag-03-sr1.perf.twttr.net:
   scp -r /Users/LAEH/Desktop/shuffledCO.th sfo2-aag-03-sr1.perf.twttr.net:
   scp -r /Users/LAEH/Desktop/shuffledNA.th sfo2-aag-03-sr1.perf.twttr.net:
   scp -r /Users/LAEH/Desktop/shuffledTX.th sfo2-aag-03-sr1.perf.twttr.net:
   scp -r /Users/LAEH/Desktop/shuffledFD.th sfo2-aag-03-sr1.perf.twttr.net:
   scp -r /Users/LAEH/Desktop/shuffledIN.th sfo2-aag-03-sr1.perf.twttr.net:
   cp exp-007.tgz /tmp/
   ssh sfo2-aag-03-sr1.perf.twttr.net
   ln -s /Users/LAEH/laeh/io/shell/sequence .
   ln -s /Users/LAEH/laeh/io/shell/bucket .
   ln -s /Users/LAEH/laeh/io/shell/classify .
   ln -s /Users/LAEH/laeh/io/shell/clean .
   ln -s /Users/LAEH/laeh/io/shell/crop .
   ln -s /Users/LAEH/laeh/io/shell/idir .
   ln -s /Users/LAEH/laeh/io/shell/mosaic .
   ln -s /Users/LAEH/laeh/io/shell/saveids .
   ln -s /Users/LAEH/laeh/io/shell/scale .

]]


local MADBITS = [[
./install-torch
cd ~
 rm ~/bin 
ln -s madbits/ckoia/build-Darwin-x86_64-Lua51/bin bin

IF Twitter bin
./install-torch
cd ~
ln -sf `pwd`/madbits/ckoia/build-Darwin-x86_64-Lua51/bin/th ~/bin/th

]]





command_pushToBlobstore = 'scp fichier.zip nest.smfc.twitter.com:~'
command_getFromBlobstore = 'scp nest.smfc.twitter.com:fichier.zip .'




[[

function findAndReplace()

end


os.execute('find TO -name "*.toosmall"')
os.execute('find TO -name "*.corrupted"')
os.execute('find TO -name "*.corrupted" -exec rm {} \;')
os.execute('find TO -name "*.toosmall" -exec rm {} \;')
os.execute('find TO -name "*.x" -exec rm {} \;')
os.execute('find TOx -name "*.jpg" -exec rm {} \;')
os.execute('find TOx -name "*.toosmall" -exec rm {} \;')
os.execute('find . -name “*orig” -exec mv {} {}.jpg \;')


ls dirname | wc -l
Command + J view options



go/krb-git
go/birdbrain
go/badsearchjira



Code - Tricks

un seul score, c’est pas facile je crois

le mieux c’est de calculer la distance

tu els resizes en 16x16

et

tu fais

dist = img1:dist(img2)

local _,_,score,id,ext = paths.basename(file):find('(%d%.%d*)_(.*)%.(...)$’)


MARKDOWN


![Training Sets](/img/trainingsets.jpg "Training Sets”)


<img
    style = "float       : center;
            width       : 512px;
            margin      : 0px 10% 20px 0px;
            box-shadow  : 0px 0px 5px #222"
    src =   "/img/GR.cartoon.character.bart.jpg"
/>

./get-set.lua “GR.album\ cover”


--
gm.Image(img, ‘RGB’, ‘DHW’):save(filename)
Antoine : antoine@etudes-studio.com



avant : th run
chmod +x crop.lua
apres : ./run

UPLOAD TEST SETS :


]]





local terminalColors = [[
   Black     : function: 0x058ad080
   black     : function: 0x058ad2d0
   _black    : function: 0x058ad290

   blue      : function: 0x058ad1a8
   Blue      : function: 0x058ad598
   _blue     : function: 0x058ad310

   cyan      : function: 0x058ad0c0
   Cyan      : function: 0x058ad8e0
   _cyan     : function: 0x058ad558

   green     : function: 0x058ad100
   Green     : function: 0x058ad920
   _green    : function: 0x058ad228

   Magenta   : function: 0x058ad140
   magenta   : function: 0x058ad350
   _magenta  : function: 0x058ad498

   Red       : function: 0x058ad450
   red       : function: 0x058ad4d8
   _red      : function: 0x058a8c30

   white     : function: 0x058ad1e8
   White     : function: 0x058ad390
   _white    : function: 0x058ad518

   Yellow    : function: 0x058ad3d0
   yellow    : function: 0x058ad410
   _yellow   : function: 0x058ad168

   none      : function: 0x058a8b98

]]

