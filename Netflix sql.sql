CREATE TABLE netflix (
    show_id VARCHAR(20),
    type VARCHAR(20),
    title VARCHAR(255),
    director TEXT,
    "cast" TEXT,
    country TEXT,
    date_added VARCHAR(50),
    release_year INTEGER,
    rating VARCHAR(20),
    duration VARCHAR(30),
    listed_in TEXT,
    description TEXT
);

SELECT * FROM netflix LIMIT 5;

---checking datatypes 

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'netflix'
ORDER BY ordinal_position;

---checking total rows 
select count(*)as total_rows
from netflix

select count(*) as total_titles 
from netflix

select * from netflix 
---Check Movies vs TV Shows

select type,count(*) as total
from netflix 
group by "type"
order by total desc;

--Checking the missing values

SELECT
    COUNT(*) FILTER (WHERE show_id IS NULL) AS missing_show_id,
    COUNT(*) FILTER (WHERE title IS NULL) AS missing_title,
    COUNT(*) FILTER (WHERE director IS NULL) AS missing_director,
    COUNT(*) FILTER (WHERE "cast" IS NULL) AS missing_cast,
    COUNT(*) FILTER (WHERE country IS NULL) AS missing_country,
    COUNT(*) FILTER (WHERE date_added IS NULL) AS missing_date_added,
    COUNT(*) FILTER (WHERE rating IS NULL) AS missing_rating,
    COUNT(*) FILTER (WHERE duration IS NULL) AS missing_duration
	from netflix;

--Check duplicate titles

SELECT title, COUNT(*) AS occurrences
FROM netflix
GROUP BY title
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

-- checking Percentage the Movies vs TV Shows

SELECT
    type,
    COUNT(*) AS total_titles,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM netflix
GROUP BY type
ORDER BY total_titles DESC;

--Analyzing titles by release year

select release_year,
count(*) AS total_titles
from netflix
group by release_year
order by release_year DESC;

--Finding the top 10 release years

SELECT release_year,count(*) as total_titles
FROM netflix
group by release_year
order by total_titles desc
limit 10;

--Analyzing the Movies vs TV Shows by release year

select release_year,"type",count(*) as total_titles
from netflix
group by release_year,"type"
order by release_year DESC,total_titles DESC;

--Top countries by number of titles

SELECT
    country,
    COUNT(*) AS total_titles
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 15;

--splitting multiple countries into individual countries

SELECT
    TRIM(country_name) AS country,
    COUNT(*) AS total_titles
FROM netflix,
LATERAL STRING_TO_TABLE(country, ',') AS country_name
WHERE country IS NOT NULL
GROUP BY TRIM(country_name)
ORDER BY total_titles DESC
LIMIT 15;

--Analyzing Netflix content ratings

SELECT
    rating,
    COUNT(*) AS total_titles,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM netflix
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY total_titles DESC;

SELECT
    show_id,
    title,
    type,
    rating,
    duration
FROM netflix
WHERE rating IN ('66 min', '84 min', '74 min');

--Fixing the 3 records
UPDATE netflix
SET
    duration = rating,
    rating = NULL
WHERE rating IN ('66 min', '84 min', '74 min');


SELECT
    show_id,
    title,
    rating,
    duration
FROM netflix
WHERE show_id IN ('s5542', 's5795', 's5814');


--Analyze Movie duration
SELECT
    ROUND(AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER)), 2) AS avg_movie_duration_minutes,
    MIN(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER)) AS shortest_movie_minutes,
    MAX(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER)) AS longest_movie_minutes
FROM netflix
WHERE type = 'Movie'
  AND duration IS NOT NULL;
  
--Finding the shortest movie

SELECT
    title,
    duration
FROM netflix
WHERE type = 'Movie'
  AND duration IS NOT NULL
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER)
LIMIT 10;

--Finding the longest movies
SELECT
    title,
    duration
FROM netflix
WHERE type = 'Movie'
  AND duration IS NOT NULL
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) DESC
LIMIT 10;

--Analyzing the TV Show seasons

