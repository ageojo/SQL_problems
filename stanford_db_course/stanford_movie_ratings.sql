## https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_core/


# find the titles of all movies directed by steven spielberg
SELECT title, director
FROM Movie
WHERE director = 'Steven Spielberg';

# Find all years that have a movie that received a rating of 4 or 5, 
# and sort them in increasing order.
SELECT DISTINCT year
FROM Movie
INNER JOIN Rating
    ON Movie.mID = Rating.mID
    AND stars >= 4
ORDER BY year;

# WRONG WAY TO DO THIS: Find the titles of all movies that have no ratings. 
SELECT title
FROM Movie
LEFT JOIN Rating
	ON Movie.mID = Rating.mID
    AND stars IS NOT NULL
WHERE stars IS NULL;

#SELECT * FROM Rating;

#SELECT * 
#FROM Rating, Movie;
#WHERE title = "Star Wars" OR title = "Titanic";

# Find the titles of all movies that have no ratings. 
SELECT title, stars
FROM Movie
LEFT JOIN Rating USING (mID)
WHERE stars IS NULL;


SELECT title FROM Movie
WHERE mID NOT IN (SELECT mID FROM Rating);

#Some reviewers didn't provide a date with their rating. 
#Find the names of all reviewers who have ratings with a NULL value for the date. 

SELECT name FROM Reviewer
INNER JOIN Rating #USING (rID)
	ON Reviewer.rID = Rating.rID
    AND stars IS NOT NULL
    AND ratingDate IS NULL;


# Write a query to return the ratings data in a more readable format: 
# reviewer name, movie title, stars, and ratingDate. 
# Also, sort the data, first by reviewer name, then by movie title, 
# and lastly by number of stars. 

SELECT * FROM Rating;

SELECT re.name, m.title, r.stars, r.ratingDate
FROM Reviewer AS re
INNER JOIN Rating AS r 
	ON re.rID = r.rId
INNER JOIN Movie AS m
	ON m.mID = r.mID
ORDER BY re.name, m.title, r.stars;



## Q6: For all cases where the same reviewer rated the same movie twice 
#and gave it a higher rating the second time, return the reviewer's name 
#and the title of the movie. 



## Q7: For each movie that has at least one rating, 
#find the highest number of stars that movie received. 
#Return the movie title and number of stars. Sort by movie title. 


## Q8: For each movie, return the title and the 'rating spread', 
#that is, the difference between highest and lowest ratings given to that movie. 
#Sort by rating spread from highest to lowest, then by movie title. 



# Q9: Find the difference between the average rating of movies released before 1980
# and the average rating of movies released after 1980. 
#(Make sure to calculate the average rating for each movie, 
#then the average of those averages for movies before 1980 and movies after. 
#Don't just calculate the overall average rating before and after 1980.) 


