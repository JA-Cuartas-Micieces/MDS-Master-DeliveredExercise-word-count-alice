########################################################
#########################LICENSE########################
########################################################

#MIT License Copyright <2021> <Javier A. Cuartas Micieces,
#Francisco Cotera Fernández> <JA-Cuartas-Micieces, Fcg27> 

#Permission is hereby granted, free of charge, to any 
#person obtaining a copy of this software and associated 
#documentation files (the "Software"), to deal in the 
#Software without restriction, including without limitation 
#the rights to use, copy, modify, merge, publish, distribute, 
#sublicense, and/or sell copies of the Software, and to 
#permit persons to whom the Software is furnished to do 
#so, subject to the following conditions:

#The above copyright notice and this permission notice 
#shall be included in all copies or substantial portions 
#of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF 
#ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
#TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
#PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
#THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
#DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
#TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
#WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
#SOFTWARE.


#!/bin/bash

########################################################
########################FUNCTIONS#######################
########################################################

Help()
{
   # Display Help
   echo
   echo "Description:"
   echo
   echo "It cleans header and footer of single .txt files from different possible origins, and outputs a list of words matching certain minimum frequencies (which is also an input option). Finally, the script removes the original files."
   echo
   echo "Syntax:"
   echo
   echo "word-count-alice.sh [-U|D|F] [-h] [Frequency threshold to store words] [String ending line of the header to remove] [String starting line of the footer to remove] [Desired output filename] [Path or URL]"
   echo
   echo "Options:"
   echo
   echo "  -U     Command input will be the URL where the target txt file is stored."
   echo "  -D     Command input will be a folder name in the same directory as the script, where the target txt files are stored."
   echo "  -F     Command input will be the name of a single txt file input in the same directory as the script."
   echo "  -h     Print this help"
   echo
   echo "Examples:"
   echo
   echo "bash wordcount.sh -U 50 \"START OF THE PROJECT GUTENBERG EBOOK ALICE’S ADVENTURES IN WONDERLAND\" \"END OF THE PROJECT GUTENBERG EBOOK ALICE’S ADVENTURES IN WONDERLAND\" \"trial\" \"https://www.gutenberg.org/files/11/11-0.txt\""
   echo
   echo "bash wordcount.sh -D 50 \"START OF THE PROJECT GUTENBERG EBOOK ALICE’S ADVENTURES IN WONDERLAND\" \"END OF THE PROJECT GUTENBERG EBOOK ALICE’S ADVENTURES IN WONDERLAND\" \"trial\" \"txtFiles\""
   echo
   echo "bash wordcount.sh -F 50 \"START OF THE PROJECT GUTENBERG EBOOK ALICE’S ADVENTURES IN WONDERLAND\" \"END OF THE PROJECT GUTENBERG EBOOK ALICE’S ADVENTURES IN WONDERLAND\" \"trial\" \"11-0.txt\""
   echo
}

Wordcountsplitter()
{
   dt=$(date '+%y%m%d-%H%M%S');
   outfilename="$dt-$4-$1-${5%????}";

   nstart=$(expr $(awk "/$2/{print NR}" "$5") + 1);
   nend=$(expr $(awk "/$3/{print NR}" "$5") - 1);
   cleantext=$(sed -n "${nstart},${nend}p" "$5" | sed 's/[^a-zA-Z0-9 ]//g' | tr '[:upper:]' '[:lower:]' | sed 's/ /\n/g');
   nrep=$(printf "$cleantext" | sort | uniq -c);
   outp=$(printf "$nrep" | sed 's/[^a-zA-Z0-9 ]//g' | sort -r | awk -v th="$1" '$1>th');

   echo "$outp" > "$outfilename".txt;
   rm "$5";
}


########################################################
##########################MAIN##########################
########################################################