SELECT
    ROUND(AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER)), 2) AS avg_seasons,
    MIN(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER)) AS min_seasons,
    MAX(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER)) AS max_seasons
FROM netflix
WHERE type = 'TV Show'
  AND duration IS NOT NULL;


--Distribution of TV Shows by number of seasons

SELECT
    CASE
        WHEN CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) = 1 THEN '1 Season'
        WHEN CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) = 2 THEN '2 Seasons'
        WHEN CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) = 3 THEN '3 Seasons'
        WHEN CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) = 4 THEN '4 Seasons'
        ELSE '5+ Seasons'
    END AS season_category,
    COUNT(*) AS total_shows
FROM netflix
WHERE type = 'TV Show'
  AND duration IS NOT NULL
GROUP BY
    CASE
        WHEN CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) = 1 THEN '1 Season'
        WHEN CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) = 2 THEN '2 Seasons'
        WHEN CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) = 3 THEN '3 Seasons'
        WHEN CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) = 4 THEN '4 Seasons'
        ELSE '5+ Seasons'
    END
ORDER BY
    MIN(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER));

--Finding the longest-running TV Shows
SELECT
    title,
    duration
FROM netflix
WHERE type = 'TV Show'
  AND duration IS NOT NULL
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) DESC
LIMIT 15;

--Analyzing the genres/categories
SELECT
    TRIM(category) AS genre,
    COUNT(*) AS total_titles
FROM netflix,
LATERAL STRING_TO_TABLE(listed_in, ',') AS category
GROUP BY TRIM(category)
ORDER BY total_titles DESC
LIMIT 20;


--Comparing genres by Movies vs TV Shows

SELECT
    TRIM(category) AS genre,
    type,
    COUNT(*) AS total_titles
FROM netflix,
LATERAL STRING_TO_TABLE(listed_in, ',') AS category
GROUP BY
    TRIM(category),
    type
ORDER BY
    TRIM(category),
    total_titles DESC;

--Top 10 genres overall

SELECT
    TRIM(category) AS genre,
    COUNT(*) AS total_titles
FROM netflix,
LATERAL STRING_TO_TABLE(listed_in, ',') AS category
GROUP BY TRIM(category)
ORDER BY total_titles DESC
LIMIT 10;

--Top 10 Movie genres

SELECT
    TRIM(category) AS genre,
    COUNT(*) AS total_movies
FROM netflix,
LATERAL STRING_TO_TABLE(listed_in, ',') AS category
WHERE type = 'Movie'
GROUP BY TRIM(category)
ORDER BY total_movies DESC
LIMIT 10;

--Top 10 TV shows genre

SELECT
    TRIM(category) AS genre,
    COUNT(*) AS total_tv_shows
FROM netflix,
LATERAL STRING_TO_TABLE(listed_in, ',') AS category
WHERE type = 'TV Show'
GROUP BY TRIM(category)
ORDER BY total_tv_shows DESC
LIMIT 10;


--Analyzing when Netflix added the titles

SELECT
    date_added,
    COUNT(*) AS total_titles
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY date_added
ORDER BY total_titles DESC
LIMIT 20;

--Analyzing Netflix additions by year
SELECT
    EXTRACT(YEAR FROM TO_DATE(TRIM(date_added), 'Month DD, YYYY'))::INT AS added_year,
    COUNT(*) AS titles_added
FROM netflix
WHERE date_added IS NOT NULL
  AND TRIM(date_added) <> ''
GROUP BY added_year
ORDER BY added_year;


--Netflix additions by month

SELECT
    EXTRACT(MONTH FROM TO_DATE(TRIM(date_added), 'Month DD, YYYY'))::INT AS added_month,
    TO_CHAR(
        TO_DATE(TRIM(date_added), 'Month DD, YYYY'),
        'Month'
    ) AS month_name,
    COUNT(*) AS titles_added
FROM netflix
WHERE date_added IS NOT NULL
  AND TRIM(date_added) <> ''
GROUP BY added_month, month_name
ORDER BY titles_added DESC;


