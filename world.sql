-- How does GNP vary by government?
SELECT
    co.GovernmentForm
  ,	AVG(co.GNP) AS gnp_mean
  , STDDEV_POP(co.GNP) AS gnp_sd
  , COUNT(DISTINCT co.code) AS country_count
FROM world.Country co
GROUP BY co.GovernmentForm
ORDER BY gnp_mean DESC
;

-- Histogram of GNP amount
SELECT
    COALESCE(POWER(10, FLOOR(LOG10(co.GNP))), 0) AS gnp_bucket
  ,	COUNT(DISTINCT co.code) AS country_count
FROM world.Country co
GROUP BY gnp_bucket
ORDER BY gnp_bucket DESC
;

-- Normalized Histogram
SELECT
    COALESCE(POWER(10, FLOOR(LOG10(co.GNP))), 0) AS gnp_bucket
  ,	COUNT(DISTINCT co.code) / (SELECT COUNT(*) FROM Country) AS country_percent
FROM world.Country co
GROUP BY gnp_bucket
ORDER BY gnp_bucket DESC
;

--  GNP PMF and CDF
SELECT
    pmf.gnp_bucket
  ,	pmf.country_percent AS country_percent_pmf
  , SUM(cdf.country_percent) AS country_percent_cdf
FROM (
  SELECT
      COALESCE(POWER(10, FLOOR(LOG10(co.GNP))), 0) AS gnp_bucket
    ,	COUNT(DISTINCT co.code) / (SELECT COUNT(*) FROM Country) AS country_percent
  FROM world.Country co
  GROUP BY gnp_bucket
  ORDER BY gnp_bucket ASC
) pmf
JOIN (
  SELECT
      COALESCE(POWER(10, FLOOR(LOG10(co.GNP))), 0) AS gnp_bucket
    ,	COUNT(DISTINCT co.code) / (SELECT COUNT(*) FROM Country) AS country_percent
  FROM world.Country co
  GROUP BY gnp_bucket
  ORDER BY gnp_bucket ASC
) cdf
ON cdf.gnp_bucket <= pmf.gnp_bucket
GROUP BY pmf.gnp_bucket
;

-- Life Expectancy per Continent
-- First get the totals:
SELECT
    co.Continent
  ,	SUM(co.Population) AS population
FROM world.Country co
GROUP BY co.Continent
LIMIT 10;

-- Now join against that:
SELECT
    co.Code
  ,	co.Name
  , co.Continent
  , (co.Population / sub.Population) AS percent_continent_population
FROM  world.Country co
JOIN (
  SELECT
      co.Continent
    ,	SUM(co.Population) AS population
  FROM world.Country co
  GROUP BY co.Continent
) sub
ON co.Continent = sub.Continent
;

-- Double check that things add to 1:
SELECT
    Continent
  ,	SUM(percent_continent_population)
FROM (
  SELECT
      co.Code
    ,	co.Name
    , co.Continent
    , (co.Population / sub.Population) AS percent_continent_population
  FROM  world.Country co
  JOIN (
    SELECT
        co.Continent
      ,	SUM(co.Population) AS population
    FROM world.Country co
    GROUP BY co.Continent
  ) sub
  ON co.Continent = sub.Continent
) inside
GROUP BY Continent
;


-- Weighed Life Expectancy
SELECT
    Continent
  , SUM(percent_continent_population*LifeExpectancy) AS weighed_life_expectancy
FROM (
  SELECT
      co.Code
    ,	co.Name
    , co.Continent
    , co.LifeExpectancy
    , (co.Population / sub.Population) AS percent_continent_population
  FROM  world.Country co
  JOIN (
    SELECT
        co.Continent
      ,	SUM(co.Population) AS population
    FROM world.Country co
    GROUP BY co.Continent
  ) sub
  ON co.Continent = sub.Continent
) inside
GROUP BY Continent
ORDER BY weighed_life_expectancy DESC
;

