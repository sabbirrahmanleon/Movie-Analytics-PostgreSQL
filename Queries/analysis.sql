-- Top 5 highest rated movies
select
	*
from 
	movies
order by
	imdb_rating desc
limit 5;

--------------------------------------

-- Count of movies released by Year
select 
	release_year, 
	count(movie_id) number_of_movies
from 
	movies
group by
	1;
-- Sort by number of movies 
select 
	release_year,
	count(movie_id) number_of_movies
from
	movies
group by
	1
order by
	2 desc;

--------------------------------------

-- Movies by Marvel Studios in the order of their release
select 
	title,
	release_year
from
	movies
where
	studio = 'Marvel Studios';

--------------------------------------

-- Movies that include the word "Avenger"
select
	*
from 
	movies
where
	title like '%Avenger%';

--------------------------------------

-- Release year of any specific movie (i.e. 3 Idiots)
select 
	title,
	release_year
from 
	movies
where 
	title = '3 Idiots';

--------------------------------------

-- List of movie studios in the Bollywood industry
select
	distinct studio
from
	movies
where
	industry = 'Bollywood';

--------------------------------------

-- Movies by release year (latest first)
select
	release_year,
	title
from
	movies
order by
	release_year desc;

--------------------------------------

-- Movies released in 2022
select
	release_year,
	title
from
	movies
where
	release_year = 2022;

--------------------------------------

-- Movies released after 2020
select
	release_year,
	title
from
	movies
where
	release_year > 2020;

--------------------------------------

-- Movies after the year 2020 having more than 8 rating
select
	release_year,
	title,
	imdb_rating
from
	movies
where
	release_year > 2020
	and imdb_rating > 8;

--------------------------------------

-- Movies by Yash Raj Films and Hombale Films
select
	*
from
	movies
where
	studio in ('Yash Raj Films', 'Hombale Films');

--------------------------------------

-- All Thor movies by their release year
select
	release_year,
	title
from
	movies
where
	lower(title) like '%thor%'
order by
	release_year desc;

--------------------------------------

-- Movies that are not from Warner Bros. Pictures and Marvel Studios
select
	*
from
	movies
where
	studio not in ('Warner Bros. Pictures', 'Marvel Studios');

--------------------------------------

-- Number of movies released between 2015 and 2022
select
	count(*)
from
	movies
where
	release_year between 2015 and 2022;

--------------------------------------

-- Profit % of all movies
select
	m.title,
	f.budget,
	f.revenue,
	(f.revenue - f.budget) as profit,
	f.unit,
	f.currency,
	(((f.revenue - f.budget) / f.budget) * 100) as profit_percentage
from
	financials f
join movies m on
	m.movie_id = f.movie_id;

--------------------------------------

-- Movies with their language names
select
	m.title,
	l.name
from
	movies m
left join languages l
on
	m.language_id = l.language_id;

--------------------------------------

-- Hindi movie names (Assuming that the language id for Hindi is unknown)
select
	m.title,
	l.name
from
	movies m
left join languages l
on
	m.language_id = l.language_id
where
	l.name = 'Hindi';

--------------------------------------

-- Number of movies released in each language
select
	l.name,
	count(m.title) as total_movies
from
	movies m
inner join languages l
on
	m.language_id = l.language_id
group by
	1
order by
	2 desc;

--------------------------------------

-- Hindi movies sorted by their revenue (when revenue is less than a billion, show in millions)
select
	m.title,
	f.revenue,
	f.currency,
	f.unit,
	case
		when unit = 'Thousands' then round(revenue / 1000, 2)
		when unit = 'Billions' then round(revenue * 1000, 2)
		else revenue
	end as revenue_mln
from
	movies m
inner join financials f
on
	m.movie_id = f.movie_id
inner join languages l
on
	m.language_id = l.language_id
where
	l.name = 'Hindi'
order by
	revenue_mln desc;

--------------------------------------

-- Oldest and newest movies
select
	title,
	release_year
from
	movies
where
	release_year in (
(
	select
		max(release_year)
	from
		movies),
	(
	select
		min(release_year)
	from
		movies)
)
order by
	release_year desc;

--------------------------------------

-- Movies with an above average imdb rating
select
	*
from
	movies
where
	imdb_rating > (
	select
		avg(imdb_rating)
	from
		movies)
order by
	imdb_rating desc;

--------------------------------------

-- Hollywood movies released after the year 2000 making more than 500 million in profit
with x as (
select
	*
from
	movies
where
	industry = 'Hollywood'),
y as (
select
	*,
	(revenue-budget) as profit
from
	financials
where
	(revenue-budget) > 500 )
select
	x.movie_id,
	x.title,
	x.release_year,
	y.profit
from
	x
join y
on
	x.movie_id = y.movie_id
where
	release_year > 2000;

--------------------------------------

-- Language-wise Total Revenue
select
	l.name as language,
	COUNT(m.movie_id) as total_movies,
	SUM(f.revenue) as total_revenue,
	AVG(f.revenue) as avg_revenue
from
	movies m
join financials f on
	m.movie_id = f.movie_id
join languages l on
	m.language_id = l.language_id
group by
	l.name
order by
	total_revenue desc;

--------------------------------------

-- Number of Movies per Actor
select
	a.name as actor_name,
	COUNT(ma.movie_id) as total_movies
from
	actors a
join movie_actor ma on
	a.actor_id = ma.actor_id
group by
	a.actor_id,
	a.name
order by
	total_movies desc;

--------------------------------------

-- Highest rated Actors
with actor_movie_count as (
select
	ma.actor_id,
	COUNT(ma.movie_id) as total_movies
from
	movie_actor ma
group by
	ma.actor_id
),
top_actors as (
select
	amc.actor_id
from
	actor_movie_count amc
order by
	total_movies desc
limit 10
)
select
	a.name,
	COUNT(m.movie_id) as total_movies,
	AVG(m.imdb_rating) as avg_rating
from
	movie_actor ma
join top_actors ta on
	ma.actor_id = ta.actor_id
join movies m on
	ma.movie_id = m.movie_id
join actors a on
	a.actor_id = ta.actor_id
group by
	a.name
order by
	avg_rating desc;

--------------------------------------

--- ROI by Studio with High IMDB Ratings
select
	m.studio,
	COUNT(m.movie_id) as total_movies,
	AVG(m.imdb_rating) as avg_rating,
	AVG((f.revenue - f.budget) * 1.0 / f.budget) as avg_roi
from
	movies m
join financials f on
	m.movie_id = f.movie_id
where
	m.imdb_rating > 7.0
group by
	m.studio
order by
	avg_roi desc
limit 10;

--------------------------------------

-- Year-wise Trend of Movie Production
select
	release_year,
	COUNT(movie_id) as total_movies
from
	movies
group by
	release_year
order by
	release_year;
