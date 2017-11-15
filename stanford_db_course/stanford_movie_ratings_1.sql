# Find the titles of all movies directed by Steven Spielberg
SELECT title FROM Movie 
WHERE director = "Steven Spielberg";

#Find all years that have a movie that received a rating of 4 or 5,
# and sort them in increasing order. 
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
	(Select mID FROM Rating);

#Some reviewers didn't provide a date with their rating. 
#Find the names of all reviewers who have ratings with a NULL value 
#for the date. 
SELECT name 
FROM Reviewer JOIN Rating USING (rID)
WHERE ratingDATE IS NULL;


# Write a query to return the ratings data in a more readable format: 
#reviewer name, movie title, stars, and ratingDate. 
#Also, sort the data, first by reviewer name, 
#then by movie title, and lastly by number of stars. 

SELECT name, title, stars, ratingDate
FROM Reviewer, Rating, Movie
WHERE Reviewer.rID = Rating.rID AND Rating.mID = Movie.mID
ORDER BY name, title, stars;


# For all cases where the same reviewer rated the same movie twice 
#and gave it a higher rating the second time, 
#return the reviewer's name and the title of the movie. 

#if use LEFT JOIN need to use WHERE clause to filter out excess columns
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
SELECT DISTINCT name, title 
FROM Rating r1, Rating r2, Movie, Reviewer
WHERE r1.rID = r2.rID AND r1.mID = r2.mID
AND r1.ratingDate > r2.ratingDate AND r1.stars > r2.stars
AND Movie.mID = r1.mID AND r1.rID = Reviewer.rID;


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
    ) AS post1980
 ;   

