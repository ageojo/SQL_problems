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
#  DISTINCT name is b/c you may have 2 reviewers with the same name who rated the same movie 2x
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
SELECT DISTINCT name, title 
FROM Rating r1, Rating r2, Movie, Reviewer
WHERE r1.rID = r2.rID AND r1.mID = r2.mID
AND r1.ratingDate > r2.ratingDate AND r1.stars > r2.stars
AND Movie.mID = r1.mID AND r1.rID = Reviewer.rID;








