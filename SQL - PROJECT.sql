CREATE DATABASE PROJECT;
USE PROJECT;
CREATE TABLE CONSUMERS(
CONSUMER_ID VARCHAR(10) PRIMARY KEY,
CITY VARCHAR(255),
STATE VARCHAR(255),
COUNTRY VARCHAR(255),
LATITUDE DECIMAL(10,7),
LONGITUDE DECIMAL(10,7),
SMOKER VARCHAR(10),
DRINK_LEVEL VARCHAR(50),
TRANSPORTATION_METHOD VARCHAR(500),
MARITAL_STATUS VARCHAR(20),
CHILDREN VARCHAR(20),
AGE INT,
OCCUPATION VARCHAR(50),
BUDGET VARCHAR(10)
);
SELECT * FROM CONSUMERS;

CREATE TABLE RESTAURANTS(
RESTAURANT_ID INT PRIMARY KEY,
NAME VARCHAR(255),
CITY VARCHAR(255),
STATE VARCHAR(255),
COUNTRY VARCHAR(255),
ZIP_CODE VARCHAR(10),
LATITUDE DECIMAL(10,8),
LONGITUDE DECIMAL(11,8),
ALCOHOL_SERVICE VARCHAR(50),
SMOKING_ALLOWED VARCHAR(50),
PRICE VARCHAR(10),
FRANCHISE VARCHAR(5),
AREA VARCHAR(10),
PARKING VARCHAR(50)
);
SELECT * FROM RESTAURANTS;

CREATE TABLE RESTAURANT_CUISINE(
RESTAURANT_ID INT,
CUISINE VARCHAR(255),
FOREIGN KEY(RESTAURANT_ID) REFERENCES RESTAURANTS(RESTAURANT_ID)
);
SELECT * FROM RESTAURANT_CUISINE;

CREATE TABLE CONSUMER_PREFERENCES(
CONSUMER_ID VARCHAR(10),
PREFERRED_CUISINE VARCHAR(255),
FOREIGN KEY(CONSUMER_ID) REFERENCES CONSUMERS(CONSUMER_ID)
);
SELECT * FROM CONSUMER_PREFERENCES;

CREATE TABLE RATINGS(
CONSUMER_ID VARCHAR(10),
RESTAURANT_ID INT,
OVERALL_RATING INT,
FOOD_RATING INT,
SERVICE_RATING INT,
FOREIGN KEY(CONSUMER_ID) REFERENCES CONSUMERS(CONSUMER_ID),
FOREIGN KEY(RESTAURANT_ID) REFERENCES RESTAURANTS(RESTAURANT_ID)
);
SELECT * FROM RATINGS;

-- Using the WHERE clause to filter data based on specific criteria.
-- 1. List all details of consumers who live in the city of 'Cuernavaca'.
SELECT * FROM CONSUMERS
WHERE CITY = 'CUERNAVACA';

-- 2. Find the Consumer_ID, Age, and Occupation of all consumers who are 'Students' AND are 'Smokers'.
SELECT CONSUMER_ID, AGE, OCCUPATION
FROM CONSUMERS
WHERE OCCUPATION = 'STUDENT' AND SMOKER = 'YES';

-- 3. List the Name, City, Alcohol_Service, and Price of all restaurants that serve 'Wine & Beer' and have a 'Medium' price level.
SELECT NAME, CITY, ALCOHOL_SERVICE, PRICE
FROM RESTAURANTS
WHERE ALCOHOL_SERVICE = 'Wine & Beer'
HAVING PRICE = 'Medium';

-- 4. Find the names and cities of all restaurants that are part of a 'Franchise'.
SELECT NAME, CITY
FROM RESTAURANTS
WHERE FRANCHISE = 'YES';

-- 5. Show the Consumer_ID, Restaurant_ID, and Overall_Rating for all ratings where the Overall_Rating was 'Highly Satisfactory' (which corresponds to a value of 2, according to the data dictionary).
SELECT CONSUMER_ID, RESTAURANT_ID, OVERALL_RATING
FROM RATINGS
WHERE OVERALL_RATING = 2;