--How has Netflix's content library grown over the years?

SELECT
    release_year,
    COUNT(*) AS total_titles
FROM netflix
GROUP BY release_year
ORDER BY release_year;

--checking Is Netflix increasingly focusing on Movies or TV Shows?

SELECT
    release_year,
    type,
    COUNT(*) AS total_titles
FROM netflix
GROUP BY
    release_year,
    type
ORDER BY
    release_year,
    type;

--What content ratings dominate Movies vs TV Shows?

SELECT
    rating,
    type,
    COUNT(*) AS total_titles
FROM netflix
WHERE rating IS NOT NULL
GROUP BY
    rating,
    type
ORDER BY
    total_titles DESC;

--Top Directors

SELECT
    TRIM(director_name) AS director,
    COUNT(*) AS total_titles
FROM netflix,
LATERAL STRING_TO_TABLE(director, ',') AS director_name
WHERE director IS NOT NULL
  AND TRIM(director) <> ''
GROUP BY TRIM(director_name)
ORDER BY total_titles DESC
LIMIT 20;


--Top Actors / Cast Members

SELECT
    TRIM(actor_name) AS actor,
    COUNT(*) AS total_titles
FROM netflix,
LATERAL STRING_TO_TABLE("cast", ',') AS actor_name
WHERE "cast" IS NOT NULL
  AND TRIM(actor_name) <> ''
GROUP BY TRIM(actor_name)
ORDER BY total_titles DESC
LIMIT 20;

--Which countries contribute the most Movies and TV Shows?

SELECT
    TRIM(country_name) AS country,
    type,
    COUNT(*) AS total_titles
FROM netflix,
LATERAL STRING_TO_TABLE(country, ',') AS country_name
WHERE country IS NOT NULL
  AND TRIM(country_name) <> ''
GROUP BY
    TRIM(country_name),
    type
ORDER BY
    total_titles DESC;

--Country-Level Movie vs TV Share

SELECT
    TRIM(country_name) AS country,
    COUNT(*) FILTER (WHERE type = 'Movie') AS movies,
    COUNT(*) FILTER (WHERE type = 'TV Show') AS tv_shows,
    COUNT(*) AS total_titles,
    ROUND(
        COUNT(*) FILTER (WHERE type = 'Movie') * 100.0 / COUNT(*),
        2
    ) AS movie_percentage,
    ROUND(
        COUNT(*) FILTER (WHERE type = 'TV Show') * 100.0 / COUNT(*),
        2
    ) AS tv_show_percentage
FROM netflix,
LATERAL STRING_TO_TABLE(country, ',') AS country_name
WHERE country IS NOT NULL
  AND TRIM(country_name) <> ''
GROUP BY TRIM(country_name)
HAVING COUNT(*) >= 50
ORDER BY total_titles DESC;

--Genre × Country Analysis

SELECT
    TRIM(country_name) AS country,
    TRIM(category) AS genre,
    COUNT(*) AS total_titles
FROM netflix,
LATERAL STRING_TO_TABLE(country, ',') AS country_name,
LATERAL STRING_TO_TABLE(listed_in, ',') AS category
WHERE country IS NOT NULL
  AND listed_in IS NOT NULL
  AND TRIM(country_name) <> ''
  AND TRIM(category) <> ''
GROUP BY
    TRIM(country_name),
    TRIM(category)
ORDER BY total_titles DESC
LIMIT 30;

--Netflix Content by Year + Genre

SELECT
    release_year,
    TRIM(category) AS genre,
    COUNT(*) AS total_titles
FROM netflix,
LATERAL STRING_TO_TABLE(listed_in, ',') AS category
WHERE listed_in IS NOT NULL
  AND TRIM(category) <> ''
GROUP BY
    release_year,
    TRIM(category)
ORDER BY
    release_year,
    total_titles DESC;

--which genres grew the most from 2015 to 2021.

