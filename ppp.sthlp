{smcl}
{* 8 May 2017}{...}
{hline}
{cmd:help ppp}
{hline}

{title: Pre- and post-probability given the diagnostic accuracy of a test}

{p 4 12 2}
{cmd:ppp}
{arguments}
[{cmd:,}
{it:legendopts(on|off|all|options)}
{it:options}
]

{title:Description}

{p 12 12  2}
ppp is an immediate command to plot a nomogram showing evolution of probabilities pre- and post testing. 
The command requires a minimum of three and maximum of 15 arguments. By defualt, the program uses the likelihood ratios
to compute the post-probabilities. If the sensitivity and specificity are available, they can be used with the option {it:nolr}.
The first three are; 
prevalence - The prior/pre-test probability,
lrp - The likelihood ratio for positive results,
lrn - The likelihood ratio for negative results.

{p 12 12  2}
In case of a second triage, two to four more arguments are required. If both positive and the negative results have triage based on the same test then,

{p 16 16  2}
lrp2 - The likelihood ratio for positive results of the second test, and

{p 16 16  2}
lrn2 - The likelihood ratio for negative results of the second test are required.

{p 12 12  2}
However, if the second triage is done based on different tests for positive and negative results then,

{p 16 16  2}
lrp2 - The likelihood ratio for positive results of the second test for the first positives and

{p 16 16  2}
lrn2 - The likelihood ratio for negative results of the second test for the first positives are required.

{p 16 16  2}
lrp3 - The likelihood ratio for positive results of the second test for the first negatives, and

{p 16 16  2}
lrn3 - The likelihood ratio for negative results of the second test for the first negatives are required.

{p 16 16  2}
In this case, {cmd: lrp2 lrn2},{cmd: lrp3 lrn3} are likelihood ratio for the first positive outcomes and negative outcomes respectively.
When second triage is done only on positive or negative outcomes, then the likelihood ratio parameters for the missing test should be set to 1
as follows, {cmd: lrp2 lrn2}{cmd: 1 1} or {cmd: 1 1}{cmd: lrp3 lrn3} respectively. When the {nolr} option is on, the missing test parameters are 
set to 0.5.

{p 12 12 2}
Therefore {arguments} may be {cmd: prev lrp lrn} for one triage, {cmd: prev lrp1 lrn1 lrp2 lrn2} or {cmd: prev lrp1 lrn1 lrp2 lrn2 lrp3 lrn3} for two triages.

{p 12 12 2}
Note that the {cmd:ppp1} command requires Stata 10.1 or later versions.

{p 4 12 2}
The options are,

{p 4 12 2}
{cmd:bands(numlist)} A list specifying where the different bands appear. 
The numbers should be between 0 and 1.

{p 4 12 2}
{cmd:bandcolor(string)} Specify the colour of the bands. 

{p 4 12 2}
{cmd:noLR(#)} Use LR+ and LR- to compute the post-probability (default) or sensitivity and specificity.

{p 4 12 2}
{cmd:dp(#)} Controls the decimal places. The default is 2 decimal places.

{p 4 12 2}
{cmd:legendopts(string)} Controls the legend. legendopts(on) imposes my customisation. Giving no options or legends(all) shows all the keys and their labels.
legendopts(off) turns on the legend. 

{p 4 12 2}
{cmd: nocompress} allow holes in the legend

{p 4 12 2}
{cmd: skip(1|2)} skip lines to have a broader graph. Useful when going to combine graphs with unequal triages.

{p 4 12 2}
{cmd: options} allow other two way graph options e.g xsize(3) ysize(7)


{title:Examples}

One triage with a white graph region.
{cmd:ppp 0.5 14.4 0.25, graphregion(color(white)) legendopts(on)}
{it:({stata "ppp 0.5 14.4 0.25, graphregion(color(white)) legendopts(on)":click to run})}

One triage with regions and enlarged axis titles.
{cmd:ppp 0.5 14.4 0.25, bands(0.3 0.6)  ytitle(,size(5) axis(1)) ytitle(,size(5) axis(2)) legendopts(on)}
{it:({stata "ppp 0.5 14.4 0.25, bands(0.3 0.6)  ytitle(,size(5) axis(1)) ytitle(,size(5) axis(2)) legendopts(on)":click to run})}

Double triage with regions where second triage is on the negative outcomes only.
{cmd:ppp 0.5 14.4 0.45 1 1 10 0.05, bands(0.3 0.6) legendopts(on)}
{it:({stata "ppp 0.5 14.4 0.45 1 1 10 0.05, bands(0.3 0.6) legendopts(on)":click to run})}

Double triage with regions where second triage is on the positive outcomes only.
{cmd:ppp 0.5 1.5 0.25 10 0.05 1 1 , bands(0.3 0.6) legendopts(on)}
{it:({stata "ppp 0.5 1.5 0.25 10 0.05 1 1 , bands(0.3 0.6) legendopts(on)":click to run})}

Double triage with regions where second triage is on the positive outcomes only when sensitivity and specificity are supplied.
{cmd:ppp 0.5 0.9 0.6 0.9 0.6, bands(0.3 0.6) nolr legendopts(on)}
{it:({stata "ppp 0.5 0.9 0.6 0.9 0.6, bands(0.3 0.6) nolr legendopts(on)":click to run})}

Triple triage with regions (example one).
{cmd:ppp 0.5 14.4 0.35 11 0.05 1 1 1 1 10 0.05 1 1, bands(0.3 0.6 ) bandcolor(blue*0.3 brown*0.3 red*0.3) legendopts(on)}
{it:({stata "ppp 0.5 14.4 0.35 11 0.05 1 1 1 1 10 0.05 1 1, bands(0.3 0.6) bandcolor(blue*0.3 brown*0.3 red*0.3) legendopts(on)":click to run})}

Triple triage with regions without legend (example two).
{cmd:ppp 0.5 14.4 0.35 11 0.05 1 1 1 1 10 0.05 1 1, bands(0.3 0.6 ) bandcolor( green*0.3 orange*0.3 red*0.3) legendopts(off)}
{it:({stata "ppp 0.5 14.4 0.35 11 0.05 1 1 1 1 10 0.05 1 1, bands(0.3 0.6) bandcolor( green*0.3 orange*0.3 red*0.3) legendopts(off)":click to run})}


{title:Authors}

{p 4 4 2}
Victoria Nyaga 
Unit of Cancer Epidemiology,
Sciensano,
Juliette Wytsmanstreet 14, B1050 Brussels,
Belgium.

{title:Also see}

{psee}
Online:  {help fagan} (if installed)
		 

