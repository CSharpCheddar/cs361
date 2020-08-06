-- Query 1
SELECT t.team_name
  FROM Batting19 AS b
  INNER JOIN Teams19 AS t
  ON b.teamID = t.teamID
  WHERE b.HR >= 35
  GROUP BY b.teamID
  HAVING COUNT(b.playerID) > 2;

-- Query 2
SELECT p.name_first, p.name_last,
       t.team_name, a.G_ss
  FROM Appearances19 AS a
  INNER JOIN Players19 AS p
  ON a.playerID = p.playerID
  INNER JOIN Teams19 AS t
  ON a.teamID = t.teamID
  WHERE a.G_ss > 0 AND a.teamID IN (
  SELECT teamID
    FROM Teams19
    WHERE div_winner LIKE "Y"
  );

-- Query 3
SELECT t.team_name,
       AVG((p.H+p.BB)/(p.IPouts/3)) AS WHIP
  FROM Pitching19 AS p
  INNER JOIN Teams19 AS t
  ON p.teamID = t.teamID
  GROUP BY p.teamID
  ORDER BY WHIP ASC;

-- Query 4
SELECT t.team_name, p.name_last,
       f.E
  FROM Fielding19 AS f
  INNER JOIN Teams19 AS t
  ON f.teamID = t.teamID
  INNER JOIN Players19 AS p
  ON f.playerID = p.playerID
  INNER JOIN (
  SELECT teamID, MAX(E) AS ERROR
    FROM Fielding19
    GROUP BY teamID
  ) AS m
  ON f.teamID = m.teamID
     AND f.E = m.ERROR
  ORDER BY ERROR DESC;

-- Query 5
SELECT p.name_first, p.name_last,
       MIN(b.H/b.AB) AS BATAVG
  FROM Batting19 AS b
  INNER JOIN Players19 AS p
  ON p.playerID = b.playerID
  WHERE b.playerID IN (
  SELECT playerID
    FROM Appearances19
    WHERE G_3b >= 45
  );

-- Query 6
SELECT team_name
  FROM Teams19
  WHERE teamID NOT IN (
  SELECT teamID
    FROM Batting19
    WHERE AB > 0 AND playerID NOT IN (
    SELECT playerID
      FROM Fielding19
    )
  )
  ORDER BY team_name ASC;

-- Query 7
SELECT t.team_name,
       COUNT(pit.playerID) AS pitchers,
       SUM(pit.SO) AS strouts
  FROM Pitching19 AS pit
  INNER JOIN Teams19 as t
  ON pit.teamID = t.teamID
  WHERE pit.G > 0
  GROUP BY pit.teamID
  ORDER BY pitchers DESC, strouts DESC;

-- Query 8
SELECT t.team_name, u.team_name, t.rank
  FROM Teams19 AS t
  CROSS JOIN Teams19 AS u
  WHERE t.lgID LIKE "NL" AND
        u.lgID LIKE "AL" AND
        t.rank = u.rank
  ORDER BY t.rank DESC, t.team_name ASC,
           u.team_name DESC;

-- Query 9
SELECT p.name_first, p.name_last, t.team_name,
       pit.W
  FROM Pitching19 AS pit
  INNER JOIN Players19 AS p
  ON pit.playerID = p.playerID
  INNER JOIN Teams19 AS t
  ON pit.teamID = t.teamID
     AND t.div_winner LIKE "Y"
  INNER JOIN (
  SELECT teamID, MAX(W) AS wins
    FROM Pitching19
    GROUP BY teamID
  ) AS m
  ON pit.teamID = m.teamID
     AND pit.W = m.wins;

-- Query 10
SELECT team_name, SpecPlayers
  FROM (
  SELECT t.team_name,
         COUNT(b.playerID) AS SpecPlayers
    FROM Batting19 AS b
    INNER JOIN Teams19 AS t
    ON b.teamID = t.teamID
    WHERE (b.HR+b.3B+b.2B) > (b.H-b.HR-b.3B-b.2B)
    GROUP BY b.teamID
  UNION
  SELECT team_name, 0 AS SpecPlayers
    FROM Teams19
  ) AS a
  GROUP BY team_name
  ORDER BY team_name ASC;
