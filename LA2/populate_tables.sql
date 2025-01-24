INSERT INTO households (address)
VALUES
('123 Main St, Phulera'),
('456 Elm St, Phulera'),
('789 Oak St, Jaipur'),
('101 Pine St, Phulera'),
('202 Maple St, Jaipur'),
('303 Birch St, Phulera'),
('404 Cedar St, Jaipur'),
('505 Willow St, Phulera'),
('606 Redwood St, Ajmer'),
('707 Ash St, Phulera');
INSERT INTO citizens (name, dob, gender, household_id, education, is_student, parent_id, income)
VALUES
('Aarti Sharma', '2005-04-15', 'Female', 1, '10th', TRUE, 2, 30000),  -- Parent: Ravi Kumar (citizen_id = 2)
('Ravi Kumar', '1985-07-20', 'Male', 1, 'Graduate', FALSE, NULL, 50000),
('Rahul Mehta', '2003-03-25', 'Male', 2, '10th', TRUE, 4, 35000),  -- Parent: Priya Patel (citizen_id = 4)
('Priya Patel', '1980-11-30', 'Female', 2, '12th', FALSE, NULL, 40000),
('Neha Yadav', '1990-05-05', 'Female', 3, 'Graduate', FALSE, NULL, 60000),
('Sandeep Reddy', '1985-01-12', 'Male', 4, 'Post-Graduate', FALSE, NULL, 70000),
('Sunita Verma', '2007-08-22', 'Female', 5, 'Primary', TRUE, 6, 25000),  -- Parent: Neha Yadav (citizen_id = 6)
('Vikram Joshi', '1990-02-13', 'Male', 6, '12th', FALSE, NULL, 45000),
('Isha Gupta', '2006-09-17', 'Female', 6, '10th', TRUE, 8, 28000),  -- Parent: Vikram Joshi (citizen_id = 8)
('Arvind Singh', '2004-03-10', 'Male', 7, '10th', TRUE, 9, 32000),  -- Parent: Sandeep Reddy (citizen_id = 9)
('Kavita Nair', '1985-12-25', 'Female', 8, 'Graduate', FALSE, NULL, 55000),
('Manoj Desai', '1994-01-05', 'Male', 9, '12th', FALSE, NULL, 48000),
('Sita Devi', '2008-06-18', 'Female', 10, 'Illiterate', TRUE, NULL, 26000),
('Karan Thakur', '1991-09-10', 'Male', 1, 'Graduate', FALSE, NULL, 50000),
('Meera Joshi', '1990-12-30', 'Female', 2, 'Post-Graduate', FALSE, NULL, 65000),
('Anil Kumar', '2001-02-04', 'Male', 3, '12th', FALSE, NULL, 47000),
('Pooja Sharma', '1996-10-17', 'Female', 4, 'Graduate', FALSE, NULL, 52000),
('Rita Kapoor', '2000-07-12', 'Female', 5, '12th', FALSE, NULL, 46000),
('Sunil Bhat', '2007-01-21', 'Male', 6, '10th', TRUE, NULL, 30000),
('Tina Rao', '2002-06-06', 'Female', 7, '10th', TRUE, NULL, 31000),
('Ananya Joshi', '1999-11-25', 'Female', 8, 'Graduate', FALSE, NULL, 56000),
('Rajesh Agarwal', '2004-04-02', 'Male', 9, 'Primary', TRUE, NULL, 24000),
('Swati Singh', '2003-07-14', 'Female', 10, '10th', TRUE, NULL, 33000),
('Vikas Patel', '2006-05-19', 'Male', 1, '12th', TRUE, 12, 38000),  -- Parent: Kavita Nair (citizen_id = 12)
('Kajal Gupta', '1998-09-01', 'Female', 2, 'Post-Graduate', FALSE, NULL, 70000),
('Sandeep Yadav', '2001-01-27', 'Male', 3, 'Graduate', FALSE, NULL, 55000),
('Asha Rao', '2006-12-03', 'Female', 4, '10th', TRUE, 13, 31000),  -- Parent: Pooja Sharma (citizen_id = 13)
('Siddharth Bansal', '2003-10-14', 'Male', 5, '12th', TRUE, NULL, 33000),
('Chandni Mehta', '1997-05-08', 'Female', 6, 'Graduate', FALSE, NULL, 60000);
INSERT INTO land_records (citizen_id, land_area, crop_type)
VALUES
(1, 2.5, 'Rice'),  -- Citizen: Aarti Sharma (citizen_id = 1)
(2, 1.8, 'Wheat'), -- Citizen: Ravi Kumar (citizen_id = 2)
(3, 0.5, 'Rice'),  -- Citizen: Rahul Mehta (citizen_id = 3)
(4, 3.2, 'Sugarcane'), -- Citizen: Priya Patel (citizen_id = 4)
(5, 1.0, 'Cotton'), -- Citizen: Neha Yadav (citizen_id = 5)
(6, 0.75, 'Rice'),  -- Citizen: Sandeep Reddy (citizen_id = 6)
(7, 2.0, 'Rice'),  -- Citizen: Sunita Verma (citizen_id = 7)
(8, 1.5, 'Pulses'), -- Citizen: Vikram Joshi (citizen_id = 8)
(9, 4.0, 'Barley'), -- Citizen: Isha Gupta (citizen_id = 9)
(10, 1.2, 'Wheat'), -- Citizen: Arvind Singh (citizen_id = 10)
(11, 0.9, 'Rice'), -- Citizen: Kavita Nair (citizen_id = 11)
(12, 3.0, 'Rice'), -- Citizen: Manoj Desai (citizen_id = 12)
(13, 1.8, 'Corn'), -- Citizen: Sita Devi (citizen_id = 13)
(14, 2.3, 'Rice'), -- Citizen: Karan Thakur (citizen_id = 14)
(15, 1.6, 'Pulses'), -- Citizen: Meera Joshi (citizen_id = 15)
(16, 0.8, 'Cotton'), -- Citizen: Anil Kumar (citizen_id = 16)
(17, 5.0, 'Rice'), -- Citizen: Pooja Sharma (citizen_id = 17)
(18, 2.2, 'Wheat'), -- Citizen: Rita Kapoor (citizen_id = 18)
(19, 3.5, 'Sugarcane'), -- Citizen: Sunil Bhat (citizen_id = 19)
(20, 1.7, 'Rice'); -- Citizen: Tina Rao (citizen_id = 20)
INSERT INTO panchayat_employees (citizen_id, role)
VALUES
(2, 'Pradhan'),  -- Citizen: Ravi Kumar (citizen_id = 2) - Role: Pradhan
(1, 'Secretary'),   -- Citizen: Aarti Sharma (citizen_id = 1) - Role: Secretary
(3, 'Member'),     -- Citizen: Rahul Mehta (citizen_id = 3) - Role: Member
(4, 'Member'),     -- Citizen: Priya Patel (citizen_id = 4) - Role: Member
(5, 'Secretary'),  -- Citizen: Neha Yadav (citizen_id = 5) - Role: Secretary
(6, 'Member'),     -- Citizen: Sandeep Reddy (citizen_id = 6) - Role: Member
(7, 'Member'),     -- Citizen: Sunita Verma (citizen_id = 7) - Role: Member
(8, 'Secretary'),  -- Citizen: Vikram Joshi (citizen_id = 8) - Role: Secretary
(9, 'Member'),     -- Citizen: Isha Gupta (citizen_id = 9) - Role: Member
(10, 'Member');    -- Citizen: Arvind Singh (citizen_id = 10) - Role: Member
INSERT INTO assets (type, location, installation_date)
VALUES
('Street Light', 'Phulera', '2024-01-10'),
('Water Tank', 'Sikandra', '2023-07-15'),
('School Building', 'Madhapur', '2022-09-05'),
('Street Light', 'Phulera', '2024-02-20'),
('Street Light', 'Phulera', '2024-01-25'),
('Water Tank', 'Radhapur', '2023-06-30'),
('Primary School', 'Sikandra', '2021-03-18'),
('Public Toilet', 'Phulera', '2022-08-22'),
('Hand Pump', 'Madhapur', '2023-05-12'),
('Health Center', 'Sikandra', '2021-04-01'),
('Street Light', 'Madhapur', '2024-01-08'),
('Street Light', 'Radhapur', '2023-12-10'),
('Community Hall', 'Phulera', '2023-08-14'),
('Street Light', 'Madhapur', '2024-01-20'),
('Water Tank', 'Phulera', '2023-09-11'),
('Primary School', 'Radhapur', '2022-05-17'),
('Street Light', 'Radhapur', '2024-03-05'),
('Public Toilet', 'Madhapur', '2022-11-20'),
('Hand Pump', 'Phulera', '2023-07-02'),
('Health Center', 'Radhapur', '2021-11-25'),
('School Building', 'Madhapur', '2020-10-10'),
('Street Light', 'Sikandra', '2024-01-15'),
('Street Light', 'Madhapur', '2024-02-03'),
('Community Hall', 'Radhapur', '2023-10-22'),
('Hand Pump', 'Sikandra', '2022-12-14'),
('Health Center', 'Phulera', '2021-09-08'),
('Primary School', 'Phulera', '2021-02-25'),
('Water Tank', 'Madhapur', '2023-03-21'),
('Street Light', 'Sikandra', '2024-03-10');
INSERT INTO vaccinations (citizen_id, vaccine_type, date_administered)
VALUES
(1, 'COVID-19', '2024-01-10'),  -- Citizen: Aarti Sharma (citizen_id = 1)
(2, 'COVID-19', '2024-02-20'),  -- Citizen: Ravi Kumar (citizen_id = 2)
(3, 'Hepatitis B', '2023-11-05'),  -- Citizen: Rahul Mehta (citizen_id = 3)
(4, 'Polio', '2024-01-25'),  -- Citizen: Priya Patel (citizen_id = 4)
(5, 'COVID-19', '2024-03-15'),  -- Citizen: Neha Yadav (citizen_id = 5)
(6, 'Measles', '2023-09-10'),  -- Citizen: Sandeep Reddy (citizen_id = 6)
(7, 'Hepatitis B', '2023-12-18'),  -- Citizen: Sunita Verma (citizen_id = 7)
(8, 'COVID-19', '2024-01-18'),  -- Citizen: Vikram Joshi (citizen_id = 8)
(9, 'Flu', '2024-03-01'),  -- Citizen: Isha Gupta (citizen_id = 9)
(10, 'Polio', '2024-01-12'),  -- Citizen: Arvind Singh (citizen_id = 10)
(11, 'COVID-19', '2024-02-25'),  -- Citizen: Kavita Nair (citizen_id = 11)
(12, 'Measles', '2023-08-20'),  -- Citizen: Manoj Desai (citizen_id = 12)
(13, 'Hepatitis B', '2023-05-30'),  -- Citizen: Sita Devi (citizen_id = 13)
(14, 'COVID-19', '2024-03-12'),  -- Citizen: Karan Thakur (citizen_id = 14)
(15, 'Flu', '2023-10-25'),  -- Citizen: Meera Joshi (citizen_id = 15)
(16, 'Polio', '2024-02-02'),  -- Citizen: Anil Kumar (citizen_id = 16)
(17, 'COVID-19', '2024-01-28'),  -- Citizen: Pooja Sharma (citizen_id = 17)
(18, 'Hepatitis B', '2023-06-15'),  -- Citizen: Rita Kapoor (citizen_id = 18)
(19, 'Measles', '2023-07-05'),  -- Citizen: Sunil Bhat (citizen_id = 19)
(20, 'COVID-19', '2024-03-08');  -- Citizen: Tina Rao (citizen_id = 20)