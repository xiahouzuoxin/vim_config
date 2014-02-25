##Features
    1. 解决中文/菜单乱码
    2. 窗口设置：配置置状态栏，默认隐藏工具栏和菜单栏，F2快捷键可打开
	3. Ctrl+]执行ctags跳转，F12快捷键自动生成/更新tags文件,普通模式下wm在VIM左侧打开wmmanager窗口
    4. 自动补全([{等括号
    5. 自动为.c.h等插入文件头注释
    6. F3快捷键自动插入函数注释
    7. 设置中文字体为幼圆，英文字体为Courier New
    8. 语法高亮
    9. omnicppcomplete实现自动C/C++代码补全
    10. 当前行高亮
    11. 使用molokai经典TextMate主题
    12. 使用vim-markdown插件实现Markdown语法高亮等
	13. Visual模式下选择多行注释(>c)/反注释(<c)代码块
	14. Visual模式下选中字符串后，使用#,*,gv快捷键可快速实现文档内对选中字符串的查找
	15. 诸多其它小功能

##Plugins
    echofunc           函数参数提示
    taglist            标签
    winmanager         窗口管理 快捷键wm
    bufexplore         多文件编辑缓存管理 快捷键\be \bs \bv
    omnicppcomplete    C/C++代码自动提示
    colors/*           各种VIM主题
    vim-markdown       Markdown语法高亮 https://github.com/plasticboy/vim-markdown

## exec
    ctags.exe          Windows环境下的ctags,放置到gvim.exe所在目录,亦可到http://ctags.sourceforge.net/下载Linux环境下默认已安装
