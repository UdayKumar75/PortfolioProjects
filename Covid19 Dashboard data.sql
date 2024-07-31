select sum(convert(float,new_cases)) as totalcases,sum(convert(float,new_deaths)) as totaldeaths, 
sum(convert(float,total_deaths))/sum(nullif(convert(float,total_cases),0))*100 as DeathPercentage
from [dbo].[CovidDeath1]
where nullif(continent,'') is not null





select location, max(cast(total_deaths as int)) as TotalDeathCounts from [dbo].[CovidDeath1]  
where nullif(continent,'') is null and location not in ('World','European Union','International')
group by location order by TotalDeathCounts desc 





select location, population, max(cast(total_cases as int)) as MaximumInfectedCount , 
max(convert(int,total_cases)/nullif(convert(float,population),0))*100 as PercentagePopulationInfected
from [dbo].[CovidDeath1] 
where nullif(continent,'') is not null 
group by location, population order by PercentagePopulationInfected desc





select location, population,date, max(cast(total_cases as int)) as MaximumInfectedCount , 
max(convert(int,total_cases)/nullif(convert(float,population),0))*100 as PercentagePopulationInfected
from [dbo].[CovidDeath1] 
where nullif(continent,'') is not null 
group by location, population,date order by PercentagePopulationInfected desc
