CREATE TABLE households (
    household_id SERIAL PRIMARY KEY,
    address VARCHAR(100)
);
CREATE TABLE citizens (
    citizen_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    dob DATE,
    gender VARCHAR(6),
    household_id INT REFERENCES households(household_id),
    education VARCHAR(50),
    is_student BOOLEAN,
    parent_id INT REFERENCES citizens(citizen_id),
    income INT
);
CREATE TABLE land_records (
    land_id SERIAL PRIMARY KEY,
    citizen_id INT REFERENCES citizens(citizen_id),
    land_area NUMERIC(10, 2),
    crop_type VARCHAR(50)
);
CREATE TABLE panchayat_employees (
    employee_id SERIAL PRIMARY KEY,
    citizen_id INT REFERENCES citizens(citizen_id),
    role VARCHAR(50)
);
CREATE TABLE assets (
    asset_id SERIAL PRIMARY KEY,
    type VARCHAR(50),
    location VARCHAR(100),
    installation_date DATE
);
CREATE TABLE welfare_schemes (
    scheme_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    description TEXT
);
CREATE TABLE scheme_enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    citizen_id INT REFERENCES citizens(citizen_id),
    scheme_id INT REFERENCES welfare_schemes(scheme_id),
    enrollment_date DATE
);
CREATE TABLE vaccinations (
    vaccination_id SERIAL PRIMARY KEY,
    citizen_id INT REFERENCES citizens(citizen_id),
    vaccine_type VARCHAR(50),
    date_administered DATE
);
CREATE TABLE census_data (
    census_id SERIAL PRIMARY KEY,
    household_id INT REFERENCES households(household_id),
    citizen_id INT REFERENCES citizens(citizen_id),
    event_type VARCHAR(50),
    event_date DATE
);
