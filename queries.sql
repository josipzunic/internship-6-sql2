SELECT t.tournament_name, t.tournament_year, t.tournament_city, tm.team_name AS winner FROM tournaments t
JOIN winners w ON w.tournament_id = t.tournament_id
JOIN teams tm ON tm.team_id = w.team_id;

SELECT t.tournament_name, tm.team_name, tm.team_representative
FROM tournaments t
JOIN participations p ON p.tournament_id = t.tournament_id
JOIN teams tm ON tm.team_id = p.team_id
ORDER BY t.tournament_name, tm.team_name;

SELECT p.*, tm.*
FROM players p
JOIN teams tm ON tm.team_id = p.team_id
WHERE tm.team_id = 5
ORDER BY p.player_surname, p.player_name;

SELECT m.match_date, m.home_goals, m.guest_goals, th.team_name AS home, tg.team_name AS guest, mt.match_type FROM matches m
JOIN match_teams mh ON mh.match_id = m.match_id AND mh.role = 'home'
JOIN teams th ON th.team_id = mh.team_id
JOIN match_teams mg ON mg.match_id = m.match_id AND mg.role = 'guest'
JOIN teams tg ON tg.team_id = mg.team_id
JOIN match_types mt ON mt.match_type_id = m.match_type_id
WHERE m.tournament_id = 5
ORDER BY m.match_date;

SELECT
  m.match_date, t_home.team_name AS home_team, m.home_goals,
  t_guest.team_name AS guest_team, m.guest_goals, mt.match_type, tr.tournament_name
FROM matches m
JOIN match_teams mh ON mh.match_id = m.match_id AND mh.role = 'home'
JOIN teams t_home ON t_home.team_id = mh.team_id
JOIN match_teams mg ON mg.match_id = m.match_id AND mg.role = 'guest'
JOIN teams t_guest ON t_guest.team_id = mg.team_id
JOIN match_types mt ON mt.match_type_id = m.match_type_id
JOIN tournaments tr ON tr.tournament_id = m.tournament_id
WHERE mh.team_id = 5 OR mg.team_id = 5
ORDER BY m.match_date;

SELECT et.event_type, p.player_name, p.player_surname, e.minute FROM events e
JOIN event_types et ON et.event_type_id = e.event_type_id
JOIN players p ON p.player_id = e.player_id
WHERE e.match_id = 5
ORDER BY e.minute;

SELECT t.tournament_name, p.player_name, p.player_surname, tm.team_name, m.match_id,
  et.event_type, e.minute FROM events e
JOIN event_types et ON et.event_type_id = e.event_type_id
JOIN players p ON p.player_id = e.player_id
JOIN teams tm ON tm.team_id = p.team_id
JOIN matches m ON m.match_id = e.match_id
JOIN tournaments t ON t.tournament_id = m.tournament_id
WHERE et.event_type IN ('yellow card', 'red card')
  AND t.tournament_id = 5
ORDER BY m.match_id, e.minute;

SELECT p.player_name, p.player_surname, tm.team_name, COUNT(*) AS goals FROM events e
JOIN event_types et ON et.event_type_id = e.event_type_id
JOIN players p ON p.player_id = e.player_id
JOIN teams tm ON tm.team_id = p.team_id
JOIN matches m ON m.match_id = e.match_id
WHERE et.event_type = 'goal'
  AND m.tournament_id = 5
GROUP BY p.player_id, tm.team_name
ORDER BY goals DESC, p.player_surname, p.player_name;

SELECT t.tournament_name, m.match_date,
  CASE
    WHEN m.home_goals > m.guest_goals THEN th.team_name
    WHEN m.guest_goals > m.home_goals THEN tg.team_name
    ELSE 'draw'
  END AS winner,
  th.team_name AS home_team,
  m.home_goals,
  tg.team_name AS guest_team,
  m.guest_goals
