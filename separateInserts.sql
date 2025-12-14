

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