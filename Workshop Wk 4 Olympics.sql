--Olympics Basketball

--When was this sport introduced to the Olympics? 
--1904
SELECT edition, sport
FROM Olympic_Athlete_Event_Results oaer 
WHERE sport = 'Basketball'
GROUP BY edition
ORDER BY edition_id 


 


--How many countries typically participate? 
WITH cte AS
(
SELECT sport, edition, count(DISTINCT country_noc) AS Participating_Countries
FROM Olympic_Athlete_Event_Results 
WHERE sport = 'Basketball'
GROUP BY edition 
)
SELECT sport, edition, Participating_Countries, 
round(avg(Participating_Countries) 
OVER() ) AS AvgParticipants
FROM cte


SELECT sum()


--3.How many players are on an Olympic team in your sport? 
--join?
WITH cte as
(
SELECT country_noc, edition, count(athlete) AS Players
FROM Olympic_Athlete_Event_Results oaer 
WHERE sport = 'Basketball'
GROUP BY country_noc, edition
)
SELECT country_noc, edition, round(avg(Players))
FROM cte
GROUP BY country_noc 
ORDER BY edition 






--4.Who has won the most gold medals in your sport? 
SELECT country_noc, athlete, count(medal) AS Gold,
dense_rank () OVER (ORDER BY count(medal) desc) AS Gold_Medal_Rank
FROM Olympic_Athlete_Event_Results oaer 
WHERE medal = 'Gold' AND sport = 'Basketball'
GROUP BY athlete 
ORDER BY Gold DESC 


--5. Does one team dominate the sport? 
SELECT oaer.country_noc, oaer.edition, oc.country--count(country_noc)
FROM Olympic_Athlete_Event_Results oaer
JOIN Olympics_Country oc ON oc.country_noc = oaer.country_noc 
WHERE medal = 'Gold' AND sport = 'Basketball'
GROUP BY edition 
ORDER BY edition

--6. Are there rivalries?
--see silver & bronze
WITH cte as
(
SELECT oaer.country_noc, oaer.edition, oc.country
FROM Olympic_Athlete_Event_Results oaer
JOIN Olympics_Country oc ON oc.country_noc = oaer.country_noc 
WHERE medal = 'Gold'
AND sport = 'Basketball'
GROUP BY edition
order BY edition
)
SELECT country, count(edition) AS gold_medals
FROM cte
GROUP BY country_noc
ORDER BY gold_medals DESC 


--What teams/countries have never won a medal in your sport? 
--medals into integers
--

WITH cte AS
(
SELECT country_noc, edition, medal,
CASE
WHEN medal = 'na' THEN 0
ELSE 1
END AS medal_bool

FROM Olympic_Athlete_Event_Results oaer
WHERE sport = 'Basketball'
ORDER BY 1, 2, 3
)
SELECT country_noc, SUM(medal_bool)
FROM cte
Group by country_noc
HAVING SUM(medal_bool) = 0

our best try
--SELECT oaer.country_noc, oaer.edition, oc.country
--FROM Olympic_Athlete_Event_Results oaer
--JOIN Olympics_Country oc ON oc.country_noc = oaer.country_noc 
--WHERE medal = 'na'
--AND sport = 'Basketball' 


