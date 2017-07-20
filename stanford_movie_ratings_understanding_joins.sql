SELECT * FROM Movie LIMIT 5; #unique mID
SELECT * FROM Rating LIMIT 5;  #rating date can be null; more tahn one mID and rID
SELECT * FROM Reviewer LIMIT 5;  #rID (corresponds to rID in Rating; name of reviewer

# find the titles of all movies directed by steven spielberg
SELECT title 
FROM Movie 
WHERE director = 'Steven Spielberg';

#Find all years that have a movie that received a rating of 4 or 5,
# and sort them in increasing order. 
# doing an inner join or join b/c only want records where there is an mID in both tables
SELECT DISTINCT year 
FROM Movie
JOIN Rating
	ON Movie.mID = Rating.mID
	AND Rating.stars >= 4
ORDER BY year;


#Find the titles of all movies that have no ratings. 
SELECT title
FROM Movie
WHERE Movie.mID NOT IN 
	(SELECT Rating.mID FROM Rating);

#SELECT * FROM Movie;
SELECT * FROM Rating;
SELECT * FROM Reviewer; #201-208 rID



#Some reviewers didn't provide a date with their rating. 
#Find the names of all reviewers who have ratings with a NULL value 
#for the date.
SELECT Reviewer.name
FROM Reviewer
JOIN Rating
    ON Reviewer.rID = Rating.rID
    AND Rating.ratingDate IS NULL;



SELECT name FROM Reviewer as re
JOIN Rating as ra 
	ON re.rID = ra.rID
	AND ratingDate IS NULL;

 
SELECT name 
FROM Reviewer JOIN Rating USING (rID)
WHERE ratingDATE IS NULL;


SELECT * FROM Rating;
SELECT * FROM Rating, Reviewer;
# Write a query to return the ratings data in a more readable format: 
#reviewer name, movie title, stars, and ratingDate. 
#Also, sort the data, first by reviewer name, 
#then by movie title, and lastly by number of stars. 
SELECT Reviewer.name, Movie.title, Rating.stars, Rating.ratingDate
FROM Movie 
JOIN Rating
    ON Movie.mID = Rating.mID
JOIN Reviewer
    ON Rating.rID = Reviewer.rID
ORDER BY Reviewer.name, Movie.title, Rating.stars;

# also correct

SELECT name, title, stars, ratingDate
FROM Reviewer, Rating, Movie
WHERE Reviewer.rID = Rating.rID AND Rating.mID = Movie.mID
ORDER BY name, title, stars;


# For all cases where the same reviewer rated the same movie twice 
#and gave it a higher rating the second time, 
#return the reviewer's name and the title of the movie. 


# PART SOLUTION
# joining the rating table to itself except only in cases where the same reviewer rated the same movie
# (hence on R1.mID = R2.MID AND R1.rID = R2.rID) and when the rater gave the movie a higher review
## but this doesn't take into account the date of the rating-- returns the reviewers who've given a movie a 
# higher rating at some point or another; 
# we want only those where it was rated higher the 2nd time around: R1.ratingDate > R2.ratingDate
# Don't need DISTINCT R1.rID (see below); b/c rID is unique even if rater's name may not be
SELECT R1.rID, R1.mID, R1.stars
    FROM Rating AS R1
	JOIN 
        Rating as R2
        ON R1.mID = R2.mID
        AND R1.rID = R2.rID
		AND R1.stars > R2.stars
        AND R1.ratingDate > R2.ratingDate;

# 201 = only rater that should be returned; 201 = Sara Martinez

## But want to return the reviewer's name
# So join the Reviewer table to the one created above; returns Sara Martinez, whose rID=201
## unlike solutions below, do not need DISTINCT R1.rID b/c even if raters have the same name, they have unique IDs
SELECT Reviewer.name 
FROM Reviewer
JOIN 
	(SELECT R1.rID, R1.mID, R1.stars 
    FROM Rating AS R1
	JOIN 
        Rating as R2
        ON R1.mID = R2.mID
        AND R1.rID = R2.rID
		AND R1.stars > R2.stars
        AND R1.ratingDate > R2.ratingDate) AS Rev
ON Reviewer.rID = Rev.rID;


