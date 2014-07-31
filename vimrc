" ==============================================================================
" ## Plugins
" echofunc 函数参数提示
" taglist 标签
" winmanager 窗口管理 快捷键wm
" bufexplore 多文件编辑缓存管理 快捷键\be \bs \bv
" omnicppcomplete C/C++代码自动提示
" colors/* 各种VIM主题
" vim-markdown Markdown语法高亮 https://github.com/plasticboy/vim-markdown
" NERDTree 文件浏览器管理插件
"
" ## Features
" 1. 解决中文/菜单乱码
" 2. 配置置状态栏，默认隐藏工具栏和菜单栏，F2快捷键可打开
" 3. 快捷键：Ctrl+]执行ctags跳转，Ctrl+T返回，F12快捷键自动生成/更新tags文件,
"    普通模式下wm在VIM左侧打开wmmanager窗口
" 4. 自动补全([{等括号
" 5. 自动为.c.h等插入文件头注释
" 6. F3快捷键自动插入函数注释
" 7. 设置中文字体为幼圆，英文字体为Courier New
" 8. 语法高亮
" 9. omnicppcomplete实现自动C/C++代码补全
" 10. 当前行高亮
" 11. 使用molokai经典TextMate主题
" 12. 使用vim-markdown插件实现Markdown语法高亮等
" 13. Visual模式下选择注释代码块 \cc注释 \co反注释
" 14. Visual模式下选中字符串后，使用#,*,gv快捷键可快速实现文档内对选中字符串的查找
" 15. 添加NERDTree插件，将NERDTree集成到winmanager窗口中. 将原NERDTree的打开文件快捷键O修改为Enter.
"
" ## Key Mapping
" 1. F2 打开工具栏和菜单栏
" 2. Ctrl+] Ctags跳转
" 3. Ctrl+T Ctags返回
" 4. F12 创建或更新tags文件
" 5. wm 打开winmanager左侧导航窗口
" 6. F3 插入函数注释
" 7. \cc 注释代码块
" 8. \co 反注释代码块
" 9. #,* Visual模式下对选择字符查找
" 10.NERDTree/Enter: 从NERDTree中打开选中文件
"
" Author: Zuoxin,Xiahou (xiahouzuoxin@163.com)
" Copyright (c) MICL,USTB
" ==============================================================================


" ------------------------------------------------------------------------------
" FOR VIM in Linux
" ------------------------------------------------------------------------------

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
  autocmd!
  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"



" ------------------------------------------------------------------------------
" EchoFunc配置（快捷键）
" ------------------------------------------------------------------------------
let g:EchoFuncKeyNext = '<S-n>'   
let g:EchoFuncKeyPrev = '<S-p>'
let g:EchoFuncShowOnStatus = 1  " 状态行函数提示

" ------------------------------------------------------------------------------
" VIM窗口界面设置
" ------------------------------------------------------------------------------
au GUIEnter * simalt ~x         "启动后最大化
let g:winManagerWindowLayout='FileExplorer|TagList'  "设置左侧导航窗口
" 我的状态行显示的内容（包括文件类型和解码）
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}\ %{EchoFuncGetStatusLine()}
set laststatus=2                " 启动显示状态行(1),总是显示状态行(2)
set guioptions-=m               " 隐藏工具栏
set guioptions-=T               " 隐藏菜单栏
map <silent> <F2> :if &guioptions =~# 'T' <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=m <bar>
    \else <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=m <Bar>
    \endif<CR>

" ------------------------------------------------------------------------------
" 程序的编译运行
" ------------------------------------------------------------------------------
"C，C++ 按F5编译运行
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "!./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!./%<"
    elseif &filetype == 'java' 
        exec "!javac %" 
        exec "!java %<"
    elseif &filetype == 'sh'
        :!./%
    endif
endfunc
"C,C++的调试
map <F8> :call Rungdb()<CR>
func! Rungdb()
    exec "w"
    exec "!g++ % -g -o %<"
    exec "!gdb ./%<"
endfunc

