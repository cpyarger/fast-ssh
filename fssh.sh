#!/bin/bash
# pflint Fri Sep 14 10:29:19 EDT 2012
# pflint Mon 05 Nov 2012 09:14:14 AM EST Added standard functions
# pflint Tue 27 Nov 2012 08:35:47 AM EST Added security variables\]
# pflint Mon 15 Apr 2013 09:00:27 AM EDT check for passwords
# cpyarger Tue 17 Sep 2013 08:12:25 PM EDT Initial work on fast-ssh
VERSION="1.0"
pName="fssh.sh"
rfile=~/.fssh/fssh.list
#
# hold environment
export S=$PWD
#* move to the appropriate directory
# cd ??
#
#* check location of vital files and programs, sanity check
# ??
mkdir -v ~/.fssh 2>/dev/null
touch $rfile
# Define files to be used
# uid="" ; if [ "$uid" == "" ]; then echo "Set user id!"; exit; fi
# passwd="" ; if [ "$passwd" == "" ]; then echo "Set user passwd!"; exit; fi
# ??
#
#* function help  - Help function for template basic help goes here
function help(){
	clear;
	echo "This is "$0"  "$version
	cat $0 | grep '^## ' | sed -e 's/##//'
# echo "This is the help function"
##                       *****DOCUMENTATION*****
## You get this documentation when you put in the wrong number of arguments...
## The name of this program is fssh.sh, This is a tool for saving frequently used SSH connections 
## This is released under GPL v3
## The syntax is:
##  - fssh.sh dummy                   			; tests the dummy function
##                                    			  Output is delivered to the screen...
##  - fssh.sh connect <Network Name>  			; Connects to <Network Name> via SSH
##  - fssh.sh createKey               			; Allows you to create a SSH key
##  - fssh.sh list               			; Lists networks
##  - fssh.sh anet 				     	; Adds a network to your list
##  - fssh.sh rmnet <Network Name>    			; Removes <Network Name> from your list
## ''
## For structure information type "grep '^\#\*' fssh.sh"
##    :^)
## (C) CPYarger, CPYarger IT Services Liscensed under GPLv3
##
#          *****Documentation Loop ends here the rest is function******
#
} # Test: fssh.sh
#
#
#* function dummy - Dummy basic function template. ajm1Rename and fill stuff in between braces
function dummy(){
	echo "This is the dummy function"
} # Test:
#
#*######################################STANDARD AND MAYBE USEFUL FUNCTIONS BELOW
#
#
#* Read Array Function - Reads the array from $rfile
function readArray (){ 
i=0
	while read line; do
		name[i]="$(echo $line | cut -d'=' -f 1)" 
		value[i]="$(echo $line | cut -d'=' -f 2-)"
        	((i++))
	done < $rfile
}
#
#
#* Parse Array Function - Parses the Array and returns connection value and name variables
function parseArray() {
	readArray
	iline=$(grep -nsi $var2 $rfile|cut -d: -f1)
	((iline--))
	rval="${value[iline]}"
	nval="${name[iline]}"
}
#
#
#* Connect Function - initiates SSH command
function connect () {
	parseArray
	#echo $iline
	#echo $rval
	#echo $nval
	clear
	echo "Connecting to $nval... "
	ssh $rval
}
#
#
#* create key function - Checks for ssh-key and offers the choice to create one, with the option for password free logins
function createKey () {
parseArray
# Check for File
	if [ -e ~/.ssh/id_rsa.pub ];then
		echo " Found ~/.ssh/id_rsa.pub"
	else
		read -p "Do you want to enable key based logins? Y/n: "
		[[ $REPLY = [yYnN] ]] || { echo "Invalid response."; exit 1; } && [[ $REPLY = [yY] ]] && read -p "Enable password free logins? Y/n: "
		[[ $REPLY = [yYnN] ]] || { echo "Invalid response."; exit 1; } && [[ $REPLY = [yY] ]] && ssh-keygen -N '' || [[ $REPLY = [nN] ]] &&  ssh-keygen
	fi
}
#
#
#* Add network function - Allows you to add a network to the file $rfile
function anet() {
	echo "Adding network to list"
	#
	# Parse for Network Name
	read -p "Network Name (ex. example): "
	netname=$REPLY
	# Parse for Network Value
	read -p "Network Value (ex. -XC example.cpyarger.com): "
	netvalue=$REPLY
	# Write to $rfile
	wvalue="$netname=$netvalue" 
	echo $wvalue >>$rfile
	list
}
#
#
#* Remove Network Function -Allows you to remove a network from the file $rfile 
function rmnet () {
	readArray
	dline=$(grep -nsi $var2 $rfile|cut -d: -f1)
	if [ "$dline" != "" ]; then
		tdline=$(sed -n "$dline"p "$rfile")
		read -p "Are you sure you want to delete the network $tdline? Y/n: "
		[[ $REPLY = [yYnN] ]] || { echo "Invalid response."; exit 1; } && [[ $REPLY = [yY] ]] && { sed -i "$dline"d "$rfile" ; echo "$tdline" Deleted; } || { echo "$tdline NOT deleted"; }
	fi
}
#
#
#* List Network Function - Lists networks in the file $rfile 
function list () {
	readArray
	anum="${#name[@]}"
	j=0
	echo -e "Network name \t:\t\t  Network Value"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	while [ $j -ne $anum ]; do
		echo -e "${name[j]} \t\t:\t ${value[j]} "
		((j++))
	done
}
#
#
#* function cleanup - cleanup function deletes all temporary files
function cleanup(){
echo "This is the cleanup function"
echo $#"        "$ARGS
#* Clean up stuff used in this function
#* Remove buffers
rm iccf.first.half iccf.second.half iccflist$LIBR.txt $LIBR.iccf.column 2>/dev/null
# rm $1 # removes the bin/$pName wait "..go on" 5target file...
# mv $1 ../../$1 # instead, moves the target file to ../../$1
# mv $1 ../../$1"_"$(date +%Y-%m-%d) # most severe, moves the target file to ../../$1
} # Test:
#
#*###################################### MAIN ENTRY POINT AND COMPOUND CASE
#
# echo "$pName  v $VERSION starts"
#* Evaluator Routine
# Note the evaluator allows for many cases and error checking...
# ARGS=$#         # carries the number of args into the functions...
if [ "$#" -eq "1" ] && [ "$1" = "dummy"     ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "list"      ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "connect"   ]; then ARGS="2"; fi
if [ "$#" -eq "1" ] && [ "$1" = "createKey" ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "anet"      ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "rmnet"     ]; then ARGS="2"; fi
if [ "$#" -eq "1" ] && [ "$1" = "help"      ]; then ARGS="9"; fi
# this tests the evaluator...
#debug echo $#"     "$1"    "$2"    "$3"    "$ARGS #debug
# typical cases, be careful to make your own...
case "$ARGS" in
    "0") clear; cat $0 | grep '^## ' | sed -e 's/##//'; exit 1;; # got nothing, display help and go
    "1") $1 					;;             	# run the command
    "2") var2=$2;  $1 				;;             	# run the command with an argument
    "3") var3=$3; var2=$2;  $1  		;;             	# run the command with two arguments
    "4") var4=$4; var3=$3; var2=$2;  $1 	;;              # run the command with three arguments
    "5") prompt=$2; $1 				;;	    	# run the command with a different argument
    "6") time=$3; prompt=$2;  $1                ;; 		# run the command with two different arguments
    "7") clear; echo $ARGS" Your function here" ;;		# Spare for capacity
    "8") clear; echo $ARGS" Your function here" ;;		# Spare for capacity
    "9") clear; echo $ARGS" Your function here" ;;		# Spare for capacity
      *) clear; cat $0 | grep '^## '| sed -e 's/##//'; exit 1;;  # Anything else run help and exit...
esac # End main loop. To TEST:
#
# echo " ";
# echo "$pName stops"
#  That's all folks!!
# Junk shop
#     if [ "$#" -eq "3" ] && [ "$1" = "get" ] && [ "$2" = "all"  ];  then ARGS="7"; fi
#    "2") secs=$2;  while read line ; do $1; done;;             # read from a file and process
#     *) clear; cat $0 | grep '^## ' | sed -e 's/##//'; exit 1;;
#* restore environment
cd $S

