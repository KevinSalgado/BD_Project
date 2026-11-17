DROP SCHEMA IF EXISTS bd_project CASCADE;
CREATE SCHEMA bd_project;
SET search_path TO bd_project;

CREATE TABLE conference (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    acronym     VARCHAR(32)  NOT NULL,
    description TEXT
);

CREATE TABLE participant (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    email       VARCHAR(255) NOT NULL,
    affiliation VARCHAR(255),
    CONSTRAINT participant_email_uk UNIQUE (email)
);

CREATE TABLE edition (
    id            SERIAL PRIMARY KEY,
    conference_id INTEGER      NOT NULL REFERENCES conference (id),
    year          INTEGER      NOT NULL,
    start_date    DATE         NOT NULL,
    end_date      DATE         NOT NULL,
    location      VARCHAR(255) NOT NULL,
    CONSTRAINT edition_conference_year_uk UNIQUE (conference_id, year),
    CONSTRAINT edition_dates_ck CHECK (start_date <= end_date)
);

CREATE TABLE participates (
    edition_id     INTEGER NOT NULL REFERENCES edition (id),
    participant_id INTEGER NOT NULL REFERENCES participant (id),
    PRIMARY KEY (edition_id, participant_id)
);

CREATE TABLE activity (
    id          SERIAL PRIMARY KEY,
    title       VARCHAR(255) NOT NULL,
    description TEXT,
    start_ts    TIMESTAMP    NOT NULL,
    end_ts      TIMESTAMP    NOT NULL,
    edition_id  INTEGER      NOT NULL REFERENCES edition (id),
    CONSTRAINT activity_id_edition_uk UNIQUE (id, edition_id),
    CONSTRAINT activity_ts_ck CHECK (start_ts < end_ts)
);

CREATE TABLE involvement (
    participant_id INTEGER      NOT NULL,
    activity_id    INTEGER      NOT NULL,
    edition_id     INTEGER      NOT NULL,
    role           VARCHAR(64)  NOT NULL,
    PRIMARY KEY (participant_id, activity_id),
    CONSTRAINT involvement_activity_fk
        FOREIGN KEY (activity_id, edition_id)
        REFERENCES activity (id, edition_id),
    CONSTRAINT involvement_participates_fk
        FOREIGN KEY (edition_id, participant_id)
        REFERENCES participates (edition_id, participant_id)
);

-- Activity must fall within the period of its Edition
CREATE OR REPLACE FUNCTION check_activity_within_edition() RETURNS TRIGGER AS $$
DECLARE
    ed_start DATE;
    ed_end   DATE;
BEGIN
    SELECT start_date, end_date INTO ed_start, ed_end
    FROM edition
    WHERE id = NEW.edition_id;

    IF NEW.start_ts::date < ed_start OR NEW.end_ts::date > ed_end THEN
        RAISE EXCEPTION 'Activity % must fall within the edition period (% to %)',
            NEW.title, ed_start, ed_end;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER activity_within_edition_tg
    BEFORE INSERT OR UPDATE ON activity
    FOR EACH ROW EXECUTE FUNCTION check_activity_within_edition();
