# general song information
-- 1. What are the top 5 most streamed songs in 2023?
SELECT   track_name,
         streams
FROM     spotify
WHERE    released_year = 2023
ORDER BY streams DESC limit 5;

-- 2. How many unique artists contributed to the dataset?
SELECT Count(DISTINCT artist_name) AS Unique_artist_count
FROM   spotify;

-- 3. What is the distribution of songs across different release years?
SELECT
         CASE
                  WHEN released_year BETWEEN 1930 AND      1939 THEN '1930-1939'
                  WHEN released_year BETWEEN 1940 AND      1949 THEN '1940-1949'
                  WHEN released_year BETWEEN 1950 AND      1959 THEN '1950-1959'
                  WHEN released_year BETWEEN 1960 AND      1969 THEN '1960-1969'
                  WHEN released_year BETWEEN 1970 AND      1979 THEN '1970-1979'
                  WHEN released_year BETWEEN 1980 AND      1989 THEN '1980-1989'
                  WHEN released_year BETWEEN 1990 AND      1999 THEN '1990-1999'
                  WHEN released_year BETWEEN 2000 AND      2009 THEN '2000-2009'
                  WHEN released_year BETWEEN 2010 AND      2019 THEN '2010-2019'
                  WHEN released_year BETWEEN 2020 AND      2029 THEN '2020-2029'
                  ELSE 'Other'
         END      AS year_range,
         Count(track_name) AS count_songs
FROM     spotify
GROUP BY 1
ORDER BY 1;

-- 4.Who are the top 10 artists based on popularity, and what are their tracks' average danceability and energy?
SELECT   artist_name,
         track_name,
         Sum(streams)         AS streams,
         Avg(`danceability`) AS avg_danceability,
         Avg(`energy`)       AS avg_energy
FROM     spotify
GROUP BY artist_name,
         track_name
ORDER BY Sum(streams) DESC limit 10;

-- 5. Number of songs released by each artist in 2023:
SELECT   artist_name,
         Count(track_name) AS songs_released
FROM     spotify
WHERE    released_year = 2023
GROUP BY artist_name
ORDER BY songs_released DESC;

# spotify metrics
-- 1.Which song is present in the highest number of Spotify playlists?
SELECT   track_name,
         artist_name
FROM     spotify
GROUP BY track_name,
         artist_name
HAVING   Max(in_spotify_playlists) limit 1;

-- 3. What is the average BPM (Beats Per Minute) of songs on Spotify?
SELECT Avg(bpm) AS Avg_beats_per_minute
FROM   spotify;

-- 4. What is the average bpm of the top 15 most popular songs?
SELECT Avg(bpm) AS top15_avg_bpm
FROM   (
		SELECT  track_name,
				streams,
				bpm
		FROM     spotify
		ORDER BY streams DESC limit 15 ) AS top_15_songs;

-- 5. What is the average danceability of the top 15 most popular songs?
SELECT Avg(danceability) AS top15_avg_danceability
FROM   (
		SELECT  track_name,
				streams,
				danceability
		FROM    spotify
		ORDER BY streams DESC limit 15 ) AS top_15_songs;
        
        # `apple music metrics`:
-- 1. How many songs made it to both Apple Music charts and Spotify charts?
SELECT Sum(
       CASE
			WHEN track_name IN (in_spotify_charts, in_apple_charts) THEN 1
			ELSE 0
       END) AS common_songs_count
FROM   spotify;

-- 2. List down the name of those song which appreared in both charts
SELECT track_name
FROM   spotify
WHERE  track_name IN(in_spotify_charts,
                     in_apple_charts);

-- 3. Which song is present in the highest number of apple playlists?`
SELECT   track_name
FROM     spotify
GROUP BY track_name
HAVING   Max(in_apple_playlists) limit 1;

-- 4. Average energy level of songs on Apple Music playlists:
SELECT Avg(energy) AS avg_energy
FROM   spotify
WHERE  in_apple_playlists > 0;

# `deezer metrics`:
-- 1. Are there any trends in the presence of songs on Deezer charts based on the release month?
SELECT   released_month,
         Count(track_name) AS songs_count
FROM     spotify
WHERE    in_deezer_charts IS NOT NULL
GROUP BY released_month
ORDER BY released_month ASC;

-- 2. How many songs are common between Deezer and Spotify playlists?
SELECT track_name
FROM   spotify
WHERE  track_name IN(in_deezer_charts , in_spotify_charts);

-- 3. Which song is present in the highest number of deezer playlists?`
SELECT   track_name
FROM     spotify
GROUP BY track_name
HAVING   Max(in_deezer_playlists) limit 1;

-- 4. Top 15 songs on Deezer based on danceability and energy
SELECT   track_name,
         Avg(danceability) AS avg_danceability,
         Avg(energy)       AS avg_energy
FROM     spotify
WHERE    in_deezer_playlists > 0
GROUP BY track_name
ORDER BY avg_danceability DESC,
         avg_energy DESC limit 15;
         
         ### `shazam metrics`:
-- 1. What is the distribution of speechiness percentages for songs on Shazam charts?
SELECT   Concat(Floor(speechiness / 5) * 5, '-', Floor(speechiness / 5) * 5 + 5) AS speechiness_distribution,
         Count(*)  AS songs_count
