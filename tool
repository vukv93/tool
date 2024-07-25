#!/usr/bin/env bash
DATA_DIR=~/.local/share/tool
[ ! -e $DATA_DIR ] && mkdir -p $DATA_DIR
# @todo[240711_074508] Add subcommand completion.
TOOL_SHELL_SETUP="\
complete -W \"$(gawk 'match($0,/^\s+(\w+)\)/,a){printf"%s ",a[1]}' $(realpath $0) | sed 's/\n/ /g')\" tool
"
case $1 in
  pack) tar -zcvf $(date +%y%m%d_%H%M%S)_$(basename $2).tar.gz $2 ;;
  shrec) script -O $2.typescript -T $2.timingfile ;;
  shplay) script $2.timingfile $2.typescript ;;
  cs) read -s x && cowsay "$x" ;;
  tunnel) ssh -L $3:localhost:$3 $2 ;;
  slp) sleep 30 && systemctl suspend ;;
  github) git clone git@github.com:$2 ;;
  ytaudio) yt-dlp -x $2 -o $3 ;;
  shellsetup) echo "$TOOL_SHELL_SETUP" ;;
  gsave) git add . && git commit -m "$2" && git log --stat -1 ;;
  help) [[ -n $2 ]] && awk -v opt="$2" "BEGIN{p=0};\$1~opt\")\"{p=1};p{print};\$0~\";;\$\"{p=0}" $(realpath $0) || batcat $(realpath $0) ;;
  cp) xclip -selection clipboard -i < $2 ;;
  *) echo "I don't know that one." ;;
esac