-- Questions JOINs with Subqueries
-- 1. List the names and cities of all restaurants that have an Overall_Rating of 2 (Highly Satisfactory) from at least one consumer.
SELECT R.NAME, R.CITY
FROM RESTAURANTS R
JOIN RATINGS T ON 
R.RESTAURANT_ID = T.RESTAURANT_ID
WHERE OVERALL_RATING = 2;

-- 2. Find the Consumer_ID and Age of consumers who have rated restaurants located in 'San Luis Potosi'.
SELECT C.CONSUMER_ID, C.AGE 
FROM CONSUMERS C
JOIN RATINGS R ON
R.CONSUMER_ID = C.CONSUMER_ID
JOIN RESTAURANTS T ON
T.RESTAURANT_ID = R.RESTAURANT_ID
WHERE T.CITY = 'San Luis Potosi';

-- 3. List the names of restaurants that serve 'Mexican' cuisine and have been rated by consumer 'U1001'.
SELECT R.NAME
FROM RESTAURANTS R
JOIN RESTAURANT_CUISINE C ON 
C.RESTAURANT_ID = R.RESTAURANT_ID
JOIN RATINGS T ON
T.RESTAURANT_ID = C.RESTAURANT_ID
WHERE C.CUISINE = 'Mexican' AND T.CONSUMER_ID = 'U1001';

-- 4. Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget.
SELECT C.* FROM CONSUMERS C
JOIN CONSUMER_PREFERENCES P ON
C.CONSUMER_ID = P.CONSUMER_ID
WHERE P.PREFERRED_CUISINE = 'American' AND C.BUDGET = 'Medium';

-- 5. List restaurants (Name, City) that have received a Food_Rating lower than the average Food_Rating across all rated restaurants.
SELECT R.NAME, R.CITY
FROM RESTAURANTS R
JOIN RATINGS T ON
R.RESTAURANT_ID = T.RESTAURANT_ID
WHERE T.FOOD_RATING < (
	SELECT AVG(FOOD_RATING)
    FROM RATINGS
);

-- 6. Find consumers (Consumer_ID, Age, Occupation) who have rated at least one restaurant but have NOT rated any restaurant that serves 'Italian' cuisine.
SELECT C.CONSUMER_ID, C.AGE, C.OCCUPATION
FROM CONSUMERS C
JOIN RATINGS T ON
C.CONSUMER_ID = T.CONSUMER_ID
JOIN RESTAURANT_CUISINE RC ON 
T.RESTAURANT_ID = RC.RESTAURANT_ID
WHERE RC.CUISINE = 'Italian' AND T.OVERALL_RATING >=1;

-- 7. List restaurants (Name) that have received ratings from consumers older than 30.
SELECT R.NAME 
FROM RESTAURANTS R
JOIN RATINGS T ON
R.RESTAURANT_ID = T.RESTAURANT_ID
JOIN CONSUMERS C ON 
C.CONSUMER_ID = T.CONSUMER_ID
WHERE C.AGE > 30;

-- 8. Find the Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican' and 
-- who have given an Overall_Rating of 0 to at least one restaurant (any restaurant).
SELECT C.CONSUMER_ID, C.OCCUPATION
FROM CONSUMERS C
JOIN CONSUMER_PREFERENCES CP ON
C.CONSUMER_ID = CP.CONSUMER_ID
JOIN RATINGS RT ON
RT.CONSUMER_ID = C.CONSUMER_ID
WHERE CP.PREFERRED_CUISINE = 'Mexican' AND RT.OVERALL_RATING <= 0;

-- 9. List the names and cities of restaurants that serve 'Pizzeria' cuisine and are located in a city where at least one 'Student' consumer lives
SELECT R.NAME, R.CITY
FROM RESTAURANTS R
JOIN RESTAURANT_CUISINE RC ON
RC.RESTAURANT_ID = R.RESTAURANT_ID
JOIN CONSUMERS C ON
C.CITY = R.CITY
WHERE RC.CUISINE = 'Pizzeria' AND C.OCCUPATION = 'Student';

