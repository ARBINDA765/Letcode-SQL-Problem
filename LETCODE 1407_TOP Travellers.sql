--Write an SQL query to report the distance traveled by each user.

--Return the result table ordered by travelled_distance in descending order, if two or more users traveled the same distance,
--order them by their name in ascending order.

------------------Sample Table Script--------------

USE [SSIS]
Create Table  Users (id INT, name varchar(30))
Create Table  Rides (id INT, user_id INT, distance INT)
--DROP table Users
insert into Users (id, name) values (1, 'Alice')
insert into Users (id, name) values (2, 'Bob')
insert into Users (id, name) values (3, 'Alex')
insert into Users (id, name) values (4, 'Donald')
insert into Users (id, name) values (7, 'Lee')
insert into Users (id, name) values (13, 'Jonathan')
insert into Users (id, name) values (19, 'Elvis')
--DROP table Rides
insert into Rides (id, user_id, distance) values (1, 1, 120)
insert into Rides (id, user_id, distance) values (2, 2, 317)
insert into Rides (id, user_id, distance) values (3, 3, 222)
insert into Rides (id, user_id, distance) values (4, 7, 100)
insert into Rides (id, user_id, distance) values (5, 13, 312)
insert into Rides (id, user_id, distance) values (6, 19, 50)
insert into Rides (id, user_id, distance) values (7, 7, 120)
insert into Rides (id, user_id, distance) values (8,19, 400)
insert into Rides (id, user_id, distance) values (9, 7, 230)

--------------------Solution START-----------------------------------

WITH CTE_A AS 
(
SELECT DISTINCT  r.user_id,u.name,
CASE WHEN sum (r.distance) OVER (PARTITION BY r.user_id ) is null then 0 else sum (r.distance) OVER (PARTITION BY r.user_id ) end 


'travelled_distance' FROM Rides r
RIGHT   JOIN Users u on u.id=r.user_id 
)

SELECT name,travelled_distance FROM CTE_A 
ORDER BY travelled_distance DESC,name 

-----------Solution End---------------------------------------


