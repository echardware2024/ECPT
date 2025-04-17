#!/bin/bash

function green () {
  printf "\e[1;32m%b\e[0m" "$1"
}

host=$(hostname)  # get hostname
printf "\nStoring prodtest files for: \e[1;35m%s\e[0m\n" "$host"

printf "\nNavigate to prodtest:\n"
cd ~/prodtest  # ------------------------------- cd
foo=$?
if [ $foo -ne 0 ]; then
  printf "  \e[1;31m[EXIT: $foo]\e[0m\n"
else
  green "  [DONE]\n"
  printf "\nUpdate from github:\n"
  git pull  # ---------------------------------- pull
  foo=$?
  if [ $foo -ne 0 ]; then
    printf "  \e[1;31m[EXIT: $foo]\e[0m\n"
  else
    green "  [DONE]\n"
    printf "\nAdd new files:\n" 
    git add .  # ------------------------------- add
    foo=$?
    if [ $foo -ne 0 ]; then
      printf "  \e[1;31m[EXIT: $foo]\e[0m\n"
    else
      green "  [DONE]\n"
      printf "\nCommit:\n"
      git commit -m "$host"  # ----------------- commit
      foo=$?
      if [ $foo -ne 0 ]; then
        printf "  \e[1;33m[EXIT: $foo]\e[0m\n"  # YELLOW
      else
        green "  [DONE]\n"
        printf "\nPush to github:\n"
        git push  # ---------------------------- push
        foo=$?
        if [ $foo -ne 0 ]; then
          printf "  \e[1;31m[EXIT: $foo]\e[0m\n"
        else
          green "  [DONE]\n"
        fi  # end push
      fi  # end commit
    fi  # end add
  fi  # end pull
fi  # end cd

echo
# EOF
