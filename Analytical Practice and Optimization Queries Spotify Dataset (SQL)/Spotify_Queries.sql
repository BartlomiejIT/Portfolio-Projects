-- SQL Project - Spotify Dataset

-- create table
drop table if exists spotify;
create table spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(100),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);


select * from spotify;

-- EDA
select count(*) from spotify;

--
select count(distinct artist) from spotify;
select count(distinct album) from spotify;
select distinct album_type from spotify;

--
select max(duration_min) from spotify;
select min(duration_min) from spotify;

--
select * from spotify where duration_min = 0;

delete from spotify where duration_min = 0;  

--
select distinct channel from spotify;

select distinct most_played_on from spotify;

-- ----------------------------
-- Data Analysis -Easy Category
-- ----------------------------

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.

-- 2. List all albums along with their respective artists.

-- 3. Get the total number of comments for tracks where licensed = TRUE.

-- 4. Find all tracks that belong to the album type single.

-- 5. Count the total number of tracks by each artist.

----------------------
-- Answers by Queries:
----------------------

-- 1. Names of all tracks that have more than 1 billion streams.

select track, stream from spotify where stream > 1000000000;

-- 2. List all albums along with their respective artists.

select
distinct
	album,
	artist
from
	spotify
order by album;

-- 3. Total number of comments for tracks where licensed = TRUE.

select 
	sum(comments)
from 
	spotify
where
	licensed = true;

-- 4. All tracks that belong to the album type single.

select
	track, album_type 
from
	spotify
where
	album_type ILIKE 'single';

-- 5. Total number of tracks by each artist.

SELECT 
    artist,
    COUNT(track) AS total_no_songs
FROM
    spotify
GROUP BY
    artist
ORDER BY
    total_no_songs;

------------
-- NEXT PART
------------

-- 6. Calculate the average danceability of tracks in each album.

-- 7. Find the top 5 tracks with the highest energy values.

-- 8. List all tracks along with their views and likes where official_video = TRUE.

-- 9. For each album, calculate the total views of all associated tracks.

-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.

----------------------
-- Answers by Queries:
----------------------

-- 6. Average danceability of tracks in each album

select 
	album,
    avg(danceability) as avg_danceability
from 
    spotify
group by 
   album,
   avg_danceability
order by
	avg_danceability desc;

-- 7. Find the top 5 tracks with the highest energy values.

select * from spotify;

select
	track,
	max(energy) as energy_level
from
	spotify
group by
	track
order by
	energy_level desc
limit 5;

-- 8. All tracks along with their views and likes where official_video = TRUE.

select * from spotify;

select 
	track,
	sum(views) as total_views, 
	sum(likes) as total_likes
from
	spotify
where
	official_video = True
group by
	track
order by
	total_views desc, total_likes desc
limit;

-- 9. The total views of all associated tracks for each album.

select
	album,
	track,
	sum(views) as total_views
from
	spotify
group by
	album, track
order by
	total_views desc;
	
-- 10. Track names that have been streamed on Spotify more than YouTube.

select * from spotify;

SELECT * FROM (
	SELECT
		track,
		-- most_played_on,
		COALESCE (SUM (CASE WHEN most_played_on = 'Youtube' THEN stream END) , 0) as streamed_on_youtube,
		COALESCE (SUM (CASE WHEN most_played_on = 'Spotify' THEN stream END) , 0) as streamed_on_spotify
	FROM
		spotify
	GROUP BY 
		track)
as t1
WHERE
	streamed_on_spotify > streamed_on_youtube and streamed_on_youtube <> 0;

-- 11. What are the top 3 most-viewed tracks for each artist using window functions.

-- 12. Tracks where the liveness score is above the average.

-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each :

-- 14. Tracks where the energy-to-liveness ratio is greater than 1.2.

-- 15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

----------------------
-- Answers by Queries:
----------------------

-- 11. Top 3 most-viewed tracks for each artist.

with ranking_artist as
(select
	artist,
	track,
	sum(views),
	dense_rank() over (partition by artist order by sum(views) desc) as rank
from spotify
group by
	artist, track
order by
	artist, sum(views) desc)
select 
	* 
from
	ranking_artist
where rank <= 3;

-- 12. Tracks where the livenness score is above the average

select 
	track,
	liveness
from
	spotify
where
	liveness > (select avg(liveness) from spotify)
order by
	liveness desc;

-- 13. Difference between the highest and lowest energy values for tracks in each album

with cte as (
	select
		album,
		(max(energy)) as highest_energy, 
		(min(energy)) as lowest_energy
	from 
		spotify
	group by
		album
)
select 
	album,
	highest_energy - lowest_energy as energy_diff
from cte
order by
	energy_diff desc;

-- 14.
select 
    track,
    energy,
    liveness,
    (energy / liveness) as energy_to_liveness_ratio
from 
    spotify
where 
    (energy / liveness) > 1.2
order by 
    energy_to_liveness_ratio desc;

-- 15. Calculate the cumulative sum of likes for tracks ordered by the number of views by using window functions.

with cte as (
    select 
        track,
        sum(views) as total_views,
        sum(likes) as total_likes
    from 
        spotify
    group by 
        track
)
select 
    track,
    total_views,
    total_likes,
    sum(total_likes) over (order by total_views desc) as cumulative_likes
from 
    cte
order by 
    total_views desc;

-- Query Optimization

explain analyze 
select
	artist,
	track,
	views
from
	spotify
where
	artist = 'Gorillaz' and most_played_on = 'Youtube'
order by
	stream desc
limit 25;

create index artist_index on spotify (artist);

drop index artist_index;










