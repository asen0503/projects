*Macroeconomic Analysis*

clear all
use "/Users/anupamasen/Downloads/Data EAPC_EA2.dta"
gen newdate = tq(1979q1) + observ - 1
tsset newdate, quarterly
*Time variable: newdate, 1979q1 to 2022q3
*        Delta: 1 quarter

gen dummylow=0
replace dummylow=1 if (Gap>=0 & L4.Core_Infl < 3)
tab dummylow
***variables:
* Headline_Infl = quarterly (annual,base so quarter over quarter) headline inflation (including food and energy prices)
* Core_Infl = Core inflation (excluding food and energy prices)
* grex= % rate of appreciation (if >0) or depreciaion (if negative) of the real effective exchange rate for the US
* dummylow = defined aboved
* ExpInfl_1year = expcted inflaion (one year ahead, quarterly, annual base)  
* dummyGap_big3 = dummy =0 if Gap > averageGap+3*Sdgap  


twoway (tsline Headline_Infl)
twoway (tsline Gap)

***********************************HEADLINE INFLATION MODEL 1
regress Headline_Infl c.L.Headline_Infl c.Gap##i.dummylow grex_4Q ExpInfl_1year
*testing linear restrictions.
test Gap = -c.Gap#1.dummylow

********************************CORE INFLATION MODEL 2
regress Core_Infl L.Core_Infl c.Gap##i.dummylow grex_4Q ExpInfl_1year
*testing linear restrictions.
test Gap = -c.Gap#1.dummylow


************************HEADLINE INFLATION Mod 3 (with dummy for large big gap dummyGap_big3 3 times SD)
regress Headline_Infl c.L.Headline_Infl c.Gap##i.dummylow grex_4Q ExpInfl_1year dummyGap_big3
test Gap = -c.Gap#1.dummylow


********************************CORE INFLATION MODEL 4 with dummyGap_big3 
regress Core_Infl L.Core_Infl c.Gap##i.dummylow grex_4Q ExpInfl_1year dummyGap_big3
*testing linear restrictions.
test Gap = -c.Gap#1.dummylow


****************************************************************************************
******************Nonlinearity Model 5 (smooth non linear EAPC, similar to Original PC)
gen Gapsquare= Gap*Gap
************Mod3***CURRENT GAP
regress Headline_Infl L.Headline_Infl Gapsquare Gap dummyGap_big3 grex_4Q ExpInfl_1year

*** derivative of inflation relative to gap = 2* (coeff of Gapsquare) * Gap + coeff of Gap
** example delta infla/ delta gap = 2 * (0.041)*Gap -0.20 = 0.08*Gap-0.20
**this means that at a level of Gap = 0.2/0.04 = 5%  (u - un)= 5% we have a minimum (there is only one value > 5%)
**How do we know there is a minimum? Take the second derivative of infla realtive to gap= 2*0.04 = 0.08 >0    
* The estimated PC curve has a min at 5% (so but we have a dummy to take care of that case in April 2020 for Covid)
