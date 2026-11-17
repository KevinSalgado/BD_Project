SET search_path TO bd_project;

INSERT INTO conference (id, name, acronym, description) VALUES
    (1, 'Data Science and Engineering Conference', 'DSEC', 'Annual conference on data science and data engineering.'),
    (2, 'Conference on Information Systems', 'CIS', 'Conference on the design and use of information systems.');

INSERT INTO edition (id, conference_id, year, start_date, end_date, location) VALUES
    (1, 1, 2024, '2024-06-10', '2024-06-12', 'Porto'),
    (2, 1, 2025, '2025-06-16', '2025-06-18', 'Lisbon'),
    (3, 2, 2025, '2025-09-22', '2025-09-24', 'Braga');

INSERT INTO participant (id, name, email, affiliation) VALUES
    (1, 'Ana Silva',    'ana.silva@example.com',    'University of Porto'),
    (2, 'Bruno Costa',  'bruno.costa@example.com',  'INESC TEC'),
    (3, 'Carla Mendes', 'carla.mendes@example.com', 'University of Lisbon'),
    (4, 'David Rocha',  'david.rocha@example.com',  'University of Minho');

INSERT INTO participates (edition_id, participant_id) VALUES
    (1, 1),
    (1, 2),
    (2, 1),
    (2, 3),
    (3, 2),
    (3, 4);

INSERT INTO activity (id, title, description, start_ts, end_ts, edition_id) VALUES
    (1, 'Opening Keynote',           'Keynote opening the 2024 edition.',   '2024-06-10 09:00', '2024-06-10 10:00', 1),
    (2, 'Machine Learning Session',  'Papers on machine learning.',         '2025-06-16 10:00', '2025-06-16 12:00', 2),
    (3, 'Data Engineering Workshop', 'Hands-on data pipelines workshop.',   '2025-06-17 14:00', '2025-06-17 17:00', 2),
    (4, 'Welcome Reception',         'Social event for all attendees.',     '2025-09-22 19:00', '2025-09-22 21:00', 3);

INSERT INTO involvement (participant_id, activity_id, edition_id, role) VALUES
    (1, 1, 1, 'speaker'),
    (2, 1, 1, 'chair'),
    (1, 2, 2, 'speaker'),
    (3, 2, 2, 'chair'),
    (1, 3, 2, 'speaker'),
    (3, 3, 2, 'attendee'),
    (2, 4, 3, 'attendee');

-- Keep the SERIAL sequences in sync with the explicit ids used above
SELECT setval('conference_id_seq',  (SELECT MAX(id) FROM conference));
SELECT setval('edition_id_seq',     (SELECT MAX(id) FROM edition));
SELECT setval('participant_id_seq', (SELECT MAX(id) FROM participant));
SELECT setval('activity_id_seq',    (SELECT MAX(id) FROM activity));
