for i in /home/fer/Documents/cfDNA/Programs/ichorCNA/500kb/txt/*.txt;
do
				cut -f 2,3,4,8 $i > "${i%.seg*}".bed
done
