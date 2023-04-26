--total cases by location
SELECT
	location, 
	SUM(new_cases) as total_number_of_cases
FROM
	[Portfolio project]..covid_death
WHERE
	continent != ' '
	and
	location not in ('world', 'european union', 'international', 'high income', 'low income', 'upper middle income', 
	'lower middle income', 'asia', 'north america', 'south america', 'oceania', 'africa', 'europe' )
GROUP BY
	location
ORDER BY
	total_number_of_cases desc



--total death by location
SELECT
	location, 
	SUM(new_deaths) as total_number_of_death
FROM
	[Portfolio project]..covid_death
WHERE
	continent != ' '
	and
	location not in ('world', 'european union', 'international', 'high income', 'low income', 'upper middle income', 
	'lower middle income', 'asia', 'north america', 'south america', 'oceania', 'africa', 'europe' )
GROUP BY
	location
ORDER BY
	total_number_of_death desc




--total vaccinations by location
SELECT
	location, 
	SUM(new_vaccinations) as total_number_of_vaccinations
FROM
	[Portfolio project]..covid_vaccination
WHERE
	continent != ' '
	and
	location not in ('world', 'european union', 'international', 'high income', 'low income', 'upper middle income', 
	'lower middle income', 'asia', 'north america', 'south america', 'oceania', 'africa', 'europe' )
GROUP BY
	location
ORDER BY
	total_number_of_vaccinations desc



--sum of cases by country and date
SELECT 
	location,
	date,
	new_cases
FROM 
	[Portfolio project]..covid_death
WHERE
	continent != ' '
	and
	location not in ('world', 'european union', 'international', 'high income', 'low income', 'upper middle income', 
	'lower middle income', 'asia', 'north america', 'south america', 'oceania', 'africa', 'europe' )
ORDER BY
	location,
	date


--sum of death by country and date
SELECT 
	location,
	date,
	new_deaths
FROM 
	[Portfolio project]..covid_death
WHERE
	continent != ' '
	and
	location not in ('world', 'european union', 'international', 'high income', 'low income', 'upper middle income', 
	'lower middle income', 'asia', 'north america', 'south america', 'oceania', 'africa', 'europe' )
ORDER BY
	location,
	date


--sum of vaccinations by country and date
SELECT 
	location,
	date,
	new_vaccinations
FROM 
	[Portfolio project]..covid_vaccination
WHERE
	continent != ' '
	and
	location not in ('world', 'european union', 'international', 'high income', 'low income', 'upper middle income', 
	'lower middle income', 'asia', 'north america', 'south america', 'oceania', 'africa', 'europe' )
ORDER BY
	location,
	date


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