# But actually want reviewer's name and the title of the movie that she rated more highly the 2nd time
##  FINAL AND CORRECT SOLUTION 
## as before don't need DISTINCT Reviewer.name as below b/c rID is unique even if reviewer's name is not
# and you are joining the Reviewer table to Rev which selects R1.rID (see above)
SELECT Reviewer.name, Movie.title 
FROM Reviewer
JOIN 
	(SELECT R1.rID, R1.mID, R1.stars 
    FROM Rating AS R1
	JOIN 
        Rating as R2
        ON R1.mID = R2.mID
        AND R1.rID = R2.rID
		AND R1.stars > R2.stars
        AND R1.ratingDate > R2.ratingDate) AS Rev
ON Reviewer.rID = Rev.rID
JOIN Movie
ON Rev.mID = Movie.mID;  #remember Rev table included mID needed to join to Movie table


# Same and also correct solution but join rating tables before reviewer and movie ones;
#if use LEFT JOIN need to use WHERE clause to filter out excess columns
#  DISTINCT name is not actually needed b/c rID  is unique
SELECT DISTINCT name, title
FROM Rating r1 
JOIN Rating r2
#LEFT JOIN Rating r2
	ON r1.rID = r2.rID
    AND r1.mID = r2.mID
    AND r1.ratingDate > r2.ratingDate
    AND r1.stars > r2.stars
JOIN Reviewer
ON Reviewer.rID = r1.rID
JOIN Movie
ON r1.mID = Movie.mID;
#WHERE r2.stars IS NOT NULL;

# Returns same result as above:
# note that you are creating and joning the same tables
#  DISTINCT name is not actually needed b/c rID  is unique [verified via stanford online]
SELECT DISTINCT name, title 
FROM Rating r1, Rating r2, Movie, Reviewer
WHERE r1.rID = r2.rID AND r1.mID = r2.mID
AND r1.ratingDate > r2.ratingDate AND r1.stars > r2.stars
AND Movie.mID = r1.mID AND r1.rID = Reviewer.rID;


## Q7: For each movie that has at least one rating, 
#find the highest number of stars that movie received. 
#Return the movie title and number of stars. Sort by movie title. 
SELECT Movie.title, max(Rating.stars) AS mstars
FROM Rating JOIN Movie USING(mID)
GROUP BY Rating.mID
ORDER BY Movie.title;

# ALT SYNTAX

SELECT title, max(stars) AS mstars
FROM Rating, Movie
WHERE Rating.mID = Movie.mID
GROUP BY Rating.mID
ORDER BY title;



#############################################################
# without GROUP BY returns all movie titles (ie duplicates) and corresponding stars

# NOTE: GROUP BY Rating.rID will group by the reviewer and thus return the max stars given by a reviewer regardless of movie
# thus one column will stand for unique reviewers or more specifically the title of the movie they gave the highest rating to
# and the 2nd for the maximum stars they gave to that movie
# thus, there can be duplicate movie titles; easier to see if also SELECT rID 

# conversely in 'correct' version with GROUP BY Rating.mID, movie titles are unique 
# but the max stars given could be from the same reviewer

# GROUP BY determines which will be the unique element to aggregate values (here stars) over

# without max(stars) returns same list of movie titles as above
# but the stars corresponding to each is not the highest rating but the first match 
# instead, the stars corresponding to the first mID match in the Ratings and Movie table is returned. 

SELECT title, stars #max(stars) as mstars
FROM Rating, Movie
WHERE Rating.mID = Movie.mID
#GROUP BY Rating.mID
ORDER BY title;
#############################################################




## Q7: For each movie that has at least one rating, 
#find the highest number of stars that movie received. 
#Return the movie title and number of stars. Sort by movie title. 

SELECT title, max(stars) AS mstars
FROM Rating, Movie
WHERE Rating.mID = Movie.mID
GROUP BY Rating.mID
ORDER BY title;


## Q8: For each movie, return the title and the 'rating spread', 
#that is, the difference between highest and lowest ratings given to that movie. 
#Sort by rating spread from highest to lowest, then by movie title. 
SELECT title, max(stars) - min(stars) AS ratespread
FROM Rating, Movie
WHERE Rating.mID = Movie.mID
GROUP BY Rating.mID
ORDER BY ratespread DESC, title;

## ALT SYNTAX
SELECT title, MAX(stars) - MIN(stars) AS spread
FROM Movie JOIN Rating USING (mID)
GROUP BY Rating.mID
ORDER BY spread DESC, title;


