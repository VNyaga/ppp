/*
>>>> HOW TO CHANGE THE LEGEND <<<<
Step 1. Use legend(all) to see all the keys. 
Step 2. Use legend(on) to see the labels
Step 3.	Use legend(order(`user preference'), `options') to customize the legend.
For more details on legend consult the help file/
   */

/****************************************************************************
				EXAMPLE II
*****************************************************************************/
/*STEP 1 : Legend(all ) ==> Show all keys*/
ppp2 0.5 14.4 0.45 1 1 10 0.05, bands(0.3 0.6 0.8) legendopts(all) name(twoc_all, replace)  

/*Displayed Legend 

Col 1				Col 2
=====================================
1 - 1st band			2 - 2nd band
3 - 3rd band			4 - 4th band
5 - prior prob			6 - (+)post pro
7 - (-)post pro			8 - (++)post pro
9 - (+-)post pro		10 - (-+)post pro
11 - (--)post prop		12 - vertical line diving the 1st & 2nd triage
*/

/*STEP 2 : Legend(on) ==> author preference*/
ppp2 0.5 14.4 0.45 1 1 10 0.05, bands(0.3 0.6 0.8) legendopts(on) name(twoc_on, replace)  

/* Displayed Legend
Col 1					Col 2				Col 3
============================================================
5 - prior prob			6 - (+)post pro		8  - (++)post pro
[hole]					7 - (-)post pro		9  - (+-)post pro
[hole]					[hole]				10 - (-+)post pro
[hole]					[hole]				11 - (-+)post pro
*/

/*STEP 3 : Legend(user specification) == replicate author preference*/
#delimit ;
ppp2 0.5 14.4 0.45 1 1 10 0.05, 
	bands(0.3 0.6 0.8)  
	legend(order(5 "Pre" "(50.00%)"	  	  - " " " "				  - " " " "	  				- " " " "  
				 6 "Post(+)" "(93.51%)"   7 "Post(-)" "(31.03%)"  - " " " "					- " " " "  
				 8 "Post(+)" "(93.51)%"   9 "Post(-)" "(93.51)%"  10 "Post(+)" "(81.82)%"  11 "Post(-)" "(2.20)%" ) 
		pos(6)  colf col(3) rowgap(2)  colgap(20) region(color(none))) 
	name(twoc_user, replace)
;
#delimit cr

/*Step 3 : Legend(*) User preference*/
/* Desired Legend

Col 1					Col 2					Col 3
============================================================
5 - prior prob			6 - (+)post prob		[hole]
[hole]					7 - (-)post prob		10 - (-+)post prob			
[hole]					[hole]					11 - (-+)post prob
			
*/
#delimit ;
ppp2 0.5 14.4 0.45 1 1 10 0.05, 
	bands(0.3 0.6 0.8)  
	legend(order(5 "Pre" "(50.00%)"	  	  - " " " "					- " " " "				  
				 6 "Post(+)" "(93.51%)"   7 "Post(-)" "(31.03%)"	- " " " "				  
				 - " " " "  			  10 "Post(+)" "(81.82)%"   11 "Post(-)" "(2.20)%" ) 
		pos(6)  colf col(3) rowgap(2)  colgap(20) region(color(none))) 
	name(twoc_user, replace)
;
#delimit cr
/****************************************************************************
				EXAMPLE II
*****************************************************************************/

/*STEP 1 : Legend(all ) ==> Show all keys*/
ppp2 0.5 0.9 0.6 0.9 0.6, bands(0.3 0.6) nolr legendopts(all) name(twoc_all, replace)
/*Displayed Legend 
Col 1				Col 2
====================================
1 - 1st band			2 - 2nd band
3 - 3rd band			4 - prior prob
5 - (+)post prob		6 - (-)post prob	
7 - (++)post prob		8 - (+-)post prob
9 - vertical line 
	diving the 1st & 
	2nd triage
*/

/*STEP 2 : Legend(on) ==> author preference*/
ppp2 0.5 0.9 0.6 0.9 0.6, bands(0.3 0.6) nolr legendopts(on) name(twoc_on, replace)

/*Step 3 : Legend(*) User preference*/
/* Desired Legend
Col 1					Col 2					Col 3
============================================================
4 - prior prob			5 - (+)post prob		7 - (-+)post prob
[hole]					[hole]					8- (-+)post prob			
[hole]					6 - (-)post prob		[hole]			
*/
#delimit ;
ppp2 0.5 0.9 0.6 0.9 0.6, bands(0.3 0.6) nolr
	legend(order(4 "Pre" "(50.00%)"	  	  - " " " "					- " " " "				  
				 5 "Post(+)" "(69.23%)"   - " " " "					6 "Post(-)" "(14.29%)"					  
				 7 "Post(+)" "(83.51%)"   8 "Post(-)" "(27.27%)" 	- " " " ")
		pos(6)  colf col(3) rowgap(2)  colgap(20) region(color(none))) 
	name(twoc_user, replace)
;
#delimit cr




