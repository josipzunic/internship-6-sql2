CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_tournaments_timestamp
BEFORE UPDATE ON tournaments
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_update_tournaments_timestamp
BEFORE UPDATE ON teams
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_update_tournaments_timestamp
BEFORE UPDATE ON referees
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_update_tournaments_timestamp
BEFORE UPDATE ON match_types
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_update_tournaments_timestamp
BEFORE UPDATE ON event_types
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_update_tournaments_timestamp
BEFORE UPDATE ON match_teams
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_update_tournaments_timestamp
BEFORE UPDATE ON participations
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_update_tournaments_timestamp
BEFORE UPDATE ON events
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_update_tournaments_timestamp
BEFORE UPDATE ON winners
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();