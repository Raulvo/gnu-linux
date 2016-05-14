# Script sourced from other scripts. NO #!/bin/bash or whatever has to be added.

# Preferred over sourcehighlight
# Additional lexers (-l option) can be found here: http://pygments.org/docs/lexers
# About styles: http://pygments.org/docs/styles/
# ['monokai', 'manni', 'rrt', 'perldoc', 'borland', 'colorful', 'default', 'murphy', 'vs', 'trac', 'tango', 'fruity', 'autumn', 'bw', 'emacs', 'vim', 'pastie', 'friendly', 'native']
textpygment() {
    colorparams="-O style=emacs -f 256"
    file "$1" | grep text > /dev/null
    if [ $? -eq 0 ]; then
        case "$1" in
            *.v)
                pygmentize ${colorparams} -l v "$1"
                ;;
            *.sv)
                pygmentize ${colorparams} -l sv "$1"
                ;;
            *.awk|*.groff|*.java|*.js|*.m4|*.php|*.pl|*.pm|*.pod|*.sh|*.erl|\
            *.ad[asb]|*.asm|*.S|*.s|*.inc|*.[ch]|*.[ch]pp|*.[ch]xx|*.cc|*.hh|\
            *.lsp|*.l|*.pas|*.p|*.xml|*.xps|*.xsl|*.axp|*.ppd|*.pov|*.tex|\
            *.diff|*.patch|*.py|*.rb|*.sql|*.ebuild|*.eclass|*.css|*.htm|*.html|*.vhd|*.vhdl|\
            *.cu|*.cuh|*.plot|*.plt|\
            *.vim*|.exrc|.gvim*|vim*|*.el|\
            *.cmake|CMakeLists.txt|Makefile|Makefile.*|makefile|makefile.*)
                pygmentize ${colorparams} "$1";;
            .bashrc|.bash_aliases|.bash_environment|.bash_profile|.profile|*.sh)
                pygmentize ${colorparams} -l sh "$1"
                ;;
            *)
                grep "#\!/bin/bash" "$1" > /dev/null
                if [ "$?" -eq "0" ]; then
                    pygmentize ${colorparams} -l sh "$1"
                else
                    pygmentize ${colorparams} -g  "$1"
                fi
        esac
    fi
}

sourcehighlight() {
    for source in "$@"; do
        case $source in
    	*ChangeLog|*changelog) 
            source-highlight --failsafe -f esc --lang-def=changelog.lang --style-file=esc.style -i "$source" ;;
    	*Makefile|*makefile) 
            source-highlight --failsafe -f esc --lang-def=makefile.lang --style-file=esc.style -i "$source" ;;
            *) source-highlight --failsafe --infer-lang -f esc --style-file=esc.style -i "$source" ;;
        esac
    done
}

myman() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;185m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[48;5;40m\E[38;5;00m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;166m' \
    man "$@"
    # LESS_TERMCAP_mb begin blinking
    # LESS_TERMCAP_md begin bold
    # LESS_TERMCAP_me end mode
    # LESS_TERMCAP_se end standout-mode
    # LESS_TERMCAP_so begin standout-mode - info box
    # LESS_TERMCAP_ue end underline
    # LESS_TERMCAP_us begin underline
}

# Aliases are discouraged/deprecated. Export functions instead.
export -f textpygment
export -f sourcehighlight
export -f myman
alias man=myman
alias catc=textpygment
alias grepc='grep --color=always'
alias lessv='vim -u /usr/share/vim/vim74/macros/less.vim'
