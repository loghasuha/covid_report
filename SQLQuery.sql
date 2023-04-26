--alter the data type in table 
use [Portfolio project];
alter table dbo.covid_death alter column total_deaths float;

use [Portfolio project];
alter table dbo.covid_death alter column new_cases float;

use [Portfolio project];
alter table dbo.covid_death alter column total_cases float;

use [Portfolio project];
alter table dbo.covid_death alter column date date;

use [Portfolio project];
alter table dbo.covid_death alter column population float;

use [Portfolio project];
alter table dbo.covid_death alter column reproduction_rate float;

use [Portfolio project];
alter table dbo.covid_vaccination alter column new_vaccinations float;

use [Portfolio project];
alter table dbo.covid_death alter column new_deaths float;


--Calculating death percentage
SELECT 
	location,
	sum(new_cases) as total_new_cases,
	sum(new_deaths) as total_new_death,
	Case when sum(new_cases)=0 then null
		Else ((sum(new_deaths))/(sum(new_cases)))*100 
		End as death_percentage
FROM 
	[Portfolio project]..covid_death
GROUP BY
	location
ORDER BY
	location


--total cases by continent
SELECT
	location,
	SUM(new_cases) as total_number_of_cases
FROM
	[Portfolio project]..covid_death
WHERE
	continent = ' '
	and
	location not in ('world', 'european union', 'international', 'high income', 'low income', 'upper middle income', 'lower middle income')
GROUP BY	
	location
ORDER BY
	total_number_of_cases desc



-- calculating most covid affected country
SELECT
	location,
	population,
	MAX(total_cases) as max_total_cases,
	MAX((total_cases)/population)*100 as max_infected_percentage
FROM
	[Portfolio project]..covid_death
GROUP BY 
	location,
	Population
ORDER BY
	max_infected_percentage desc
	

	
--Max death by continent
SELECT
	continent,
	MAX(total_deaths) as max_total_death
FROM
	[Portfolio project]..covid_death
WHERE
	continent != ' '
GROUP BY 
	continent
ORDER BY
	max_total_death desc

--where function
SELECT 
	location,
	date,
	total_cases,
	total_deaths
FROM 
	[Portfolio project]..covid_death
WHERE
	location like '%states%'




 --Merging the table and performing calculation
 Select 
	d.continent,
	d.location,
	d.date,
	d.population,
	v.new_vaccinations,
	SUM(CAST(v.new_vaccinations AS bigint)) OVER
		(partition by d.location ORDER BY D.location, D.date) as rolling_vaccination
 FROM [Portfolio project]..covid_death d
 JOIN [Portfolio project]..covid_vaccination v
	ON d.location = v.location
	AND d.date = v.date
WHERE
	d.continent != ' '
ORDER BY
	2,3



--creating temp table
WITH PopVsVac (continent, location, date, population, new_vaccinations, rolling_vaccination)
as
(
 Select 
	d.continent,
	d.location,
	d.date,
	d.population,
	v.new_vaccinations,
	SUM(CAST(v.new_vaccinations AS bigint)) OVER
		(partition by d.location ORDER BY D.location, D.date) as rolling_vaccination
 FROM [Portfolio project]..covid_death d
 JOIN [Portfolio project]..covid_vaccination v
	ON d.location = v.location
	AND d.date = v.date
WHERE
	d.continent != ' '
)
SELECT *, (rolling_vaccination/population)*100 as vaccination_percentage
FROM PopVsVac



--create table in database
DROP TABLE if EXISTS PercentOfPopulationVaccinated
CREATE TABLE PercentOfPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date date,
population numeric,
new_vaccinations numeric,
rolling_vaccination numeric
)
INSERT INTO PercentOfPopulationVaccinated
 Select 
	d.continent,
	d.location,
	d.date,
	d.population,
	CAST(v.new_vaccinations as bigint),
	SUM(CAST(v.new_vaccinations AS bigint)) OVER
		(partition by d.location ORDER BY D.location, D.date) as rolling_vaccination
 FROM [Portfolio project]..covid_death d
 JOIN [Portfolio project]..covid_vaccination v
	ON d.location = v.location
	AND d.date = v.date
 WHERE
	d.continent != ' '

--Performing calculation from the table created
SELECT *, 
	(rolling_vaccination/population)*100 as vaccination_percentage
FROM 
	PercentOfPopulationVaccinated
ORDER BY 
	location


