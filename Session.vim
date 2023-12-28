let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/cfg_zsh
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +11 personal.sh
badd +2 init.sh
badd +167 install.sh
badd +4 plugins.sh
badd +1 Session.vim
badd +1 tmux.conf
badd +113 .zshrc
badd +1 alacritty.yml
badd +1 .gitignore
badd +97 .bashrc
badd +2 kubuntu_theme/13_02_44__28_12_2023.knsv
badd +1 kde_settings/utc_06_20_18__12_28_2023.knsv
argglobal
%argdel
$argadd personal.sh
edit personal.sh
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 154 + 155) / 310)
exe 'vert 2resize ' . ((&columns * 155 + 155) / 310)
argglobal
balt install.sh
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 11 - ((10 * winheight(0) + 18) / 36)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 11
normal! 05|
lcd ~/cfg_zsh
wincmd w
argglobal
if bufexists(fnamemodify("~/cfg_zsh/install.sh", ":p")) | buffer ~/cfg_zsh/install.sh | else | edit ~/cfg_zsh/install.sh | endif
if &buftype ==# 'terminal'
  silent file ~/cfg_zsh/install.sh
endif
balt ~/cfg_zsh/personal.sh
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 166 - ((10 * winheight(0) + 18) / 36)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 166
normal! 0
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 154 + 155) / 310)
exe 'vert 2resize ' . ((&columns * 155 + 155) / 310)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
let g:this_session = v:this_session
let g:this_obsession = v:this_session
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
