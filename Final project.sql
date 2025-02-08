CREATE DATABASE golf;
USE golf;

-- Player Table
CREATE TABLE Players (
    player_id INT PRIMARY KEY,
    player_name VARCHAR(100)
);

-- Tournaments Table
CREATE TABLE Tournaments (
    tournament_id INT PRIMARY KEY,
    season INT,
    purse DECIMAL(10,2),
    no_cut BOOLEAN
);

-- Tournament Participation Table (Bridge Table)
CREATE TABLE TournamentParticipation (
    tournament_id INT,
    player_id INT,
    Finish VARCHAR(10),
    sg_putt DECIMAL(5,2),
    sg_arg DECIMAL(5,2),
    sg_app DECIMAL(5,2),
    sg_ott DECIMAL(5,2),
    sg_t2g DECIMAL(5,2),
    sg_total DECIMAL(5,2),
    PRIMARY KEY (tournament_id, player_id),
    FOREIGN KEY (tournament_id) REFERENCES Tournaments(tournament_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);

-- Performance Statistics Table
CREATE TABLE PerformanceStats (
    tournament_id INT,
    player_id INT,
    hole_par INT,
    strokes INT,
    hole_DKP DECIMAL(5,2),
    hole_FDP DECIMAL(5,2),
    hole_SDP DECIMAL(5,2),
    streak_DKP DECIMAL(5,2),
    streak_FDP DECIMAL(5,2),
    PRIMARY KEY (tournament_id, player_id),
    FOREIGN KEY (tournament_id) REFERENCES Tournaments(tournament_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);

-- Financials Table
CREATE TABLE Financials (
    tournament_id INT,
    player_id INT,
    purse DECIMAL(10,2),
    season INT,
    PRIMARY KEY (tournament_id, player_id),
    FOREIGN KEY (tournament_id) REFERENCES Tournaments(tournament_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);

-- Query 1: Identify players with the highest total strokes gained across all tournaments.(Top Players by Total Strokes Gained)
SELECT p.player_id, p.player_name, SUM(tp.sg_total) AS total_strokes_gained
FROM Players p
JOIN TournamentParticipation tp ON p.player_id = tp.player_id
GROUP BY p.player_id, p.player_name
ORDER BY total_strokes_gained DESC
LIMIT 10;

-- Query 2: Analyze the average performance of players in each tournament.(Average Strokes Gained by Tournament)
SELECT t.tournament_id, t.season, AVG(tp.sg_total) AS avg_strokes_gained
FROM Tournaments t
JOIN TournamentParticipation tp ON t.tournament_id = tp.tournament_id
GROUP BY t.tournament_id, t.season
ORDER BY avg_strokes_gained DESC;

-- Query 3: Identify the best-performing player in each tournament
SELECT tp.tournament_id, p.player_name, tp.sg_total
FROM TournamentParticipation tp
JOIN Players p ON tp.player_id = p.player_id
WHERE (tp.tournament_id, tp.sg_total) IN (
    SELECT tournament_id, MAX(sg_total)
    FROM TournamentParticipation
    GROUP BY tournament_id
)
ORDER BY tp.tournament_id;

-- Query 4: Analyze player activity across tournaments. (Number of Tournaments Each Player Participated In)
SELECT p.player_id, p.player_name, COUNT(tp.tournament_id) AS total_tournaments
FROM Players p
JOIN TournamentParticipation tp ON p.player_id = tp.player_id
GROUP BY p.player_id, p.player_name
ORDER BY total_tournaments DESC;

-- Query 5: Determine players with the best average finish positions. (Average Finish Position by Player)
SELECT tp.player_id, p.player_name, AVG(CAST(tp.Finish AS UNSIGNED)) AS avg_finish
FROM TournamentParticipation tp
JOIN Players p ON tp.player_id = p.player_id
WHERE tp.Finish REGEXP '^[0-9]+$' -- Ensuring numerical finishes only
GROUP BY tp.player_id, p.player_name
ORDER BY avg_finish ASC
LIMIT 10;

-- Query 6: Identify tournaments with the highest purses and player participation. (Highest Purse Tournaments)
SELECT t.tournament_id, t.season, t.purse, COUNT(tp.player_id) AS num_players
FROM Tournaments t
JOIN TournamentParticipation tp ON t.tournament_id = tp.tournament_id
GROUP BY t.tournament_id, t.season, t.purse
ORDER BY t.purse DESC, num_players DESC
LIMIT 10;

-- Query 7: Identify players with the most consistent strokes gained across tournaments. (Players with the Most Consistent Strokes Gained)
SELECT tp.player_id, p.player_name, STDDEV(tp.sg_total) AS consistency
FROM TournamentParticipation tp
JOIN Players p ON tp.player_id = p.player_id
GROUP BY tp.player_id, p.player_name
ORDER BY consistency ASC
LIMIT 10;

SELECT tp.player_id, p.player_name, STDDEV(tp.sg_total) AS consistency
FROM TournamentParticipation tp
JOIN Players p ON tp.player_id = p.player_id
GROUP BY tp.player_id, p.player_name
ORDER BY consistency ASC
LIMIT 10;  -- Fetches the 10 most consistent players

-- Query 8: Estimate player earnings based on tournament purses and participation. (Total Earnings by Player)
SELECT f.player_id, p.player_name, SUM(f.purse) AS total_earnings
FROM Financials f
JOIN Players p ON f.player_id = p.player_id
GROUP BY f.player_id, p.player_name
ORDER BY total_earnings DESC
LIMIT 10;

-- Query 9: Rank players based on strokes gained in each tournament. (Ranking Players Using Window Functions)
SELECT tp.tournament_id, tp.player_id, p.player_name, tp.sg_total,
       RANK() OVER (PARTITION BY tp.tournament_id ORDER BY tp.sg_total DESC) AS rank_position
FROM TournamentParticipation tp
JOIN Players p ON tp.player_id = p.player_id
ORDER BY tp.tournament_id, rank_position;

-- Query 10: Determine each player’s best-performing season. (Best season for each player)
WITH PlayerSeasonPerformance AS (
    SELECT f.player_id, p.player_name, f.season, SUM(tp.sg_total) AS total_strokes_gained
    FROM Financials f
    JOIN TournamentParticipation tp ON f.tournament_id = tp.tournament_id AND f.player_id = tp.player_id
    JOIN Players p ON f.player_id = p.player_id
    GROUP BY f.player_id, p.player_name, f.season
),
RankedSeasons AS (
    SELECT player_id, player_name, season, total_strokes_gained,
           RANK() OVER (PARTITION BY player_id ORDER BY total_strokes_gained DESC) AS season_rank
    FROM PlayerSeasonPerformance
)
SELECT player_id, player_name, season, total_strokes_gained
FROM RankedSeasons
WHERE season_rank = 1
ORDER BY player_id, season;




