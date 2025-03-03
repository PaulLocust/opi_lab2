#!/bin/bash

set -e  # Прерывает выполнение скрипта при любой ошибке

git config --global core.autocrlf input

red() {
  git config --local user.name "red"
  git config --local user.email "red@mail.com"
}

blue() {
  git config --local user.name "blue"
  git config --local user.email "blue@mail.com"
}

commit() {
  unzip -o "../commits_zip/commit$1.zip" -d src
  git add *
  git commit -am "r$1" --allow-empty

  CURRENT_USER=$(git config user.name)  # Получаем имя пользователя

  if [ "$CURRENT_USER" = "red" ]; then
    echo -e "commit info: r$1 $CURRENT_USER 🔴 ↑"
  else
    echo -e "commit info: r$1 $CURRENT_USER 🔵 ↑"
  fi
  echo -e "--------------------------\n"
}

branch() {
	git checkout $2 branch$1
}

merge() {
  git merge branch$1 --no-commit
}

# Эта опция сохранит вашу версию файла (ветку, из которой выполняется слияние) в случае конфликта
# git merge --no-commit branch3 -Xours
merge_save_our_data() {
  git merge --no-commit branch$1 -Xours
}

# Эта опция сохранит версию файла из ветки, с которой выполняется слияние, в случае конфликта
# git merge --no-commit branch3 -Xtheirs
merge_save_their_data() {
  git merge --no-commit branch$1 -Xtheirs
}

# init
rm -rf git
mkdir git
cd git
git init

# 0
red
commit 0

# 1
branch 1 -b
commit 1

# 2
blue
branch 2 -b
commit 2

# 3
branch 3 -b
commit 3

# 4
red
branch 4 -b
commit 4

# 5
blue
branch 2
commit 5

# 6
red
branch 1
commit 6

# 7
blue
branch 7 -b
commit 7

# 8
branch 3
commit 8

# 9
branch 9 -b
merge 3
commit 9

# 10
red
branch 10 -b
commit 10

# 11
branch 4
commit 11

# 12
blue
branch 9
merge_save_our_data 4
commit 12

# 13
red
branch 1
commit 13

# 14
blue
branch 9
commit 14

# 15
branch 2
commit 15

# 16
red
branch 10
commit 16

# 17
git checkout master
commit 17

# 18
blue
branch 9
commit 18

# 19
branch 2
commit 19

# 20
red
branch 20 -b
commit 20

# 21
blue
branch 9
commit 21

# 22
branch 7
commit 22

# 23 merge conflict Automatic merge failed
branch 2
merge_save_our_data 7 # Вместо merge 7
commit 23

# 24
red
branch 10
commit 24

# 25 merge conflict Automatic merge failed
branch 20
merge_save_their_data 10
commit 25

# 26
git checkout master
commit 26

# 27
branch 20
commit 27

# 28 merge conflict Automatic merge failed
blue
branch 2
merge_save_our_data 20
commit 28

# 29
branch 9
commit 29

# 30
commit 30

# 31 merge conflict Automatic merge failed
branch 2
merge_save_their_data 9
commit 31

# 32
red
branch 1
commit 32

# 33 merge conflict Automatic merge failed
blue
branch 2
merge_save_our_data 1
commit 33

# 34
red
git checkout master
merge_save_our_data 2
commit 34

git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all
