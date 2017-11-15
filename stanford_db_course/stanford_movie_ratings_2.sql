## https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_core/

SELECT * FROM Rating; 

SELECT * From Reviewer;
# Q1 find the titles of all movies directed by steven spielberg
SELECT title, director
FROM Movie
WHERE director = 'Steven Spielberg';

#Q2 Find all years that have a movie that received a rating of 4 or 5, 
# and sort them in increasing order.
SELECT DISTINCT year
FROM Movie
INNER JOIN Rating
    ON Movie.mID = Rating.mID
    AND stars >= 4
ORDER BY year;

#Q3 Find the titles of all movies that have no ratings. 
SELECT title
FROM Movie
LEFT JOIN Rating
	ON Movie.mID = Rating.mID
WHERE stars IS NULL;

#Q4: Some reviewers didn't provide a date with their rating. 
#Find the names of all reviewers who have ratings with a NULL value for the date. 
SELECT name
FROM Reviewer 
WHERE rID IN (SELECT rID
				FROM Rating
                WHERE ratingDate IS NULL);

#Same as 
SELECT name FROM Reviewer
INNER JOIN Rating
	ON Reviewer.rID = Rating.rID
    AND stars IS NOT NULL
    AND ratingDate IS NULL;

#Q5 Write a query to return the ratings data in a more readable format: 
#reviewer name, movie title, stars, and ratingDate. 
#Also, sort the data, first by reviewer name, 
#then by movie title, and lastly by number of stars. 

SELECT Reviewer.name, Movie.title, Rating.stars, Rating.ratingDate
FROM Movie JOIN Rating USING(mID) JOIN Reviewer USING(rID)
ORDER BY name, title, stars;

# saame as 
SELECT re.name, m.title, r.stars, r.ratingDate
FROM Reviewer AS re
INNER JOIN Rating AS r 
	ON re.rID = r.rId
INNER JOIN Movie AS m
	ON m.mID = r.mID
ORDER BY re.name, m.title, r.stars;




# Q6 For all cases where the same reviewer rated the same movie twice
# and gave it a higher rating the second time, 
#return the reviewer's name and the title of the movie. 

SELECT name, title 
FROM Reviewer, Movie, Rating r1, Rating r2
WHERE Reviewer.rID = r1.rID AND Movie.mID = r1.mID
	AND r1.rID = r2.rID AND r2.mID = Movie.mID
    AND r1.stars > r2.stars AND r1.ratingDate > r2.ratingDate;


#Q 7: For each movie that has at least one rating, 
#find the highest number of stars that movie received. 
#Return the movie title and number of stars. Sort by movie title. 

SELECT title, max(stars)
FROM Movie, Rating
WHERE Movie.mID = Rating.mID
GROUP BY Rating.mID 
ORDER BY title;


# Q8: For each movie, return the title and the 'rating spread', 
# that is, the difference between highest and lowest ratings given to that movie. 
# Sort by rating spread from highest to lowest, then by movie title. 
SELECT title, max(stars) - min(stars) as spread
FROM Movie JOIN Rating USING (mID)
GROUP BY title
ORDER BY spread DESC;



# Find the difference between the average rating of movies released before 1980 
#and the average rating of movies released after 1980. 

#(Make sure to calculate the average rating for each movie, 
# then the average of those averages for movies before 1980 and movies after. 
# Don't just calculate the overall average rating before and after 1980.) 

SELECT avg(former.pre1980) - avg(latter.post1980)
FROM 
	(SELECT avg(stars) as pre1980, title  
		FROM Movie JOIN RATING USING (mID)
		WHERE year < 1980
		GROUP BY title) AS former,
	(SELECT avg(stars) as post1980, title
		FROM Movie JOIN Rating USING (mID) 
        WHERE year > 1980
        GROUP BY title) as latter;
	


## Movie Ratings Extras
SELECT * FROM Movie, Rating, Reviewer
WHERE Movie.mID = Rating.mID AND Rating.rID = Reviewer.rID
ORDER BY title;  
#just smashes tables together -- horizontal joinl expands records of one table to equal records of the other
# but without key, they aren't matched up

