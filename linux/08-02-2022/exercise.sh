#1/bin/bash

read -p "Enter a file name : "filename

if [[ -r  $filename ]] && [[ -w $filename ]]
then 
	echo "Yes it is readable and writable"
else
	read -p "Would you like the file readable and writable
	yes or no? " answer
	if [[ $answer = "yes" ]]
	then 
		chmod +rw $filename
	else
		echo "Good bye..."
	fi
fi
