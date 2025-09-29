
-- Views 
CREATE OR REPLACE VIEW vw_placement_by_province AS
SELECT 
    c.province,
    COUNT(p.candidate_id) AS total_candidates,
    SUM(CASE WHEN p.status = 'Placed' THEN 1 ELSE 0 END) AS placed_candidates,
    ROUND(100.0 * SUM(CASE WHEN p.status = 'Placed' THEN 1 ELSE 0 END) / COUNT(p.candidate_id), 2) AS placement_pct
FROM dim_candidates c
LEFT JOIN fact_placements p
ON c.candidate_id = p.candidate_id
GROUP BY c.province
ORDER BY placement_pct DESC;

CREATE OR REPLACE VIEW vw_avg_attendance_by_program AS
SELECT 
    pr.program_name,
    ROUND(AVG(a.attendance_pct), 2) AS avg_attendance
FROM dim_programs pr
JOIN fact_attendance a
ON pr.program_id = a.program_id
GROUP BY pr.program_name
ORDER BY avg_attendance DESC;

CREATE OR REPLACE VIEW vw_cohort_outcomes AS
SELECT 
    c.cohort,
    COUNT(p.candidate_id) AS total_candidates,
    SUM(CASE WHEN p.status = 'Placed' THEN 1 ELSE 0 END) AS placed_candidates,
    ROUND(100.0 * SUM(CASE WHEN p.status = 'Placed' THEN 1 ELSE 0 END) / COUNT(p.candidate_id), 2) AS placement_pct,
    ROUND(AVG(a.attendance_pct), 2) AS avg_attendance
FROM dim_candidates c
LEFT JOIN fact_placements p
ON c.candidate_id = p.candidate_id
LEFT JOIN fact_attendance a
ON c.candidate_id = a.candidate_id
GROUP BY c.cohort
ORDER BY cohort;


CREATE OR REPLACE VIEW vw_candidate_details AS
SELECT 
    c.candidate_id,
    c.name,
    c.province,
    c.cohort,
    pr.program_name,
    a.attendance_pct,
    p.status,
    p.company,
    p.placement_date
FROM dim_candidates c
LEFT JOIN fact_attendance a
ON c.candidate_id = a.candidate_id
LEFT JOIN dim_programs pr
ON a.program_id = pr.program_id
LEFT JOIN fact_placements p
ON c.candidate_id = p.candidate_id
ORDER BY c.cohort, c.name;


CREATE OR REPLACE VIEW vw_program_placement_rate AS
SELECT 
    pr.program_name,
    COUNT(p.candidate_id) AS total_candidates,
    SUM(CASE WHEN p.status = 'Placed' THEN 1 ELSE 0 END) AS placed_candidates,
    ROUND(100.0 * SUM(CASE WHEN p.status = 'Placed' THEN 1 ELSE 0 END) / COUNT(p.candidate_id), 2) AS placement_pct
FROM dim_programs pr
LEFT JOIN fact_attendance a
ON pr.program_id = a.program_id
LEFT JOIN fact_placements p
ON a.candidate_id = p.candidate_id
GROUP BY pr.program_name
ORDER BY placement_pct DESC;