while getopts ":hDFU:" option; do
   case "$option" in
     h) # display Help
         Help
         exit;;
     D) # Read all txt files from a directory
         cd "$6";
         filenames=($(ls *.txt));
         for filename in ${filenames[@]}; do
             Wordcountsplitter "$2" "$3" "$4" "$5" "$filename";
         done
         exit;;
     F) # Read a single txt file in the same directory as the script
         Wordcountsplitter "$2" "$3" "$4" "$5" "$6"; 
         exit;;
     U) # Download file from an URL
         wget "$6"
	 filename=$(basename "$6")
         Wordcountsplitter "$2" "$3" "$4" "$5" "$filename";
         exit;;
   esac
done


########################################################
####################SOURCE LINKS########################
########################################################

#https://likegeeks.com/es/sed-de-linux/
#https://www.gnu.org/software/sed/manual/html_node/Command_002dLine-Options.html
#https://stackoverflow.com/questions/30658703/how-to-print-the-line-number-where-a-string-appears-in-a-file
#https://likegeeks.com/es/comando-awk/
#https://askubuntu.com/questions/76808/how-do-i-use-variables-in-a-sed-command
#https://www.baeldung.com/linux/print-lines-between-two-patterns
#https://linuxhint.com/bash_arithmetic_operations/
#https://stackoverflow.com/questions/559363/matching-a-space-in-regex
#https://stackoverflow.com/questions/23816264/remove-all-special-characters-and-case-from-string-in-bash
#https://unix.stackexchange.com/questions/2244/how-do-i-count-the-number-of-occurrences-of-a-word-in-a-text-file-with-the-comma
#https://askubuntu.com/questions/461144/how-to-replace-spaces-with-newlines-enter-in-a-text-file
#https://www.cyberciti.biz/faq/bash-for-loop/
#https://superuser.com/questions/284187/bash-iterating-over-lines-in-a-variable
#https://linuxhint.com/bash_loop_list_strings/
#https://opensource.com/article/18/5/you-dont-know-bash-intro-bash-arrays
#https://linuxize.com/post/bash-break-continue/
#https://stackoverflow.com/questions/10552803/how-to-create-a-frequency-list-of-every-word-in-a-file
#https://unix.stackexchange.com/questions/72734/awk-print-line-only-if-the-first-field-start-with-string-as-linux1
#https://www.tecmint.com/use-linux-awk-command-to-filter-text-string-in-files/
#https://www.redhat.com/sysadmin/arguments-options-bash-scripts
#https://likegeeks.com/es/scripting-de-bash-parametros-y-opciones/
#https://stackoverflow.com/questions/18884992/how-do-i-assign-ls-to-an-array-in-linux-bash/18887210
#https://stackoverflow.com/questions/8574038/wget-downloaded-file-name/14313360
#https://stackoverflow.com/questions/53103245/awk-string-greater-than-variable/53104050#53104050
#https://reactgo.com/bash-remove-last-n-characters/
#https://atareao.es/tutorial/scripts-en-bash/variables-en-bash/


########################################################
#######WORKING TRY (DONE BY nrep AND outp ABOVE)########
########################################################

#The code below outputs 3 bash arrays, wds with unique 
#words of the text, rps with their frequencies and the
#last, wsave, outputs the words which appears more than 
#50 times in the text.

#rps=()
#wds=()
#wsave=()
#while IFS= read -r line; do
#  r=0
#  k=0
#  for val in ${wds[@]}; do
#    if [[ ${line} == ${val} ]]
#    then

#      rps["$k"]=$(( ${rps[$k]} + 1 ))

#      if [[ ${rps[$k]} == 50 ]]
#      then
#        wsave+=("$line")
#        echo "saved"
#      fi

#      r=1
#      echo "existing"
#      break

#    fi
#    k=$(expr "$k" + 1)

#  done

#  if [[ ${r} == 0 ]]
#  then
#    echo "new"
#    wds+=("$line")
#    rps+=("1")
#  fi
#done <<< "$cleantext"

#for value in ${wds[@]}
#do
#    echo $value
#    echo ${rps[$k]}
#    k=$(expr "$k" + 1)
#done
