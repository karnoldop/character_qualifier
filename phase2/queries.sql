SELECT "1---------";
.headers on
--Displays the entire content of agent sorted on a_agentkey (Simple one but it's part of our idea in displaying every agent).

SELECT * FROM agents;
;
.headers off

SELECT "2---------";
.headers on
--Find agents that are from United States and has role of Controller.

SELECT a_name
FROM agents, roles, origin
WHERE 
	a_rolekey = r_rolekey AND
	r_name = 'Controller' AND
	a_originkey = o_originkey AND
	o_name = 'United States'
GROUP BY a_name;
;
.headers off

SELECT "3---------";
.headers on
--Find one agent with the highest KDA kill ratio in the Bind map. Print agent name and their KDA kill.

SELECT a_name, kda_kill
FROM agents, kda, map
WHERE 
	a_agentkey = kda_agentkey AND
    kda_mapkey = m_mapkey AND
	m_name = 'Bind'
GROUP BY a_name
ORDER BY kda_kill DESC
LIMIT 1;
;
.headers off

SELECT "4---------";
.headers on
--Print the weapons that cost under $1000 and has a fire rate greater than 5. Order by weapon cost (w_price) in increasing order.

SELECT w_name
FROM weapon
WHERE 
	w_price < 1000 AND
	w_firerate > 5
GROUP BY w_name
ORDER BY w_price ASC;
;
.headers off

SELECT "5---------";
.headers on
--For every agent, find their highest win rate for any map. Print the agent, map, and win rate.

SELECT a_name, m_name, MAX(kda_winrate)
FROM agents, kda, map
WHERE
	a_agentkey = kda_agentkey AND
	kda_mapkey = m_mapkey
GROUP BY a_name;
;
.headers off

SELECT "6---------";
.headers on 
--Find the minimum and maximum picked by silver in each map. Print the map name and min/max pick rate.

SELECT MIN(mr_silver), MAX(mr_silver)
FROM maprank;
;
.headers off

SELECT "7---------";
.headers on 
--Count the number of agents who have an overall death greater than 11 in Haven.

SELECT COUNT(a_agentkey)
FROM agents, kda, map
WHERE
	a_agentkey = kda_agentkey AND
	kda_mapkey = m_mapkey AND
	m_name = 'Haven' AND
	kda_death > 11;
;
.headers off

SELECT "8---------";
.headers on 
--It is preferred that Duelists prefer using closer range weapon. Remove specific roles of Duelists whose close headshot is less than 75.

DELETE FROM Roles
WHERE
	r_name = 'Duelist' AND
	r_weaponkey IN (
		SELECT r_weaponkey
		FROM roles, weapon
		WHERE
			r_weaponkey = w_weaponkey AND
			w_nearheaddmg < 75);
;
.headers off

SELECT "9---------";
.headers on 
--Find the number of agents who have at least 15 weapon choices now (basically anyone not a Duelist).

SELECT COUNT(DISTINCT a_agentkey) AS numAgent
FROM agents, roles, weapon
WHERE
    a_rolekey = r_rolekey AND
    r_weaponkey = w_weaponkey AND
    a_agentkey IN (SELECT a_agentkey
                FROM agents, roles, weapon
                WHERE 
					a_rolekey = r_rolekey AND
    				r_weaponkey = w_weaponkey
                GROUP BY a_agentkey
                HAVING COUNT(a_agentkey) >= 15);
;
.headers off

SELECT "10---------";
.headers on 
--Find the top 3 agents with the highest win rate and in the Breeze map. Print agent name and their win rate.

SELECT a_name, kda_winrate
FROM agents, kda, map
WHERE
	a_agentkey = kda_agentkey AND
	kda_mapkey = m_mapkey AND
	m_name = 'Breeze'
GROUP BY a_name
ORDER BY kda_winrate DESC
LIMIT 3;
;
.headers off

SELECT "11---------";
.headers on 
--Find how many agents in every map have a smaller kda_kill than the average kda_kill of each map.

SELECT
    m_name,
    COUNT(*)
FROM
    agents,
    map,
	kda,
    (SELECT m_name AS m_name1, avg(kda_kill) AS avg_kill
    FROM agents, map, kda
    WHERE a_agentkey = kda_agentkey AND kda_mapkey = m_mapkey
    GROUP BY m_name) AS avgfound ON m_name = avgfound.m_name1
WHERE
	a_agentkey = kda_agentkey AND 
	kda_mapkey = m_mapkey AND
    kda_kill < avgfound.avg_kill
GROUP BY m_name;
;
.headers off

SELECT "12---------";
.headers on 
--Find the smallest weapon price that is larger than the average weapon price. Print the weapon name and price.

SELECT DISTINCT w_name, w_price
FROM weapon
WHERE
    w_price = (SELECT MIN(w_price) 
                FROM weapon 
                WHERE w_price > (SELECT AVG(w_price) FROM weapon));
;
.headers off

SELECT "13---------";
.headers on 
--Triple KAY/O's agentpr tuple if kda_assist is greater than 4.

UPDATE kda
SET kda_agentpr = kda_agentpr * 3
WHERE
	kda_agentkey = 16 AND
	kda_assist NOT IN (
		SELECT DISTINCT kda_assist
		FROM agents, kda
		WHERE
			a_agentkey = kda_agentkey AND
			kda_assist <= 4);
;
.headers off

SELECT "14---------";
.headers on 
--If the maps picked by diamond ranks is greater than 17%, find the max kda_agentpr. Print the map name and kda_agentpr. 

SELECT m_name, MAX(kda_agentpr)
FROM map, kda, maprank
WHERE
	kda_mapkey = m_mapkey AND
	m_mapkey = mr_mapkey AND 
	mr_diamond > 0.17
GROUP BY m_name;
;
.headers off

SELECT "15---------";
.headers on 
--Find how many agents are Sentinels from Brazil, China, and Germany.

SELECT COUNT(DISTINCT a_agentkey)
FROM agents, roles, origin
WHERE
	a_originkey = o_originkey AND
	a_rolekey = r_rolekey AND
	r_name = 'Sentinel' AND
	o_originkey IN (3,4,5);
;
.headers off

SELECT "16---------";
.headers on 
--Print the weapon where there doesn't exist a weapon whose leg damage from a medium distance is greater.

SELECT w_name
FROM weapon W1
WHERE NOT EXISTS (
	SELECT w_name
	FROM weapon W2
	WHERE
		W2.w_midlegdmg > W1.w_midlegdmg);
;
.headers off

SELECT "17---------";
.headers on 
--Find map descriptions that include the word "two" and print the map name in alphabetical order.

SELECT m_name
FROM map
WHERE
	m_description LIKE '%two%'
GROUP BY m_name
ORDER BY m_name ASC;
;
.headers off

SELECT "18---------";
.headers on 
--Assume Controllers prefer to keep a distance when battling. Remove specific roles of Controllers whose far headshot is less than 130.

DELETE FROM Roles
WHERE
	r_name = 'Controller' AND
	r_weaponkey IN (
		SELECT r_weaponkey
		FROM roles, weapon
		WHERE
			r_weaponkey = w_weaponkey AND
			w_farheaddmg < 130);
;
.headers off

SELECT "19---------";
.headers on 
--Find agents who are human, has a kda death greater than the average kda death, and is either Controller or Sentinels in the Split map

SELECT DISTINCT a_name
FROM roles, agents, kda, map
WHERE
	r_rolekey = a_rolekey AND
	a_agentkey = kda_agentkey AND
	kda_mapkey = m_mapkey AND
	m_mapkey = 1 AND
	kda_death > (SELECT AVG(kda_death) FROM kda) AND 
	a_race = 'Human' AND
	r_rolekey IN (1,4)
;
.headers off

SELECT "20---------";
.headers on 
--Find weapons that can be used by Controllers and Duelists after the modifications.

SELECT w_name
FROM agents, roles, weapon
WHERE
	a_rolekey = r_rolekey AND
	r_weaponkey = w_weaponkey AND
	r_rolekey = 1
INTERSECT
SELECT w_name
FROM agents, roles, weapon
WHERE 
	a_rolekey = r_rolekey AND
	r_weaponkey = w_weaponkey AND
	r_rolekey = 2
;
.headers off