#!/usr/bin/env bash

TERM=xterm
EDITOR=vim

run_rofi () {
	rofi -font "ypn envypn 13" \
  -separator-style none -font "ypn envypn 13" -columns 1 -bw 0 \
       -line-margin 0 -line-padding 2 \
      -hide-scrollbar \
      -color-window "#222222, #222222, #b1b4b3" \
      -color-normal "#262626, #b1b4b3, #262626, #262626, #42E66C" \
      -color-active "#222222, #E356A7, #222222, #007763, #b1b4b3" \
      -color-urgent "#222222, #b1b4b3, #222222, #77003d, #b1b4b3" \
      -kb-row-select "Tab" -kb-row-tab "" \
  -lines 15 -width 1000 -dmenu -p "> " "$@"
}

addBookmark () {
	URL=$(xsel | head -n1 | run_rofi -mesg "Insert an url.")
	if [[ $? -eq 1 ]]; then
		exit
	fi
	TAGS=$(run_rofi -mesg "Insert some space separated tags.")
	if [[ $? -eq 1 ]]; then
		exit
	fi

	bookmarks add $DB $URL $TAGS
}

openURL () {
	number=$1
	$BROWSER $(bookmarks find $DB ${number::-1})
}

listTags () {
	tag=$(bookmarks tag-list $DB | run_rofi -mesg "Enter to select tag.")
	if [[ $? -eq 1 ]] ; then
		exit
	fi
	url=$(bookmarks tag-search $DB $tag | run_rofi -mesg "Enter to select a bookmark")
	if [[ $? -eq 1 ]] ; then
		exit
	fi
	openURL $url
}

delete () {
	number=$1
	bookmarks rm $DB ${number::-1}

	main
}

edit () {
	id=$(echo $1 | tr '.' '\n' | head -n1)
	bookmarks edit $DB $id
	main

}

#
# xdotool key "Super_L+n" && xdotool type "test"


reader () {
   # cat cheatsheets/git |
    cat cheatsheets/xmonad | sed '/^--/ d'
}


main () {



	selection=$(reader | awk -F"=/|=" 'NF == 2 { $0 = $0 "No tag" }; {  print $1"\t"$3"\t"$5"\t"$7"\t"$9}' | run_rofi -kb-custom-1 "${new_bookmark_shortcut}" -kb-custom-2 "${list_tags_shortcut}" -kb-custom-3 "${delete_shortcut}" -kb-custom-4 "${edit_shorcut}" -mesg "Enter to select a bookmark. Alt+n to create a new one.
Edit a bookmarks with Alt+e. Remove one with Alt+d. Search for tags with Alt+t.")
	val=$?

	# if [[ $val -eq 1 ]]; then
	# 	exit
	# elif [[ $val -eq 10 ]]; then
	# 	addBookmark
	# elif [[ $val -eq 11 ]]; then
	# 	listTags
	# elif [[ $val -eq 12 ]]; then
	# 	delete $selection
	# elif [[ $val -eq 13 ]]; then
	# 	edit $selection
	# else
	# 	openURL $selection
	# fi

  echo reader



  selection


}

# if [ $# -eq 0 ]
# 	then
#     echo "Please choose a bookmark file path."
# 	exit
# fi
#
# DB=$1

#shortcuts
new_bookmark_shortcut="Alt+n"
list_tags_shortcut="Alt+t"
delete_shortcut="Alt+d"
edit_shorcut="Alt+e"

touch $DB &

main
