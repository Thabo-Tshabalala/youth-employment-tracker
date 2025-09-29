-- Drop existing tables
DROP TABLE IF EXISTS fact_attendance, fact_placements, fact_engagement;
DROP TABLE IF EXISTS dim_candidates, dim_programs;

-- Dimension tables
CREATE TABLE dim_candidates (
    candidate_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    gender CHAR(1),
    province VARCHAR(50),
    age INT,
    cohort VARCHAR(10),
    enrollment_date DATE
);

CREATE TABLE dim_programs (
    program_id VARCHAR(10) PRIMARY KEY,
    program_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    cohort VARCHAR(10)
);

-- Fact tables
CREATE TABLE fact_attendance (
    attendance_id VARCHAR(10) PRIMARY KEY,
    candidate_id VARCHAR(10) REFERENCES dim_candidates(candidate_id),
    program_id VARCHAR(10) REFERENCES dim_programs(program_id),
    session_date DATE,
    status VARCHAR(20)
);

CREATE TABLE fact_placements (
    placement_id VARCHAR(10) PRIMARY KEY,
    candidate_id VARCHAR(10) REFERENCES dim_candidates(candidate_id),
    employer VARCHAR(100),
    province VARCHAR(50),
    placement_date DATE,
    status VARCHAR(20)
);

CREATE TABLE fact_engagement (
    engagement_id VARCHAR(10) PRIMARY KEY,
    candidate_id VARCHAR(10) REFERENCES dim_candidates(candidate_id),
    module_name VARCHAR(100),
    last_activity DATE,
    score INT,
    completion_rate FLOAT
);
