dasm\bin\DOS\dasm main.asm -f3 -obin/wrdl-f.rom
cd mess
messd channelf -cart "C:\Users\NickSherman\Dropbox\wdl/bin/wrdl-f.rom" -w -r 960x800 -nodebug -nodirect3d
rem messd channelf -cart "C:\Dropbox\skal/bin/game.bin" -w -r 960x800 -nodebug -nodirect3d
rem messd channelf -cart "C:\Users\NickSherman\Dropbox\skal/skalboarga.rom" -w -r 960x800 -nodebug -nodirect3d