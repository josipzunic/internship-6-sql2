ALTER TABLE match_teams
	ADD CONSTRAINT unique_match_role UNIQUE (match_id, role);

ALTER TABLE matches
	ADD CONSTRAINT negative_goals CHECK(home_goals >= 0 AND guest_goals >= 0);

ALTER TABLE events
	ADD CONSTRAINT valid_minute CHECK(minute BETWEEN 0 AND 125);

ALTER TABLE tournaments
	ADD CONSTRAINT tournament_year 
	CHECK(tournament_year BETWEEN 1930 AND EXTRACT(YEAR FROM NOW()));

ALTER TABLE teams
	ADD CONSTRAINT email_format CHECK (team_contact_mail LIKE '%@%');

ALTER TABLE participations
	ADD CONSTRAINT negative_placement CHECK (placement > 0);

ALTER TABLE participations
	ADD CONSTRAINT negative_points CHECK (points >= 0);


