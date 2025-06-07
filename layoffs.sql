select 
  * 
from 
  layoffs;
create table layoffs_staging like layoffs;
insert layoffs_staging 
select 
  * 
from 
  layoffs;
select 
  * 
from 
  layoffs_staging;
-- remove dublicate 
DELETE FROM 
  layoffs_staging 
WHERE 
  (
    company, location, industry, total_laid_off, 
    percentage_laid_off, date, stage, 
    country, funds_raised_millions
  ) IN (
    SELECT 
      company, 
      location, 
      industry, 
      total_laid_off, 
      percentage_laid_off, 
      date, 
      stage, 
      country, 
      funds_raised_millions 
    FROM 
      (
        SELECT 
          *, 
          ROW_NUMBER() OVER (
            PARTITION BY company, 
            location, 
            industry, 
            total_laid_off, 
            percentage_laid_off, 
            date, 
            stage, 
            country, 
            funds_raised_millions 
            ORDER BY 
              company
          ) AS rn 
        FROM 
          layoffs_staging
      ) AS ranked 
    WHERE 
      rn > 1
  );
SELECT 
  company, 
  location, 
  industry, 
  total_laid_off, 
  percentage_laid_off, 
  date, 
  stage, 
  country, 
  funds_raised_millions, 
  COUNT(*) AS duplicate_count 
FROM 
  layoffs_staging 
GROUP BY 
  company, 
  location, 
  industry, 
  total_laid_off, 
  percentage_laid_off, 
  date, 
  stage, 
  country, 
  funds_raised_millions 
HAVING 
  COUNT(*) > 1;
-- standardize the data  
select 
  company 
from 
  layoffs_staging;
UPDATE 
  layoffs_staging 
SET 
  company = TRIM(company);
select 
  distinct industry 
from 
  layoffs_staging 
order by 
  1;
UPDATE 
  layoffs_staging 
SET 
  industry = 'Crypto' 
WHERE 
  LOWER(industry) IN (
    'cryptocurrency', 'crypto currency', 
    'crypto'
  );
select 
  distinct country 
from 
  layoffs_staging;
select 
  * 
from 
  layoffs_staging 
where 
  country like "United States";
UPDATE 
  layoffs_staging 
SET 
  country = 'United States' 
WHERE 
  TRIM(country) = 'United States.';
ALTER TABLE 
  layoffs_staging 
ADD 
  COLUMN date_clean DATE;
select 
  date 
from 
  layoffs_staging;
-- null and blanck values 
DELETE FROM 
  layoffs_staging 
WHERE 
  (
    company IS NULL 
    OR TRIM(company) = ''
  ) 
  AND (
    location IS NULL 
    OR TRIM(location) = ''
  ) 
  AND (
    industry IS NULL 
    OR TRIM(industry) = ''
  ) 
  AND total_laid_off IS NULL 
  AND percentage_laid_off IS NULL 
  AND (
    date IS NULL 
    OR TRIM(date) = ''
  ) 
  AND (
    stage IS NULL 
    OR TRIM(stage) = ''
  ) 
  AND (
    country IS NULL 
    OR TRIM(country) = ''
  ) 
  AND funds_raised_millions IS NULL;
DELETE FROM 
  layoffs_staging 
WHERE 
  company IS NULL 
  OR location IS NULL 
  OR industry IS NULL 
  OR total_laid_off IS NULL 
  OR percentage_laid_off IS NULL 
  OR date IS NULL 
  OR stage IS NULL 
  OR country IS NULL 
  OR funds_raised_millions IS NULL;
select 
  * 
from 
  layoffs_staging;
-- remove any columns 
alter TABLE 
  layoffs_staging 
DROP 
  column date_clean;
select 
  * 
from 
  layoffs_staging