" ------------------------------------------------------------------------------
" 自动补全各种括号
" ------------------------------------------------------------------------------
let g:CompleteBracket=1         "设自动补全括号变量
if g:CompleteBracket==1
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {<CR>}<ESC>O
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i
endif
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction

" ------------------------------------------------------------------------------
" 自动插入文件头
" ------------------------------------------------------------------------------
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.v,*.m exec ":call SetTitle()" 
autocmd BufNewFile * normal G  "新建文件后，自动定位到文件末尾
func SetTitle() " 定义函数SetTitle，自动插入文件头  
    if &filetype == 'sh'  "如果文件类型为.sh文件 
        call setline(1,"#########################################################################") 
        call append(line("."), "# FileName : ".expand("%")) 
        call append(line(".")+1, "# Author   : xiahouzuoxin @163.com") 
        call append(line(".")+2, "# Date     : ".strftime("%c")) 
        call append(line(".")+3, "#########################################################################") 
        call append(line(".")+4, "# ") 
        call append(line(".")+5, "#!/bin/bash") 
        call append(line(".")+6, "") 
    elseif &filetype == 'matlab' 
        call setline(1, "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%") 
        call append(line("."), "% FileName : ".expand("%")) 
        call append(line(".")+1, "% Author   : xiahouzuoxin @163.com") 
        call append(line(".")+2, "% Version  : v1.0") 
        call append(line(".")+3, "% Date     : ".strftime("%c")) 
        call append(line(".")+4, "% Brief    : ")
        call append(line(".")+5, "% ")
        call append(line(".")+6, "% Copyright (C) MICL,USTB") 
        call append(line(".")+7, "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%") 
        call append(line(".")+8, " ")
    else 
        call setline(1, "/*") 
        call append(line("."), " * FileName : ".expand("%")) 
        call append(line(".")+1, " * Author   : xiahouzuoxin @163.com") 
        call append(line(".")+2, " * Version  : v1.0") 
        call append(line(".")+3, " * Date     : ".strftime("%c")) 
        call append(line(".")+4, " * Brief    : ")
        call append(line(".")+5, " * ")
        call append(line(".")+6, " * Copyright (C) MICL,USTB") 
        call append(line(".")+7, " */") 
        call append(line(".")+8, " ")
    endif
    " include in .c and .cpp
    " if &filetype == 'cpp'
    "     call append(line(".")+9, "#include<iostream>")
    "     call append(line(".")+10, "using namespace std;")
    "     call append(line(".")+11, "")
    " endif
    " if &filetype == 'c'
    "     call append(line(".")+9, "#include<stdio.h>")
    "     call append(line(".")+10, "")
    " endif
endfunc 

" ------------------------------------------------------------------------------
" F3自动插入函数注释
" ------------------------------------------------------------------------------
map <F3> :call SetFuncNotes()<CR>
func SetFuncNotes()
    if &filetype == 'sh'
        call append(line("."), "# @brief   ") 
        call append(line(".")+1, "# @inputs  ") 
        call append(line(".")+2, "# @outputs ") 
        call append(line(".")+3, "# @retval  ") 
    elseif &filetype == 'matlab'
        call append(line("."), "% @brief   ") 
        call append(line(".")+1, "% @inputs  ") 
        call append(line(".")+2, "% @outputs ") 
        call append(line(".")+3, "% @retval  ") 
    else
        call append(line("."), "/*") 
        call append(line(".")+1, " * @brief   ") 
        call append(line(".")+2, " * @inputs  ") 
        call append(line(".")+3, " * @outputs ") 
        call append(line(".")+4, " * @retval  ") 
        call append(line(".")+5, " */") 
    endif
endfunc

