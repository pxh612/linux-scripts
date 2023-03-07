#=== DEFAULTS
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[[ "$(whoami)" = "root" ]] && return
[[ -z "$FUNCNEST" ]] && export FUNCNEST=100      

#=== Setting
#set -o noclobber # not allow ">" to overwrite file, only ">|"
#set -o vi		 # vim command on command line 

shopt -s checkwinsize
#shopt -u autocd                   

#export FZF_DEFAULT_OPTS="--ellipsis=\" [...] \""
#=== Bindingd

#bind '"\e[A":history-search-backward'
#bind '"\e[B":history-search-forward'
bind '"\e[B":history-search-backward'
bind '"\C-q":"q\n"'

#=== History setting
shopt -s histappend 

HISTTIMEFORMAT="   [%F > %H:%M]     "
export HISTCONTROL=erasedups:ignoredups
export HISTIGNORE
export HISTSIZE= 
export HISTFILESIZE=
#============ Bin from $PATH
#=== additional config (have to be at the beginning of file if use alias, add "command" if use function)
#alias fzf='fzf --height=~50'

#alias fzf='fzf --height 13 --info=hidden --border=rounded --prompt="           > "'
alias fzf='fzf --height 13 --info=hidden  --prompt="           > "'
alias ls='ls -v --color=auto --group-directories-first'
alias tree='tree -C --dirsfirst '
alias htop='htop -s M_RESIDENT -u $USER'
#htop(){
#	set-title-term htop
#	command htop -s M_RESIDENT -u $USER
#}

#=== shortening of a Bin command (use function please, for f() )
evi(){ evince "$@" ;}
t(){ trash "$@" ;}
gnum(){ gnumeric "$@" ;}
nv(){ nvim-qt "$@" ;}
yt(){ yt-dlp "$@" ;}
ebv(){ ebook-viewer "$@" ;}
a(){ cat "$@" ;}
#=== spelling mistake
mvp(){ mpv "$@" ;}
mpc(){ mpv "$@" ;}

#=== just BIN
sort-u(){
	sed '/^$/d' --in-place "$@"
	sort -u "$@" -o "$@"
	echo Sorted file \"$(realpath "$@")\".
}
set-title(){
	echo -en "\033]0;$@ \a"
	true
}
#/============ Bin from $PATH

