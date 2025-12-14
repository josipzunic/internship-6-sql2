ALTER TABLE participations 
	ADD CONSTRAINT unique_team_tournament UNIQUE (team_id, tournament_id);

ALTER TABLE match_teams
	ADD CONSTRAINT unique_match_role UNIQUE (match_id, role);

ALTER TABLE matches
	ADD CONSTRAINT negative_goals CHECK(home_goals >= 0 AND guest_goals >= 0);

ALTER TABLE events
	ADD CONSTRAINT valid_minute CHECK(minute BETWEEN 0 AND 125);

ALTER TABLE tournaments
	ADD CONSTRAINT tournament_year 
	CHECK(tournament_year BETWEEN 1930 AND EXTRACT(YEAR FROM NOW()))

ALTER TABLE teams
	ADD CONSTRAINT email_format CHECK (team_contact_mail LIKE '%@%')

ALTER TABLE participations
	ADD CONSTRAINT negative_placement CHECK (placement > 0)

ALTER TABLE participations
	ADD CONSTRAINT negative_points CHECK (points >= 0)

ALTER TABLE tournaments
    ADD CONSTRAINT winner_only_when_finished 
    CHECK (tournament_is_active = FALSE OR NOT EXISTS (
        SELECT 1 FROM winners WHERE winners.tournament_id = tournament_id
    ));

ALTER TABLE events
    ADD CONSTRAINT player_in_match_team
    CHECK EXISTS (
        SELECT 1 FROM match_teams mt
        JOIN players p ON p.team_id = mt.team_id
        WHERE mt.match_id = events.match_id 
        AND p.player_id = events.player_id
    );

ALTER TABLE matches
    ADD CONSTRAINT match_in_tournament_year
    CHECK EXISTS (
        SELECT 1 FROM tournaments t 
        WHERE t.tournament_id = matches.tournament_id 
        AND EXTRACT(YEAR FROM match_date) = t.tournament_year
    );

