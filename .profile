#=== Also run .bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

#=== Bin path
export PATH
PATH=$PATH:$HOME/BIN
PATH=$PATH:$HOME/BIN/direct-command

#=== export
export CLICOLOR=1
export EDITOR=nvim-qt
export -n SESSION_MANAGER
#export FZF_DEFAULT_OPTS="--height=17 --border=horizontal --margin=1,0,0,0 --info=hidden --prompt=\"                         > \"  --pointer=#  --marker=X  --ellipsis=\" [...] \"  --scroll-off=9999  --keep-right -m"
#export FZF_DEFAULT_OPTS='--prompt="    					> "'

#=== export HISTIGNORE
#export HISTIGNORE
#source_generated_command_histignore(){
#	for file in /home/pxh612/bashnumber-histignore/*; do
#		source $file
#	done
#}
#source_generated_command_histignore

##=== keyboard
setxkbmap -option caps:escape
xbindkeys

#=== startup pxh612-script
tint2 &
pxh612-DAEMON &
# the one and only customable script in .profile, 
# everything else is written inside it

#=== daemon
ibus-daemon &
qbittorrent &