FROM matches m
JOIN match_types mt ON mt.match_type_id = m.match_type_id
JOIN tournaments t ON t.tournament_id = m.tournament_id
JOIN match_teams mh ON mh.match_id = m.match_id AND mh.role = 'home'
JOIN teams th ON th.team_id = mh.team_id
JOIN match_teams mg ON mg.match_id = m.match_id AND mg.role = 'guest'
JOIN teams tg ON tg.team_id = mg.team_id
WHERE mt.match_type = 'finals'
ORDER BY m.match_date;

SELECT mt.match_type, COUNT(m.match_id) AS number_of_matches
FROM match_types mt
LEFT JOIN matches m ON m.match_type_id = mt.match_type_id
GROUP BY mt.match_type
ORDER BY mt.match_type;

SELECT m.match_date, th.team_name AS home_team, m.home_goals, tg.team_name AS guest_team,
  m.guest_goals, mt.match_type FROM matches m
JOIN match_types mt ON mt.match_type_id = m.match_type_id
JOIN match_teams mh ON mh.match_id = m.match_id AND mh.role = 'home'
JOIN teams th ON th.team_id = mh.team_id
JOIN match_teams mg ON mg.match_id = m.match_id AND mg.role = 'guest'
JOIN teams tg ON tg.team_id = mg.team_id
WHERE m.match_date = '2011-11-04'
ORDER BY m.match_id;

SELECT p.player_name, p.player_surname, tm.team_name, COUNT(*) AS goals FROM events e
JOIN event_types et ON et.event_type_id = e.event_type_id
JOIN players p ON p.player_id = e.player_id
JOIN teams tm ON tm.team_id = p.team_id
JOIN matches m ON m.match_id = e.match_id
WHERE et.event_type = 'goal'
  AND m.tournament_id = 5
GROUP BY p.player_id, tm.team_name
ORDER BY goals DESC, p.player_surname, p.player_name;

SELECT t.tournament_name, t.tournament_year, p.placement FROM participations p
JOIN tournaments t ON t.tournament_id = p.tournament_id
WHERE p.team_id = 5
ORDER BY t.tournament_year;

SELECT t.tournament_name, t.tournament_year, tm.team_name AS winner FROM winners w
JOIN tournaments t ON t.tournament_id = w.tournament_id
JOIN teams tm ON tm.team_id = w.team_id

SELECT t.tournament_name, t.tournament_year, COUNT(DISTINCT p.team_id) AS number_of_teams, 
COUNT(DISTINCT pl.player_id) AS number_of_players
FROM tournaments t
LEFT JOIN participations p ON p.tournament_id = t.tournament_id
LEFT JOIN players pl ON pl.team_id = p.team_id
GROUP BY t.tournament_id
ORDER BY t.tournament_year;

WITH team_goals AS (
  SELECT
    pl.team_id,
    e.player_id,
    pl.player_name,
    pl.player_surname,
    COUNT(*) AS goals
  FROM events e
  JOIN event_types et ON et.event_type_id = e.event_type_id
  JOIN players pl ON pl.player_id = e.player_id
  WHERE et.event_type = 'goal'
  GROUP BY pl.team_id, e.player_id, pl.player_name, pl.player_surname
),
ranked_goals AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY team_id ORDER BY goals DESC) AS rn
  FROM team_goals
)
SELECT
  t.team_name,
  rg.player_name,
  rg.player_surname,
  rg.goals
FROM ranked_goals rg
JOIN teams t ON t.team_id = rg.team_id
WHERE rg.rn = 1
ORDER BY t.team_name;

SELECT
  m.match_date,
  t.tournament_name,
  th.team_name AS home_team,
  m.home_goals,
  tg.team_name AS guest_team,
  m.guest_goals,
  mt.match_type
FROM matches m
JOIN referees r ON r.referee_id = m.referee_id
JOIN tournaments t ON t.tournament_id = m.tournament_id
JOIN match_types mt ON mt.match_type_id = m.match_type_id
JOIN match_teams mh ON mh.match_id = m.match_id AND mh.role = 'home'
JOIN teams th ON th.team_id = mh.team_id
JOIN match_teams mg ON mg.match_id = m.match_id AND mg.role = 'guest'
JOIN teams tg ON tg.team_id = mg.team_id
WHERE r.referee_id = 5
ORDER BY m.match_date;