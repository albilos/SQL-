SELECT * 
FROM ProjectsPortofolio..CovidVaccinations$

-- Covid_deaths

SELECT * 
FROM ProjectsPortofolio..CovidDeaths$

-- TOTAL CASES vs TOTAL DEATHS
SELECT location, date, total_cases, (total_deaths/total_cases) as deathspourcentage
FROM ProjectsPortofolio..CovidDeaths$
Where location like '%States%'
order by 1,2

-- TOTAL CASES VS POPULATION
SELECT location, population, total_cases, (total_cases/population) as Infectedpourcentage
FROM ProjectsPortofolio..CovidDeaths$
--Where location like '%States%'
order by 1,2

-- countries highest Infection per population

SELECT location, MAX(cast(total_deaths as int)) as TotaldeathsCount
FROM ProjectsPortofolio..CovidDeaths$
Where continent is not null
group by location
order by TotaldeathsCount desc



-- countinent highest Infection per population
SELECT continent, MAX(cast(total_deaths as int)) as TotaldeathsCount
FROM ProjectsPortofolio..CovidDeaths$
Where continent is not null
group by continent
order by TotaldeathsCount desc

---NUMBER CASES

SELECT date, SUM(new_cases), SUM(cast(new_deaths as int)) as ToTalnewdeaths
FROM ProjectsPortofolio..CovidDeaths$
WHERE continent is null
group by  date

-- looking at total population vs vaccination

with Popvsvac (continent, location, date, population, new_vaccinations,RollingPeopleVaccinated)

as

(

SELECT  dead.continent, dead.location, dead.date,dead.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dead.location order by dead.location,
dead.date) as RollingPeopleVaccinated

FROM ProjectsPortofolio..CovidDeaths$ dead
join ProjectsPortofolio..CovidVaccinations$ vac
    on dead.location = vac.location
    and dead.date   = vac.date
WHERE dead.continent is not null
--order by 2,3
)