" ------------------------------------------------------------------------------
" 基础设置
" ------------------------------------------------------------------------------
"set history=500                 "设定历史记录条数
set guifont=Courier\ New:h11    "英文字体及大小 
set gfw=幼圆:h10.5:cGB2312       "中文字体及大小
set nocp                        "去掉vi一致性模式，避免以前版本的bug和局限
filetype plugin on              "允许插件
filetype plugin indent on       "缩进
set completeopt=longest,menu    "打开文件类型检测, 加了这句才可以用智能补全
set cursorline                  "突出显示当前行
syntax enable
syntax on                       "语言高亮
set cindent                     "C语言格式缩进
set smartindent                 "智能缩进
set nu                          "行号显示
colo desert                    "设定主题,desert/lucius/molokai主题都不错
set tabstop=4                   "设定tab宽度为4个字符
set shiftwidth=4                "设定自动缩进为4个字符
set expandtab                   "用space替代tab的输入
set nobackup                    "无备份
"set noswapfile                  "无交换文件,注意，错误退出后无法恢复
autocmd InsertLeave * se nocul  "用浅色高亮当前行  
autocmd InsertEnter * se cul    "用浅色高亮当前行
set completeopt=preview,menu    "代码补全
"set foldenable                  "允许折叠  
"set foldmethod=indent           "折叠方式,包括indent,manual,marker等 
let Tlist_Exit_OnlyWindow = 1   "如果taglist窗口是最后一个窗口，则退出VIM
set iskeyword+=_,$,@,%,#,-      "带有左侧符号的单词不要被换行分割
set noerrorbells                "禁止错误声音提示
set novisualbell                "无错误屏幕闪烁提示
set t_vb=                       "清空错误响铃终端代码
set mouse=a                     "使能鼠标
" set lbr                         "在breakat字符处而不是最后一个字符处断行
" set textwidth=82                "设置最大列数，超出后自动换行
" set fo+=m                       "汉字超出最大列数自动换行
" set cc=82                       "在cc列加列数限制竖线
set so=5                        "光标上下两侧最少保留的屏幕行数scrolloff
set cmdheight=1                 "命令行高度设置
set hlsearch                    "搜索的字符高亮

" 第82列往后加下划线
au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 82 . 'v.\+', -1)


"如果文件外部改变，自动载入
if exists("&autoread")
    set autoread
endif

"下次开启VIM，自动将光标定位到关闭的位置
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" ------------------------------------------------------------------------------
" vim-markdown插件设置
" ------------------------------------------------------------------------------
"]]: go to next header.
"[[: go to previous header. Contrast with ]c.
"][: go to next sibling header if any.
"[]: go to previous sibling header if any.
"]c: go to Current header.
"]u: go to parent header (Up).
let g:vim_markdown_folding_disable=1    "禁止md文件的折叠功能
let g:vim_markdown_initial_foldlevel=1  "折叠级别设置，需开启vim_markdown_folding_disable

" ------------------------------------------------------------------------------
" Ctags与Taglist设置
" ------------------------------------------------------------------------------
"如果ctags与gvim不在同一目录，则设置ctags路径
"let Tlist_Ctags_Cmd = 'D:\ctags58\ctags.exe'

"Taglist跳转快捷键
nmap <c-]> g<c-]>               "将Ctrl+]快捷键映射到g Ctrl+]

let Tlist_Show_One_File=1       "不同时显示多个文件的 tag ，只显示当前文件的

"F12生成/更新tags文件 
set tags=tags 
"set autochdir
function! UpdateTagsFile() 
    !ctags -R --c++-kinds=+p --fields=+ianS --extra=+q 
endfunction 
nmap <F12> :call UpdateTagsFile()<CR>

" ------------------------------------------------------------------------------
" NERDTree设置
" ------------------------------------------------------------------------------
let g:NERDTree_title="[NERDTree]"
function! NERDTree_Start()  
    exec 'NERDTree'  
endfunction  
  
function! NERDTree_IsValid()  
    return 1  
endfunction 

"let NERDTreeChDirMode=2         "选中root即设置为当前目录
let NERDTreeShowBookmarks=1     "显示书签
"let NERDTreeMinimalUI=1         "不显示帮助面板
let NERDTreeDirArrows=0         "目录箭头 1 显示箭头  0传统+-|号
let NERDTreeMouseMode=2         "可以使用鼠标打开文件