-- 10 Find consumers (Consumer_ID, Age) who are 'Social Drinkers' and have rated a restaurant that has 'No' parking.
SELECT C.CONSUMER_ID, C.AGE
FROM CONSUMERS C
JOIN RATINGS RT ON
C.CONSUMER_ID = RT.CONSUMER_ID
JOIN RESTAURANTS R ON
R.RESTAURANT_ID = RT.RESTAURANT_ID
WHERE C.DRINK_LEVEL = 'Social Drinkers' AND R.PARKING = 'None';

-- Questions Emphasizing WHERE Clause and Order of Execution
-- 1. List Consumer_IDs and the count of restaurants they've rated, but only for consumers who are 'Students'. Show only students who have rated more than 2 restaurants.
SELECT C.CONSUMER_ID, COUNT(DISTINCT R.RESTAURANT_ID) AS REST_COUNT
FROM CONSUMERS C
JOIN RATINGS R ON
C.CONSUMER_ID = R.CONSUMER_ID
WHERE C.OCCUPATION = 'Student'
GROUP BY C.CONSUMER_ID
HAVING COUNT(DISTINCT R.RESTAURANT_ID) > 2;

-- 2. We want to categorize consumers by an 'Engagement_Score' which is their Age divided by 10 (integer division).
-- List the Consumer_ID, Age, and this calculated Engagement_Score,
-- but only for consumers whose Engagement_Score would be exactly 2 and who use 'Public' transportation.
SELECT C.CONSUMER_ID, C.AGE, (AGE / 10) AS ENGAGEMENT_SCORE
FROM CONSUMERS C
WHERE (AGE / 10) = 2 AND C.TRANSPORTATION_METHOD = 'Public';

-- 3. For each restaurant, calculate its average Overall_Rating.
-- Then, list the restaurant Name, City, and its calculated average Overall_Rating,
-- but only for restaurants located in 'Cuernavaca' AND whose calculated average Overall_Rating is greater than 1.0.
SELECT R.NAME, R.CITY, AVG(RT.Overall_Rating) AS OVER_RATE
FROM RESTAURANTS R
JOIN RATINGS RT ON
RT.RESTAURANT_ID = R.RESTAURANT_ID
WHERE R.CITY = 'Cuernavaca'
GROUP BY R.NAME, R.CITY
HAVING (AVG(RT.Overall_Rating)) > 1.0;

-- 4. Find consumers (Consumer_ID, Age) who are 'Married' and
-- whose Food_Rating for any restaurant is equal to their Service_Rating for that same restaurant,
-- but only consider ratings where the Overall_Rating was 2.
SELECT C.CONSUMER_ID, C.AGE
FROM CONSUMERS C
JOIN RATINGS RT ON
C.CONSUMER_ID = RT.CONSUMER_ID
WHERE C.MARITAL_STATUS = 'Married' AND RT.FOOD_RATING = RT.SERVICE_RATING AND RT.OVERALL_RATING = 2;

-- 5. List Consumer_ID, Age, and the Name of any restaurant they rated, but only for consumers who are 'Employed' and
-- have given a Food_Rating of 0 to at least one restaurant located in 'Ciudad Victoria'.
SELECT C.CONSUMER_ID, C.AGE, R.NAME
FROM CONSUMERS C
JOIN RATINGS RT ON
RT.CONSUMER_ID = C.CONSUMER_ID
JOIN RESTAURANTS R ON
R.RESTAURANT_ID = RT.RESTAURANT_ID
WHERE C.OCCUPATION = 'Employed' AND RT.FOOD_RATING = 0 AND R.CITY = 'Ciudad Victoria';

-- Advanced SQL Concepts: Derived Tables, CTEs, Window Functions, Views, Stored Procedures
-- 1. Using a CTE, find all consumers who live in 'San Luis Potosi'. Then, list their Consumer_ID, Age, and
-- the Name of any Mexican restaurant they have rated with an Overall_Rating of 2.
WITH CON_REST AS(
	SELECT C.CONSUMER_ID, C.AGE, R.NAME, C.CITY, RT.OVERALL_RATING, RC.CUISINE
	FROM CONSUMERS C
	JOIN RATINGS RT ON 
	RT.CONSUMER_ID = C.CONSUMER_ID
	JOIN RESTAURANTS R ON
	R.RESTAURANT_ID = RT.RESTAURANT_ID
    JOIN RESTAURANT_CUISINE RC ON
    RC.RESTAURANT_ID = R.RESTAURANT_ID)
