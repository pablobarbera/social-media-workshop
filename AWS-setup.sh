# creating new users

for i in 0{1..9} {10..50}
do
	adduser --quiet --disabled-password --shell /bin/bash --home /home/user$i --gecos "User" user$i
	echo "user$i:password$i" | chpasswd
done

# copying files and changing permissions
for i in 0{1..9} {10..50}
do
	mkdir /home/user$i/code
	mkdir /home/user$i/data
	mkdir /home/user$i/credentials
	cp /home/rstudio/code/* /home/user$i/code/
	cp /home/rstudio/data/candidate-tweets.csv /home/user$i/data/
	cp /home/rstudio/data/lexicon.csv /home/user$i/data/
	sudo chown user$i -R /home/user$i/
done	

# solutions challenge 1
for i in 0{1..9} {10..50}
do
	cp /home/rstudio/code/challenge1-solutions.rmd /home/user$i/code/
	cp /home/rstudio/code/challenge1-solutions.html /home/user$i/code/
	sudo chown user$i -R /home/user$i/
done

# solutions challenge 2
for i in 0{1..9} {10..50}
do
	cp /home/rstudio/code/challenge2-solutions.rmd /home/user$i/code/
	cp /home/rstudio/code/challenge2-solutions.html /home/user$i/code/
	sudo chown user$i -R /home/user$i/
done


# solutions challenge 3
for i in 0{1..9} {10..50}
do
	cp /home/rstudio/code/challenge3-solutions.rmd /home/user$i/code/
	cp /home/rstudio/code/challenge3-solutions.html /home/user$i/code/
	sudo chown user$i -R /home/user$i/
done


