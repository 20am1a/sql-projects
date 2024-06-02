-- After connecting to the database, run the below query inorder to use the database for analysis
USE project_medical_data_history;

-- Know the various tables within the database
SHOW TABLES;

-- To understand the attrubutes and fields in each table
SELECT * FROM admissions;
SELECT * FROM patients;
SELECT * FROM province_names;
SELECT * FROM doctors;
--------------------------------------------------------------------------------------------------------------------------------------------------
-- ATTEMPTING VARIOUS QUESTIONS IN THE ASSIGNED TASKS

-- 1. Show first name, last name, and gender of patients who's gender is 'M'
SELECT first_name, last_name, gender 
FROM patients 
WHERE gender = "M";

-- 2. Show first name and last name of patients who does not have allergies.
SELECT first_name, last_name 
FROM patients 
WHERE allergies IS NULL;

-- 3. Show first name of patients that start with the letter 'C'
SELECT first_name 
FROM patients
WHERE first_name LIKE "C%";

-- 4. Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
SELECT first_name, last_name 
FROM patients 
WHERE weight BETWEEN 100 AND 120;

-- 5. Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
UPDATE patients 
SET allergies = 'NKA'
WHERE allergies IS NULL;

-- 6. Show first name and last name concatenated into one column to show their full name.
SELECT CONCAT(first_name, ' ', last_name) AS 'Full name'
FROM patients;

-- 7. Show first name, last name, and the full province name of each patient
-- alternative #1
SELECT first_name, last_name, province_name
FROM patients
JOIN province_names ON patients.province_id = province_names.province_id;

-- alternative #2
SELECT p.first_name, p.last_name, pn.province_name
FROM patients p
JOIN province_names pn ON p.province_id = pn.province_id;

-- 8. Show how many patients have a birth_date with 2010 as the birth year
-- alternative #1
SELECT COUNT(*) AS "No of patients born in 2010"
FROM patients
WHERE YEAR(birth_date) = 2010;

-- alternative #2
SELECT COUNT(patients.birth_date)
FROM patients
WHERE birth_date BETWEEN '2010-01-01' AND '2010-12-30';

-- alternative #3
SELECT COUNT(patients.birth_date)
FROM patients
WHERE birth_date LIKE '2010%';

-- 9. Show the first_name, last_name, and height of the patient with the greatest height
-- alternative #1
SELECT first_name, last_name, height
FROM patients
ORDER BY height DESC
LIMIT 1;

-- alternative #2
SELECT first_name, last_name, MAX(height) AS height
FROM patients
GROUP BY first_name, last_name
ORDER BY height DESC
LIMIT 1;

-- 10. Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
-- alternative #1
SELECT * 
FROM patients
WHERE patient_id IN (1, 45, 534, 879, 1000);

-- alternative #2
SELECT *
FROM patients
WHERE patient_id = 1
   OR patient_id = 45
   OR patient_id = 534
   OR patient_id = 879
   OR patient_id = 1000;

-- 11. Show the total number of admissions
SELECT COUNT(patient_id) AS "Total No. of admissions"
FROM admissions;

-- 12. Show all the columns from admissions where the patient was admitted and discharged on the same day
SELECT *
FROM admissions
WHERE admission_date = discharge_date;

-- 13. Show the total number of admissions for patient_id 579.
-- alternative #1
SELECT COUNT(*) AS 'Total admission for 579'
FROM admissions
WHERE patient_id = 579;
ORDER BY patient_id


-- alternative #2
SELECT patient_id, COUNT(*) AS total_admissions
FROM admissions
WHERE patient_id = 579
GROUP BY patient_id;

-- 14. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
-- alternative #1
SELECT DISTINCT (city) AS 'unique cities' 
FROM patients
WHERE province_id = 'NS';

-- alternative #2
SELECT DISTINCT(city) AS unique_cities
FROM patients
JOIN province_names ON patients.province_id = province_names.province_id
WHERE province_names.province_id = 'NS';

-- 15. Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70
SELECT first_name, last_name, birth_date
FROM patients
WHERE height >160 AND weight >70;

-- 16. Show unique birth years from patients and order them by ascending
SELECT DISTINCT year(birth_date) AS birth_year
FROM patients
ORDER BY birth_year ASC;

-- 17. Show unique first names from the patients table which only occurs once in the list.
SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1;

-- 18. Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE 's%----s';

-- 19. Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'. Primary diagnosis is stored in the admissions table.
-- alternative #1
SELECT patients.patient_id, patients.first_name, patients.last_name
FROM patients
JOIN admissions ON patients.patient_id = admissions.patient_id
WHERE admissions.diagnosis = "Dementia";

