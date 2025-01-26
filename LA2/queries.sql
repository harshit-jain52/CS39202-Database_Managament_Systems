SELECT c.name
FROM citizens AS c
JOIN land_records AS l ON c.citizen_id = l.citizen_id
WHERE l.land_area > 1.00;
SELECT c1.name
FROM citizens AS c1                                         
JOIN households AS h ON c1.household_id = h.household_id
WHERE c1.gender = 'Female'
AND c1.is_student = TRUE
AND                
( SELECT SUM(c2.income)
FROM citizens AS c2
WHERE c2.household_id = h.household_id
)                      
< 100000;
SELECT SUM(land_area)
FROM land_records
WHERE crop_type ILIKE 'rice';
SELECT COUNT(*)
FROM citizens
WHERE dob > '2000-01-01'
AND education ILIKE '10th';
SELECT c.name
FROM citizens AS c
JOIN panchayat_employees AS p ON c.citizen_id = p.citizen_id
JOIN land_records AS l ON p.citizen_id = l.citizen_id
WHERE l.land_area > 1.00;
SELECT c1.name        
FROM citizens AS c1
JOIN households AS h ON h.household_id = c1.household_id
JOIN citizens AS c2 ON c2.household_id = h.household_id
JOIN panchayat_employees AS p ON p.citizen_id = c2.citizen_id
WHERE p.role ILIKE 'Pradhan';
SELECT COUNT(*)
FROM assets
WHERE type ILIKE 'Street Light'
AND location ILIKE 'Phulera'
AND EXTRACT(YEAR FROM installation_date) = 2024;
SELECT COUNT(*)
FROM vaccinations AS v
JOIN citizens as c1 ON v.citizen_id = c1.citizen_id
JOIN citizens AS c2 ON c1.parent_id = c2.citizen_id
WHERE EXTRACT(YEAR FROM v.date_administered) = 2024
AND c2.education ILIKE '10th';
SELECT COUNT(*) from citizens
WHERE gender = 'Male'
AND EXTRACT(YEAR FROM dob) = 2024;
SELECT COUNT(DISTINCT c1.citizen_id)        
FROM citizens AS c1
JOIN households AS h ON h.household_id = c1.household_id
JOIN citizens AS c2 ON c2.household_id = h.household_id
JOIN panchayat_employees AS p ON p.citizen_id = c2.citizen_id;