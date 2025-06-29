CREATE DATABASE ds;

SELECT * FROM ds_salaries;

-- 1. cek data null
SELECT *
FROM ds_salaries
WHERE work_year IS NULL
OR experience_level IS NULL
OR employment_type IS NULL
OR job_title IS NULL
OR salary IS NULL
OR salary_currency IS NULL
OR salary_in_usd IS NULL
OR employee_residence IS NULL
OR remote_ratio IS NULL
OR company_location IS NULL
OR company_size IS NULL;

-- 2. melihat ada job_title apa saja
SELECT DISTINCT job_title 
FROM ds_salaries 
ORDER BY job_title;

-- 3. job_title apa saja yang berkaitan dengan data analyst
SELECT DISTINCT job_title 
FROM ds_salaries 
WHERE job_title LIKE '%data analyst%' 
ORDER BY job_title;

-- 4. berapa rata-rata gaji data analyst dalam rupiah?
SELECT (AVG(salary_in_usd)*15000)/12 avg_salary_in_rp FROM ds_salaries;

-- 4.1 berapa rata-rata gaji data analyst berdasarkan experience_level?
SELECT experience_level, (AVG(salary_in_usd)*15000)/12 avg_salary_exp_level 
FROM ds_salaries 
GROUP BY 1;

-- 4.2 berapa rata-rata gaji data analyst berdasarkan experience_level dan employment_type?
SELECT experience_level, 
	employment_type, 
    (AVG(salary_in_usd)*15000)/12 avg_salary_exp_level 
FROM ds_salaries 
GROUP BY 1,2
ORDER BY 1,2;

-- 5. negara dengan gaji yang menarik untuk posisi data analyst?
SELECT company_location, 
	AVG(salary_in_usd) avg_salary
FROM ds_salaries
WHERE job_title LIKE '%data analyst%'
	AND employment_type = 'FT'
    AND experience_level IN ('MI','EN')
GROUP BY company_location
HAVING avg_salary >= 20000;

-- 6. di tahun berapa, kenaikan gaji dari mid ke expert itu memiliki kenaikan gaji tertinggi?
-- (untuk pekerjaan yang berkaitan dg data analyst, penuh waktu)
WITH ds_1 AS (
	SELECT work_year,
		AVG(salary_in_usd) AS rerata_gaji_ex
	FROM ds_salaries
    WHERE employment_type = 'FT'
		AND experience_level = 'EX'
        AND job_title LIKE '%data analyst%'
	GROUP BY 1
), ds_2 AS (
	SELECT work_year,
		AVG(salary_in_usd) AS rerata_gaji_mid
	FROM ds_salaries
    WHERE employment_type = 'FT'
		AND experience_level = 'MI'
        AND job_title LIKE '%data analyst%'
	GROUP BY 1
), t_year AS(
	SELECT DISTINCT work_year
    FROM ds_salaries
)

SELECT t_year.work_year, 
	ds_1.rerata_gaji_ex, 
	ds_2.rerata_gaji_mid, 
	ds_1.rerata_gaji_ex - ds_2.rerata_gaji_mid differences
FROM t_year
LEFT JOIN ds_1 
	ON ds_1.work_year = t_year.work_year
LEFT JOIN ds_2
	ON ds_2.work_year = t_year.work_year;
