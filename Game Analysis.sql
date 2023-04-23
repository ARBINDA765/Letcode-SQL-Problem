--Date 22-04-2023
--LetCode SQL Intreview Series

--Que-1--Write an SQL query to report the first login date for each player.

--Que-2--Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out 
--on some day using some device.Write a SQL query that reports the device that is first logged in for each player

--Que-3--Write an SQL query that reports for each player and date, how many games played so far by the player. 
--That is, the total number of games played by the player until that date. Check the example for clarity.

--Write an SQL query that reports the fraction of players that logged in again on the day after the day they first logged in,
--rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days
--starting from their first login date, then divide that number by the total number of players.

-------------------NOTES-----------------------

--RANGE UNBOUNDED PRECEDING AND CURRENT ROW for window frame 
--rowsBetween: - With rowsBetween you define a boundary frame of rows to calculate, which frame is calculated independently.
--ROWS BETWEEN lower_bound AND upper_bound

--The bounds can be any of these five options:

--UNBOUNDED PRECEDING – All rows before the current row.
--n PRECEDING – n rows before the current row.
--CURRENT ROW – Just the current row.
--n FOLLOWING – n rows after the current row.
--UNBOUNDED FOLLOWING – All rows after the current row.

----------------END OF NOTES-------------------------------
USE SSIS

Create table  Activity (player_id INT, device_id INT, event_date date, games_played INT)
--DROP table Activity
insert into Activity (player_id, device_id, event_date, games_played) values (1, 2, '2016-03-01', 5)
insert into Activity (player_id, device_id, event_date, games_played) values (1, 2, '2016-03-02', 6)
insert into Activity (player_id, device_id, event_date, games_played) values (1, 3, '2016-03-03', 5)
insert into Activity (player_id, device_id, event_date, games_played) values (2, 3, '2017-06-25', 1)
insert into Activity (player_id, device_id, event_date, games_played) values (2, 4, '2017-09-25', 4)
insert into Activity (player_id, device_id, event_date, games_played) values (3, 1, '2016-03-02', 0)
insert into Activity (player_id, device_id, event_date, games_played) values (3, 4, '2018-07-03', 5)

SELECT * FROM Activity
------------------------------SOLUTION START-------------------------------------

--QUE-1:
SELECT DISTINCT player_id,MIN(event_date) OVER(PARTITION BY player_id ) 'First_Login' FROM Activity

--Que -2:
WITH First_Login_T as 
(
SELECT DISTINCT player_id,MIN(event_date) OVER(PARTITION BY player_id ) 'First_Login' FROM Activity
)

SELECT FL.player_id,FL.First_Login,A.device_id  FROM First_Login_T FL
INNER JOIN  Activity A ON A.player_id = FL.player_id AND 
FL.First_Login=A.event_date

--Que-3:

SELECT player_id,games_played,event_date,SUM(games_played) OVER (PARTITION BY player_id ORDER BY event_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 'games_played_so_far'
FROM Activity

--QUE-4:
--First_login_date of each player
WITH First_Login_T as 
(
SELECT DISTINCT player_id,MIN(event_date) OVER(PARTITION BY player_id ) 'First_Login' FROM Activity
)
--Players whose event_date is least two consecutive days starting from their first login date
,
Consucutive_Players as
(
SELECT a.player_id FROM First_Login_T
INNER JOIN Activity a ON a.player_id=First_Login_T.player_id AND
DATEDIFF(DAY,First_Login_T.First_Login,a.event_date)=1
)

SELECT CAST (

(
SELECT CAST ( COUNT (DISTINCT player_id ) AS FLOAT) FROM Consucutive_Players--1
)

/

(
SELECT CAST ( COUNT (DISTINCT player_id ) AS FLOAT) FROM Activity--3
) AS DECIMAL (10,2)) AS Finaloutput