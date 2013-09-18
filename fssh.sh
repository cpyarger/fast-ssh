#!/bin/bash
# pflint Fri Sep 14 10:29:19 EDT 2012
# pflint Mon 05 Nov 2012 09:14:14 AM EST Added standard functions
# pflint Tue 27 Nov 2012 08:35:47 AM EST Added security variables\]
# pflint Mon 15 Apr 2013 09:00:27 AM EDT check for passwords
# cpyarger Tue 17 Sep 2013 08:12:25 PM EDT Initial work on fast-ssh
VERSION="1.0"
pName="fssh.sh"
#
# hold environment
export S=$PWD
#* move to the appropriate directory
# cd ??
#
#* check location of vital files and programs, sanity check
# ??
#
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
##  - fssh.sh dummy tests the dummy function
##    Output is delivered to the screen...
##  - fssh.sh pause <message> displays message and with enter exits normally
##  - fssh.sh wait <n> <filename> where "n" is
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
function spause(){
   # -t sets time
   # read -t $pt -p "$*" ans
   read -p "Hit enter to continue..." ans
   echo $ans

}
#
#* function pause - Allows many ways to tarry...
function pause(){
#debug echo "Vairables in Pause are: "
#debug echo $#"     "$1"    "$ARGS
   # -t sets time
   # read -t $var3 -p "$*" ans
case "$ARGS" in
   "6") read -t $time -p "$prompt";;
   "5") read -p "$prompt";;
   "1") read;;
esac # end of choices
   # echo $ans
} # TESTS: $pName pause; $pName pause "Testing wait"; $pName pause 3 "Testing 1,2,3";/manage_main
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
echo "$pName  v $VERSION starts"
#* Evaluator Routine
# Note the evaluator allows for many cases and error checking...
# ARGS=$#         # carries the number of args into the functions...
if [ "$#" -eq "1" ] && [ "$1" = "dummy"   ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "spause"  ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "pause"   ]; then ARGS="1"; fi
if [ "$#" -eq "2" ] && [ "$1" = "pause"   ]; then ARGS="5"; fi
if [ "$#" -eq "3" ] && [ "$1" = "pause"   ]; then ARGS="6"; fi
if [ "$#" -eq "2" ] && [ "$1" = "fwatch"  ]; then ARGS="2"; fi
if [ "$#" -eq "3" ] && [ "$1" = "get"     ]; then ARGS="6"; fi
if [ "$#" -eq "4" ] && [ "$1" = "dir"     ]; then ARGS="4"; fi
if [ "$#" -eq "3" ] && [ "$1" = "dir"     ]; then ARGS="3"; fi
if [ "$#" -eq "2" ] && [ "$1" = "dir"     ]; then ARGS="2"; fi
if [ "$#" -eq "1" ] && [ "$1" = "dir"     ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "tlog"    ]; then ARGS="9"; fi
if [ "$#" -eq "1" ] && [ "$1" = "cleanup" ]; then ARGS="9"; fi
if [ "$#" -eq "1" ] && [ "$1" = "listful" ]; then ARGS="9"; fi
if [ "$#" -eq "3" ] && [ "$1" = "wait"    ]; then ARGS="6"; fi
if [ "$#" -eq "1" ] && [ "$1" = "help"    ]; then ARGS="9"; fi
# this tests the evaluator...
#debug echo $#"     "$1"    "$2"    "$3"    "$ARGS #debug
# typical cases, be careful to make your own...
case "$ARGS" in
    "0") clear; cat $0 | grep '^## ' | sed -e 's/##//'; exit 1;; # got nothing, display help and go
    "1") $1 ;;                                              	# run the command
    "2") var2=$2;  $1 ;;                                    	# run the command with an argument
    "3") var3=$3; var2=$2;  $1 ;;                           	# run the command with two arguments
    "4") var4=$4; var3=$3; var2=$2;  $1 ;;                      # run the command with three arguments
    "5") prompt=$2; $1 ;;				    	# run the command with a different argument
    "6") time=$3; prompt=$2;  $1 ;;				# run the command with two different arguments
    "7") clear; echo $ARGS" Your function here" ;;		# Spare for capacity
    "8") clear; echo $ARGS" Your function here" ;;		# Spare for capacity
    "9") clear; echo $ARGS" Your function here" ;;		# Spare for capacity
      *) clear; cat $0 | grep '^## '| sed -e 's/##//'; exit 1;;  # Anything else run help and exit...
esac # End main loop. To TEST:
#
# echo " ";
echo "$pName stops"
#  That's all folks!!
# Junk shop
#     if [ "$#" -eq "3" ] && [ "$1" = "get" ] && [ "$2" = "all"  ];  then ARGS="7"; fi
#    "2") secs=$2;  while read line ; do $1; done;;             # read from a file and process
#     *) clear; cat $0 | grep '^## ' | sed -e 's/##//'; exit 1;;
#* restore environment
cd $S

