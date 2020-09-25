# my old custom colors
# export LS_COLORS="no=00:fi=37:di=1;33:ex=1;31:ln=7:or=1;30;41:su=32;40:sg=36;40:tw=33;40:ow=35;40:st=34;40:pi=7;30:so=7;30:do=7;30:bd=7;30:cd=7;30:*.jpg=36:*.png=36:*.gif=36:*.txt=35:*.md=35:*.rst=35:*.sql=35:*.py=32:*.php=32:*.rb=32:*.git=33:*.svn=33:*.html=34:*.ejs=34:*.js=38;5;137:*.scss=38;5;204:*.css=38;5;204:*.less=38;5;204:*.pyc=30:*.pyo=30:*.DS_Store=00:*.Trash=00:*.localized=00:*.html~=30:*.html#=30:*.dmg=7;33:*.csv=1;32:*.xlsx=1;32:*.xls=1;32:*.docx=1;36:*.doc=1;36:*.pptx=1;36:*.ppt=1;36:*.pdf=1;36:*.webloc=1;34:*.taskpaper=1;37:*.psd=1;37:*.pxm=1;37:*.acorn=1;37:*.json=38;5;101:Dockerfile=38;5;103"

# from vivid (https://github.com/sharkdp/vivid/tree/master/themes)
export LS_COLORS="$(vivid generate jellybeans)"
export GREP_COLORS="ms=43:mc=43:sl=:cx=:fn=35:ln=32:bn=32:se=36" # for default $ man grep

autoload -U colors && colors