SELECT * FROM CON_REST
WHERE CITY = 'San Luis Potosi' AND OVERALL_RATING = 2 AND CUISINE = 'Mexican';

-- 2. For each Occupation, find the average age of consumers.
-- Only consider consumers who have made at least one rating. (Use a derived table to get consumers who have rated).
SELECT OCCUPATION, AVG(AGE) AS AVG_AGE
FROM CONSUMERS
WHERE CONSUMER_ID IN (
    SELECT CONSUMER_ID
    FROM RATINGS
    WHERE OVERALL_RATING >= 1
)
GROUP BY OCCUPATION;

-- 3. Using a CTE to get all ratings for restaurants in 'Cuernavaca',
-- rank these ratings within each restaurant based on Overall_Rating (highest first).
-- Display Restaurant_ID, Consumer_ID, Overall_Rating, and the RatingRank.
WITH RAT AS (
	SELECT RT.RESTAURANT_ID, RT.CONSUMER_ID, RT.OVERALL_RATING, R.CITY,
    CASE OVERALL_RATING
    WHEN 2 THEN 'HIGH'
    WHEN 1 THEN 'MEDIUM'
    ELSE 'LOW'
    END AS RATINGRANK
	FROM RATINGS RT
    JOIN RESTAURANTS R ON
    R.RESTAURANT_ID = RT.RESTAURANT_ID
)
SELECT RESTAURANT_ID, CONSUMER_ID, OVERALL_RATING, RATINGRANK, CITY
FROM RAT
WHERE CITY = 'Cuernavaca'
ORDER BY OVERALL_RATING DESC;

-- 4. For each rating, show the Consumer_ID, Restaurant_ID, Overall_Rating, and 
-- also display the average Overall_Rating given by that specific consumer across all their ratings.
SELECT RT.CONSUMER_ID, RT.RESTAURANT_ID, RT.OVERALL_RATING, AVG(RT.OVERALL_RATING)
OVER ( PARTITION BY RT.CONSUMER_ID
) AS AVG_RATING
FROM RATINGS RT;

-- 5. Using a CTE, identify students who have a 'Low' budget. Then, for each of these students,
-- list their top 3 most preferred cuisines based on the order they appear in the Consumer_Preferences table 
-- (assuming no explicit preference order, use Consumer_ID, Preferred_Cuisine to define order for ROW_NUMBER).
WITH STUDENT_BUDGET AS (
SELECT CONSUMER_ID, OCCUPATION = 'Student', BUDGET = 'Low' FROM CONSUMERS ),
PREF_CUISINE AS (
SELECT CP.CONSUMER_ID, CP.PREFERRED_CUISINE, ROW_NUMBER()
OVER ( PARTITION BY CP.CONSUMER_ID 
	   ORDER BY CP.CONSUMER_ID, CP.PREFERRED_CUISINE ) AS PC
       FROM CONSUMER_PREFERENCES CP
       JOIN STUDENT_BUDGET SB ON
       CP.CONSUMER_ID = SB.CONSUMER_ID )
SELECT CONSUMER_ID, PREFERRED_CUISINE
FROM PREF_CUISINE
WHERE PC <=3
ORDER BY CONSUMER_ID, PC;