" ------------------------------------------------------------------------------
" winmanager设置
" ------------------------------------------------------------------------------
"let g:winManagerWindowLayout="FileExplorer|TagList,BufExplorer"  "设置wm界面分割
let g:winManagerWindowLayout="NERDTree|TagList,BufExplorer"  "设置wm界面分割: NERDTree替换FileExplorer
let g:AutoOpenWinManager=0      "设为1则在进入vim时自动打开winmanager
let g:winManagerWidth = 30      "设置winmanager宽度
nmap wm :WMToggle<cr>           "wm快捷键用于打开winmanager

" ------------------------------------------------------------------------------
" Visual模式下快速注释代码块
" Refrence to comment.vim, version 1.0
" jerome.plut at normalesup dot org
" 快捷键：\cc注释，\co反注释
" ------------------------------------------------------------------------------
function! CommentStyle(s)
  if match (a:s, '@') >= 0
  let str1 = substitute (a:s, '@.*$', '', '')
    let str2 = substitute (a:s, '^.*@', '', '')
  else
    let str1 = a:s. ' '
    let str2 = ''
  endif
  let pat1 = substitute (str1, '[][*^.$~]', '\\&', 'g')
  let pat1 = substitute (pat1, '\s*$', '\\s*', '')
  let str1 = substitute (str1, '&', '\\&', 'g')
  if str2 == ''
    " s:l1 contains the computed patterns to comment, s:l2 those to
    " uncomment
    let s:l1 = [ 'sm@^@'.str1.'@e' ]
    let s:l2 = [ 'sm@^\s*'.pat1.'@@e' ]
  else
    let pat2 = substitute (str2, '[][*^.$~]', '\\&', 'g')
    let pat2 = substitute (pat2, '^\s*', '\\s*', '')
    let str2 = substitute (str2, '&', '\\&', 'g')
    " protect any comment that becomes nested
    " with non-ASCII chars, to avoid collisions
    let s:l1 = ['sm@?¤@?¤¤@ge', 'sm@'.pat1.'@?¤?@ge', 'sm@^@'.str1.'@e']
    let s:l1+= ['sm@¤?@¤¤?@ge', 'sm@'.pat2.'@?¤?@ge', 'sm@$@'.str2.'@e']
    let s:l2 = ['sm@^\s*'.pat1.'@@e', 'sm@?¤?@'.str1.'@ge', 'sm@?¤¤@?¤@ge']
    let s:l2+= ['sm@'.pat2.'\s*$@@e', 'sm@?¤?@'.str2.'@ge', 'sm@¤¤?@¤?@ge']
  endif
endfunction

function! Comment() range
  for s in s:l1
    execute ':sil '.a:firstline.','.a:lastline.s
  endfor
endfunction

function! UnComment() range
  let pre = ':sil '.a:firstline.','.a:lastline
  for s in s:l2
    execute ':sil '.a:firstline.','.a:lastline.s
  endfor
endfunction

command! -nargs=1 CommentStyle call CommentStyle (<f-args>)

map <silent> \cc :call Comment()<CR>
map <silent> \co :call UnComment()<CR>
map =c :CommentStyle<Space>

"不同类型文件使用不同的注释符号
au FileType * CommentStyle #
au FileType vim CommentStyle "
au FileType c,cpp,h,verilog CommentStyle //
au FileType html CommentStyle <!-- @ -->
au FileType python CommentStyle """ @ """
" This makes quotes in emails
au FileType mail CommentStyle >

" ------------------------------------------------------------------------------
" Visual模式下选择查找，非常棒的操作
" - Using the "*" key while in visual mode searches for the current selection (forwards)
" - Using the "#" key while in visual mode searches for the current selection (backwards)
" - Pressing "gv" will vimgrep the current selection
" ------------------------------------------------------------------------------
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"Basically you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
vnoremap <silent> gv :call VisualSearch('gv')<CR>

set tags+=/usr/local/include/opencv/tags
set tags+=/usr/local/include/opencv2/tags