-- alternative #2
SELECT p.patient_id, p.first_name, p.last_name
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
WHERE a.diagnosis = "Dementia";

-- 20. Display every patient's first_name. Order the list by the length of each name and then by alphbetically.
SELECT first_name
FROM patients
ORDER BY length(first_name), first_name;

-- 21. Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
-- alternative #1
SELECT
     SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS total_male_patients,
     SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS total_female_patients
FROM patients;

-- alternative #2
SELECT SUM(gender = 'M') AS Male_total, 
       SUM(gender = 'F') AS female_total 
FROM patients;

-- 22. THE SAME QUESTION IN NUMBER 21
-- 22. Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
-- alternative #1
SELECT
     SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS total_male_patients,
     SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS total_female_patients
FROM patients;

-- alternative #2
SELECT SUM(gender = 'M') AS Male_total, 
       SUM(gender = 'F') AS female_total 
FROM patients;

-- 23. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
-- alternative #1
SELECT patient_id, diagnosis
FROM admissions 
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1;

-- alternative #2
SELECT patient_id, diagnosis
FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(diagnosis = diagnosis) > 1;

-- 24. Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending
-- aternative #1
SELECT city, COUNT(patient_id) AS total_patients
FROM patients
GROUP BY city
ORDER BY total_patients DESC, city ASC;

-- alternative #2
SELECT city, COUNT(*) AS total_patients
FROM patients
GROUP BY city
ORDER BY total_patients DESC, city ASC;

-- 25. Show first name, last name and role of every person that is either patient or doctor.    The roles are either "Patient" or "Doctor"
SELECT first_name, last_name, 'patient' AS role FROM patients
UNION ALL
SELECT first_name, last_name, 'Doctor' AS role FROM doctors;

-- 26. Show all allergies ordered by popularity. Remove NULL values from query.
SELECT allergies, COUNT(*) AS popularity
FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies 
ORDER BY popularity DESC;

-- 27. Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
-- alternative #1
SELECT first_name, last_name, birth_date
FROM patients
WHERE birth_date BETWEEN '1970-01-01' AND '1979-12-31'
ORDER BY birth_date ASC;

-- alternative #2
SELECT first_name, last_name, birth_date
FROM patients
WHERE YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;

-- 28. We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order    EX: SMITH,jane
SELECT CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS full_name
FROM patients
ORDER BY first_name DESC;

-- 29. Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

SELECT pr.province_id, SUM(pa.height) AS sum_height
FROM province_names pr
         JOIN patients pa ON pr.province_id = pa.province_id
GROUP BY pr.province_id
HAVING SUM(pa.height) >= 7000;

-- 30. Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
SELECT MAX(weight) - MIN(weight) AS weight_difference
FROM patients
WHERE last_name = 'Maroni';

-- 31. Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
SELECT DAY(admission_date) AS day_of_month, COUNT(patient_id) AS total_admissions
FROM admissions
GROUP BY day_of_month
ORDER BY total_admisSions DESC;

-- 32. Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. Order the list by the weight group decending. e.g. if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
SELECT (weight / 10) * 10 AS weight_group, COUNT(*) AS total_patients
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;

-- 33. Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1. Obese is defined as weight(kg)/(height(m). Weight is in units kg. Height is in units cm.
-- alternative #1
SELECT patient_id, weight, height, 
   IF(weight / (POW(height / 100, 2)) > 30, 1, 0) AS isObese
FROM patients;

-- alternative #2
SELECT patient_id,
       weight,
       height, CASE
           WHEN weight / POWER(height / 100.00, 2) >= 30
               THEN 1
           ELSE 0
           END AS isobese
FROM patients;

-- 34. Show patient_id, first_name, last_name, and attending doctor's specialty. Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'. Check patients, admissions, and doctors tables for required information.

SELECT p.patient_id, p.first_name, p.last_name, d.specialty
FROM patients p
         JOIN admissions a ON p.patient_id = a.patient_id
         JOIN doctors d ON a.attending_doctor_id = d.doctor_id
WHERE a.diagnosis = 'Epilepsy'
  AND d.first_name = 'Lisa';
  
-- 35. All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
-- The password must be the following, in order:
    -- - patient_id
    -- - the numerical length of patient's last_name
    -- - year of patient's birth_date

SELECT DISTINCT p.patient_id, 
        CONCAT(a.patient_id, 
        LENGTH(p.last_name), YEAR(p.birth_date)) AS temp_password
FROM patients p
         JOIN admissions a ON p.patient_id = a.patient_id;