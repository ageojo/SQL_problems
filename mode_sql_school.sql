--SELECT *
--  FROM tutorial.us_housing_units
  
SELECT year AS "Year", month AS "Month", month_name AS "Month_name", south AS "South", 
west as "West", midwest AS "Midwest", northeast as "Northeast"
FROM tutorial.us_housing_units
WHERE Month <> 4
ORDER BY Month_name
LIMIT 5;

-- did the west region ever produce more than 50,000 housing units in one month?
SELECT *
FROM tutorial.us_housing_units
WHERE west > 50;


# notice that single quotes are used for value
# and the difference btw 'J' and 'January'; former includes records with month_name=January
# b/c 'Ja' comes after 'J'; (alphabetic string sorting)

SELECT *
  FROM tutorial.us_housing_units
  WHERE month_name > 'January';

# all rows for which more units produced in the west region than in the midwest and northeast combined

SELECT *
FROM tutorial.us_housing_units
WHERE west > (midwest + northeast)
LIMIT 10;


# return percentage of all houses completed in US represented by each region
# me interview prep clarification: alter
# (num houses in the south/all houses), (#H west/All), (#H midwest/All), (#H northeast/All)   
#     WHERE year >= 2000

SELECT year, month,
  south/(south + west + midwest + northeast)*100 as south_per,
  west/(south + west + midwest + northeast)*100 as west_per,
  midwest/(south + west + midwest + northeast)*100 as midwest_per,
  northeast/(south + west + midwest + northeast)*100 as northeast_per
FROM tutorial.us_housing_units
WHERE year >= 2000;


# "group" in quotes to designate the col name rather than the function GROUP 
# (caps for mysql commands only a convention)
# to match in a way not case-sensitive, use ILIKE  

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE "group" LIKE 'Snoop%'  #capture anything that starts with capital 'S' followed by 'noop'
 LIMIT 10;

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE "group" ILIKE 'dr_ke'  
 LIMIT 10;

## VERSION I AM USING -- NO ILIKE; AND LIKE IS *NOT* CASE SENSITIVE
## the single character subsititution _ is used with LIKE 

#########################################
# WRITE:  query that shows all of the entires for Elivs and M.C. Hammer
# Note: M.C. Hammer listed under multiple names

#--artist = 'Elvis' returns no rows; always listed as 'Elivis Presley'
# WHERE "group" ILIKE '%Ludacris%'
# WHERE artist ILIKE '%Hammer%'   --returns Jan Hammer and M.C. Hammer and Hammer (ref M.C. Hammer)
#--WHERE artist ILIKE '%M.C.%' -- returns Run-D.M.C, Young M.C. and M.C. Hammer


SELECT *
FROM tutorial.billboard_top_100_year_end
#--WHERE "group" = 'Elvis Presley' OR artist = 'M.C. Hammer' OR artist = 'Hammer'
WHERE "group" in ('Elvis Presley', 'M.C. Hammer', 'Hammer'); 



## between includes range bounds; below equivalent >= statments shown
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year BETWEEN 1985 AND 1990
# WHERE year >= 1985 AND year <= 1990
ORDER BY year DESC;


SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2013 
    AND artist IS NOT NULL;
#--   AND year_rank NOT BETWEEN 2 AND 3
#--   AND "group" NOT ILIKE '%macklemore%';


# surface songs that were on the charts in 2013 and do not contain the letter 'a'
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2013 
    AND song_name NOT LIKE '%a%';



# all songs featuring Dr. Dre before 2001 or after 2010; ILIKE if case sensitive; 
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" LIKE '%Dr. Dre%' 
   AND (year < 2000 OR year >= 2009); # must use ( ) to bracket of OR b/c of AND 
   #>= before incl soungs in 2009; although should check year stuff in interview - input/output


#Write a query that returns songs that ranked between 10 and 20 (inclusive) in 1993, 2003, or 2013. 
#Order the results by year and rank, and leave a comment on each line of the WHERE clause 
#to indicate what that line does

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank BETWEEN  10 AND 20  # Limit the rank to 10-20
    AND year in (1993, 2003, 2013)   # select the relevant years
  ORDER BY year, year_rank;


# number of missing values in column high; COUNT(*)=COUNT(1) = total number of records in table
# COUNT returns total number of non-NULL rows; not unique values
SELECT COUNT(*) - COUNT(high) AS ct_h_null
  FROM tutorial.aapl_historical_stock_price


