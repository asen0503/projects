//mortality//
clear all
 use "/Users/anupamasen/Downloads/state_mort_month.dta"
 format month %tm
 gen date1= ym(year, month)
 format date1 %tm
 sort date1 state
 encode state, gen(state1)
 xtset state1 date1, monthly
 xtline deaths
 xtline deaths if state=="Uttar Pradesh"
 
 
 
//excess mortality//
 clear all
import excel "/Users/anupamasen/Library/Mobile Documents/com~apple~CloudDocs/dissertation/excess deaths India.xlsx", sheet("Sheet1") firstrow
gen date2= date(Day, "YMD")
format date2 %td
sort date2
tsset date2
gen month1= mofd(date2)
rename TotalconfirmeddeathsduetoCO confirmed
rename cumulative_estimated_daily_exces excess_central
rename F excess_top
rename G  excess_bottom
egen sum1= sum(confirmed), by(month1)
egen sum2= sum(excess_central), by (month1)
egen sum3= sum(excess_top), by (month1)
egen sum4= sum(excess_bottom), by (month1)
tsline confirmed excess_central excess_top excess_bottom
//excess mortality who data//
clear all 
import excel "/Users/anupamasen/Library/Mobile Documents/com~apple~CloudDocs/dissertation/who ed.xlsx", sheet("Sheet1") firstrow 
gen date3= ym(year, month)
format date3 %tm
sort date3
tsset date3
tsline Excessmean Expected
//excess moratlity data who to recheck//
 clear all
 import excel "/Users/anupamasen/Library/Mobile Documents/com~apple~CloudDocs/dissertation/new sum1.xlsx", sheet("Sheet1") firstrow
 tsset Day
 tsline Expected sum1 COVIDcumulative

//final excess mortality//
clear all
use "/Users/anupamasen/Downloads/state_mort_month-2.dta"
summarize
sort year month
gen date1= ym(year, month)
format date1 %tm
sort date1 state
 encode state, gen(state1)
 xtset state1 date1, monthly
 summarize 
 xtnbreg deaths c.date if year>2015 & year<= 2019, fe 
 predict expected_deaths // before pandemic

xtnbreg deaths c.date if year>2019 & year<= 2021, fe 
 predict expected_deaths1 // after pandemic
gen log_deaths= log(deaths)
egen total_deaths= total(log_deaths), by (year)
egen expected_deaths_total= total(expected_deaths), by (year)
egen expected_deaths_total1= total(expected_deaths1), by (year)
twoway (lfit total_deaths year, ytitle(total_deaths) color(red)) (lfit expected_deaths_total year, ytitle(residuals) color(blue)) 
twoway (lfit total_deaths year, ytitle(total_deaths) color(red)) (lfit expected_deaths_total1 year, ytitle(residuals) color(blue))
gen excess_deaths= total_deaths - expected_deaths_total
twoway (lfit total_deaths year, ytitle(total_deaths) color(red)) (lfit expected_deaths_total year, ytitle(residuals) color(blue)) (lfit excess_deaths year, ytitle(residuals) color(green)) 
twoway (lfit total_deaths year, ytitle(total_deaths) color(red)) (lfit expected_deaths_total1 year, ytitle(residuals) color(blue)) (lfit excess_deaths year, ytitle(residuals) color(green)) 

//final excess mortality- xtreg//
clear all
use "/Users/anupamasen/Downloads/state_mort_month-2.dta"
summarize
sort year month
gen date1= ym(year, month)
format date1 %tm
sort date1 state
 encode state, gen(state1)
 xtset state1 date1, monthly
 summarize 
 xtreg deaths date if year>2015 & year<= 2019, fe 
 predict expected_deaths01 // before pandemic
 egen total_deaths01= total (deaths), by (year)
egen expected_deaths_total01= total (expected_deaths01), by (year)
twoway (line total_deaths01 year, ytitle(total_deaths) color(red)) (lfit expected_deaths_total01 year, ytitle(expected_deaths) color(blue)) 
gen excess_deaths01= total_deaths01 - expected_deaths_total01
//final excess mortality- xtnbreg//
clear all
use "/Users/anupamasen/Downloads/state_mort_month-2.dta"
summarize
sort year month
gen date1= ym(year, month)
format date1 %tm
sort date1 state
 encode state, gen(state1)
 xtset state1 date1, monthly
 summarize 
 xtnbreg deaths c.date if year>2015 & year<= 2019, fe 
 predict expected_deaths // before pandemic