SELECT
    genre,
    SUM(CASE WHEN release_year = 2015 THEN total_titles ELSE 0 END) AS titles_2015,
    SUM(CASE WHEN release_year = 2021 THEN total_titles ELSE 0 END) AS titles_2021,
    SUM(CASE WHEN release_year = 2021 THEN total_titles ELSE 0 END)
      - SUM(CASE WHEN release_year = 2015 THEN total_titles ELSE 0 END) AS growth
FROM (
    SELECT
        release_year,
        TRIM(category) AS genre,
        COUNT(*) AS total_titles
    FROM netflix,
    LATERAL STRING_TO_TABLE(listed_in, ',') AS category
    WHERE listed_in IS NOT NULL
      AND TRIM(category) <> ''
    GROUP BY release_year, TRIM(category)
) AS genre_year
GROUP BY genre
HAVING
    SUM(CASE WHEN release_year = 2015 THEN total_titles ELSE 0 END) > 0
    AND SUM(CASE WHEN release_year = 2021 THEN total_titles ELSE 0 END) > 0
ORDER BY growth DESC;


--Find the fastest-growing genres by percentage

SELECT
    genre,
    titles_2015,
    titles_2021,
    growth,
    ROUND(
        growth * 100.0 / NULLIF(titles_2015, 0),
        2
    ) AS growth_percentage
FROM (
    SELECT
        genre,
        SUM(CASE WHEN release_year = 2015 THEN total_titles ELSE 0 END) AS titles_2015,
        SUM(CASE WHEN release_year = 2021 THEN total_titles ELSE 0 END) AS titles_2021,
        SUM(CASE WHEN release_year = 2021 THEN total_titles ELSE 0 END)
          - SUM(CASE WHEN release_year = 2015 THEN total_titles ELSE 0 END) AS growth
    FROM (
        SELECT
            release_year,
            TRIM(category) AS genre,
            COUNT(*) AS total_titles
        FROM netflix,
        LATERAL STRING_TO_TABLE(listed_in, ',') AS category
        WHERE listed_in IS NOT NULL
          AND TRIM(category) <> ''
        GROUP BY release_year, TRIM(category)
    ) AS genre_year
    GROUP BY genre
    HAVING
        SUM(CASE WHEN release_year = 2015 THEN total_titles ELSE 0 END) > 0
        AND SUM(CASE WHEN release_year = 2021 THEN total_titles ELSE 0 END) > 0
) AS growth_data
ORDER BY growth_percentage DESC;


--Netflix content by year and type

SELECT
    release_year,
    COUNT(*) FILTER (WHERE type = 'Movie') AS movies,
    COUNT(*) FILTER (WHERE type = 'TV Show') AS tv_shows,
    COUNT(*) AS total_titles,
    ROUND(
        COUNT(*) FILTER (WHERE type = 'Movie') * 100.0 / COUNT(*),
        2
    ) AS movie_percentage,
    ROUND(
        COUNT(*) FILTER (WHERE type = 'TV Show') * 100.0 / COUNT(*),
        2
    ) AS tv_show_percentage
FROM netflix
GROUP BY release_year
ORDER BY release_year;

--Movie and TV Show catalogs changed each year.

WITH yearly_content AS (
    SELECT
        release_year,
        COUNT(*) FILTER (WHERE type = 'Movie') AS movies,
        COUNT(*) FILTER (WHERE type = 'TV Show') AS tv_shows
    FROM netflix
    GROUP BY release_year
)
SELECT
    release_year,
    movies,
    tv_shows,
    
    LAG(movies) OVER (ORDER BY release_year) AS previous_year_movies,
    LAG(tv_shows) OVER (ORDER BY release_year) AS previous_year_tv_shows,

    ROUND(
        (movies - LAG(movies) OVER (ORDER BY release_year)) * 100.0
        / NULLIF(LAG(movies) OVER (ORDER BY release_year), 0),
        2
    ) AS movie_yoy_growth,

    ROUND(
        (tv_shows - LAG(tv_shows) OVER (ORDER BY release_year)) * 100.0
        / NULLIF(LAG(tv_shows) OVER (ORDER BY release_year), 0),
        2
    ) AS tv_show_yoy_growth

FROM yearly_content
ORDER BY release_year;