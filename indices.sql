CREATE INDEX idx_tournaments_year ON tournaments(tournament_year);
CREATE INDEX idx_teams_name ON teams(team_name);

CREATE INDEX idx_players_team_id ON players(team_id);
CREATE INDEX idx_players_name ON players(player_surname, player_name);

CREATE INDEX idx_matches_tournament_id ON matches(tournament_id);
CREATE INDEX idx_matches_match_type_id ON matches(match_type_id);
CREATE INDEX idx_matches_referee_id ON matches(referee_id);
CREATE INDEX idx_matches_date ON matches(match_date);

CREATE INDEX idx_match_teams_role ON match_teams(role);
CREATE INDEX idx_match_teams_team_id ON match_teams(team_id);

CREATE INDEX idx_participations_team_id ON participations(team_id);
CREATE INDEX idx_participations_tournament_id ON participations(tournament_id);

CREATE INDEX idx_events_match_id ON events(match_id);
CREATE INDEX idx_events_player_id ON events(player_id);
CREATE INDEX idx_events_event_type_id ON events(event_type_id);
CREATE INDEX idx_events_minute ON events(minute);
CREATE INDEX idx_events_match_event_type ON events(match_id, event_type_id);

CREATE INDEX idx_winners_team_id ON winners(team_id);