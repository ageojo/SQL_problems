
# https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_query_core/


SELECT * 
FROM Friend
INNER JOIN Highschooler
	ON ID = ID1
GROUP BY name
ORDER BY ID1;




# Find the names of all students who are friends with someone named Gabriel. 
SELECT name
FROM Highschooler h
LEFT JOIN Friend f 
	ON h.name = 'Gabriel';

SELECT h1.name, h2.name
FROM Highschooler h1
INNER JOIN Friend f 
	ON h1.ID = f.ID1
    AND h1.name = 'Gabriel'


LEFT JOIN Highschooler h2
	ON h1.name = h2.name
    AND h1.name = 'Gabriel'
    AND h2.name != 'Gabriel'   #highschoolers
INNER JOIN Friend f
	ON h.ID = f.ID1;
    
    
    .ID1, f1.ID2 
FROM Friend f1
LEFT JOIN Friend f2
	ON f1.ID1 = f2.ID1    
    AND f1.ID1 = 'Gabriel'
    AND f2.ID2 != 'Gabriel';
    

# Q2 For every student who likes someone 2 or more grades younger than themselves, 
#return that student's name and grade, and the name and grade of the student they like. 








## Q3 : For every pair of students who both like each other, 
#return the name and grade of both students. 
#Include each pair only once, with the two names in alphabetical order. 


# Q4: Find all students who do not appear in the Likes table 
#(as a student who likes or is liked) and return their names and grades. 
#Sort by grade, then by name within each grade. 


SELECT DISTINCT name, grade 
FROM Highschooler AS h 
LEFT JOIN LIKES l
	ON h.ID = l.ID1
    AND h.ID = l.ID1
    OR h.ID = l.ID2
WHERE l.ID1 IS NULL
	AND l.ID2 IS NULL
ORDER BY grade, name;





SELECT a.director
FROM movie a
LEFT JOIN movie b
    ON a.director = b.director
    AND a.yr = 2009
    AND b.yr = 2010
WHERE b.yr is null
    AND a.yr = 2009;
    
    
    
    
    
#Q5: For every situation where student A likes student B, 
#but we have no information about whom B likes 
#(that is, B does not appear as an ID1 in the Likes table), 
#return A and B's names and grades. 

SELECT a.name, a.grade, b.name, b.grade
FROM Highschooler 
WHERE a.ID IN (SELECT ID1 AS ID FROM Likes)
AND
a.ID NOT IN (SELECT ID2 AS ID From Likes);




# Q6: Find names and grades of students who only have friends in the same grade. 
# Return the result sorted by grade, then by name within each grade. 


SELECT h1.name, h1.grade
FROM Friend 
JOIN HighSchooler h1
	ON h1.ID = ID1
WHERE ID1 NOT IN (
	SELECT h2.ID 
    FROM Friend 
		JOIN Highschooler h2
        ON ID1 = h2.ID
        JOIN Highschooler h3;
    

FROM Highschooler h1 
LEFT JOIN Highschooler h2
	ON h1.name = h2.name
    AND h1.grade = h2.grade;
    
    

###########
# Q7: For each student A who likes a student B where the two are not friends, 
#find if they have a friend C in common (who can introduce them!). 
#For all such trios, return the name and grade of A, B, and C. #

SELECT h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
FROM Highschooler h1 
JOIN Highschooler h2 
JOIN (
	SELECT DISTINCT h1.name, h1.grade 
	FROM Highschooler AS h1
	LEFT JOIN LIKES l
		ON h.ID = l.ID1
		AND h.ID = l.ID1
		OR h.ID = l.ID2
	WHERE l.ID1 IS NULL
	  AND l.ID2 IS NULL
      )
JOIN
	(
    SELECT DISTINCT h1.name, 

LEFT JOIN Friends f
	ON h1.ID = f.ID1
    AND h1.ID = 

JOIN (
	SELECT ID1 FROM Likes WHERE ID2 NOT IN (  
		SELECT ID1 FROM Likes
        )
	)

ON h1.ID = ID1
AND h2.ID = ID2


JOIN



s1.ID NOT IN (SELECT s1.name 


SELECT DISTINCT name, grade 
FROM Highschooler AS h 
LEFT JOIN LIKES l
	ON h.ID = l.ID1
    AND h.ID = l.ID1
    OR h.ID = l.ID2
WHERE l.ID1 IS NULL
	AND l.ID2 IS NULL
ORDER BY grade, name;


SELECT a.name, a.grade, b.name, b.grade, c.name, c.grade
FROM Highschooler 
WHERE a.ID IN (SELECT ID1 AS ID FROM Likes)
AND
a.ID NOT IN (SELECT ID2 AS ID From Likes)
;

#################

SELECT h1.name,h1.grade, h2.name,h2.grade, h3.name,h3.grade
FROM Highschooler h1 JOIN Highschooler h2 JOIN Highschooler h3
WHERE (h1.ID, h2.ID, h3.ID) IN (
	SELECT nf.ID1 AS IDA, nf.ID2 AS IDB, f1.ID2 AS IDC
	FROM Friend f1 
    JOIN
			(SELECT ID1,ID2
				FROM Likes
				WHERE (ID1,ID2) 
			NOT IN
			(SELECT ID1,ID2
				FROM Friend)) AS nf
		ON f1.ID1 = nf.ID1
JOIN Friend f2 
	ON f2.ID1 = nf.ID2
WHERE f2.ID2 = f1.ID2);


#Q8: Find the difference between the number of students in the school 
#and the number of different first names. 



#Q9 Find the name and grade of all students who are liked by more than one other student. 