gen log_deaths= log(deaths)
egen total_deaths= total(log_deaths), by (year)
egen expected_deaths_total= total(expected_deaths), by (year)
twoway (line total_deaths year, ytitle(total_deaths) color(red)) (lfit expected_deaths_total year, ytitle(residuals) color(blue)) 
//final excess mortality- xtreg- UPDATED//
clear all
use "/Users/anupamasen/Downloads/state_mort_month-2.dta"
sort year month
gen date1= ym(year, month)
format date1 %tm
sort date1 state
 encode state, gen(state1)
 xtset state1 date1, monthly
 summarize 
 egen total_deaths01= total (deaths), by (year )
 xtreg total_deaths01 year if year>2015 & year<= 2019, fe 
 predict expected_deaths01 // before pandemic
 twoway (line total_deaths01 year, ytitle(total_deaths) color(red)) (lfit expected_deaths01 year, ytitle(expected_deaths) color(blue)) 
gen excess_deaths01= total_deaths01 - expected_deaths01


gen excess_deaths= total_deaths - expected_deaths_total
//FINAL!!!!//
//final excess mortality- xtreg- UPDATED//
clear all
use "/Users/anupamasen/Downloads/state_mort_month-2.dta"
sort year month
xtset state1 date1, monthly
 xtline deaths 
 summarize 
 egen national_monthly1= total (deaths), by (date1 )
 collapse national_monthly1, by ( state1 date1 year)
 xtreg  national_monthly1 date1 if year >= 2015 & year<2020, fe
 predict expected_deaths01 // before pandemic
  twoway (line national_monthly1 date1, sort) (lfit expected_deaths01 date1)
gen excess_deaths01= national_monthly1 - expected_deaths01

//independent variables with excess mortality- COVID INFECTED//
clear all 
use "/Users/anupamasen/Downloads/covid_infected_deaths-2.dta"
rename lgd_state_name state

gen year = year(date)
gen month = month(date)
gen date3= ym( year, month)
format date3 %tm
sort state1 date3

encode state, gen (state1)

egen monthly_case2= total (total_deaths), by (date3 state1)
 collapse monthly_case2 , by( state1 date3)


xtset state1 date3, monthly
xtline monthly_case2
//regression//
clear all 
use "/Users/anupamasen/Downloads/covid_infected_deaths-2.dta"

egen monthly_case2= total (total_deaths), by (date1 state1)
 collapse monthly_case2 , by( state1 date1)


xtset state1 date1, monthly
xtline monthly_case2
egen national_monthly= total(monthly_case2), by (date1)
xtreg national_monthly date1, fe
predict ed1
twoway (line national_monthly date1, sort) (lfit ed1 date1)



// COVID VACCINATION//
clear all
 use "/Users/anupamasen/Downloads/covid_vaccination.dta"
 rename lgd_state_name state2
 gen year1 = year(date)
gen month1 = month(date)
gen date4= ym( year, month)
format date4 %tm
sort date4 state2

encode state, gen (state3)
 gen total_vac =male_vac +female_vac+ trans_vac
 egen monthly_vaccinated= total (total_vac), by (date4 state3)
 collapse monthly_vaccinated , by( state3 date4)
xtset state3 date4, monthly
xtline monthly_vaccinated


//independent variables//
clear all
 import excel "/Users/anupamasen/Library/Mobile Documents/com~apple~CloudDocs/dissertation/healthcare infra2.xlsx", sheet("Sheet1") firstrow