SELECT * FROM Reviewer
JOIN Rating USING(rID)
JOIN Movie USING(mID)
ORDER BY title;

#JOIN Reviewer USING(rID)
#ORDER BY title;                             
SELECT * FROM Movie ORDER BY mID;
SELECT * FROM Rating ORDER BY mID;
SELECT * FROM Reviewer ORDER BY rID;



#Q1: Find the names of all reviewers who rated Gone with the Wind
SELECT DISTINCT name
FROM Reviewer
JOIN Rating 
	ON Reviewer.rID = Rating.rID
    WHERE Rating.mID IN (SELECT mID FROM Movie WHERE title = 'Gone with the wind');


SELECT DISTINCT name
FROM Rating JOIN Reviewer USING (rID)
WHERE Rating.mID IN (SELECT mID FROM Movie WHERE title = 'Gone with the Wind');


#Q2: For any rating where the reviewer is the same as the director of the movie, 
# return the reviewer name, movie title, and number of stars. 

SELECT name, title, stars
FROM Movie, Rating, Reviewer
WHERE Movie.mID = Rating.mID AND Rating.rID = Reviewer.rID
AND Movie.director = Reviewer.name;


#Q3 Return all reviewer names and movie names together in a single list, alphabetized.
# (Sorting by the first name of the reviewer and first word in the title is fine; 
#no need for special processing on last names or removing "The".) 


## not sure why this doesn't run in mysql workbench; it is correct according to stanford site
SELECT DISTINCT Reviewer.name
FROM Reviewer
UNION
SELECT DISTINCT Movie.title
FROM Movie
ORDER BY Reviewer.name, Movie.title;




#Q4: Find the titles of all movies not reviewed by Chris Jackson. 
#[HINT: including movies NOT reviewd]
SELECT title 
FROM Movie
WHERE mID NOT IN 
	(SELECT mID FROM Rating WHERE rID  IN 
		(SELECT rID FROM Reviewer WHERE name = 'Chris Jackson')
        );
    



#Q5: For all pairs of reviewers such that both reviewers gave a rating to the same movie,
# return the names of both reviewers. Eliminate duplicates, 
#don't pair reviewers with themselves, and include each pair only once. 
#For each pair, return the names in the pair in alphabetical order. 



SELECT DISTINCT rev1.name, rev2.name
FROM 
	(SELECT re1.name, mID 
    FROM Rating LEFT JOIN Reviewer re1
    ON Rating.rID = re1.rID) as rev1
    LEFT JOIN
		(SELECT re2.name, mID
		FROM Rating LEFT JOIN Reviewer re2
		ON Rating.rID = re2.rID) as rev2
	ON rev1.mID = rev2.mID 
WHERE rev1.name < rev2.name
ORDER BY rev1.name;


# Q6: For each rating that is the lowest (fewest stars) currently in the database, 
#return the reviewer name, movie title, and number of stars. 




# Q7: List movie titles and average ratings, from highest-rated to lowest-rated. 
# If two or more movies have the same average rating, list them in alphabetical order. 


# Q8: Find the names of all reviewers who have contributed three or more ratings. 
# (As an extra challenge, try writing the query without HAVING or without COUNT.) 



#Q9: Some directors directed more than one movie. 
# For all such directors, return the titles of all movies directed by them, 
# along with the director name. Sort by director name, then movie title. (
# As an extra challenge, try writing the query both with and without COUNT.) 




#Q10:

#Q11:

#Q12:



######### Social Network Extras
# https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_query_extra/
SELECT * FROM Likes;

# Q1For every situation where student A likes student B, 
#but student B likes a different student C, 
#return the names and grades of A, B, and C. 

Select a.name, a.grade, b.name, b.grade, c.name, c.grade
FROM Likes l1, Likes l2, Highschooler a, Highschooler b, Highschooler c 
WHERE a.ID = l1.ID1 AND b.ID = l1.ID2 
AND b.ID = l2.ID1 AND a.ID != l2.ID2 AND c.ID = l2.ID2;


