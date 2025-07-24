cap program drop ppp
//*! version 1.00 May 8, 2017
*! version 1.10 Oct 29, 2019
*! Victoria Nyaga 
/*			UPDATES
Oct 29, 2019:
Arrow and lines have same colour
Area border and fill have same color

Nov 6, 2019
legend on(developer defined )-off - blank(all)

Jan 8, 2020


*/
program define ppp
version 10.1

#delimit ;
syntax anything [if] [in], [bands(string) bandcolor(string) noLR
	LEGENDopts(string asis) YSIZE(integer 6) XSIZE(integer 4) dp(string) noCOMPress skip(integer 0) * ];
#delimit cr
	 
tempname prev PLR2 NLR3 PLR4 NLR5 PLR6 NLR7  upbound lowbound max min x band1 ///
		 PLR8 NLR9 PLR10 NLR11 PLR12 NLR13 PLR14 NLR15
qui {

	local k: word count `anything'
	tokenize "`anything'"
	
	scalar `prev' = `1'
	
	if "`lr'" == ""{
		scalar `PLR2' = `2'
		scalar `NLR3' = `3' 
	}
	else{
		scalar `PLR2' = `2'/(1 - `3')
		scalar `NLR3' = (1 - `2')/`3'
	}
	
	if "`dp'" == "" {
		local dp = "2"
	}
	
	local lprprob = log((`prev')/(1 - `prev'))
	local priorprob = 100*`prev' 
	local noteprior: di "("%4.`dp'f `priorprob' "%)"
	
	local lpostprob2 = `lprprob' + log(`PLR2')
	local postprob2 = 100*invlogit(`lpostprob2')
	local notepost2: di "(" %4.`dp'f `postprob2' "%)"
	
	local lpostprob3 = `lprprob' + log(`NLR3')	
	local postprob3 = 100*invlogit(`lpostprob3')
	local notepost3: di "("  %4.`dp'f `postprob3' "%)"
		
	local segment =  `""'
	local vertikal =  `""'
	local vertikali =  `""'
	
	local maxl = log(99.9/(100-99.9))
	local minl = log(0.01/(100-0.01))
	
	
	/*Generate statements for the other branches*/
	if `skip' > 0 {
		local zero 4
	}
	local c = 4	
	while `c' <= `k' {
		
		local o = floor(`c'/2)
		local fstep = `c' + 1
		local bstep = `c' - 1

		if mod(`c', 2) == 0 {
			if "`lr'" == "" {
				local PLR`c' = ``c''
			}
			else{
				local PLR`c' = ``c''/(1 - ``fstep'')
			}
			
			local lpostprob`c' = `lpostprob`o'' + log(`PLR`c'')
			local postprob`c' = 100*invlogit(`lpostprob`c'')
			local notepost`c': di "(" %4.`dp'f `postprob`c'' ")%"
			
			if (`c' > 3 & `c' < 8)  {			
				local segmenti = `"(pcarrowi `lpostprob`o'' `= 0 + 4*`skip'' `lpostprob`c'' `= 4 + 4*`skip'', lcolor(red) mcolor(red)	yaxis(2) lpat(dash) lwidth(thin))"'
			}
			else if (`c' > 7)  {
				local segmenti = `"(pcarrowi `lpostprob`o'' `= 4 + 4*`skip'' `lpostprob`c'' `=  8 + 4*`skip'', lcolor(red)	mcolor(red) yaxis(2) lpat(dash) lwidth(thin)) "'
			}
		}
		else {
			if "`lr'" == "" {
				local NLR`c' = ``c''
			}
			else{
				local NLR`c' = (1 - ``bstep'')/``c''
			}
			local lpostprob`c' = `lpostprob`o'' + log(`NLR`c'')
			local postprob`c' = 100*invlogit(`lpostprob`c'')
			local notepost`c': di "(" %4.`dp'f `postprob`c'' ")%"
			
			if (`c' > 3 & `c' < 8)  {			
				local segmenti = `"(pcarrowi `lpostprob`o'' `= 0 + 4*`skip'' `lpostprob`c'' `= 4 + 4*`skip'', lcolor(green) mcolor(green) yaxis(2) lpat(dash) lwidth(thin))"'
			}
			else if (`c' > 7)  {
				local segmenti = `"(pcarrowi `lpostprob`o'' `= 4 + 4*`skip'' `lpostprob`c'' 8, lcolor(green) mcolor(green) yaxis(2) lpat(dash) lwidth(thin))"'
			}
		}
		
		if ``c'' == 1 & "`lr'" == "" {
			if `c' < 8  {			
				local segmenti = `"(pcarrowi `lpostprob`o'' `= 0 + 4*`skip'' `lpostprob`c'' `= 4 + 4*`skip'', lcolor(gs5) mcolor(gs5) yaxis(2) lpat(dash) lwidth(thin))"'
			}
			else {
				local segmenti = `"(pcarrowi `lpostprob`o'' `= 4 + 4*`skip'' `lpostprob`c'' 8, lcolor(gs5) mcolor(gs5) yaxis(2) lpat(dash) lwidth(thin))"'
			}
		}
		if ``c'' == 0.5 & "`lr'" != "" {
			if `c' < 8  {			
				local segmenti = `"(pcarrowi `lpostprob`o'' `= 0 + 4*`skip'' `lpostprob`c'' `= 4 + 4*`skip'', lcolor(gs5) mcolor(gs5) yaxis(2) lpat(dash) lwidth(thin))"'
			}
			else {
				local segmenti = `"(pcarrowi `lpostprob`o'' `= 4 + 4*`skip'' `lpostprob`c'' 8, lcolor(gs5) mcolor(gs5) yaxis(2) lpat(dash) lwidth(thin))"'
			}
		}
		
		if `c' == 4{
			local vertikali = `"(pci `minl' `= 0 + 4*`skip'' `maxl' `= 0 + 4*`skip'', recast(pcspike) lcolor(gs5) plotregion(margin(zero)))"'
			local vertikal = "`vertikal' `vertikali'"
		}
		
		
		if `c' == 8{
			local vertikali = `"(pci `minl' `= 4 + 4*`skip'' `maxl' `= 4 + 4*`skip'', recast(pcspike) lcolor(gs5)  plotregion(margin(zero)))"'
			local vertikal = "`vertikal' `vertikali'"
		}
		
		local segment = " `segment' `segmenti'"
		
		
		local ++c
	} 
	
	if `k' < 4 {
		local maxx = `= 0 + 4*`skip''
	}
	else if (`k' > 3 & `k' < 8) {
		local maxx = `= 4 + 4*`skip''
	}
	else{
		local maxx = 8
	}
	
	foreach p in 0.01 0.05 0.1 0.5 1 2 5 10 20 50 80 90 95 99 99.5 99.9 {   
			 local ylab `"`ylab' `=ln(`p' / (100 - `p'))' "`p'" "'
	}

	foreach lr in 0.0001 0.0002 0.0003 0.0005 0.0007 0.001 0.002 0.005 0.01 ///
				0.02 0.05 0.1 0.2 0.5 1 2 5 10 20   ///
				   50 100 200 500 1000 {
			 local PLRts `"`PLRts' `=-.5*ln(`lr')' 0 "`lr'" "'
	}
	
	if ("`bands'" != "" ){
		if `k' == 3 {
			local obs `= 5 + 4*`skip'' 
			set obs `obs'
			egen  `x' = seq(),f(-4) to(`= 0 + 4*`skip'')
		}
		else if (`k' > 4 & `k' < 8){
			local obs `= 9 + 4*`skip'' 
			set obs `obs'
			egen  `x' = seq(),f(-4) to(`= 4 + 4*`skip'')
		}
		else {
			set obs 13
			egen  `x' = seq(),f(-4) to(8)
		}	
	}
	
	local area =  `""'
	if "`bands'" != "" {
	
		local countbands = wordcount("`bands'")
		
		forvalues band = 1/`countbands'{	
			local value = word("`bands'", `band')
			cap assert (`value'> 0 & `value' < 1)
			if _rc!=0 {
				di as err "Band values should be between 0 and 1"
				exit _rc
			}
		}
		
		if "`bandcolor'" == "" {
			if 	`countbands' < 3{
				local bandcolor = "green*0.3 orange*0.3 red*0.3"
			}
			else if `countbands' == 3{
				local bandcolor = "blue*0.3 green*0.3 orange*0.3 red*0.3"
			}
			else {
				di as error "Please speficify colours with bandcolor() option"
				exit 
			}
		}
		local countbands = `countbands' + 1
		forvalues band=1/`countbands'{
		
			tempname upbound`band'
			
			if `band' == 1 {
				local lowbound = log(0.01/(100-0.01))
			} 
			else {
				local value = word("`bands'", `band' - 1)
				local lowbound = log(`value'/(1 -`value'))
			}
			
			if `band' == `countbands' {
				gen `upbound`band'' = log(99.9/(100-99.9))
			} 
			else {
				local value = word("`bands'", `band')
				gen `upbound`band'' = log(`value'/(1 -`value'))
			}
			local colorb = word("`bandcolor'", `band')
			local area`band' "(area `upbound`band'' `x', color(`colorb') base(`lowbound'))"
			
			local area  `area' `area`band''
		}
	}		
			
	if `"`legendopts'"' == "on" {
		local legendopts
	
		if "`bands'" != "" {
			local offset = wordcount("`bands'")  //why count the bands? because they are plotted before the arrows
			local offset = `offset' + 1
		}
		else {
			local offset 0
		}
		if `skip' > 0 {
			local holes `=`"- " " " " "'*2'
		}

		if `k' == 3 {
			if `"`legendopts'"' == "" { // default legend options
				local legendopts `"colf pos(6)  col(`=2 +  `skip'') rowgap(2) region(lcolor(none)) "'
			}
			local column1 `"`=`offset' + 1' "Pre" "`noteprior'" - " " " " `holes'"'
			local column2 `"`=`offset' + 2' "Post(+)" "`notepost2'" `=`offset' + 3' "Post(-)" "`notepost3'" `holes'"'
			if `skip' > 0 {
				local column3 `"`=`"`holes'"'*2'"'
			}
			if `skip' > 1 {
				local column4 `"`=`"`holes'"'*4'"'
			}
			local legendopts `" order(`column1' `column2' `column3' `column4') `legendopts'"'
		}
		
		if (`k' > 3) & (`k' < 8) {
			if `"`legendopts'"' == "" { // default legend options
				local legendopts `"pos(6)  colf col(3) rowgap(2)  colgap(20) region(color(none)) "'
			}
			
			local column1 "`=`offset' + 1'  "Pre" "`noteprior'" 	   	- " " " " 		 							- " " " " 									- " " " " "
			if "`compress'" == "" {
				local column2 "`=`offset' + 2'  "Post(+)" "`notepost2'"   `=`offset' + 3' "Post(-)" "`notepost3'" 	- " " " " 									- " " " " "
			}
			else {
				local column2 "`=`offset' + 2'  "Post(+)" "`notepost2'"   - " " " "									`=`offset' + 3' "Post(-)" "`notepost3'" 	 - " " " " "
			}
			local column 3
			local i = 4
			while `i'< 8 {
				if mod(`i', 2) == 0 {
					local sign "+"
				}
				else {
					local sign "-"
				}
				if "`notepost`i''" != "" {
					local column3 = `" `column3' `=`offset' + `i'' "Post(`sign')" "`notepost`i''" "'
				}
				else {
					local column3 = `"`column3' - " " " " "'
				}
				local ++i
			}
			local legendopts `"order(`column1' `column2' `column3') `legendopts'"'
			
		}
		
		if (`k' > 7) {
			if `"`legendopts'"' == "" { // default legend options
				local legendopts `"pos(6)  colf col(4) rowgap(2)  colgap(20) region(color(none)) "'
			}
			local column1 "`=`offset' + 1'  "Pre" "`noteprior'" 	   		- " " " " 		 		- " " " " 									- " " " " 	- " " " " 						 			- " " " " 	- " " " " 						 			- " " " ""
			if "`compress'" != "" {
				local column2 "`=`offset' + 2'  "Post(+)" "`notepost2'"   - " " " " 				- " " " " 									- " " " "	`=`offset' + 2' "Post(-)" "`notepost3'" 	- " " " " 	- " " " " 						 			- " " " ""
				local column3 "`=`offset' + 4'  "Post(+)" "`notepost4'"   - " " " "				`=`offset' + 5' "Post(-)" "`notepost5'" 	- " " " "	`=`offset' + 6' "Post(+)" "`notepost6'" 	- " " " "	`=`offset' + 7' "Post(-)" "`notepost7'" 	- " " " ""
			}
			else {
				local column2 "`=`offset' + 2'  "Post(+)" "`notepost2'"   `=`offset' + 3' "Post(-)" "`notepost3'" 	- " " " " 									- " " " " 									- " " " "	- " " " " 	- " " " " 	- " " " ""
				local column3 "`=`offset' + 4'  "Post(+)" "`notepost4'"   `=`offset' + 5' "Post(-)" "`notepost5'" 	`=`offset' + 6' "Post(+)" "`notepost6'"  `=`offset' + 7' "Post(-)" "`notepost7'" 	- " " " " 	- " " " "	- " " " "	- " " " ""
			
			}
			local column 4
			local i = 8
			while `i'< 16 {
				if mod(`i', 2) == 0 {
					local sign "+"
				}
				else {
					local sign "-"
				}
				if "`notepost`i''" != "" {
					local column4 = `"`column4' `=`offset' + `i'' "Post(`sign')" "`notepost`i''" "'
				}
				else {
					local column4 = `"`column4' - " " " " "'
				}
				local ++i
			}
			local legendopts `"order(`column1' `column2' `column3' `column4') `legendopts'"'
		}
	}
		
	#delimit;
	tw 
		`area'
		
		(scatteri `lprprob' -4, 
			msym(D) 
			yaxis(1 2) 
			mcolor(black)	
		xlab(none, axis(1))
		xlab(none, axis(2))
		xtitle(" ", axis(1))
		xtitle(" ", axis(2))
		xaxis(1 2)
		ylab(`ylab', angle(0) tpos(cross) nogrid axis(1))
		ylab(`ylab', angle(0) tpos(cross) nogrid axis(2)) 
		yscale(axis(1)) yscale(axis(2)))
		(pcarrowi `lprprob' -4 `lpostprob2' `= 0 + 4*`skip'', lcolor(red) mcolor(red)
		yaxis(2) lpat(solid) lwidth(thin))
 
		(pcarrowi `lprprob' -4 `lpostprob3' `= 0 + 4*`skip'', lcolor(green) mcolor(green)
		yaxis(2) lpat(solid) lwidth(thin))	
		`segment'		
		`vertikal'	
		,  		
		ytitle("Post-test Probability (%)", axis(1) placement(0))
		ytitle("Pre-test Probability (%)", axis(2)  placement(9)  margin(l=-5 r=3))
		graphregion(color(white) margin(l=5 r=8)) 
		xscale(range(-4 `maxx')) legend(`legendopts') `options' xsize(`xsize') ysize(`ysize') 
		
		; 
	#delimit cr 
}
end                                                                
               