egen total_dlhs4_dh_beds= total (dlhs4_dh_beds), by (statenames)
egen toatal_dlhs4_dh_count= total(dlhs4_dh_count), by (statenames)
egen toatal_dlhs4_dh_staff= total(dlhs4_dh_staff), by (statenames)
egen toatal_dlhs4_chc_beds= total(dlhs4_chc_beds), by (statenames)
egen toatal_dlhs4_chc_count= total(dlhs4_chc_count), by (statenames)
egen toatal_dlhs4_chc_staff= total(dlhs4_chc_staff), by (statenames)
egen toatal_dlhs4_phc_beds= total(dlhs4_phc_beds), by (statenames)
egen toatal_dlhs4_phc_count= total(dlhs4_phc_count), by (statenames)
egen toatal_dlhs4_phc_staff= total(dlhs4_phc_staff), by (statenames)
egen toatal_dlhs4_phc_pop= total(dlhs4_phc_pop), by (statenames)
egen toatal_pc11_pca_tot_p= total(pc11_pca_tot_p), by (statenames)
egen toatal_dlhs4_total_beds= total(dlhs4_total_beds), by (statenames)
egen toatal_dlhs4_total_staff= total(dlhs4_total_staff), by (statenames)
egen toatal_dlhs4_total_facilities= total(dlhs4_total_facilities), by (statenames)
egen toatal_icu_beds= total(icu_beds), by (statenames)
egen toatal_dlhs4_chc_beds_ven= total(dlhs4_chc_beds_ven), by (statenames)
egen toatal_dlhs4_phc_beds_oxy= total(dlhs4_phc_beds_oxy), by (statenames)
collapse total_dlhs4_dh_beds toatal_dlhs4_dh_count toatal_dlhs4_dh_staff toatal_dlhs4_chc_count toatal_dlhs4_chc_staff toatal_dlhs4_phc_beds toatal_dlhs4_phc_count toatal_dlhs4_phc_staff toatal_dlhs4_phc_pop toatal_pc11_pca_tot_p toatal_dlhs4_total_beds toatal_dlhs4_total_staff toatal_dlhs4_total_facilities  toatal_icu_beds toatal_dlhs4_chc_beds_ven toatal_dlhs4_phc_beds_oxy, by( statenames )
 
// district level data// 
clear all
 use "/Users/anupamasen/Downloads/district_mort_month-2.dta"
gen date1= ym(year, month)
format date1 %tm
encode state, gen (state1)
rename pc11_district_name district1
encode district1, gen (district2)
duplicates drop district2 date1, force
xtset district2 date1, monthly
sort date1
xtreg deaths year if year>2010 & year<=2019
 predict expected_deaths
 gen exces_mortality2= deaths- expected_deaths if year>=2010 & year<= 2021

gen exces_mortality1= deaths- y if year>2019 & year<= 2021
replace exces_mortality = exces_mortality1 if missing(exces_mortality)
egen total_district_deaths2= total(deaths), by (year)
egen total_statewise_deaths= total (total_district_deaths2), by (year)
sort state1 
clear all
 use "/Users/anupamasen/Downloads/district_mort_month-2.dta"
gen date1= ym(year, month)
format date1 %tm
encode state, gen (state1)
rename pc11_district_name district1
encode district1, gen (district2)
duplicates drop district2 date1, force
xtset district2 date1, monthly
sort 
xtreg deaths year if year>2010 & year<=2019
 predict expected_deaths
 gen exces_mortality2= deaths- expected_deaths if year>=2010 & year<= 2021
 sort state1
 egen sum_district5= sum (deaths), by (year)
 collapse sum_district5 state1, by (year district2 )
 collapse deaths district2 state1, by(year )
 numlabel state1
sort district2 sum_district5
egen sum_states= sum (sum_district5), by (year)
sort state1 sum_states
egen national= sum (sum_states), by (year)
gen log_national= ln(national)
egen expected_district5= sum (deaths), by (year)
//distric-log//- final1
clear all
 use "/Users/anupamasen/Downloads/district_mort_month-2.dta"
 sort year month
egen district_deaths= total (deaths) if year>=2020 &year<=2021, by (district2)
gen log_district_deaths=log(district_deaths)
collapse log_district_deaths , by (state1  district2 lgd_district_id date1 year)
reg log_district_deaths district2
predict expected_cross_deaths
gen excess_cross_deaths= log_district_deaths- expected_cross_deaths
collapse log_district_deaths expected_cross_deaths excess_cross_deaths, by (district2 lgd_district_id state1)
sort state1 district2


egen total_district_deaths1= total(deaths), by (year)
egen total_statewise_deaths= total (total_district_deaths2), by (year)
//Cross_sectional//
clear all
import excel "/Users/anupamasen/Library/Mobile Documents/com~apple~CloudDocs/dissertation/cross_sectional1.xlsx", sheet("Sheet1") firstrow 
encode state1, gen (state2)
encode district2, gen (district3)
summarize
reg excess_cross_deaths count_sub count_dish count_sth count_phc pr_phc pr_chc pr_sub pr_dish pr_sth





 
 