SELECT * FROM Highschooler, Likes;

#Q2 Find those students for whom all of their friends are in different grades from themselves. 
# Return the students' names and grades. 

SELECT name, grade
FROM Highschooler 
WHERE ID NOT IN 
	(SELECT DISTINCT h1.ID 
    FROM Highschooler h1, Highschooler h2, Friend f
    WHERE h1.ID = f.ID1 and h2.ID = f.ID2 AND h1.grade = h2.grade);
    

# Q3: What is the average number of friends per student? 
# (Your result should be just one number.) 

SELECT avg(friend_count.numFriends)
FROM 
(SELECT COUNT(ID) as numFriends
  FROM Highschooler, Friend
  WHERE Highschooler.ID = Friend.ID1
  GROUP BY Highschooler.ID) AS friend_count;




# Q4: Find the number of students who are either friends with Cassandra 
# or are friends of friends of Cassandra. 
#Do not count Cassandra, even though technically she is a friend of a friend. 

SELECT COUNT(*)
FROM Friend f1 
	JOIN (SELECT ID FROM Highschooler WHERE name = 'Cassandra') AS cass  #Cassandra needs to be in single quotes
		ON cass.ID = f1.ID1 #cass's friends = f1.ID2
	JOIN Friend f2
WHERE f2.ID1 = f1.ID2;  #f1.ID2 = cass's friends; so here, f2.ID1 will be cass's friends' friends

# note above is first creating Friends f1 table which only has cassandra-cassandra-friend records
# second is joining to Friends table where IDs match those of cassandra's friends
 
# Why Does this work
#SELECT COUNT(*)
#FROM Friend f1, Friend f2, Highschooler
#WHERE f1.ID1 = (SELECT ID FROM Highschooler WHERE name = 'Cassandra')
#	AND f1.ID2 = f2.ID1
#	AND name = 'Cassandra';



#Q5 Find the name and grade of the student(s) with the greatest number of friends. 


## this shows you a table of each student, their grade, and the number of friends they have
SELECT H.name, H.grade, COUNT(F.ID1)
FROM Friend F, Highschooler H
WHERE F.ID1 = H.ID
GROUP BY F.ID1;        



 ### this table tells you the max # of friends any student has (in this case, 4)
SELECT MAX(fc.numFriend) FROM         
#num friends for each student in Friend
	(SELECT ID1, COUNT(*) AS numFriend
	FROM Friend
	GROUP BY ID1) AS fc;



## This table gives you the name and grade of the student(s) with the greatest # of friends
# in this case, there are two students, each with 4 friends
SELECT H.name, H.grade
FROM Friend F, Highschooler H
WHERE F.ID1 = H.ID
GROUP BY F.ID1
HAVING COUNT(*) = (SELECT MAX(fc.numFriend) FROM
#num friends for each student in Friend
						(SELECT ID1, COUNT(*) AS numFriend
							FROM Friend
							GROUP BY ID1) AS fc
					)
;



#######################
/*
# all of these produce INNER JOINS aka JOINS AKA Natural joins
SELECT * FROM Movie, Rating, Reviewer
WHERE Movie.mID = Rating.mID AND Rating.rID = Reviewer.rID
ORDER BY title;  
#just smashes tables together -- horizontal joinl expands records of one table to equal records of the other
# but without key, they aren't matched up

## exactly the same as above; order here does not matter
SELECT * FROM Reviewer, Rating, Movie
WHERE Rating.rID = Reviewer.rID AND Movie.mID = Rating.mID 
ORDER BY title;


SELECT * FROM Rating   # INNER JOIN; results with records that match in both tables on key
JOIN Movie USING (mID)
ORDER BY title;           

SELECT * 
FROM Rating, Movie  #same as above; alt syntax for INNER JOIN on key
WHERE Rating.mID = Movie.mID
ORDER BY title;

SELECT *
FROM Rating
NATURAL JOIN Movie 
WHERE Rating.mID = Movie.mID
ORDER BY title;

SELECT *
FROM Rating
JOIN Movie USING(mID)
ORDER BY title;
*/
