mkdir /home/fer/Documents/cfDNA/Programs/ichorCNA/500kb/txt/bed 

for i in /home/fer/Documents/cfDNA/Programs/ichorCNA/500kb/txt/*.bed;
do
				x=${i##*/}
				python filter_txt.py $i /home/fer/Documents/cfDNA/Programs/ichorCNA/500kb/txt/bed/$x

done
