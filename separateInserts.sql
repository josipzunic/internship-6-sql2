INSERT INTO matches (match_date, home_goals, guest_goals, referee_id, tournament_id, match_type_id)
SELECT 
    (t.tournament_year || '-01-01')::DATE + (RANDOM() * 364)::INT as match_date,
    FLOOR(RANDOM() * 6)::INT as home_goals,
    FLOOR(RANDOM() * 6)::INT as guest_goals,
    FLOOR(RANDOM() * 1000 + 1)::INT as referee_id,
    ((gs.id - 1) % 50) + 1 as tournament_id,
    gs.id as match_type_id
FROM generate_series(1, 1000) as gs(id)
JOIN tournaments t ON t.tournament_id = ((gs.id - 1) % 50) + 1;

WITH match_points AS (
  SELECT
    m.tournament_id,
    mt.team_id,
    mt2.match_type,
    CASE
      WHEN mt.role = 'home' AND m.home_goals > m.guest_goals THEN 3
      WHEN mt.role = 'guest' AND m.guest_goals > m.home_goals THEN 3
      WHEN m.home_goals = m.guest_goals THEN 1
      ELSE 0
    END AS points
  FROM matches m
  JOIN match_teams mt ON mt.match_id = m.match_id
  JOIN match_types mt2 ON mt2.match_type_id = m.match_type_id
)

INSERT INTO participations (
  placement,
  points,
  phase_reached,
  team_id,
  tournament_id,
  created_at,
  updated_at
)
SELECT
  RANK() OVER (
    PARTITION BY tournament_id
    ORDER BY SUM(points) DESC
  ) AS placement,
  SUM(points) AS points,
  MAX(match_type) AS phase_reached,
  team_id,
  tournament_id,
  NOW(),
  NOW()
FROM match_points
GROUP BY tournament_id, team_id

ON CONFLICT (team_id, tournament_id)
DO UPDATE SET
  placement = EXCLUDED.placement,
  points = EXCLUDED.points,
  phase_reached = EXCLUDED.phase_reached,
  updated_at = NOW();

INSERT INTO winners (tournament_id, team_id, created_at, updated_at)
SELECT
  tournament_id,
  team_id,
  NOW(),
  NOW()
FROM (
  SELECT
    tournament_id,
    team_id,
    ROW_NUMBER() OVER (
      PARTITION BY tournament_id
      ORDER BY points DESC, team_id
    ) AS rn
  FROM participations
) ranked
WHERE rn = 1

ON CONFLICT (tournament_id)
DO UPDATE SET
  team_id = EXCLUDED.team_id,
  updated_at = NOW();