
clear
set more off
local dir "D:\03_IO analysis nCoV\01 model proper\00 data clean\2018 (july2020ver)"		// working directory
cd "`dir'"
set type double, permanently


/*

File Requirements

1. mriobline18.dta
2. mrio18.csv



Outputs
1. findem_levels_bline18
2. totfindem_bline18
3. findem_shares_bline18
4. f_tourshre_bline18
5. exports_bline2018.dta
6. exports_bline2018.csv


*/


*================Calculating C and I levels at country-sectr level================

use mriobline18
*local mrioctry aus	aut	bel	bgr	bra	can	swi	prc	cyp	cze	ger	den	spa	est	fin	fra	ukg	grc	hrv	hun	ino	ind	ire	ita	jpn	kor	ltu	lux	lva	mex	mlt	net	nor	pol	por	rom	rus	svk	svn	swe	tur	tap	usa	ban	mal	phi	tha	vie	kaz	mon	sri	pak	fij	lao	bru	bhu	kgz	cam	mld	nep	sin	hkg	row
local mrioctry aus	aut	bel	bgr	bra	can	che	chn	cyp	cze	deu	dnk	esp	est	fin	fra	gbr	grc	hrv	hun	idn	ind	irl	ita	jpn	kor	ltu	lux	lva	mex	mlt	nld	nor	pol	prt	rom	rus	svk	svn	swe	tur	tap	usa	ban	mal	phi	tha	vie	kaz	mon	sri	pak	fij	lao	brn	btn	kgz	cam	mdv	npl	sin	hkg	row																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																														

foreach c in `mrioctry' {
gen `c'_fc=`c'f1+`c'f2
gen `c'_fi=`c'f4
}

keep mriorow country sector *_fc *_fi
save findem_levels_bline18,replace

gen id=1
collapse(sum) aus_fc-row_fi,by(id)
save totfindem_bline18



*================Calculating C and I shares at country-sectr level================
use mriobline18
*local mrioctry aus	aut	bel	bgr	bra	can	swi	prc	cyp	cze	ger	den	spa	est	fin	fra	ukg	grc	hrv	hun	ino	ind	ire	ita	jpn	kor	ltu	lux	lva	mex	mlt	net	nor	pol	por	rom	rus	svk	svn	swe	tur	tap	usa	ban	mal	phi	tha	vie	kaz	mon	sri	pak	fij	lao	bru	bhu	kgz	cam	mld	nep	sin	hkg	row
local mrioctry aus	aut	bel	bgr	bra	can	che	chn	cyp	cze	deu	dnk	esp	est	fin	fra	gbr	grc	hrv	hun	idn	ind	irl	ita	jpn	kor	ltu	lux	lva	mex	mlt	nld	nor	pol	prt	rom	rus	svk	svn	swe	tur	tap	usa	ban	mal	phi	tha	vie	kaz	mon	sri	pak	fij	lao	brn	btn	kgz	cam	mdv	npl	sin	hkg	row																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																														

foreach c in `mrioctry' {
gen `c'_fc=`c'f1+`c'f2
gen `c'_fi=`c'f4
egen `c'_totfc=sum(`c'_fc)
egen `c'_totfi=sum(`c'_fi)
gen `c'_fc_shre=`c'_fc/`c'_totfc
gen `c'_fi_shre=`c'_fi/`c'_totfi
}

keep mriorow country sec *shre
save findem_shares_bline18


*================Calculating the tourism sectors' shares================

use mriobline18

gen toursec=0
replace toursec=1 if sector=="c22"|sector=="c23"|sector=="c24"|sector=="c25"|sector=="c34"
egen totfindem=rowtotal(ausf1-rowf5)
gen fd_tour=totfindem*toursec
egen tottour=total(fd_tour),by(country)
gen f_tourshre=fd_tour/tottour
egen tourshre=total(f_tourshre),by(country)
keep country sector f_tourshre

save f_tourshre_bline2018


*================Extracting exports from MRIOT================

import delimited mrio2018, asdouble 

*local mrioctry aus	aut	bel	bgr	bra	can	swi	prc	cyp	cze	ger	den	spa	est	fin	fra	ukg	grc	hrv	hun	ino	ind	ire	ita	jpn	kor	ltu	lux	lva	mex	mlt	net	nor	pol	por	rom	rus	svk	svn	swe	tur	tap	usa	ban	mal	phi	tha	vie	kaz	mon	sri	pak	fij	lao	bru	bhu	kgz	cam	mld	nep	sin	hkg	row
local mrioctry aus	aut	bel	bgr	bra	can	che	chn	cyp	cze	deu	dnk	esp	est	fin	fra	gbr	grc	hrv	hun	idn	ind	irl	ita	jpn	kor	ltu	lux	lva	mex	mlt	nld	nor	pol	prt	rom	rus	svk	svn	swe	tur	tap	usa	ban	mal	phi	tha	vie	kaz	mon	sri	pak	fij	lao	brn	btn	kgz	cam	mdv	npl	sin	hkg	row																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																														

foreach c in `mrioctry' {
egen `c'_intdem=rowtotal(`c'c*)
egen `c'_findem=rowtotal(`c'f*)
gen `c'_dum=1
replace `c'_dum=0 if country=="`c'"
}


*local mrioctry aus	aut	bel	bgr	bra	can	swi	prc	cyp	cze	ger	den	spa	est	fin	fra	ukg	grc	hrv	hun	ino	ind	ire	ita	jpn	kor	ltu	lux	lva	mex	mlt	net	nor	pol	por	rom	rus	svk	svn	swe	tur	tap	usa	ban	mal	phi	tha	vie	kaz	mon	sri	pak	fij	lao	bru	bhu	kgz	cam	mld	nep	sin	hkg	row
local mrioctry aus	aut	bel	bgr	bra	can	che	chn	cyp	cze	deu	dnk	esp	est	fin	fra	gbr	grc	hrv	hun	idn	ind	irl	ita	jpn	kor	ltu	lux	lva	mex	mlt	nld	nor	pol	prt	rom	rus	svk	svn	swe	tur	tap	usa	ban	mal	phi	tha	vie	kaz	mon	sri	pak	fij	lao	brn	btn	kgz	cam	mdv	npl	sin	hkg	row																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																														

foreach c in `mrioctry' {
gen `c'_exprtintdem=`c'_dum*`c'_intdem
gen `c'_exprtfindem=`c'_dum*`c'_findem
}

egen exprtintdem=rowtotal(*_exprtintdem)
egen exprtfindem=rowtotal(*_exprtfindem)
gen totexport=exprtintdem+exprtfindem

keep mriorow country sector exprtintdem exprtfindem totexport
save exports_bline2018.dta
outsheet using exports_bline2018.csv,comma


*=============================For NON-MRIOT DMCs==============================================

clear
set more off
local dir "D:\03_IO analysis nCoV\25aug2020 run\nonmriot dmc"		// working directory
cd "`dir'"
set type double, permanently



use dmcdomdem082520 // file from Regie

local scene sc1 sc2 sc3
foreach s in `scene'{
gen d_domdem_pct_`s'=(c_aff*c_`s'+i_aff*c_`s')/100
}

merge 1:1 mriocode using toureff,keep(match) nogen


rename mriocode mrio_code

keep if nonmriotdmc==1

save nonmriot_compBC,replace












