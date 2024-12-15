drop trigger if exists ESGRankingTrigger;

delimiter // 
create trigger ESGRankingTrigger after insert on facility
for each row
begin
select RANK() OVER (
	ORDER BY esg_score DESC
    ) company_esg_ranking
    FROM 
    refinitiv_esg; 
end;

drop trigger if exists ROERankingTrigger;

delimiter // 
create trigger ROERankingTrigger after insert on facility
for each row
begin
select RANK() OVER (
	ORDER BY roe_ratio DESC
    ) company_roe_ranking
    FROM 
    financial_information; 
end;


drop trigger if exists EmissionsRankingTrigger;
delimiter // 
create trigger EmissionsRankingTrigger after insert on facility
for each row
begin
select RANK() OVER (
	ORDER BY co2_emissions + ch4_emissions + n2o_emissions DESC
    ) company_emissions_ranking
    FROM 
    emissions; 
end;


-- retrieves company name, ticker, esg score 
select c.name company_name, c.symbol company_symbol, esg_score
from company c inner join refinitiv_esg using company_id; 

-- retrieves company name, ticker, and all financial data for company
select c.name company_name, c.symbol company_symbol, f.date, market_cap,
e_ratio, peg_ratio, eps_ratio, pb_ratio, es_ratio,
 curr_ratio current_ratio, ebit_ratio, roe_ratio
from company c inner join financial_information f using company_id; 

-- retrieves company name, ticker, esg, and roe
select c.name company_name, c.symbol company_symbol, esg_score, f.roe_ratio
from company c inner join refinitiv_esg re on c.company_id = re.company_id
join financial_information f on f.company_id = c.company_id; 

-- retrieves the company symbol, facility name, year, 
-- and all three types of emissions
select c.symbol company_symbol, f.name facility_name, e.year,
 e.co2_emissions, e.ch4_emissions, e.n2o_emissions
from company c join company_has_facility chf using company_id
join facility f on f.facility_id = chf.facility_id
join emissions e on f.facility_id = e.facility_id; 

-- retrieves user information and information about the company investment:
-- company name, ticker, amount_invested, return, start date, end date, and investment_category
select c.name, c.symbol, category_name investment_category, i.amount amount_invested, i.return investment_return, i.start_date, i.end_date
from company c join investment i using company_id
join investment_category ic using investment_category_id; 


-- retrieves company information: company name, ticker, description, price, industry, sector
select c.name, c.symbol, c.description, price, industry_name, sector_name
from company c join price on c.company_id = price.company_id
join industry on c.industry_id = industry.industry_id
join sector on c.sector_id = sector.sector_id; 

-- retrieves company's emission data
select c.name, re.date, esg_score, environment_emissions, environment, environment_resource_use, environment_innovation, social, 
social_human_rights, social_product_responsibility, social_workforce, social_community, governance, governance_management, government_shareholders,
governance_car_strategy
from company c join refinitiv_esg re on c.company_id = re.company_id;








 
