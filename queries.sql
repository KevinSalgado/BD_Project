SET search_path TO bd_project;

-- Core Q1
SELECT a.title,
       a.start_ts,
       a.end_ts,
       p.name AS participant,
       i.role
FROM activity a
LEFT JOIN involvement i ON i.activity_id = a.id
LEFT JOIN participant p ON p.id = i.participant_id
WHERE a.edition_id = 2
ORDER BY a.start_ts, a.id, p.name;

-- Core Q2
SELECT p.id,
       p.name,
       COUNT(DISTINCT i.activity_id) AS num_activities
FROM involvement i
JOIN participant p ON p.id = i.participant_id
WHERE i.edition_id = 2
GROUP BY p.id, p.name
ORDER BY num_activities DESC, p.name;
