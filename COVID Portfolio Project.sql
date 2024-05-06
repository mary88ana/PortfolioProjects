SELECT*
FROM PortfolioProject1..CovidDeaths
ORDER BY 3,4

SELECT*
FROM PortfolioProject1..CovidVaccinations
ORDER BY 3,4

--Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject1..CovidDeaths
ORDER BY 1,2

--Looking at Total Cases Vs Total Deaths

SELECT location, date, total_cases,  total_deaths, 
CAST(total_deaths AS float)/CAST(total_cases AS float)*100 as DeathPercentage 
FROM PortfolioProject1..CovidDeaths

ORDER BY 1,2


--Looking at Total Cases Vs Total Deaths for Australia 
--Likelihood of dying if you contract Covid in Australia 

SELECT location, date, total_cases,  total_deaths, 
CAST(total_deaths AS float)/CAST(total_cases AS float)*100 as DeathPercentage 
FROM PortfolioProject1..CovidDeaths
WHERE location = 'Australia'
ORDER BY 1,2

--Looking at the Total cases VS Population 
SELECT location, date, total_cases, population ,CAST(total_cases as float)/CAST(population as float)*100 AS PercentPopulationInfected
FROM PortfolioProject1..CovidDeaths
--WHERE location IN ( 'Australia')
ORDER BY 1,2

--Looking at the Total cases VS Population 
--Shows what Percentage of Population in Australia got Covid

SELECT location, date, total_cases, population ,CAST(total_cases as float)/CAST(population as float)*100 AS PercentPopulationInfected
FROM PortfolioProject1..CovidDeaths
WHERE location IN ( 'Australia')
ORDER BY 1,2

--Looking at Countries with Highest Infection Rate compared to Population 

SELECT location, MAX(total_cases) AS HighestInfectionCount, population ,MAX(CAST(total_cases as float))/CAST(population as float)*100 AS PercentPopulationInfected
FROM PortfolioProject1..CovidDeaths
--WHERE location IN ( 'Australia')
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

--Showing Countries with Highest Death count per Population

SELECT location, MAX(CAST(total_deaths AS float)) AS TotalDeathCount
FROM PortfolioProject1..CovidDeaths
WHERE continent is not NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

--Death rate by  Continent 

SELECT continent, MAX(CAST(total_deaths AS float)) AS TotalDeathCount
FROM PortfolioProject1..CovidDeaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

--Global Numbers BY Location

SELECT   location, SUM(CAST(new_cases as float))as total_cases,
SUM(CAST(new_deaths as float)) as total_deaths, SUM(CAST(new_deaths as float))/NULLIF(SUM(CAST(new_cases as float)),0)*100 as Percentage
FROM PortfolioProject1..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER by 1,2

--Total cases worldwide

SELECT    SUM(CAST(new_cases as float))as total_cases,
SUM(CAST(new_deaths as float)) as total_deaths, SUM(CAST(new_deaths as float))/NULLIF(SUM(CAST(new_cases as float)),0)*100 as Percentage
FROM PortfolioProject1..CovidDeaths
WHERE continent is not null
--GROUP BY location
ORDER by 1,2


--Joining both tables 

SELECT *
FROM PortfolioProject1..CovidDeaths AS dea
JOIN PortfolioProject1..CovidVaccinations AS vac
ON dea.location=vac.location
AND dea.date=vac.date

--Looking at total population vs vaccinations

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
FROM PortfolioProject1..CovidDeaths AS dea
JOIN PortfolioProject1..CovidVaccinations AS vac
ON dea.location=vac.location
AND dea.date=vac.date
WHERE dea.continent is not null 
--dea.location = 'Canada'
ORDER BY 1,2,3 

--Looking at Rolling People Vaccinated based on location and date

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(float,new_vaccinations)) OVER(Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject1..CovidDeaths AS dea
JOIN PortfolioProject1..CovidVaccinations AS vac
ON dea.location=vac.location
AND dea.date=vac.date
WHERE dea.continent is not null 
--dea.location = 'Canada'
ORDER BY 1,2,3 


-- Percentage of people vaccinated at any given time based on RollingPeopleVaccinated
--USE CTE

WITH PopvsVac (continent,location,date,population,new_vaccinations, rollingpeoplevaccinated)
AS
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(float,new_vaccinations)) OVER(Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject1..CovidDeaths AS dea
JOIN PortfolioProject1..CovidVaccinations AS vac
ON dea.location=vac.location
AND dea.date=vac.date
WHERE dea.continent is not null 
--dea.location = 'Canada'
--ORDER BY 1,2,3
)
SELECT *,(RollingPeopleVaccinated/population)*100
FROM PopvsVac


--TEMP TABLE 
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(float,new_vaccinations)) OVER(Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject1..CovidDeaths AS dea
JOIN PortfolioProject1..CovidVaccinations AS vac
ON dea.location=vac.location
AND dea.date=vac.date
WHERE dea.continent is not null 
--dea.location = 'Canada'
ORDER BY 1,2,3

SELECT *,(RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated

--Creating View for Later Visualizations 

Create View PercPopulationVaccinated as
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(float,new_vaccinations)) OVER(Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject1..CovidDeaths AS dea
JOIN PortfolioProject1..CovidVaccinations AS vac
ON dea.location=vac.location
AND dea.date=vac.date
WHERE dea.continent is not null 
--dea.location = 'Canada'
--ORDER BY 1,2,3


SELECT *
FROM PercPopulationVaccinated
