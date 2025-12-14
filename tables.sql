CREATE TYPE possible_match_types AS ENUM ('groups', 'quarter-finals', 'semi-finals', 'finals');
CREATE TYPE possible_event_types AS ENUM ('goal', 'yellow card', 'red card');
CREATE TYPE roles AS ENUM ('home', 'guest');

CREATE TABLE tournaments (
	tournament_id SERIAL PRIMARY KEY,
	tournament_name VARCHAR(100) NOT NULL,
	tournament_year INT NOT NULL,
	tournament_country VARCHAR(100) NOT NULL,
	tournament_city VARCHAR(100) NOT NULL,
	tournament_is_active BOOL DEFAULT FALSE,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE teams (
	team_id SERIAL PRIMARY KEY,
	team_name VARCHAR(100) NOT NULL,
	team_country VARCHAR(100) NOT NULL,
	team_city VARCHAR(100) NOT NULL,
	team_representative VARCHAR(100) NOT NULL,
	team_contact_mail VARCHAR(100) NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE players (
	player_id SERIAL PRIMARY KEY,
	player_name VARCHAR(100) NOT NULL,
	player_surname VARCHAR(100) NOT NULL,
	player_dob DATE NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW(),
	team_id INT NOT NULL REFERENCES teams(team_id)
);

CREATE TABLE referees (
	referee_id SERIAL PRIMARY KEY,
	referee_name VARCHAR(100) NOT NULL,
	referee_surname VARCHAR(100) NOT NULL,
	referee_dob DATE NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE match_types(
	match_type_id SERIAL PRIMARY KEY,
	match_type possible_match_types NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE event_types(
	event_type_id SERIAL PRIMARY KEY,
	event_type possible_event_types NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE matches (
	match_id SERIAL PRIMARY KEY,
	match_date DATE NOT NULL,
	home_goals INT NOT NULL DEFAULT 0,
	guest_goals INT NOT NULL DEFAULT 0,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW(),
	referee_id INT NOT NULL REFERENCES referees(referee_id),
	tournament_id INT NOT NULL REFERENCES tournaments(tournament_id),
	match_type_id INT NOT NULL REFERENCES match_types(match_type_id)
);

CREATE TABLE match_teams (
  match_id INT REFERENCES matches(match_id),
  team_id INT REFERENCES teams(team_id),
  role roles NOT NULL,
  PRIMARY KEY (match_id, team_id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE participations (
	participation_id SERIAL PRIMARY KEY,
	placement INT NOT NULL,
	points INT NOT NULL,
	phase_reached possible_match_types NOT NULL,
	team_id INT NOT NULL REFERENCES teams(team_id),
	tournament_id INT NOT NULL REFERENCES tournaments(tournament_id),
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE events (
	event_id SERIAL PRIMARY KEY,
	minute INT NOT NULL,
	match_id INT NOT NULL REFERENCES matches(match_id),
	player_id INT NOT NULL REFERENCES players(player_id),
	event_type_id INT NOT NULL REFERENCES event_types(event_type_id),
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE winners (
	tournament_id INT PRIMARY KEY REFERENCES tournaments(tournament_id),
	team_id INT NOT NULL REFERENCES teams(team_id),
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);
