if [ ${1:-5} == ".docx"]; then
	docx2txt $1
elif [ ${1:-5} == ".xlsx"]; then 
	xlsx2txt $1
else
	cat $1 | less
fi