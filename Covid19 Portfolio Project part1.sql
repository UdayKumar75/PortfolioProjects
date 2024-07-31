select * from [dbo].[CovidDeath1] where nullif(continent,'') is not null order by 1,2


select * from [dbo].[CovidVaccinations1] where nullif(continent,'') is not null order by 1,2





select location , date , population , total_cases ,new_cases , total_deaths from [dbo].[CovidDeath1]
where nullif(continent,'') is not null 
order by 1,2





select location, date, population, total_cases, total_deaths, 
(convert(float,total_deaths)/nullif(convert(float,total_cases),0))*100 as DeathPercentage
from [dbo].[CovidDeath1]
where nullif(continent,'') is not null and location = 'India' 





select location, population, max(total_cases) as MaximumInfectedCount , 
max(convert(float,total_cases)/nullif(convert(float,population),0))*100 as PercentagePopulationInfected
from [dbo].[CovidDeath1] 
where nullif(continent,'') is not null 
group by location, population order by PercentagePopulationInfected desc





select location, max(cast(total_deaths as int)) as TotalDeathCounts from [dbo].[CovidDeath1]  
where nullif(continent,'') is not null 
group by location order by TotalDeathCounts desc 





select location , max(cast(total_deaths as int)) as TotalDeathCounts from [dbo].[CovidDeath1]  
where nullif(continent,'') is null 
group by location order by TotalDeathCounts desc 





select date, sum(convert(float,new_cases)) as totalcases,sum(convert(float,new_deaths)) as totaldeaths, 
sum(convert(float,total_deaths))/sum(nullif(convert(float,total_cases),0))*100 as DeathPercentage
from [dbo].[CovidDeath1]
where nullif(continent,'') is not null group by date order by convert(datetime,date,103) asc





select sum(convert(float,new_cases)) as totalcases,sum(convert(float,new_deaths)) as totaldeaths, 
sum(convert(float,total_deaths))/sum(nullif(convert(float,total_cases),0))*100 as DeathPercentage
from [dbo].[CovidDeath1]
where nullif(continent,'') is not null





select death.continent, death.location, vacc.date, death.population, nullif(vacc.new_vaccinations,0) ,
sum(convert(int,vacc.new_vaccinations)) over
(partition by vacc.location order by vacc.location, convert(datetime,vacc.date,103) asc) as RollingPeopleVaccinated
from [dbo].[CovidDeath1] death join [dbo].[CovidVaccinations1] vacc 
on death.location=vacc.location and death.date=vacc.date 
where nullif(death.continent,'') is not null order by 1,2





with popVSvacc(Continent,Location,Date,Population,New_Vaccination,RollingPeopleVaccinated) as
(
select death.continent, death.location, vacc.date, death.population, nullif(vacc.new_vaccinations,0) ,
sum(convert(int,vacc.new_vaccinations)) over
(partition by vacc.location order by vacc.location, convert(datetime,vacc.date,103) asc) as RollingPeopleVaccinated
from [dbo].[CovidDeath1] death join [dbo].[CovidVaccinations1] vacc 
on death.location=vacc.location and death.date=vacc.date 
where nullif(death.continent,'') is not null 
)
select *, (RollingPeopleVaccinated/nullif(Population,0))*100 from popVSvacc





drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric)

insert into #PercentPopulationVaccinated
select death.continent, death.location, convert(datetime,vacc.date,103), cast(death.population as bigint),
nullif(convert(int,vacc.new_vaccinations),0) ,sum(convert(int,vacc.new_vaccinations)) over
(partition by vacc.location order by vacc.location, convert(datetime,vacc.date,103)) as RollingPeopleVaccinated
from [dbo].[CovidDeath1] death join [dbo].[CovidVaccinations1] vacc 
on death.location=vacc.location and death.date=vacc.date 
--where nullif(death.continent,'') is not null 

select *, (RollingPeopleVaccinated/nullif(Population,0))*100 from #PercentPopulationVaccinated





create view PercentPopulationVaccinated as
select death.continent, death.location, vacc.date, death.population, vacc.new_vaccinations ,
sum(convert(int,vacc.new_vaccinations)) over
(partition by vacc.location order by vacc.location, convert(datetime,vacc.date,103) asc) as RollingPeopleVaccinated
from [dbo].[CovidDeath1] death join [dbo].[CovidVaccinations1] vacc 
on death.location=vacc.location and death.date=vacc.date 
where nullif(death.continent,'') is not null 


select * from PercentPopulationVaccinated