-- 6. Consider all ratings made by 'Consumer_ID' = 'U1008'. For each rating, show the Restaurant_ID, Overall_Rating, and
-- the Overall_Rating of the next restaurant they rated (if any), ordered by Restaurant_ID (as a proxy for time if rating time isn't available).
-- Use a derived table to filter for the consumer's ratings first.
WITH CONSUMER_RATINGS AS (
    SELECT RT.RESTAURANT_ID, RT.OVERALL_RATING
    FROM RATINGS RT
    WHERE RT.CONSUMER_ID = 'U1008'
)
SELECT RESTAURANT_ID, OVERALL_RATING,
    LEAD(OVERALL_RATING) OVER (
        ORDER BY RESTAURANT_ID
    ) AS NEXT_RATING
FROM CONSUMER_RATINGS
ORDER BY RESTAURANT_ID;

-- 7. Create a VIEW named HighlyRatedMexicanRestaurants that shows the Restaurant_ID, Name, and
-- City of all Mexican restaurants that have an average Overall_Rating greater than 1.5.
CREATE VIEW HighlyRatedMexicanRestaurants AS
SELECT R.RESTAURANT_ID, R.NAME, R.CITY
FROM RESTAURANTS R
JOIN RATINGS RT ON 
R.RESTAURANT_ID = RT.RESTAURANT_ID
JOIN RESTAURANT_CUISINE RC ON
RC.RESTAURANT_ID = R.RESTAURANT_ID
WHERE RC.CUISINE = 'Mexican'
GROUP BY R.RESTAURANT_ID, R.NAME, R.CITY
HAVING AVG(RT.OVERALL_RATING) > 1.5;

SELECT * FROM HighlyRatedMexicanRestaurants;

-- 8. First, ensure the HighlyRatedMexicanRestaurants view from Q7 exists. Then, using a CTE to find consumers who prefer 'Mexican' cuisine,
-- list those consumers (Consumer_ID) who have not rated any restaurant listed in the HighlyRatedMexicanRestaurants view.
WITH MEXI_LOVE AS (
    SELECT CONSUMER_ID
    FROM CONSUMER_PREFERENCES
    WHERE PREFERRED_CUISINE = 'Mexican'
)
SELECT ML.CONSUMER_ID
FROM MEXI_LOVE ML
WHERE ML.CONSUMER_ID NOT IN (
    SELECT RT.CONSUMER_ID
    FROM RATINGS RT
    JOIN HighlyRatedMexicanRestaurants HR
      ON RT.RESTAURANT_ID = HR.RESTAURANT_ID
);

-- 9. Create a stored procedure GetRestaurantRatingsAboveThreshold that accepts a Restaurant_ID and a minimum Overall_Rating as input.
-- It should return the Consumer_ID, Overall_Rating, Food_Rating, and Service_Rating for that restaurant where the Overall_Rating meets or exceeds the threshold.
DELIMITER $$
CREATE PROCEDURE GetRestaurantRatingsAboveThreshold (
    IN P_RESTAURANT_ID INT,
    IN P_MINOVERALLRATING DECIMAL(3,1)
)
BEGIN
    SELECT 
        CONSUMER_ID,
        OVERALL_RATING,
        FOOD_RATING,
        SERVICE_RATING
    FROM RATINGS
    WHERE RESTAURANT_ID = P_RESTAURANT_ID
      AND OVERALL_RATING >= P_MINOVERALLRATING;
END $$
DELIMITER ;

CALL GetRestaurantRatingsAboveThreshold('132560', 0);

-- 10. Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type.
-- If there are ties in rating, include all tied restaurants. Display Cuisine, Restaurant_Name, City, and Overall_Rating.
WITH RESTAURANT_AVG AS (
    SELECT RC.CUISINE, R.NAME AS RESTAURANT_NAME, R.CITY, AVG(RT.OVERALL_RATING) AS AVG_RATING
    FROM RESTAURANTS R
    JOIN RATINGS RT ON 
    R.RESTAURANT_ID = RT.RESTAURANT_ID
    JOIN RESTAURANT_CUISINE RC ON
    RC.RESTAURANT_ID = R.RESTAURANT_ID
    GROUP BY RC.CUISINE, R.NAME, R.CITY
),
RANKED AS (
    SELECT CUISINE, RESTAURANT_NAME, CITY, AVG_RATING, DENSE_RANK()
    OVER (
		    PARTITION BY CUISINE 
            ORDER BY AVG_RATING DESC
        ) AS RATINGRANK
    FROM RESTAURANT_AVG
)
SELECT CUISINE, RESTAURANT_NAME, CITY, AVG_RATING AS OVERALL_RATING
FROM RANKED
WHERE RATINGRANK <= 2
ORDER BY CUISINE, AVG_RATING DESC;

-- 11. First, create a VIEW named ConsumerAverageRatings that lists Consumer_ID and their average Overall_Rating. Then, using this view and a CTE, find the top 5 consumers by their average overall rating.
-- For these top 5 consumers, list their Consumer_ID, their average rating, and the number of 'Mexican' restaurants they have rated.
CREATE VIEW CON_AVG_RATINGS AS
SELECT CONSUMER_ID, AVG(OVERALL_RATING) AS AVG_RATING
FROM RATINGS
GROUP BY CONSUMER_ID;
WITH TOP_CONSUMERS AS (
    SELECT CONSUMER_ID, AVG_RATING
    FROM CON_AVG_RATINGS
    ORDER BY AVG_RATING DESC
    LIMIT 5
)
SELECT TC.CONSUMER_ID, TC.AVG_RATING, COUNT(DISTINCT CASE WHEN RC.CUISINE = 'Mexican' THEN R.RESTAURANT_ID END) AS MEXICAN_RESTAURANTS_RATED
FROM TOP_CONSUMERS TC
LEFT JOIN RATINGS RT ON
TC.CONSUMER_ID = RT.CONSUMER_ID
LEFT JOIN RESTAURANTS R ON
RT.RESTAURANT_ID = R.RESTAURANT_ID
JOIN RESTAURANT_CUISINE RC ON
RC.RESTAURANT_ID = R.RESTAURANT_ID
GROUP BY TC.CONSUMER_ID, TC.AVG_RATING
ORDER BY TC.AVG_RATING DESC;

-- 12. Create a stored procedure named GetConsumerSegmentAndRestaurantPerformance that accepts a Consumer_ID as input.
-- The procedure should:
/* 1. Determine the consumer's "Spending Segment" based on their Budget:
'Low' -> 'Budget Conscious'
'Medium' -> 'Moderate Spender'
'High' -> 'Premium Spender'
NULL or other -> 'Unknown Budget' */

/* 2. For all restaurants rated by this consumer:
List the Restaurant_Name.
The Overall_Rating given by this consumer.
The average Overall_Rating this restaurant has received from all consumers (not just the input consumer).
A "Performance_Flag" indicating if the input consumer's rating for that restaurant is 'Above Average', 'At Average', or 'Below Average' compared to the restaurant's overall average rating.
Rank these restaurants for the input consumer based on the Overall_Rating they gave (highest rating = rank 1). */
DELIMITER $$
CREATE PROCEDURE GetConsumerSegmentAndRestaurantPerformance (
    IN P_CONSUMER_ID VARCHAR(20)
)
BEGIN
    SELECT C.CONSUMER_ID,
        CASE C.BUDGET
            WHEN 'Low' THEN 'BUDGET CONSCIOUS'
            WHEN 'Medium' THEN 'MODERATE SPENDER'
            WHEN 'High' THEN 'PREMIUM SPENDER'
            ELSE 'UNKNOWN BUDGET'
        END AS SPENDING_SEGMENT
    FROM CONSUMERS C
    WHERE C.CONSUMER_ID = P_CONSUMER_ID;
    
    SELECT R.NAME AS RESTAURANT_NAME, RT.OVERALL_RATING AS CONSUMER_RATING, AVG(RT2.OVERALL_RATING) AS AVG_RESTAURANT_RATING,
        CASE
            WHEN RT.OVERALL_RATING > AVG(RT2.OVERALL_RATING) THEN 'ABOVE AVERAGE'
            WHEN RT.OVERALL_RATING = AVG(RT2.OVERALL_RATING) THEN 'AT AVERAGE'
            ELSE 'BELOW AVERAGE'
        END AS PERFORMANCE_FLAG,
        RANK() OVER (
            ORDER BY RT.OVERALL_RATING DESC
        ) AS RANK_BY_CONSUMER
    FROM RATINGS RT
    JOIN RESTAURANTS R ON
    RT.RESTAURANT_ID = R.RESTAURANT_ID
    JOIN RATINGS RT2 ON
    RT.RESTAURANT_ID = RT2.RESTAURANT_ID
    WHERE RT.CONSUMER_ID = P_CONSUMER_ID
    GROUP BY RT.RESTAURANT_ID, R.NAME, RT.OVERALL_RATING
    ORDER BY RT.OVERALL_RATING DESC;
END $$
DELIMITER ;

CALL GETCONSUMERSEGMENTANDRESTAURANTPERFORMANCE('U1008');


