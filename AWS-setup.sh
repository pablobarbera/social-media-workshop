# creating new users

for i in 0{3..9} {10..50}
do
	adduser --quiet --disabled-password --shell /bin/bash --home /home/user$i --gecos "User" user$i
	echo "user$i:password$i" | chpasswd
done

# moving files and changing permissions
for i in 0{3..9} {10..50}
do
	mkdir /home/user$i/code
	mkdir /home/user$i/data
	mkdir /home/user$i/credentials
	cp /home/rstudio/code/* /home/user$1/code/
	cp /home/rstudio/data/candidate-tweets.csv /home/user$1/data/
	cp /home/rstudio/data/lexicon.csv /home/user$1/data/
	sudo chown user$i -R /home/user$i/
done	

# solutions challenge 1
for i in 0{3..9} {10..50}
do
	cp /home/rstudio/code/challenge1-solutions.Rmd /home/user$i/code
	cp /home/rstudio/code/challenge1-solutions.html /home/user$i/code
	sudo chown user$i -R /home/user$i/
done







# day 2
for i in 0{3..9} {10..50}
do
	mkdir /home/user$i/day2
	mkdir /home/user$i/backup
	cp /home/rstudio/backup/* /home/user$i/backup
	cp /home/rstudio/packages.r /home/user$i/
	cp /home/rstudio/day2/*.Rmd /home/user$i/day2
	cp /home/rstudio/day2/*.txt /home/user$i/day2
	cp /home/rstudio/data/trump-tweets.json /home/user$i/data
	cp /home/rstudio/data/econnews.csv /home/user$i/data
	sudo chown user$i -R /home/user$i/
done	


for i in 0{3..9} {10..50}
do
	cp /home/rstudio/day1/challenge2-solutions.Rmd /home/user$i/day1
	cp /home/rstudio/day1/challenge2-solutions.html /home/user$i/day1
done

# day 3
for i in 0{3..9} {10..50}
do
	mkdir /home/user$i/day3
	cp /home/rstudio/day3/*.Rmd /home/user$i/day3
	cp /home/rstudio/day3/*.html /home/user$i/day3
	mkdir /home/user$i/facebook
	mkdir /home/user$i/facebook-senate
	cp /home/rstudio/data/congress-facebook.csv /home/user$i/congress-facebook.csv
	cp /home/rstudio/data/congress-tweets.csv /home/user$i/congress-tweets.csv
	cp /home/rstudio/data/facebook/*.txt /home/user$i/facebook
	cp /home/rstudio/data/facebook-senate/*.txt /home/user$i/facebook-senate
	cp /home/rstudio/backup/fb-dfm.Rdata /home/user$i/backup
	cp /home/rstudio/backup/lda-output.Rdata /home/user$i/backup
	cp /home/rstudio/backup/stm-output.Rdata /home/user$i/backup
	cp /home/rstudio/data/inaugural/2017-Trump.txt /home/user$i/data/inaugural
done

for i in 0{3..9} {10..50}
do
	cp /home/rstudio/day2/challenge1-solutions.Rmd /home/user$i/day2
	cp /home/rstudio/day2/challenge1-solutions.html /home/user$i/day2
done

for i in 0{3..9} {10..50}
do
	cp /home/rstudio/day3/challenge1.Rmd /home/user$i/day3
done

for i in 0{3..9} {10..50}
do
	sudo chown user$i -R /home/user$i/
done	

# day 3
for i in 0{3..9} {10..50}
do
	cp /home/rstudio/backup/stm-small-output.Rdata /home/user$i/backup
	cp /home/rstudio/day3/03-stm.html /home/user$i/day3
	cp /home/rstudio/day3/03-stm.Rmd /home/user$i/day3
	sudo chown user$i -R /home/user$i/
done


for i in 0{3..9} {10..50}
do
	cp /home/rstudio/data/nytimes.csv /home/user$i/data
	sudo chown user$i -R /home/user$i/
done


for i in 0{3..9} {10..50}
do
	mkdir /home/user$i/day4
	cp /home/rstudio/day4/*.Rmd /home/user$i/day4
	cp /home/rstudio/day4/*.html /home/user$i/day4
	cp /home/rstudio/data/UK-mps-data.csv /home/user$i/data/
	cp /home/rstudio/data/US-follower-network.rdata /home/user$i/data/	
	cp /home/rstudio/data/UK-follower-network.rdata /home/user$i/data/
	cp /home/rstudio/data/accounts-twitter-data.csv /home/user$i/data/
	cp /home/rstudio/data/ecpr-edges.csv /home/user$i/data/
	cp /home/rstudio/data/ecpr-nodes.csv /home/user$i/data/
	cp /home/rstudio/data/insta-edges.csv /home/user$i/data/
	cp /home/rstudio/data/insta-nodes.csv /home/user$i/data/
	cp /home/rstudio/data/house.csv /home/user$i/data/
	cp /home/rstudio/data/senate.csv /home/user$i/data/
	cp /home/rstudio/backup/ca-results.rdata /home/user$i/backup/
	sudo chown user$i -R /home/user$i/
done


for i in 0{3..9} {10..50}
do
	cp /home/rstudio/day3/challenge1-solutions.Rmd /home/user$i/day3
	cp /home/rstudio/day3/challenge1-solutions.html /home/user$i/day3
	cp /home/rstudio/backup/day4-challenge1-lda-backup.rdata /home/user$i/backup/
	cp /home/rstudio/backup/day4-challenge1-stm-backup.Rdata /home/user$i/backup/
done


for i in 0{3..9} {10..50}
do
	cp /home/rstudio/day4/challenge1-solutions.Rmd /home/user$i/day4
	cp /home/rstudio/day4/challenge1-solutions.html /home/user$i/day4
	sudo chown user$i -R /home/user$i/
done

for i in 0{3..9} {10..50}
do
	mkdir /home/user$i/day5
	cp /home/rstudio/day5/* /home/user$i/day5
	cp /home/rstudio/day4/challenge2-solutions.Rmd /home/user$i/day4
	cp /home/rstudio/day4/challenge2-solutions.html /home/user$i/day4
	cp /home/rstudio/data/congress-facebook-2017.csv /home/user$i/data/
	cp /home/rstudio/data/facebook-2017.zip /home/user$i/data/	
	sudo chown user$i -R /home/user$i/
done

for i in 0{3..9} {10..50}
do
	mkdir /home/user$i/day5
	cp /home/rstudio/day5/* /home/user$i/day5
	cp /home/rstudio/day4/challenge2-solutions.Rmd /home/user$i/day4
	cp /home/rstudio/day4/challenge2-solutions.html /home/user$i/day4
	cp /home/rstudio/data/congress-facebook-2017.csv /home/user$i/data/
	cp /home/rstudio/data/facebook-2017.zip /home/user$i/data/	
	sudo chown user$i -R /home/user$i/
done

for i in 0{3..9} {10..50}
do
	mkdir /home/user$i/facebook-2017
	cp /home/rstudio/facebook-2017/* /home/user$i/facebook-2017
	sudo chown user$i -R /home/user$i/
done

for i in 0{3..9} {10..50}
do
	cp /home/rstudio/day5/challenge1-solutions.Rmd /home/user$i/day5
	cp /home/rstudio/day5/challenge1-solutions.html /home/user$i/day5
	sudo chown user$i -R /home/user$i/
done


for i in 0{3..9} {10..50}
do
	cp /home/rstudio/day5/challenge2-solutions.Rmd /home/user$i/day5
	cp /home/rstudio/day5/challenge2-solutions.html /home/user$i/day5
	sudo chown user$i -R /home/user$i/
done