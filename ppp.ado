*! Refactored version: ppp v2.00 (2025-08-20)
*! Upto to 5 colourbands and 5 triages
cap program drop ppp
program define ppp
    version 10.1

    syntax anything [if] [in], [bands(string) bandcolor(string) noLR ///
        LEGENDopts(string asis) YSIZE(integer 6) XSIZE(integer 4) ///
        dp(string) noCOMPress skip(integer 0) * ]

    tempname lprev 
	tempvar x
    qui {
        local k: word count `anything'
        tokenize `anything'

        if `k' < 3 {
            di as err "At least 3 arguments required (prev, LR+, LR−)"
            exit 198
        }

        if `k' > 63 {
            di as err "Maximum of 63 arguments (5 triages) allowed"
            exit 198
        }
		
		// decimals
        if "`dp'" == "" local dp 2
		
		// logit limits for y-scale & guide lines
		local maxl = log(99.9/(100-99.9))
		local minl = log(0.01/(100-0.01))
		
        scalar `lprev' = log(`1' / (1 - `1'))
		
		*Prior: Node 0: root node
        local lpostprob0 = log(`1' / (1 - `1'))
        local postprob0 = 100*`1'
        local notepost0: di "(" %4.`dp'f `postprob0' "%)"
		local path0 = "Start"
		
		local segment =  `""'
		local vertikal =  `""'

        * Setup binary tree for up to 5 triages (2^5 = 32 paths)
        local max_depth = floor(ln(`k' - 1)/ln(2))

		* Pre-compute x positions for each depth level
		forvalues d = 0/`max_depth' {
			if `d' == 0 {
				local xpos0 = 0
			}
			else {
				local xpos`d' = `= 4 * `d' + 4*`skip''
			}
		}
		* Compute values for each child
        forvalues i = 1/`= `k' - 1'  {
            local parent = floor((`i' - 1) / 2)
			local param_idx = `i' + 1
			if `param_idx' > `k' continue

            if mod(`i',2) == 1 {
                * Left child/Odd index = LR+
                if "`lr'" == "" {
                    local plr = ``param_idx''
                }
                else {
                    * Convert Se/Sp to LR+
					if `param_idx' + 1 > `k' continue 
                    local Se = ``param_idx''
                    local Sp = ``=`param_idx' + 1''
                    local plr = `Se' / (1 - `Sp')
                }
				
                local lpostprob`i' = `lpostprob`parent'' + log(`plr')
				local path`i' = "`path`parent''->P"
				local color`i' "red"
            }
            else {
                * Rightchild/Even index = LR−
                if "`lr'" == "" {
                    local nlr = ``param_idx''
                }
                else {
                    * Convert Se/Sp to LR−
                    local Se = ``=`param_idx'-1''
                    local Sp = ``param_idx''
                    local nlr = (1 - `Se') / `Sp'
                }
				
                local lpostprob`i' = `lpostprob`parent'' + log(`nlr')
				local path`i' = "`path`parent''->N"
				local color`i' "green"
            }
            local postprob`i' = 100*invlogit(`lpostprob`i'')
            local notepost`i': di "(" %4.`dp'f `postprob`i'' "%)"
			local label = "Post`i': `notepost`i''"
			
			
			 // neutral color when user passes 1 (LR mode) or 0.5 (noLR mode) to indicate "no test" at this branch
            if ("`lr'" == "" & "``param_idx''" == "1") | ("`lr'" != "" & "``param_idx''" == "0.5") local color`i' "gs5"
        }
		
        * Generate plot commands (arrows)
        forvalues i = 1/`= `k' - 1'  {
			local parent = floor((`i' - 1)/2)
			local col = "`color`i''"
            local level_parent = floor(log(`parent' + 1)/log(2))
			local level_child = floor(log(`i' + 1)/log(2))
			local x0 = `xpos`level_parent''
			local x1 = `xpos`level_child''
			
			* line pattern: solid for first triage (level 1), dashed deeper
			local lpat = cond(`level_child' == 1, "solid", "dash")

            local segment `"`segment' (pcarrowi `lpostprob`parent'' `x0' `lpostprob`i'' `x1', lcolor(`col') mcolor(`col') yaxis(2) lpat(`lpat') lwidth(thin))"'
		}
		
        * Y-axis labels (probability scale)
        local ylab ""
        foreach p in 0.01 0.05 0.1 0.5 1 2 5 10 20 50 80 90 95 99 99.5 99.9 {
            local ylab `"`ylab' `=log(`p' / (100 - `p'))' "`p'" "'
        }
		
		* Vertical guide lines for each depth level > 0
		forvalues d = 1/`=`max_depth'-1' {
			local vertikal = "`vertikal' (pci `minl' `xpos`d'' `maxl' `xpos`d'', recast(pcspike) lcolor(gs5) plotregion(margin(zero)))"
		}
		
        * Plot bands if specified
        local area ""
        if "`bands'" != "" {
            local countbands = wordcount("`bands'")
            if `countbands' > 4 {
                di as err "Maximum of 5 bands supported"
                exit 198
            }
            if "`bandcolor'" == "" {
				if `countbands' == 2 local bandcolor = "green*0.3 orange*0.3 red*0.3"
				if `countbands' == 3 local bandcolor = "blue*0.3 green*0.3 orange*0.3 red*0.3"
				if `countbands' == 4 local bandcolor = "blue*0.3 green*0.3 orange*0.3 brown*0.3 red*0.3"
            }
			
            local countzones = `countbands' + 1
            set obs `=`max_depth'*4 + 1'
            gen `x' = .
            replace `x' = _n-1
            forvalues i = 1/`countzones' {
                tempname upbound`i'
                if `i' == 1 {
                    local low = log(0.01 / (100 - 0.01))
                }
                else {
                    local val = word("`bands'", `=`i'-1')
                    local low = log(`val' / (1 - `val'))
                }
				
                if `i' == `countzones' {
                    gen `upbound`i'' = log(99.9 / (100 - 99.9))
                }
                else {
                    local val = word("`bands'", `i')
                    gen `upbound`i'' = log(`val' / (1 - `val'))
                }
                local col = word("`bandcolor'", `i')
                local area `area' (area `upbound`i'' `x', color(`col') base(`low'))
            }
        }
		
if `"`legendopts'"' == "on" {
    local legendopts

    local bands_plots = cond("`bands'" == "", 0, wordcount("`bands'") + 1)
    local offset = `bands_plots'
    local branches = `k' - 1
    local ncols = `max_depth' + 1

    * Initialize columns and fill counters
    forvalues C = 1/`ncols' {
        local col`C' ""
        local filled`C' = 0
    }

    * --- Column 1: Pre-test ---
    local p_pre = `offset' + 1
    local col1 `"`p_pre' "Pre" `"`notepost0'"'"'
    local filled1 = 1

    * --- Depth 1: Nodes i = 1, 2 in col2 ---
    local C = 2
    local idx_in_col = 0
    forvalues i = 1/2 {
        if `i' > `branches' continue
        local sign = cond(mod(`i', 2), "+", "-")
        local p    = `offset' + `i' + `max_depth'
        local note = `"`notepost`i''"'
        local lr_val = "``=`i'+1''"
        local is_neutral = ("`lr'" == "" & "`lr_val'" == "1") | ("`lr'" != "" & "`lr_val'" == "0.5")

        if "`note'" != "" & !`is_neutral' {
            local ++idx_in_col
            if "`compress'" != "" & `idx_in_col' == 2 {
                local shift = max(0, `ncols' - `C')
                forvalues s = 1/`shift' {
                    local col`C' `"`col`C'' - " " " " "'  // visual stagger
                    local ++filled`C'
                }
            }
            local col`C' `"`col`C'' `p' "Post(`sign')" `"`note'"'"'
        }
        else {
            local col`C' `"`col`C'' - " " " " "'  // blank for neutral
        }
        local ++filled`C'
    }

    * --- Depths ≥ 2: Auto-scaled across columns ---
    forvalues d = 2/`max_depth' {
        local start = 2^`d' - 1
        local end   = min(2^(`d'+1) - 2, `branches')
        local C     = `d' + 1
        local idx_in_col = 0

        forvalues i = `start'/`end' {
            local sign = cond(mod(`i', 2), "+", "-")
            local p    = `offset' + `i' + `max_depth'
            local note = `"`notepost`i''"'
            local lr_val = "``=`i'+1''"
            local is_neutral = ("`lr'" == "" & "`lr_val'" == "1") | ("`lr'" != "" & "`lr_val'" == "0.5") | "`lr_val'" == "."

            if "`note'" != "" & !`is_neutral' {
                local ++idx_in_col
                if "`compress'" != "" & `idx_in_col' == 2 {
                    local shift = max(0, `ncols' - `C')
                    forvalues s = 1/`shift' {
                        local col`C' `"`col`C'' - " " " " "'
                        local ++filled`C'
                    }
                }
                local col`C' `"`col`C'' `p' "Post(`sign')" `"`note'"'"'
            }
            else {
                local col`C' `"`col`C'' - " " " " "'
            }
            local ++filled`C'
        }
    }

    * --- Determine required rows ---
    local rows = 0
    forvalues C = 1/`ncols' {
        local rows = max(`rows', `filled`C'')
    }
	
	* --- Add skip rows ---
	local rows = `rows' + `skip'

	* --- Pad each column to final row count ---
	forvalues C = 1/`ncols' {
		local pad`C' = `= `rows' - `filled`C'''
		forvalues r = 1/`pad`C'' {
			local col`C' `"`col`C'' - " " " " "'  // visual blank row
		}
	}

    * --- Assemble order ---
    local legend_order ""
    forvalues C = 1/`ncols' {
        if `"`col`C''"' != "" {
            local legend_order `"`legend_order' `col`C''"'
        }
    }

    * --- Final legend ---
    local legend_defaults `"pos(6) colf col(`ncols') rowgap(2) colgap(20) region(lcolor(none))"'
    local legendopts `"order(`legend_order') `legend_defaults'"'
    
}

       * Draw full graph
		#delimit;
        twoway 
			/*Zones*/
			`area' 
			
			/*scatter for the pre-test probability*/
			(scatteri `lpostprob0' 0, 
				msym(D) mcolor(black) xlab(none, axis(1))
				xlab(none, axis(2))
				xtitle(" ", axis(1))
				xtitle(" ", axis(2))
				xaxis(1 2)
				ylab(`ylab', angle(0) tpos(cross) nogrid axis(1))
				ylab(`ylab', angle(0) tpos(cross) nogrid axis(2)) 
				yscale(axis(1)) yscale(axis(2))) 
				
			/*Arrows*/
			`segment' 
			
			`vertikal', 
			ytitle("Post-test Probability (%)", axis(2) placement(0)) 
			ytitle("Pre-test Probability (%)", axis(1) placement(9)  margin(l=-5 r=3)) 
			graphregion(color(white) margin(l=5 r=8)) 
			xsize(`xsize') ysize(`ysize') `options' legend(`legendopts')
		; 
		#delimit cr
    }
end

