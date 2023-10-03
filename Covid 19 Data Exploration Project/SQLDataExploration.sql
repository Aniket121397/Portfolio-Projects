--Select * 
--From PortfolioProject..CovidDeaths
--Order By 3,4

--Select * 
--From PortfolioProject..CovidVaccinations
--Order By 3,4


Select location,date , total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
Order By 1,2

--Showing Total Cases vs total deaths and  death percentage in India

Select location,date , total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%india%'
Order By total_cases DESC

-- Looking at Total Cases vs Population in India
-- Shows what percentage of population has got covid in India

Select location,date , total_cases,population,(total_deaths/population)*100 as CovidPercentage
From PortfolioProject..CovidDeaths
Where location like '%india%'
Order By CovidPercentage DESC

-- Looking at countries  with Highest Infection Rate compared to Population

Select location,population,MAX(total_cases) as HighestInfectedCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group By location, population
Order By PercentPopulationInfected DESC


--Showing Countries With Highest Death Count

Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not NULL
Group By location
Order By TotalDeathCount DESC


--Showing Continent With Highest Death Count
Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not NULL
Group By continent
Order By TotalDeathCount DESC


-- Global Numbers

Select date ,SUM(new_cases) as total_cases , SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not NULL
Group by date	
Order by total_deaths DESC

-- Looking at Total Population vs Vaccination
-- Use CTE
With PopvsVac (continent , location , date , population , new_vaccinations , RollingPeopleVaccinated)
as
(
Select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER (Partition By dea.location Order By dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not NULL
--Order BY 2, 3
)

Select * , (RollingPeopleVaccinated/population)* 100
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *
From PercentPopulationVaccinated