#=== Appearance
pwd_shorten() {
	# How many characters of the $PWD should be kept
	pwdmaxlen=15
	# Indicate that there has been dir truncation
	trunc_symbol=".."
	dir=${PWD##*/}
	pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
	NEW_PWD=${PWD/$HOME/~}
	pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
	if [ ${pwdoffset} -gt "0" ]
	then
		NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
		NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
	fi
	#echo $NEW_PWD
	#pwd_short=$(pwd_shortened)
	pwd_short=$NEW_PWD
}
declare_colors(){
	NO='\[\033[0m\]'    # unsets color to term's fg color prompt_command(){
																	
	# regular colors
	 K='\[\033[0;30m\]'    # black                        	
	 R='\[\033[0;31m\]'    # red                          	
	 G='\[\033[0;32m\]'    # green                        	
	BR='\[\033[0;33m\]'   # brown                         	
	 B='\[\033[0;34m\]'    # blue                         	
	 M='\[\033[0;35m\]'    # magenta                      	
	LY='\[\033[0;37m\]'   # light gray                    	

																	
	DG='\[\033[1;30m\]'   # dark gray
	LR='\[\033[1;31m\]'   # light red                     	
	LG='\[\033[1;32m\]'   # light green                   	
	 Y='\[\033[1;33m\]'   # yellow                        	
	LB='\[\033[1;34m\]'   # light blue                    	
	LP='\[\033[1;35m\]'   # light purple                  	
	LC='\[\033[1;36m\]'   # light cyan                    	
	W='\[\033[1;37m\]'    # dark gray                     	
																	
	# background colors
	BGK='\[\033[40m\]'	# black                         	
	BGR='\[\033[41m\]'	# red                           	
	BGG='\[\033[42m\]'	# green                         	
	BGBR='\[\033[43m\]'	# brown                        	
	BGB='\[\033[44m\]'	# blue                          	
	BGM='\[\033[45m\]'	# purple                        	
	BGC='\[\033[46m\]'	# cyan                          	
	BGG='\[\033[47m\]'	# gray                          	

	#=== Color without escape character, new revision
	GREEN='\033[38;5;82m' # use for address bar
	CYAN='\033[0;36m'    # cyan                         	
	NO_COLOR='\033[0m'
	NO_COLOR_PS='\[\033[0m\['
	#/=== Color without escape character, new revision
																	
	UC=$C                 # user's color
	[ $UID -eq "0" ] && UC=$R   # root's color                  	
																	
	# custom pallette                                           	
	CS1='\[\033[38;5;226m\]'                              	
}	
declare_colors
#=== PROMPT COMMAND: EXECUTE AFTER EVERY COMMAND
prompt_command(){

	#local last_cmd=$?
	#=== write to history immediately
	history -a

	#=== reprint file listing if folder changed
	pwd_shorten
	total_file_size=$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')
	number_of_file=$(ls -1 | wc -l)
	#if [[ "$pwd_save" != "$PWD" ||  "$(ls | head -25)" != "$ls_view" ]]; then c ;fi
	#if [[ "$pwd_save" != "$PWD" ||  "$(ls | head -25)" != "$ls_view" ]]; then l ;fi

	#=== window name
	if [[ -n $NAME  ]]
		then set-title "$NAME"
		else set-title "($pwd_short)"
	fi
	#=== PS1
	export PS1=""
	PS1+="${BGB}"
	#	PS1+="              "
	#	PS1+="${LR}\u@\h "
		PS1+="${LR}"
		PS1+=" ($number_of_file files = $total_file_size)"
		PS1+="  >  "
	PS1+="${NO_COLOR_PS} "

	if [[ -n "$(jobs -rp )" || -n "$(jobs -sp )" ]]; then PS1+="${NO_COLOR_PS} [Job: \j] "; fi
	PS1+="\[${GREEN}\]($pwd_short) "
	PS1+="${NO_COLOR_PS}"
}

PROMPT_COMMAND='prompt_command'
set-title-term(){ 
	NAME="$@" ;
}
#=== Essential command, one button & no verbose name needed
R_xbindkeys(){
	local PID=$(ps aux | grep " xbindkeys" | grep -v grep | awk '{print $2}')
	kill $PID 1>/dev/null 2>&1 && xbindkeys && echo "xbindkeys: reloaded"
}
R(){
	source $HOME/.bashrc && echo "$HOME/.bashrc: sourced"
	openbox --reconfigure && echo "Openbox: reconfigured"
	R_xbindkeys
}
r(){
	ranger
}
q(){
	bg 2>/dev/null
	disown -a 
	exit
}
qq(){
	sleep 2
	#padding for after jobs notification

	second=10
	echo ==============
	while [ $second -gt 0 ]
	do
		echo Exit in $second...
		let second--
		sleep 1
	done
	q
}

c(){
	clear
	l
}
cla(){
	clear
	la
}
HISTIGNORE+=":R:q:qq:c"


#=== Navigate with numbers
addressbar()
{
	#echo -e "${CYAN}($number_of_file files = $total_file_size) ${GREEN}$PWD ${NO_COLOR}"
	echo -e "${GREEN}$PWD ${NO_COLOR}"
	if [[ "$PWD" != "$(pwd -P)" ]]; then
		echo -e "${GREEN}Physical: $(pwd -P)$(tput sgr0)"
	fi
}
l()
{			
	pwd_save=$PWD

	#=== truncate
	addressbar 
	ls --color=yes | head -25 | nl -s ", " -w 5 
	if [[ $(ls | wc -l) -gt 25 ]]
	then 
		echo "   ........"
	fi
	#/=== truncate

	ls_view="$(ls | head -25)"
	ls_save="$ls_view"
}
la()
{
	addressbar
	ls --color=yes -A | nl -s ", " -w 5
	ls_save="$(ls -A)"
}
HISTIGNORE+=":l:la"

#
#generate_number_command(){
#	path=/home/pxh612/.bashnumber
#	if [ -d "$path" ]; then
#		echo "#!/bin/sh" > $path
#		for((i=1;i<=99;i++)) 
#		do
#			echo "
#	k$i() {
#		 awk 'NR==$i' <(echo \"\$ls_save\")
#		 if [[ \"\$@\" != \"\" ]] ; then k\$@ ; fi
#	}" >> $path
#		done
#	fi
#}
#[[ -d "$HOME/.bashnumber" ]] && source $HOME/.bashnumber
#
#generate_command()
##{
#	alias=$@
#	place="$HOME/bashnumber/$alias"
#	place2="$HOME/bashnumber-histignore/$alias"
#	rm $place 2>/dev/null
#	rm $place2 2>/dev/null
#
#	echo "#!/bin/sh" > $place
#	for((i=1;i<=99;i++)) 
#	do
#		kstring=\"\$\(k$i\)\"
#		echo "alias $alias$i='$alias $kstring'" >> $place
#		echo HISTIGNORE+=\":$alias$i\" >> $place2
#	done
#	#source_generated_command
#} 
#generate_command_all(){
#	for cmd in $(ls $HOME/bashnumber) 
#	do
#		generate_command $cmd
#	done
#}
#source_generated_command(){
#	path=/home/pxh612/bashnumber
#	if [ -d "$path" ]; then
#		for file in /home/pxh612/bashnumber/*; do
#			source $file
#		done
#	fi
#}
#source_generated_command 

#=== FZF
fzf-dir() { find $HOME | fzf  --query="^$HOME     " ; }
fzf-file() { find $HOME | fzf  --query="$@ ^$HOME     " ; }

[[ -d "$HOME/completion.fzf" ]] && source $HOME/completion.fzf
[[ -d "$HOME/key-bindings.fzf" ]] && source $HOME/key-bindings.fzf
#fzf-his(){ __fzf_history__ "$@" ;}

#=== Directories with FZF
dhistory=$HOME/.directory_visited
[ -f $dhistory ] || touch $dhistory

#Add_to_dhistory(){
#	local path=$(realpath .)
#	local slash=${path//[!\/]}
#	slash=${#slash}
#	if [ $((slash%2)) -eq 0 ]
#	then sort -u -m $dhistory <(echo $path) -o $dhistory 
#	fi
#}
d()
{
	path="$@"
	if [[ $path ]]; then
		lastdirectory=$(realpath .)

		if [ -f "$path" ]; then 
			path="$(dirname "$path")"
			echo Dirname: $path
		fi
		
		cd "$path" &&\
		sort -u -m $dhistory <(realpath .) -o $dhistory 
	else 
		path=$(fzf-dir)
		if [[ $path ]]; then 
			d "$path"
		else echo No path choosen!
		fi
	fi
}
-(){ d - ;}
alias ~='d ~'
alias ..='d ..'
alias D='d  $HOME/Downloads'
alias dreal='d $(realpath .)'

HISTIGNORE+=":-:d:back:D:.."
#=== Files with FZF
f()
{
	local OPTIND run_and_quit
	while getopts "q" flag
	do
		case $flag in 
			q)
				run_and_quit=1
				;;
			\?)
				echo "Invalid option: -$flag" >&2
				;;
		esac
	done
	shift $((OPTIND-1))

	cmd=$1
	local query
	case $cmd in
		"mpv")
			query="mkv$ | mp4$ | webm$ "
			;;
		"gnum")
			query="gnumeric$ "
			;;
	esac
	file="$(fzf-file "$query")"
		
	if [ -f "$file" ]; then 
		d "$(dirname "$file")" 
		if [[ $cmd != "" ]]; then 
			echo Executed: $cmd \"$file\"
			if [ $run_and_quit ]; then
				$@ "$file" >/dev/null 2>&1 &
				qq
			else
				$@ "$file"
			fi
		fi		
	else
		echo No file choosen!
	fi
}
alias fq='f -q'

