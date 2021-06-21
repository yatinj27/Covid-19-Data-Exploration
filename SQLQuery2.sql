--Quick Overview of the Data
SELECT * 
FROM PortfolioProject..CovidDeaths
--

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..CovidDeaths
order by 1,2

--Total cases VS total Deaths
SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
order by 1,2

--Total Cases VS totalDeaths for india
SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
where location = 'India'
order by 1,2

-- Percentage of population Infected in India
SELECT location,date,total_cases,population, (total_cases/population)*100 as InfectedPopulation
FROM PortfolioProject..CovidDeaths
where location = 'India'
order by 1,2

-- Looking at countries with highest Infection rate by population
SELECT location,population, max(total_cases/population)*100 as InfectionRate
FROM PortfolioProject..CovidDeaths
where continent is not null
group by location,population
order by InfectionRate desc



-- Countries with highest Death Count 
Select Location, max(cast(total_deaths AS int)) as DeathCounts
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by DeathCounts desc

--Continent with highest Death Count 
Select location, max(cast(total_deaths AS int)) as DeathCounts
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by DeathCounts desc

--GLOBAL NUMBERS
--Global death rate

SELECT sum(cast(new_deaths as int)) as TotalDeaths,sum(new_cases) as totalCases, SUM(cast(new_deaths as int))/sum(new_cases)*100 as GlobalDeathRate
from PortfolioProject..CovidDeaths
where continent is not null


--looking at total population vaccinated by each country
--USING CTE
with PopvsVac  (Continent,Location,Date,Population,NewVaccinations,RollingPeopleVaccinated)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as RollingCountVaccinations
FROM PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated 
from PopvsVac

-- Creating View for visualization
Create View PopulationVaccinated as
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as RollingCountVaccinations
FROM PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null



create view IndiaDeathRate as
SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
where location = 'India'
--order by 1,2