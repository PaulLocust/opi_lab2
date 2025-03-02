#!/bin/bash

set -e  # Прерывает выполнение скрипта при любой ошибке

red() {
	CURRENT_USER=red
}

blue() {
	CURRENT_USER=blue
}

commit() {
  echo "some info" >> file.txt  # Добавляем текст в файл
  svn add file.txt --force # force для каталогов
  svn commit -m r$1 --username $CURRENT_USER
  if [ "$CURRENT_USER" = "red" ]; then
    echo -e "commit: r$1 $CURRENT_USER 🔴 ↑"
  else
    echo -e "commit: r$1 $CURRENT_USER 🔵 ↑"
  fi
  echo -e "--------------------------\n"
}

branch() {
	# Создание ветки (branch 1 3) - создаст ветку 3 как копию 1
	svn copy $REMOTE_URL/branches/branch"$1" $REMOTE_URL/branches/branch"$2" -m "Add branch$2" --username $CURRENT_USER
  # Переключение на созданную ветку
	svn switch $REMOTE_URL/branches/branch"$2"
}

branch_from_trunk() {
	# Создание ветки из trunk
	svn copy $REMOTE_URL/trunk $REMOTE_URL/branches/branch"$1" -m "Add branch$1" --username $CURRENT_USER
}

switch() {
	# Переключение на ветку
	svn switch $REMOTE_URL/branches/branch"$1"
}


switch_to_trunk() {
	# Переключение на ветку trunk
	svn switch $REMOTE_URL/trunk
}

merge() {
	# Слияние в нынешнюю ветку
	svn merge $REMOTE_URL/branches/branch"$1"
	svn resolved *
}

# init
rm -rf svn
mkdir svn
cd svn

REMOTE_URL="file:///$(pwd -W)/repo"
CURRENT_USER="red"

svnadmin create repo
svn mkdir $REMOTE_URL/trunk $REMOTE_URL/branches -m "File structure" --username $CURRENT_USER

# Создание рабочей копии
svn checkout "$REMOTE_URL/trunk" working_copy
cd working_copy

# 0
red
commit 0

# 1
branch_from_trunk 1
commit 1

# 2
blue
branch 1 2
commit 2

# 3
branch 2 3
commit 3

# 4
red
branch 3 4
commit 4

# 5
blue
switch 2
commit 5

# 6
red
switch 1
commit 6

# 7
blue
branch 1 7
commit 7

# 8
switch 3
commit 8

# 9
branch 3 9
merge 3
commit 9

# 10
red
branch 9 10
commit 10

# 11
switch 4
commit 11

# 12
blue
switch 9
merge 4
commit 12

# 13
red
switch 1
commit 13

# 14
blue
switch 9
commit 14

# 15
switch 2
commit 15

# 16
red
switch 10
commit 16

# 17
switch_to_trunk
commit 17

# 18
blue
switch 9
commit 18

# 19
switch 2
commit 19

# 20
red
branch 2 20
commit 20

# 21
blue
switch 9
commit 21

# 22
switch 7
commit 22

# 23 зря я сюда полез... svn: E155015: One or more conflicts were produced while merging r4:12 into
switch 2
merge 7
commit 23

# 24
red
switch 10
commit 24

# 25
switch 20
merge 10
commit 25

# 26
switch_to_trunk
commit 26

# 27
switch 20
commit 27

# 28
blue
switch 2
merge 20
commit 28

# 29
switch 9
commit 29

# 30
commit 30

# 31
switch 2
merge 9
commit 31

# 32
red
switch 1
commit 32

# 33
blue
switch 2
merge 1
commit 33

# 34
red
switch_to_trunk
merge 2
commit 34

# end
cd ..
