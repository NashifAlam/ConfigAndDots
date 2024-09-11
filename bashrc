#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
                PS1='\n \[\033[01;31m\][\h\[\033[01;36m\] \w\[\033[01;31m\]]\$\[\033[00m\] '
        else
                PS1='\n \[\e[30;1m\]\nNstation\[\e[33;1m\]\n  \t \[\e[37;1m\]\W \[\e[0m\]'
        fi


	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
	alias vi=vim
	alias lc='ls -latr'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
alias vi=vim

xhost +local:root > /dev/null 2>&1

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

y-dlv()
{
        cd Videos
        yt-dlp -f 'bestvideo[height<=1440]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 $1
        cd
}

y-dls()
{
	cd Videos
        yt-dlp -f 'bestvideo[height<=480]+bestaudio' --merge-output-format mp4 $1
	cd
}

y-dlfile()
{
        yt-dlp -f 'bestvideo[height<=1440]+bestaudio' -o "%(autonumber)02d-%(title)s.%(ext)s" --merge-output-format mp4 --batch-file=data
}

y-dlp()
{
	yt-dlp  -f 'bestvideo[height<=480]+bestaudio' -o "%(playlist_index)s-%(title)s.%(ext)s" --merge-output-format mp4 $1

}

y-dlm()
{
       cd Music
       yt-dlp -i --extract-audio --audio-format mp3 --audio-quality 0 $1
       cd 
}

y-dlmp()
{

        cd Music
        mkdir $2
        cd $2
        yt-dlp --yes-playlist --extract-audio $1
        cd 
}

gitDeploy()
{
	timestamp=$(date +%s)
	git pull origin main
	git add -A
	git commit -m $timestamp
	git push origin main
}

setBack()
{
	xsetroot -solid "#002244"
}


boot()
{
echo  -ne '\n'
echo Initialising $1
sleep 1
sudo systemctl start sshd
sleep 0.5
echo -ne 'System verified \n'
sleep 0.7
echo -ne 'Initialising boot sequence\n'
sleep 0.5
echo -ne '#####                  (33%)\r'
sleep 0.3
echo -ne '#############          (66%)\r'
sleep 0.6
echo -ne '#######################(100%)\r'
#echo -ne '\n'

echo -ne 'Boot sequence completed         '
echo -ne '\n'
sleep 0.5
echo System Initialised sucessfully

#       sleep 3
#       echo system initialised
#       sleep
#       echo boot sequence complete
}

stats()
{
	btop --utf-force
}
RenderScreen()
{
	echo "$1x$2 Added to correct resolutions"
	cd Documents/Scripts
	./Resolution.sh
	cd
}

DeployPixel4a()
{

	cd /home/ndev/Android/Sdk/emulator/
	./emulator -avd Pixel_4a_API_30 &
}

run()
{
	echo "Running $1"
	gcc -g $1.c -o $1  &&	./$1 $2 $3
}
 
deploy()
{
	echo "Connecting to $1"
	ssh -p 9092 v23he8q1@183.82.107.231

}
Codes()
{
	cd ~/Documents/Study/Vector/C_sources/Codes 
	clear

runp()
{
        echo "Running $1"
        g++ -g $1.cpp -o $1 &&    ./$1 $2 $3
}
 

}
download()
{
	scp -P 9092 v23he8q1@183.82.107.231:~/Documents/$1 ~/Documents/Study/Vector/$2
}
export PATH=$PATH:/home/tdeck-4p/Documents/Scripts/
