/*
Memo_0
9/12/24
PS
*/

// Set directory
cd "/Users/pranjal/Library/CloudStorage/OneDrive-CentreCollegeofKentucky/ECO 392/Memo_0"

// Open GDP data
import excel "GDP.xls", sheet("Sheet1") firstrow

// Set unit of time
tsset observation_date

// Reconstruct date
gen year = year(observation_date)
gen quarter = quarter(observation_date)

// Combine year and quarter into a quarterly date format
gen date = yq(year, quarter)
tsset date, quarterly

// Format the date variable for quarterly data
format date %tq

// Rename GDP variable for consistency
rename GDP gdp

// Create a lagged GDP variable for growth rate calculation
gen gdp_1 = l1.gdp

// Generate growth rate
gen grwth_gdp = (gdp - gdp_1)/gdp_1

// Display summary statistics for the GDP growth rate
sum grwth_gdp

// Drop unnecessary variables
drop observation_date year quarter gdp_1

// Save GDP data set
save gdp.dta, replace

// Clear the current dataset from memory
clear

// Open Debt data
import excel "GFDEBTN.xls", sheet("Sheet1") firstrow

// Set unit of time
tsset observation_date

// Reconstruct date
gen year = year(observation_date)
gen quarter = quarter(observation_date)

// Combine year and quarter into a quarterly date format
gen date = yq(year, quarter)
tsset date, quarterly

// Format the date variable for quarterly data
format date %tq

// Rename GFDEBTN variable for consistency
rename GFDEBTN debt

// Convert debt to billions from millions 
replace debt = debt/1000

// Create a lagged Debt variable for growth rate calculation
gen debt_1 = l1.debt

// Generate growth rate
gen grwth_debt = (debt - debt_1)/debt_1

// Display summary statistics for the Debt growth rate
sum grwth_debt

// Drop unnecessary variables
drop observation_date year quarter debt_1

// Merge the GDP and Debt datasets by date
merge 1:1 date using gdp.dta

// Generate single graph with both variables
tsline gdp debt, legend(order(1 "GDP" 2 "Federal Debt")) ///
    xtitle(Year) ytitle("Value (in billions)") ///
    subtitle("Federal Debt and GDP: 1966-2024") ///
    note("Source: St. Louis FRED") tline(2012q4)

// Arrange variables and drop the merge indicator variable
order date gdp debt grwth_gdp grwth_debt
drop _merge

// Save the final merged dataset
save memo_0.dta, replace