# Q9: Find the difference between the average rating of movies released before 1980
# and the average rating of movies released after 1980. 
#(Make sure to calculate the average rating for each movie, 
#then the average of those averages for movies before 1980 and movies after. 
#Don't just calculate the overall average rating before and after 1980.) 

SELECT AVG(pre1980.stars1) - AVG(post1980.stars2) as ratingDiff
FROM 
	(SELECT title, AVG(stars) AS stars1
    FROM Rating, Movie
    WHERE Rating.mID = Movie.mID AND Movie.year < 1980
    GROUP BY title
    ) AS pre1980
    JOIN
    (SELECT title, AVG(stars) AS stars2
    FROM Rating, Movie
    WHERE Rating.mID = Movie.mID AND Movie.year > 1980
    GROUP BY title
    ) AS post1980;


# Alternative Syntax


SELECT AVG(pre1980.avgstars) - AVG(post1980.avgstars)
FROM 
(SELECT title, AVG(stars) as avgstars
FROM Movie JOIN Rating USING (mID)
WHERE year < 1980
GROUP BY Rating.mID) AS pre1980
JOIN
(SELECT title, AVG(stars) as avgstars
FROM Movie JOIN Rating USING (mID)
WHERE year > 1980
GROUP BY Rating.mID) AS post1980;


##########################################################################################



###### SEE HOW THIS DIFFERS FROM ABOVE -- USE OF UNION VS. JOIN
## The code below gives you the avg stars for the movies that were released before 1980 AND have a rating (3/4)
# and the avg stars for movies released after 1980 which have ratings (again, 3/4 movies released)
# title for avg rating row is whatever is named in first SELECT statement
## create new column labeled year in both selected tables  with value 'pre1980' and 'post1980' respectively 

SELECT title, AVG(stars) AS avgstars1, 'pre1980' AS year 
FROM Movie JOIN Rating USING (mID)
WHERE year < 1980
GROUP BY title
UNION
SELECT title, AVG(stars) AS avgstars2, 'post1980' AS year
FROM Movie JOIN Rating USING (mID)
WHERE year > 1980
GROUP BY title;

## returns title, avgstars1, year with each movie that's rated under title
## avgstars for that movie under avgstars1; and either pre1980 or post1980 as inserted under year


#### similar to above but here you end up with two columns, year and avg rating for all movies released in that year
## but they are not subtracted as requested in the problem 
SELECT year, AVG(foo.avgstars)
FROM 
(SELECT title, AVG(stars) AS avgstars, 'pre1980' AS year 
FROM Movie JOIN Rating USING (mID)
WHERE year < 1980
GROUP BY title
UNION
SELECT title, AVG(stars) AS avgstars, 'post1980' AS year
FROM Movie JOIN Rating USING (mID)
WHERE year > 1980
GROUP BY title) AS foo
GROUP BY year DESC;

## returns
#year       avg(foo.avgstars)
#pre1980	3.33333333
#post1980   3.27776667
#### actually want to subtract those numbers!!

##############################################

SELECT year, AVG(foo.avgstars)
FROM 
(SELECT title, AVG(stars) AS avgstars, 'pre1980' AS year 
FROM Movie JOIN Rating USING (mID)
WHERE year < 1980
GROUP BY title
UNION
SELECT title, AVG(stars) AS avgstars, 'post1980' AS year
FROM Movie JOIN Rating USING (mID)
WHERE year > 1980
GROUP BY title) AS foo
GROUP BY year DESC;





## following doesn't work but might have to use CASE (suggested on stackoverflow)
#SELECT AVG( CASE WHEN year < 1980 THEN foo.avgstars END)
  #    - AVG( CASE WHEN year >= 1980 THEN foo.avgstars END)
 #FROM Movie JOIN Rating USING (mID)








##########################################################

#Since cannot use JOIN, this method will not work as it does in the correct example above
SELECT title, AVG(pre1980.avgStars) - AVG(post1980.avgStars)
FROM 
# this select statement and teh ones
(SELECT title, AVG(stars) AS avgStars FROM Rating, Movie
WHERE Rating.mID = Movie.mID AND Movie.year < 1980
GROUP BY title) AS pre1980;
## can't join b/c there are no common values to join from (ie no titles or avgStars that are the same in each)
(SELECT title, AVG(stars)AS avgStars FROM Rating, Movie
WHERE Rating.mID = Movie.mID AND Movie.year > 1980
GROUP BY title) AS post1980;

##########################################################









