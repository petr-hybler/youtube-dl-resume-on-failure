#!/bin/bash

#CHANGE ACCORDINGLY
URL="https://udemy.com/some-course-name"

# NO NEED TO CHANGE ANYTHING BELOW
REGEX='^[0-9]+$'

# store the parameter (if none -> default = 1 )
CHAPTER=${1:-1}

echo "Download is starting with the chapter $CHAPTER ... "

# map the output in the array
mapfile -t array < <( youtube-dl -i -o "%(playlist)s/%(chapter_number)s %(chapter)s/%(playlist_index)s. %(title)s.%(ext)s" --cookies ./cookies.txt $URL --playlist-start $CHAPTER )

# check the error
var=$(echo ${array[-2]} | cut -d'/' -f 3 | cut -d'.' -f 1)

# recursively call again the javascript
#   if the script ends with an error, the $var will contain a number of the last chapter processed (error)
#   otherwise, it will contain some random string based on the final message (= finished)
if [[ $var =~ $REGEX ]]
then
  echo "Error ... restarting at the chapter $var"
  bash $0 $var
else
  echo "Finished."
fi
