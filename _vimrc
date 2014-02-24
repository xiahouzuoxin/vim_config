" ==> Add plugins
" echofunc           函数参数提示
" taglist            标签
" winmanager         窗口管理 快捷键wm
" bufexplore         多文件编辑缓存管理 快捷键\be \bs \bv
" omnicppcomplete    C/C++代码自动提示
" colors/*           各种VIM主题
" vim-markdown       Markdown语法高亮 https://github.com/plasticboy/vim-markdown
"


"默认vimrc配置
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

""""""""""""""""""""""""""""""""""""""""""""""""""
" 原gvim自带的配置
""""""""""""""""""""""""""""""""""""""""""""""""""
set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""
" 解决中文/菜单乱码
""""""""""""""""""""""""""""""""""""""""""""""""""
"编码设置
set encoding=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
"语言设置
set langmenu=zh_CN.UTF-8
set helplang=cn
" 解决菜单乱码,set encoding=utf-8会出现菜单乱码，下面配置可解决
let $LANG = 'zh_CN.UTF-8'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim


""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM窗口界面设置
""""""""""""""""""""""""""""""""""""""""""""""""""
au GUIEnter * simalt ~x         "启动后最大化
let g:winManagerWindowLayout='FileExplorer|TagList'  "设置左侧导航窗口
" 我的状态行显示的内容（包括文件类型和解码）
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
"set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
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

""""""""""""""""""""""""""""""""""""""""""""""""""
" 快捷键映射
""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <c-]> g<c-]>      " 将Ctrl+]快捷键映射到g Ctrl+]
nmap wm :WMToggle<cr>  " wm快捷键用于打开FileExplorer

""""""""""""""""""""""""""""""""""""""""""""""""""
" 程序的编译运行
""""""""""""""""""""""""""""""""""""""""""""""""""
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

""""""""""""""""""""""""""""""""""""""""""""""""""
" 自动补全各种括号
""""""""""""""""""""""""""""""""""""""""""""""""""
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {<CR>}<ESC>O
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""
" 自动插入文件头
""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.v,*.m exec ":call SetTitle()" 
func SetTitle() " 定义函数SetTitle，自动插入文件头  
    if &filetype == 'sh'  "如果文件类型为.sh文件 
        call setline(1,"#########################################################################") 
        call append(line("."), "# FileName : ".expand("%")) 
        call append(line(".")+1, "# Author   : xiahouzuoxin @163.com") 
        call append(line(".")+2, "# Date     : ".strftime("%c")) 
        call append(line(".")+3, "#########################################################################") 
        call append(line(".")+4, "") 
        call append(line(".")+5, "#!/bin/bash") 
        call append(line(".")+6, "") 
    elseif &filetype == 'matlab' 
        call setline(1, "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%") 
        call append(line("."), "% FileName : ".expand("%")) 
        call append(line(".")+1, "% Author   : xiahouzuoxin @163.com") 
        call append(line(".")+2, "% Version  : v1.0") 
        call append(line(".")+3, "% Date     : ".strftime("%c")) 
        call append(line(".")+4, "% Brief    : ")
        call append(line(".")+5, "")
        call append(line(".")+6, "% Copyright (C) USTB") 
        call append(line(".")+7, "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%") 
        call append(line(".")+8, " ")
    else 
        call setline(1, "/*") 
        call append(line("."), " * FileName : ".expand("%")) 
        call append(line(".")+1, " * Author   : xiahouzuoxin @163.com") 
        call append(line(".")+2, " * Version  : v1.0") 
        call append(line(".")+3, " * Date     : ".strftime("%c")) 
        call append(line(".")+4, " * Brief    : ")
        call append(line(".")+5, "")
        call append(line(".")+6, " * Copyright (C) USTB") 
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
    "新建文件后，自动定位到文件末尾
    autocmd BufNewFile * normal G
endfunc 

""""""""""""""""""""""""""""""""""""""""""""""""""
" F3自动插入函数注释
""""""""""""""""""""""""""""""""""""""""""""""""""
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

""""""""""""""""""""""""""""""""""""""""""""""""""
" 基础设置
""""""""""""""""""""""""""""""""""""""""""""""""""
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
set cindent
set nu                          "行号显示
colo molokai                    "设定主题,desert/lucius/molokai主题都不错
set tabstop=4                   "设定tab宽度为4个字符
set shiftwidth=4                "设定自动缩进为4个字符
set expandtab                   "用space替代tab的输入
set nobackup                    "无备份
"set noswapfile                  "无交换文件
autocmd InsertLeave * se nocul  "用浅色高亮当前行  
autocmd InsertEnter * se cul    "用浅色高亮当前行
set completeopt=preview,menu    "代码补全
set foldenable                  "允许折叠  
set foldmethod=manual           "手动折叠  
let Tlist_Exit_OnlyWindow = 1   "如果taglist窗口是最后一个窗口，则退出VIM
set iskeyword+=_,$,@,%,#,-      "带有左侧符号的单词不要被换行分割
set noerrorbells                "禁止错误声音提示
set novisualbell                "无错误屏幕闪烁提示
"清空错误响铃终端代码
set t_vb=
set mouse=a                     "使能鼠标

"如果文件外部改变，自动载入
if exists("&autoread")
    set autoread
endif

"vim-markdown插件设置
"]]: go to next header.
"[[: go to previous header. Contrast with ]c.
"][: go to next sibling header if any.
"[]: go to previous sibling header if any.
"]c: go to Current header.
"]u: go to parent header (Up).
let g:vim_markdown_folding_disable=1    "禁止md文件的折叠功能
let g:vim_markdown_initial_foldlevel=1  "折叠级别设置，需开启vim_markdown_folding_disable

""""""""""""""""""""""""""""""""""""""""""""""""""
" 新增tags
""""""""""""""""""""""""""""""""""""""""""""""""""
" Linux Kernel Tags
set tags+=E:\LinuxKernel\linux-3.13\tags