FROM     spotify
WHERE    in_shazam_charts IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- 2. Relationship between song energy and Shazam rank:
SELECT in_shazam_charts,
       energy
FROM   spotify
WHERE  in_shazam_charts > 0;

### `audio features`:
-- 1. Is there a noticeable difference in danceability percentages between songs in major and minor modes?
SELECT DISTINCT `mode`, Avg(danceability)
FROM    spotify
GROUP BY `mode`;

-- 2. Are there any trends in the energy levels of songs over the years?
SELECT   Concat(Floor(released_year / 10) * 10 , '-', Floor(released_year / 10) * 10 + 10) AS decade_range,
         Round(Avg(energy),2) AS avg_energy
FROM spotify
GROUP BY 1
ORDER BY 1;

-- 3. What are the most common song keys for the entire dataset?
SELECT   `KEY`, count(*) AS songs_count
FROM spotify
GROUP BY 1
ORDER BY 2 DESC limit 5;

-- 4.How does the distribution of acousticness percentages vary across different keys?
SELECT DISTINCT `KEY`, avg(acousticeness) AS avg_acousticness
FROM  spotify
GROUP BY `KEY`
ORDER BY   1;

-- 5. Mode (major or minor) in high-danceability songs:
SELECT   mode,
         Avg(danceability) AS avg_danceability
FROM     spotify
GROUP BY mode
ORDER BY avg_danceability DESC;

### `artist impact`:
-- 1. What is the average number of artists contributing to a song that makes it to the charts?
SELECT Avg(artist_count)
FROM   spotify
WHERE  track_name IN(in_spotify_charts,  in_apple_charts, in_deezer_charts,  in_shazam_charts);

-- 2.Do songs with a higher number of artists tend to have higher or lower danceability percentages?
SELECT  artist_count, Avg(danceability) AS avg_daceability
FROM     spotify
GROUP BY 1
ORDER BY 1 DESC;

-- ### `Temporal Trends`:
-- 1.How has the distribution of song valence percentages changed over the months in 2023?
SELECT   released_month , Avg(valence) AS avg_valence
FROM  spotify
GROUP BY 1
ORDER BY 1;

-- 2. Are there any noticeable trends in the key of songs over the years?
SELECT   Concat( Floor(released_year / 5) * 5, '-', (Floor(released_year / 5) * 5) + 4 ) AS year_range,
         `KEY`,  count(*) AS key_count
FROM     spotify
GROUP BY year_range,
         `KEY`
ORDER BY year_range ASC,
         key_count DESC;
         
         ## CROSS-platform presence
-- 1. Songs consistently ranking high across all platforms:
SELECT   track_name, (
         CASE
		      WHEN in_spotify_charts IS NOT NULL THEN 1
			  ELSE 0
         END +
         CASE
			WHEN in_apple_charts IS NOT NULL THEN 1
			ELSE 0
         END +
         CASE
			WHEN in_deezer_charts IS NOT NULL THEN 1
			ELSE 0
         END +
         CASE
			WHEN in_shazam_charts IS NOT NULL THEN 1
			ELSE 0
         END) AS platform_presence_count
FROM     spotify
HAVING   platform_presence_count = 4
ORDER BY platform_presence_count DESC;

-- 2. Identify songs with the highest combined playlist presence across Spotify, Apple Music, and Deezer:
SELECT   track_name,
         COALESCE(in_spotify_playlists, 0) + COALESCE(in_apple_playlists, 0) + COALESCE(in_deezer_playlists, 0) AS total_playlist_presence
FROM  spotify
ORDER BY total_playlist_presence DESC limit 10;

### `miscellaneous`:
-- 1. What is the distribution of key and mode combinations across the dataset?
SELECT   Concat(`KEY` , '-', `mode`) AS key_mode_Combination,
         Count(*)   AS total_count
FROM  spotify
GROUP BY 1
ORDER BY 2 DESC;

--  2. Compare the most popular song keys with song keys most represented in the top 50 tracks of 2023.
WITH all_keys AS
(
         SELECT   `KEY`,
                  count(*) AS key_count
         FROM     spotify
         GROUP BY `KEY` ), top_50_keys AS
(
         SELECT   `KEY`,
                  count(*) AS top_50_key_count
         FROM     spotify
         WHERE    released_year = 2023
         AND      in_spotify_charts <= 50
         GROUP BY `KEY` )
SELECT    a.KEY,  a.key_count  AS overall_count,
          t.top_50_key_count  AS top_50_count
FROM      all_keys a
LEFT JOIN top_50_keys t
  ON      a.KEY = t.KEY
ORDER BY  overall_count DESC,
          top_50_count DESC;

-- 3. Are there any patterns in the release days of songs that make it to the charts?
SELECT   released_day,
         Count(*) AS songs_count
FROM     spotify
WHERE  in_spotify_charts = 1
OR     in_apple_charts = 1
OR     in_deezer_charts = 1
OR     in_shazam_charts = 1
GROUP BY released_day
ORDER BY released_day;

-- 4.Create a table with the popularity rankings for each song key.
SELECT   `KEY`,  count(*)  AS key_count,
		  rank() OVER (ORDER BY count(*) DESC) AS popularity_rank
FROM     spotify
GROUP BY `KEY`
ORDER BY popularity_rank;