HISTIGNORE+=":f"
#=== xclip and variations...
pm(){ xclip -selection primary -o ;}
pw(){
	if [[ $@ == "" ]]; then
		echo No file...
		return
	fi
	pm >> "$@"
	echo >> "$@"
	echo ==== Printed to \""$@"\" ====
	echo $(pm) 
}

ytpp(){
	yt "$(pp)"
}

#=== sudo & excutable: variations...

#alias Install='sudo pacman -S '
#alias Uninstall='sudo pacman -R'
#alias Search='pacman -Ss '

alias Install='sudo apt install'
alias Uninstall='sudo apt remove'
alias Search='apt search'

alias Install-deb='sudo dpkg -i'

#alias Install2='yay -S'
#alias Uninstall2='yay -R'
#alias Search2='yay -Ss'

alias Executable='sudo chmod +x '
alias Chmodx='sudo chmod +x '
Script()
{
	filename=$1

	echo "#!/bin/sh" > $filename
	sudo chmod +x $filename
}



#=== Start up
#[[ $startup_done -eq 0 ]] && D 
#startup_done=1

#export PATH
#PATH=$PATH:$HOME/BIN

#===?
#set -o vi : use vim commands on the command line
#alias pf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
#https://stackoverflow.com/questions/6109225/echoing-the-last-command-run-in-bash
#https://stackoverflow.com/questions/4210042/how-do-i-exclude-a-directory-when-using-find


#=== bashrc command (quick)
alias bashrc-brightness-full='sudo brightnessctl set 255'
export -n SESSION_MANAGER
