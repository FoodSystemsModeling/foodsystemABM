extensions [ table matrix GIS profiler ]

__includes [ "setupWorld.nls"  "setupStaticNames.nls"  "setupDashboard.nls"  "potatoDashboard.nls"   "peachDashboard.nls"   "wheatDashboard.nls" "beefDashboard.nls"  "matrixToTableAPI.nls"  "modelOutputs.nls" ]

globals [

  workspace
  osSeparator
  paramDir
  outputDir

  ;; -------------------------
  ; dates/calendar
  ;; -------------------------

  week                                                           ;; julian week in year the model is in
  year                                                           ;; year the model is in
  max-ticks
  years-in-model-run

  ;; -------------------------
  ; others
  ;; -------------------------

  ;market-knowledge ; % of market knowledge; interesting to play around with to show changes in speed of price convergence; added as interface variable for now because want to change for scenarios
  organic-planning-horizon ; when doing organic vs. conventional profitability calculations how many years in the future are considered in the trade-off?

  ;; -------------------------
  ; GIS/data variables
  ;; -------------------------

  county-load

  ;; potatoes
  potato-county-load
  potato-patches-load
  canela-mean-load
  canela-org-mean-load
  purple-mean-load
  purple-org-mean-load
  canela-load
  canela-org-load
  purple-load
  purple-org-load
  potato-rotation-year
  potato-data-year ;; the year of dssat data that is pulled for a particular year's yield

  ;; wheat
  wheat-county-load
  wheat-patches-load
  wheat-hrw-conventional-mean-load
  wheat-hrw-organic-mean-load
  wheat-snowmass-conventional-mean-load
  wheat-snowmass-organic-mean-load
  wheat-hrw-conventional-load
  wheat-hrw-organic-load
  wheat-snowmass-conventional-load
  wheat-snowmass-organic-load
  wheat-data-year

  ;; peaches
  peach-county-load
  peach-patches-load
  conventional-mean-load
  organic-mean-load
  conventional-load
  organic-load
  peach-data-year

  ;; beef
  beef-county-load
  beef-patches-load
  beef-data-year
  public-lands
  forage-range
  precip-average
  irrigated-lands
  grazable-lands
  rainfall-factor
  precip-year
  feeder-cattle-price      ; per head
  cull-cow-price           ; per head


  ;; -------------------------
  ; table setup
  ;; -------------------------

  ; tables track sales transactions along the supply chain
  ; there is a separate table for each product of each commodity

  ;; potatoes
  potato-table_russet-conventional
  potato-table_russet-organic
  potato-table_purple-conventional
  potato-table_purple-organic
  potato-table_russet-conventional-small
  potato-table_russet-conventional-processed
  potato-table_russet-organic-processed
  potato-table_purple-conventional-processed
  potato-table_purple-organic-processed

  ;; wheat
  wheat-table_hrw-conventional
  wheat-table_hrw-organic
  wheat-table_snowmass-conventional
  wheat-table_hrw-conventional-flour
  wheat-table_hrw-organic-flour
  wheat-table_snowmass-conventional-flour
  wheat-table_hrw-conventional-bread
  wheat-table_hrw-organic-bread
  wheat-table_snowmass-conventional-bread

  ;; peaches
  peach-table_conventional
  peach-table_organic
  peach-table_seconds
  peach-table_iqf

  ;; beef
  beef-table_conventional
  beef-table_grassfed
  beef-table_colorado-source-id
  beef-table_animal-welfare

  ;; -------------------------
  ; number of agents
  ;; -------------------------

  ;; potatoes
  number-potato_farmers
  number-potato_shippers
  number-potato_repackers
  number-potato_processors

  ;; wheat
  number-wheat_farmers
  number-wheat_elevators
  number-wheat_mills
  number-wheat_bakers

  ;; peaches
  number-peach_farmers
  number-peach_processors
  number-peach_altmarks
  peaches-percent-seconds

  ; seems like this should be an agent variable, not global but don't have time to test - el 5/21/21
  packer ;; dummy variable that indicates which (one) peach farmer is an outsource packer (packs peaches for other farms). streamline with outsource-packer peach_farmer variable?  - el 5/21/21

  ;; beef
  number-beef_ranchers
  number-beef_packing-houses

  ;; common

  number-distributors
  number-dps_buyers
  number-of-students

  ;;------------------------------------------
  ;; pillar 3 variables
  ;;------------------------------------------

  delta-hei-low-income
  delta-hei-high-income
  hei-elementary
  hei-middlehigh
  hei-baseline

  ;;------------------------------------------
  ;; lca variables
  ;;------------------------------------------


  ; Results from J. Antonanzas Torres, Nov 23, 2021 and Jan. 2022
;
;                             	Total at farm gate  	              Total at truck gate (in Denver)
;                             	GHG 	Water depletion 	            GHG 	Water depletion
;                               kg CO2eq/kg potato 	m3/kg potato 	  kg CO2eq/kg potato 	m3/kg potato
; Russet Conventional 	             0,159 	           0,049 	             0,233 	          0,161
; Russet Organic 	                   0,128 	           0,063 	             0,197 	          0,178
; Purple Conventional 	             0,158           	 0,048 	             0,232 	          0,160
; Purple Organic 	                   0,133 	           0,065 	             0,203 	          0,180
; French fry                           --                --                0,577            0,081
; Specialty product                    --                --                0,572            0,236


  ; GHG and Water Depletion parameters per KG
  potato-russet-conventional_per-kg-CO2-kg-eq-at-farm
  potato-russet-conventional_per-kg-CO2-kg-eq-at-Denver
  potato-russet-organic_per-kg-CO2-kg-eq-at-farm
  potato-russet-organic_per-kg-CO2-kg-eq-at-Denver
  potato-purple-conventional_per-kg-CO2-kg-eq-at-farm
  potato-purple-conventional_per-kg-CO2-kg-eq-at-Denver
  potato-purple-organic_per-kg-CO2-kg-eq-at-farm
  potato-purple-organic_per-kg-CO2-kg-eq-at-Denver
  potato-french-fry_per-kg-CO2-kg-eq-at-Denver
  potato-specialty-product_per-kg-CO2-kg-eq-at-Denver

  potato-russet-conventional_per-kg-h2o-m3-at-farm
  potato-russet-conventional_per-kg-h2o-m3-at-Denver
  potato-russet-organic_per-kg-h2o-m3-at-farm
  potato-russet-organic_per-kg-h2o-m3-at-Denver
  potato-purple-conventional_per-kg-h2o-m3-at-farm
  potato-purple-conventional_per-kg-h2o-m3-at-Denver
  potato-purple-organic_per-kg-h2o-m3-at-farm
  potato-purple-organic_per-kg-h2o-m3-at-Denver
  potato-french-fry_per-kg-h2o-m3-at-Denver
  potato-specialty-product_per-kg-h2o-m3-at-Denver

  potato-russet-conventional_CO2-kg-eq-at-farm-annual
  potato-russet-conventional_CO2-kg-eq-at-Denver-annual
  potato-russet-organic_CO2-kg-eq-at-farm-annual
  potato-russet-organic_CO2-kg-eq-at-Denver-annual
  potato-purple-conventional_CO2-kg-eq-at-farm-annual
  potato-purple-conventional_CO2-kg-eq-at-Denver-annual
  potato-purple-organic_CO2-kg-eq-at-farm-annual
  potato-purple-organic_CO2-kg-eq-at-Denver-annual
  potato-french-fry_CO2-kg-eq-at-Denver-annual
  potato-specialty-product_CO2-kg-eq-at-Denver-annual

  potato-russet-conventional_h2o-m3-at-farm-annual
  potato-russet-conventional_h2o-m3-at-Denver-annual
  potato-russet-organic_h2o-m3-at-farm-annual
  potato-russet-organic_h2o-m3-at-Denver-annual
  potato-purple-conventional_h2o-m3-at-farm-annual
  potato-purple-conventional_h2o-m3-at-Denver-annual
  potato-purple-organic_h2o-m3-at-farm-annual
  potato-purple-organic_h2o-m3-at-Denver-annual
  potato-french-fry_h2o-m3-at-Denver-annual
  potato-specialty-product_h2o-m3-at-Denver-annual

  potato-russet-conventional_CO2-kg-eq-at-farm-model-run
  potato-russet-conventional_CO2-kg-eq-at-Denver-model-run
  potato-russet-organic_CO2-kg-eq-at-farm-model-run
  potato-russet-organic_CO2-kg-eq-at-Denver-model-run
  potato-purple-conventional_CO2-kg-eq-at-farm-model-run
  potato-purple-conventional_CO2-kg-eq-at-Denver-model-run
  potato-purple-organic_CO2-kg-eq-at-farm-model-run
  potato-purple-organic_CO2-kg-eq-at-Denver-model-run
  potato-french-fry_CO2-kg-eq-at-Denver-model-run
  potato-specialty-product_CO2-kg-eq-at-Denver-model-run

  potato-russet-conventional_h2o-m3-at-farm-model-run
  potato-russet-conventional_h2o-m3-at-Denver-model-run
  potato-russet-organic_h2o-m3-at-farm-model-run
  potato-russet-organic_h2o-m3-at-Denver-model-run
  potato-purple-conventional_h2o-m3-at-farm-model-run
  potato-purple-conventional_h2o-m3-at-Denver-model-run
  potato-purple-organic_h2o-m3-at-farm-model-run
  potato-purple-organic_h2o-m3-at-Denver-model-run
  potato-french-fry_h2o-m3-at-Denver-model-run
  potato-specialty-product_h2o-m3-at-Denver-model-run

  ; Totals for carbon dioxide equivalents and water depletion
  potato_CO2-kg-eq-at-farm-annual
  potato_CO2-kg-eq-at-Denver-annual
  potato_h2o-m3-at-farm-annual
  potato_h2o-m3-at-Denver-annual
  potato_CO2-kg-eq-at-farm-model-run
  potato_CO2-kg-eq-at-Denver-model-run
  potato_h2o-m3-at-farm-model-run
  potato_h2o-m3-at-Denver-model-run

  ; -------------WHEAT LCA
  ;products: wheat-hrw-conventional, wheat-hrw-organic, wheat-snowmass-conventional              (per-kg entries for model run and annual removed.  They do not apply and are not used.  rb  05/21/2022)

; Results from J. Antonanzas Torres, Feb 2, 2022
;
; 	                               Total at farm gate  	    Flour at DPS gate 	    Bread at DPS gate 	  Total at farm gate  	   Flour at DPS gate 	   Bread at DPS gate
;  	                                 kg CO2/kg wheat 	       kg CO2/kg flour 	       kg CO2/kg bread 	        m3/kg wheat 	          m3/kg flour 	        m3/kg bread
;  White winter conventional 	        4,39E-01 	               8,57E-01 	               8,51E-01 	           1,71E-01 	             5,79E-01 	           1,05E+00
;  Red winter conventional 	          4,61E-01 	               8,85E-01 	               8,69E-01 	           1,62E-01 	             5,67E-01 	           1,04E+00
;  Red winter organic 	              3,90E-01 	               7,92E-01 	               8,09E-01 	           2,56E-01 	             6,91E-01 	           1,12E+00
;  Baseline 	                                                 1,66E+00 	               1,37E+00 	  	  	

  ; GHG and Water Depletion parameters per KG
  wheat-snowmass-conventional_per-kg-CO2-kg-eq-at-farm
  wheat-hrw-conventional_per-kg-CO2-kg-eq-at-farm
  wheat-hrw-organic_per-kg-CO2-kg-eq-at-farm
  wheat-baseline_per-kg-CO2-kg-eq-at-farm
  wheat-snowmass-conventional-flour_per-kg-CO2-kg-eq-at-Denver
  wheat-hrw-conventional-flour_per-kg-CO2-kg-eq-at-Denver
  wheat-hrw-organic-flour_per-kg-CO2-kg-eq-at-Denver
  wheat-baseline-flour_per-kg-CO2-kg-eq-at-Denver
  wheat-snowmass-conventional-bread_per-kg-CO2-kg-eq-at-Denver
  wheat-hrw-conventional-bread_per-kg-CO2-kg-eq-at-Denver
  wheat-hrw-organic-bread_per-kg-CO2-kg-eq-at-Denver
  wheat-baseline-bread_per-kg-CO2-kg-eq-at-Denver

  wheat-snowmass-conventional_per-kg-h2o-m3-at-farm
  wheat-hrw-conventional_per-kg-h2o-m3-at-farm
  wheat-hrw-organic_per-kg-h2o-m3-at-farm
  wheat-baseline_per-kg-h2o-m3-at-farm
  wheat-snowmass-conventional-flour_per-kg-h2o-m3-at-Denver
  wheat-hrw-conventional-flour_per-kg-h2o-m3-at-Denver
  wheat-hrw-organic-flour_per-kg-h2o-m3-at-Denver
  wheat-baseline-flour_per-kg-h2o-m3-at-Denver
  wheat-snowmass-conventional-bread_per-kg-h2o-m3-at-Denver
  wheat-hrw-conventional-bread_per-kg-h2o-m3-at-Denver
  wheat-hrw-organic-bread_per-kg-h2o-m3-at-Denver
  wheat-baseline-bread_per-kg-h2o-m3-at-Denver

  wheat-snowmass-conventional_CO2-kg-eq-at-farm-model-run
  wheat-hrw-conventional_CO2-kg-eq-at-farm-model-run
  wheat-hrw-organic_CO2-kg-eq-at-farm-model-run
  wheat-baseline_CO2-kg-eq-at-farm-model-run
  wheat-snowmass-conventional-flour_CO2-kg-eq-at-Denver-model-run
  wheat-hrw-conventional-flour_CO2-kg-eq-at-Denver-model-run
  wheat-hrw-organic-flour_CO2-kg-eq-at-Denver-model-run
  wheat-baseline-flour_CO2-kg-eq-at-Denver-model-run
  wheat-snowmass-conventional-bread_CO2-kg-eq-at-Denver-model-run
  wheat-hrw-conventional-bread_CO2-kg-eq-at-Denver-model-run
  wheat-hrw-organic-bread_CO2-kg-eq-at-Denver-model-run
  wheat-baseline-bread_CO2-kg-eq-at-Denver-model-run

  wheat-snowmass-conventional_h2o-m3-at-farm-model-run
  wheat-hrw-conventional_h2o-m3-at-farm-model-run
  wheat-hrw-organic_h2o-m3-at-farm-model-run
  wheat-baseline_h2o-m3-at-farm-model-run
  wheat-snowmass-conventional-flour_h2o-m3-at-Denver-model-run
  wheat-hrw-conventional-flour_h2o-m3-at-Denver-model-run
  wheat-hrw-organic-flour_h2o-m3-at-Denver-model-run
  wheat-baseline-flour_h2o-m3-at-Denver-model-run
  wheat-snowmass-conventional-bread_h2o-m3-at-Denver-model-run
  wheat-hrw-conventional-bread_h2o-m3-at-Denver-model-run
  wheat-hrw-organic-bread_h2o-m3-at-Denver-model-run
  wheat-baseline-bread_h2o-m3-at-Denver-model-run

  wheat-snowmass-conventional_CO2-kg-eq-at-farm-annual
  wheat-hrw-conventional_CO2-kg-eq-at-farm-annual
  wheat-hrw-organic_CO2-kg-eq-at-farm-annual
  wheat-baseline_CO2-kg-eq-at-farm-annual
  wheat-snowmass-conventional-flour_CO2-kg-eq-at-Denver-annual
  wheat-hrw-conventional-flour_CO2-kg-eq-at-Denver-annual
  wheat-hrw-organic-flour_CO2-kg-eq-at-Denver-annual
  wheat-baseline-flour_CO2-kg-eq-at-Denver-annual
  wheat-snowmass-conventional-bread_CO2-kg-eq-at-Denver-annual
  wheat-hrw-conventional-bread_CO2-kg-eq-at-Denver-annual
  wheat-hrw-organic-bread_CO2-kg-eq-at-Denver-annual
  wheat-baseline-bread_CO2-kg-eq-at-Denver-annual

  wheat-snowmass-conventional_h2o-m3-at-farm-annual
  wheat-hrw-conventional_h2o-m3-at-farm-annual
  wheat-hrw-organic_h2o-m3-at-farm-annual
  wheat-baseline_h2o-m3-at-farm-annual
  wheat-snowmass-conventional-flour_h2o-m3-at-Denver-annual
  wheat-hrw-conventional-flour_h2o-m3-at-Denver-annual
  wheat-hrw-organic-flour_h2o-m3-at-Denver-annual
  wheat-baseline-flour_h2o-m3-at-Denver-annual
  wheat-snowmass-conventional-bread_h2o-m3-at-Denver-annual
  wheat-hrw-conventional-bread_h2o-m3-at-Denver-annual
  wheat-hrw-organic-bread_h2o-m3-at-Denver-annual
  wheat-baseline-bread_h2o-m3-at-Denver-annual

  ; Totals for carbon dioxide equivalents and water depletion
  wheat_CO2-kg-eq-at-farm-annual
  wheat_CO2-kg-eq-at-Denver-annual
  wheat_h2o-m3-at-farm-annual
  wheat_h2o-m3-at-Denver-annual
  wheat_CO2-kg-eq-at-farm-model-run
  wheat_CO2-kg-eq-at-Denver-model-run
  wheat_h2o-m3-at-farm-model-run
  wheat_h2o-m3-at-Denver-model-run

  ; -------------PEACHES LCA
  ; products: conventional, organic, seconds --> IQF



  ; -------------BEEF LCA       ---- !!!!!!!!!!!! OUTDATED !!!!!!!!!!!!!!!
  ; products: conventional, grassfed, colorado-source-id, animal-welfare

  ; Results from Jasmin Dillion, May 9, 2022
  ; ********************************************************
  ; Baseline, AGA, & AWA beef 	  	
  ; GWP       	5.6 	kg CO2e/kg cull cow LW
  ;     	     11.3  	kg CO2e/kg cull cow HCW
  ; WF       	330.2 	L H2O/kg cull cow LW
  ;         	660.3  	L H2O/kg cull cow HCW
  ; ********************************************************

  ; LW is live weight.  HCW is hot carcass weight.
  beef-conventional_per-kg-CO2-kg-eq-at-farm
  beef-conventional_per-kg-h2o-m3-at-farm
  beef-conventional_CO2-kg-eq-at-farm-model-run
  beef-conventional_h2o-m3-at-farm-model-run
  beef-conventional_CO2-kg-eq-at-farm-annual
  beef-conventional_h2o-m3-at-farm-annual
  beef-grassfed_per-kg-CO2-kg-eq-at-farm
  beef-grassfed_per-kg-h2o-m3-at-farm
  beef-grassfed_CO2-kg-eq-at-farm-model-run
  beef-grassfed_h2o-m3-at-farm-model-run
  beef-grassfed_CO2-kg-eq-at-farm-annual
  beef-grassfed_h2o-m3-at-farm-annual
  beef-colorado-source-id_per-kg-CO2-kg-eq-at-farm
  beef-colorado-source-id_per-kg-h2o-m3-at-farm
  beef-colorado-source-id_CO2-kg-eq-at-farm-model-run
  beef-colorado-source-id_h2o-m3-at-farm-model-run
  beef-colorado-source-id_CO2-kg-eq-at-farm-annual
  beef-colorado-source-id_h2o-m3-at-farm-annual
  beef-animal-welfare_per-kg-CO2-kg-eq-at-farm
  beef-animal-welfare_per-kg-h2o-m3-at-farm
  beef-animal-welfare_CO2-kg-eq-at-farm-model-run
  beef-animal-welfare_h2o-m3-at-farm-model-run
  beef-animal-welfare_CO2-kg-eq-at-farm-annual
  beef-animal-welfare_h2o-m3-at-farm-annual

  beef-conventional_per-kg-CO2-kg-eq-at-Denver
  beef-conventional_per-kg-h2o-m3-at-Denver
  beef-conventional_CO2-kg-eq-at-Denver-model-run
  beef-conventional_h2o-m3-at-Denver-model-run
  beef-conventional_CO2-kg-eq-at-Denver-annual
  beef-conventional_h2o-m3-at-Denver-annual
  beef-grassfed_per-kg-CO2-kg-eq-at-Denver
  beef-grassfed_per-kg-h2o-m3-at-Denver
  beef-grassfed_CO2-kg-eq-at-Denver-model-run
  beef-grassfed_h2o-m3-at-Denver-model-run
  beef-grassfed_CO2-kg-eq-at-Denver-annual
  beef-grassfed_h2o-m3-at-Denver-annual
  beef-colorado-source-id_per-kg-CO2-kg-eq-at-Denver
  beef-colorado-source-id_per-kg-h2o-m3-at-Denver
  beef-colorado-source-id_CO2-kg-eq-at-Denver-model-run
  beef-colorado-source-id_h2o-m3-at-Denver-model-run
  beef-colorado-source-id_CO2-kg-eq-at-Denver-annual
  beef-colorado-source-id_h2o-m3-at-Denver-annual
  beef-animal-welfare_per-kg-CO2-kg-eq-at-Denver
  beef-animal-welfare_per-kg-h2o-m3-at-Denver
  beef-animal-welfare_CO2-kg-eq-at-Denver-model-run
  beef-animal-welfare_h2o-m3-at-Denver-model-run
  beef-animal-welfare_CO2-kg-eq-at-Denver-annual
  beef-animal-welfare_h2o-m3-at-Denver-annual

  ; Totals for carbon dioxide equivalents and water depletion
  beef_CO2-kg-eq-at-farm-annual
  beef_h2o-m3-at-farm-annual
  beef_CO2-kg-eq-at-farm-model-run
  beef_h2o-m3-at-farm-model-run

  beef_CO2-kg-eq-at-Denver-annual
  beef_h2o-m3-at-Denver-annual
  beef_CO2-kg-eq-at-Denver-model-run
  beef_h2o-m3-at-Denver-model-run



  ;; -------------------------
  ; production: potatoes
  ;; -------------------------

  potato-russet-conventional_production-annual
  potato-russet-conventional_production-total-model-run
  potato-russet-organic_production-annual
  potato-russet-organic_production-total-model-run
  potato-purple-conventional_production-annual
  potato-purple-conventional_production-total-model-run
  potato-purple-organic_production-annual
  potato-purple-organic_production-total-model-run

   ;; -------------------------
  ; production: wheat
  ;; -------------------------

  wheat-hrw-conventional_production-annual
  wheat-hrw-conventional_production-total-model-run
  wheat-hrw-organic_production-annual
  wheat-hrw-organic_production-total-model-run
  wheat-snowmass-conventional_production-annual
  wheat-snowmass-conventional_production-total-model-run

  ;; -------------------------
  ; production: peaches
  ;; -------------------------

  peach-conventional_production-annual
  peach-conventional_production-total-model-run
  peach-organic_production-annual
  peach-organic_production-total-model-run
  peach-seconds_production-annual
  peach-seconds_production-total-model-run

  ; weight conversion rate from fresh to iqf peaches
  peaches-iqf-conversion-rate

   ;; -------------------------
  ; production: beef
  ;; -------------------------
  beef-conventional_production-annual
  beef-conventional_production-total-model-run
  beef-grassfed_production-annual
  beef-grassfed_production-total-model-run
  beef-colorado-source-id_production-annual
  beef-colorado-source-id_production-total-model-run
  beef-animal-welfare_production-annual
  beef-animal-welfare_production-total-model-run

  ; weight conversion rate for cow to ground beef
  ground-beef-conversion-rate

  ;; -------------------------
  ; prices: potatoes
  ;; -------------------------

  ;input costs per acre ($)
  potato-conventional-russet_cost-input-per-acre
  potato-organic-russet_cost-input-per-acre
  potato-conventional-purple_cost-input-per-acre
  potato-organic-purple_cost-input-per-acre

  ;farmer breakeven per lb. prices
  potato-conventional-russet_price-farmer-breakeven
  potato-organic-russet_price-farmer-breakeven
  potato-conventional-purple_price-farmer-breakeven
  potato-organic-purple_price-farmer-breakeven

  ;; prices for all four potato varieties (avg and standard deviation) in $/lb.
  ; careful with conversions because production inputs in kg/ha

  ;farmgate prices (paid by shipper)
  potato-conventional-russet_price-farmgate-avg
  potato-conventional-russet_price-farmgate-stdev

  potato-organic-russet_price-farmgate-avg
  potato-organic-russet_price-farmgate-stdev

  potato-conventional-purple_price-farmgate-avg
  potato-conventional-purple_price-farmgate-stdev

  potato-organic-purple_price-farmgate-avg
  potato-organic-purple_price-farmgate-stdev

  potato-conventional-russet-small_price-farmgate-avg
  potato-conventional-russet-small_price-farmgate-stdev

  ;price shipper receives
  potato-conventional-russet_price-shipper-receives-avg
  potato-conventional-russet_price-shipper-receives-stdev

  potato-organic-russet_price-shipper-receives-avg
  potato-organic-russet_price-shipper-receives-stdev

  potato-conventional-purple_price-shipper-receives-avg
  potato-conventional-purple_price-shipper-receives-stdev

  potato-organic-purple_price-shipper-receives-avg
  potato-organic-purple_price-shipper-receives-stdev

  potato-conventional-russet-small_price-shipper-receives-avg
  potato-conventional-russet-small_price-shipper-receives-stdev

  ;price repacker pays to farmer
  potato-conventional-russet_price-repacker-pays-avg
  potato-conventional-russet_price-repacker-pays-stdev

  potato-organic-russet_price-repacker-pays-avg
  potato-organic-russet_price-repacker-pays-stdev

  potato-conventional-purple_price-repacker-pays-avg
  potato-conventional-purple_price-repacker-pays-stdev

  potato-organic-purple_price-repacker-pays-avg
  potato-organic-purple_price-repacker-pays-stdev

  potato-conventional-russet-small_price-repacker-pays-avg
  potato-conventional-russet-small_price-repacker-pays-stdev

  ;price repacker receives
  potato-conventional-russet_price-repacker-receives-avg
  potato-conventional-russet_price-repacker-receives-stdev

  potato-organic-russet_price-repacker-receives-avg
  potato-organic-russet_price-repacker-receives-stdev

  potato-conventional-purple_price-repacker-receives-avg
  potato-conventional-purple_price-repacker-receives-stdev

  potato-organic-purple_price-repacker-receives-avg
  potato-organic-purple_price-repacker-receives-stdev

  potato-conventional-russet-small_price-repacker-receives-avg
  potato-conventional-russet-small_price-repacker-receives-stdev

  ;price distributor receives
  potato-conventional-russet_price-distributor-receives-avg
  potato-conventional-russet_price-distributor-receives-stdev

  potato-organic-russet_price-distributor-receives-avg
  potato-organic-russet_price-distributor-receives-stdev

  potato-conventional-purple_price-distributor-receives-avg
  potato-conventional-purple_price-distributor-receives-stdev

  potato-organic-purple_price-distributor-receives-avg
  potato-organic-purple_price-distributor-receives-stdev

  potato-conventional-russet-small_price-distributor-receives-avg
  potato-conventional-russet-small_price-distributor-receives-stdev

  ;price processor receives
  potato-conventional-russet-processed_price-processor-receives-avg
  potato-conventional-russet-processed_price-processor-receives-stdev

  potato-organic-russet-processed_price-processor-receives-avg
  potato-organic-russet-processed_price-processor-receives-stdev

  potato-conventional-purple-processed_price-processor-receives-avg
  potato-conventional-purple-processed_price-processor-receives-stdev

  potato-organic-purple-processed_price-processor-receives-avg
  potato-organic-purple-processed_price-processor-receives-stdev

  ;price distributor receives for processed product
  potato-conventional-russet-processed_price-distributor-receives-avg
  potato-conventional-russet-processed_price-distributor-receives-stdev

  potato-organic-russet-processed_price-distributor-receives-avg
  potato-organic-russet-processed_price-distributor-receives-stdev

  potato-conventional-purple-processed_price-distributor-receives-avg
  potato-conventional-purple-processed_price-distributor-receives-stdev

  potato-organic-purple-processed_price-distributor-receives-avg
  potato-organic-purple-processed_price-distributor-receives-stdev

  ; gfpp and small scenarios: price points for short supply chains

  ; price farmer receives from shipper in short supply chain
  potato-conventional-russet_gfpp-price-farmgate-avg
  potato-conventional-russet_gfpp-price-farmgate-stdev

  potato-organic-russet_gfpp-price-farmgate-avg
  potato-organic-russet_gfpp-price-farmgate-stdev

  potato-conventional-purple_gfpp-price-farmgate-avg
  potato-conventional-purple_gfpp-price-farmgate-stdev

  potato-organic-purple_gfpp-price-farmgate-avg
  potato-organic-purple_gfpp-price-farmgate-stdev

  potato-conventional-russet-small_gfpp-price-farmgate-avg
  potato-conventional-russet-small_gfpp-price-farmgate-stdev

  ; price shipper receives from dps in short supply chain
  potato-conventional-russet_gfpp-price-shipper-receives-avg
  potato-conventional-russet_gfpp-price-shipper-receives-stdev

  potato-organic-russet_gfpp-price-shipper-receives-avg
  potato-organic-russet_gfpp-price-shipper-receives-stdev

  potato-conventional-purple_gfpp-price-shipper-receives-avg
  potato-conventional-purple_gfpp-price-shipper-receives-stdev

  potato-organic-purple_gfpp-price-shipper-receives-avg
  potato-organic-purple_gfpp-price-shipper-receives-stdev

  potato-conventional-russet-small_gfpp-price-shipper-receives-avg
  potato-conventional-russet-small_gfpp-price-shipper-receives-stdev

  ;; -------------------------
  ; prices: wheat
  ;; -------------------------

  ;; prices for all wheat varieties (avg and standard deviation)

  ;; input costs
  wheat-hrw-conventional_cost-input-per-acre
  wheat-hrw-organic_cost-input-per-acre
  wheat-snowmass-conventional_cost-input-per-acre

  ;breakeven prices (per lb.)
  wheat-hrw-conventional_price-farmer-breakeven
  wheat-hrw-organic_price-farmer-breakeven
  wheat-snowmass-conventional_price-farmer-breakeven

  ; wheat prices in $/lb.

  ;farmgate prices
  wheat-hrw-conventional_price-farmgate-avg
  wheat-hrw-conventional_price-farmgate-stdev

  wheat-hrw-organic_price-farmgate-avg
  wheat-hrw-organic_price-farmgate-stdev

  wheat-snowmass-conventional_price-farmgate-avg
  wheat-snowmass-conventional_price-farmgate-stdev

  ;prices elevators receive
  wheat-hrw-conventional_price-elevator-receives-avg
  wheat-hrw-conventional_price-elevator-receives-stdev

  wheat-hrw-organic_price-elevator-receives-avg
  wheat-hrw-organic_price-elevator-receives-stdev

  wheat-snowmass-conventional_price-elevator-receives-avg
  wheat-snowmass-conventional_price-elevator-receives-stdev

  ;prices mills receive
  wheat-hrw-conventional-flour_price-mill-receives-avg
  wheat-hrw-conventional-flour_price-mill-receives-stdev

  wheat-hrw-organic-flour_price-mill-receives-avg
  wheat-hrw-organic-flour_price-mill-receives-stdev

  wheat-snowmass-conventional-flour_price-mill-receives-avg
  wheat-snowmass-conventional-flour_price-mill-receives-stdev

  ;prices bakers receive
  wheat-hrw-conventional-bread_price-baker-receives-avg
  wheat-hrw-conventional-bread_price-baker-receives-stdev

  wheat-hrw-organic-bread_price-baker-receives-avg
  wheat-hrw-organic-bread_price-baker-receives-stdev

  wheat-snowmass-conventional-bread_price-baker-receives-avg
  wheat-snowmass-conventional-bread_price-baker-receives-stdev

  ;prices distributors receive
  wheat-hrw-conventional-flour_price-distributor-receives-avg
  wheat-hrw-conventional-flour_price-distributor-receives-stdev

  wheat-hrw-organic-flour_price-distributor-receives-avg
  wheat-hrw-organic-flour_price-distributor-receives-stdev

  wheat-snowmass-conventional-flour_price-distributor-receives-avg
  wheat-snowmass-conventional-flour_price-distributor-receives-stdev

  wheat-hrw-conventional-bread_price-distributor-receives-avg
  wheat-hrw-conventional-bread_price-distributor-receives-stdev

  wheat-hrw-organic-bread_price-distributor-receives-avg
  wheat-hrw-organic-bread_price-distributor-receives-stdev

  wheat-snowmass-conventional-bread_price-distributor-receives-avg
  wheat-snowmass-conventional-bread_price-distributor-receives-stdev

  ;; -------------------------
  ; prices: peaches
  ;; -------------------------

  ;; prices for peach varieties (avg and standard deviation)

  ;; input prices
  peach-conventional_cost-input-per-acre
  peach-organic_cost-input-per-acre

  ;breakeven prices (per lb.)
  peach-conventional_price-farmer-breakeven
  peach-organic_price-farmer-breakeven

  ; peach prices in $/lb.

  ;;prices farmers who self pack and/or are the outsource packer recieve
  peach-conventional_price-farmgate-wholesale-avg
  peach-conventional_price-farmgate-wholesale-stdev
  peach-organic_price-farmgate-wholesale-avg
  peach-organic_price-farmgate-wholesale-stdev
  peach-seconds_price-farmgate-wholesale-avg
  peach-seconds-to-iqf_price-farmgate-wholesale-avg
  peach-seconds_price-farmgate-wholesale-stdev

  peach-conventional_price-farmgate-altmark-avg
  peach-conventional_price-farmgate-altmark-stdev
  peach-organic_price-farmgate-altmark-avg
  peach-organic_price-farmgate-altmark-stdev
;  peach-seconds_price-farmgate-altmark-avg
;  peach-seconds_price-farmgate-altmark-stdev

  ;; prices farmers who outsource pack receive
  peach-conventional-outsourced_price-farmgate-avg
  peach-conventional-outsourced_price-farmgate-stdev
  peach-organic-outsourced_price-farmgate-avg
  peach-organic-outsourced_price-farmgate-stdev
  peach-seconds-outsourced_price-farmgate-avg
  peach-seconds-outsourced_price-farmgate-stdev

  ;; prices IQF receive
  peach-iqf_price-iqf-receives-avg
  peach-iqf_price-iqf-receives-stdev

  ; prices distributors pay
  peach-out-of-state_price-distributor-pays-avg
  peach-out-of-state_price-distributor-pays-stdev

  ;; prices distributors receive
  peach-out-of-state_price-distributor-receives-avg
  peach-out-of-state_price-distributor-receives-stdev


  ;; -------------------------
  ; prices: beef
  ;; -------------------------

  ; input costs
  beef-conventional_cost_input_per_head

  ;farm gate prices
  beef-conventional-live-weight_price-farmgate-avg
  beef-conventional-live-weight_price-farmgate-stdev

  beef-grassfed-live-weight_price-farmgate-avg
  beef-grassfed-live-weight_price-farmgate-stdev

  beef-colorado-source-id-live-weight_price-farmgate-avg
  beef-colorado-source-id-live-weight_price-farmgate-stdev

  beef-animal-welfare-live-weight_price-farmgate-avg
  beef-animal-welfare-live-weight_price-farmgate-stdev

  ; packing house prices
  beef-conventional_price-packing-house-receives-avg
  beef-conventional_price-packing-house-receives-stdev

  beef-grassfed_price-packing-house-receives-avg
  beef-grassfed_price-packing-house-receives-stdev

  beef-colorado-source-id_price-packing-house-receives-avg
  beef-colorado-source-id_price-packing-house-receives-stdev

  beef-animal-welfare_price-packing-house-receives-avg
  beef-animal-welfare_price-packing-house-receives-stdev

  ; distributor prices
  beef-conventional_price-distributor-receives-avg
  beef-conventional_price-distributor-receives-stdev

  beef-grassfed_price-distributor-receives-avg
  beef-grassfed_price-distributor-receives-stdev

  beef-colorado-source-id_price-distributor-receives-avg
  beef-colorado-source-id_price-distributor-receives-stdev

  beef-animal-welfare_price-distributor-receives-avg
  beef-animal-welfare_price-distributor-receives-stdev

  ;; -------------------------
  ; lbs. of each product inside/outside the dps system
  ;; -------------------------

  ;; potatoes
  potatoes-outside                                               ;; potatoes sent outside the system (no capacity for them in the model world) in lbs. ALL POTATOES (raw, processed)
  potatoes-dps

  potato-french-fry_dps-purchased-annual
  potato-french-fry_dps-purchased-total-model-run
  potato-russet-conventional_dps-purchased-annual
  potato-russet-conventional_dps-purchased-total-model-run
  potato-russet-organic_dps-purchased-annual
  potato-russet-organic_dps-purchased-total-model-run
  potato-purple-conventional_dps-purchased-annual
  potato-purple-conventional_dps-purchased-total-model-run
  potato-purple-organic_dps-purchased-annual
  potato-purple-organic_dps-purchased-total-model-run
  potato-specialty-product_dps-purchased-annual                   ;; note that all specialty product made from purple conventional potatoes in our scenario so lca for specialty product based on purple conventional
  potato-specialty-product_dps-purchased-total-model-run

  potato-russet-conventional_production-annual-kg
  potato-russet-conventional_production-total-model-run-kg
  potato-russet-organic_production-annual-kg
  potato-russet-organic_production-total-model-run-kg
  potato-purple-conventional_production-annual-kg
  potato-purple-conventional_production-total-model-run-kg
  potato-purple-organic_production-annual-kg
  potato-purple-organic_production-total-model-run-kg

  ; potatoes purchased by dps
  potato-french-fry_dps-purchased-annual-kg
  potato-french-fry_dps-purchased-total-model-run-kg
  potato-russet-conventional_dps-purchased-annual-kg
  potato-russet-conventional_dps-purchased-total-model-run-kg
  potato-russet-organic_dps-purchased-annual-kg
  potato-russet-organic_dps-purchased-total-model-run-kg
  potato-purple-conventional_dps-purchased-annual-kg
  potato-purple-conventional_dps-purchased-total-model-run-kg
  potato-purple-organic_dps-purchased-annual-kg
  potato-purple-organic_dps-purchased-total-model-run-kg
  potato-specialty-product_dps-purchased-annual-kg
  potato-specialty-product_dps-purchased-total-model-run-kg

  ;; wheat
  wheat-outside                                           ;; wheat sent outside the system (no capacity for them in the model world) in lbs. counts ALL wheat of all varieties (raw, processed)
  wheat-dps
  flour-dps
  bread-dps

  wheat-hrw-conventional_production-annual-kg
  wheat-hrw-conventional_production-total-model-run-kg
  wheat-hrw-organic_production-annual-kg
  wheat-hrw-organic_production-total-model-run-kg
  wheat-snowmass-conventional_production-annual-kg
  wheat-snowmass-conventional_production-total-model-run-kg

  ; wheat products purchased by dps in lbs
  wheat-hrw-conventional-flour_dps-purchased-annual
  wheat-hrw-conventional-flour_dps-purchased-total-model-run
  wheat-hrw-organic-flour_dps-purchased-annual
  wheat-hrw-organic-flour_dps-purchased-total-model-run
  wheat-snowmass-conventional-flour_dps-purchased-annual
  wheat-snowmass-conventional-flour_dps-purchased-total-model-run
  wheat-hrw-conventional-bread_dps-purchased-annual
  wheat-hrw-conventional-bread_dps-purchased-total-model-run
  wheat-hrw-organic-bread_dps-purchased-annual
  wheat-hrw-organic-bread_dps-purchased-total-model-run
  wheat-snowmass-conventional-bread_dps-purchased-annual
  wheat-snowmass-conventional-bread_dps-purchased-total-model-run


  ; wheat products purchased by dps in kg
  wheat-hrw-conventional-flour_dps-purchased-annual-kg
  wheat-hrw-conventional-flour_dps-purchased-total-model-run-kg
  wheat-hrw-organic-flour_dps-purchased-annual-kg
  wheat-hrw-organic-flour_dps-purchased-total-model-run-kg
  wheat-snowmass-conventional-flour_dps-purchased-annual-kg
  wheat-snowmass-conventional-flour_dps-purchased-total-model-run-kg
  wheat-hrw-conventional-bread_dps-purchased-annual-kg
  wheat-hrw-conventional-bread_dps-purchased-total-model-run-kg
  wheat-hrw-organic-bread_dps-purchased-annual-kg
  wheat-hrw-organic-bread_dps-purchased-total-model-run-kg
  wheat-snowmass-conventional-bread_dps-purchased-annual-kg
  wheat-snowmass-conventional-bread_dps-purchased-total-model-run-kg

  ;; peaches
  peaches-outside
  peaches-dps

  ;; beef
  beef-outside
  beef-dps
  beef-conventional_dps-purchased-annual-kg
  beef-grassfed_dps-purchased-annual-kg
  beef-colorado-source-id_dps-purchased-annual-kg
  beef-animal-welfare_dps-purchased-annual-kg

  beef-conventional_dps-purchased-total-model-run-kg
  beef-grassfed_dps-purchased-total-model-run-kg
  beef-colorado-source-id_dps-purchased-total-model-run-kg
  beef-animal-welfare_dps-purchased-total-model-run-kg

]


breed [potato_farmers potato_farmer]
breed [potato_repackers potato_repacker]
breed [potato_shippers potato_shipper]
breed [potato_processors potato_processor]

breed [wheat_farmers wheat_farmer]
breed [wheat_elevators wheat_elevator]
breed [wheat_mills wheat_mill]
breed [wheat_bakers wheat_baker]

breed [peach_farmers peach_farmer]
breed [peach_processors peach_processor]
breed [peach_altmarks peach_altmark]                             ;; alternative market (e.g. farmer's market) for peach sales

breed [beef_ranchers beef_rancher]
breed [beef_packing-houses beef_packing-house]

breed [distributors distributor]
breed [dps_buyers dps_buyer]


patches-own [
  county-id

  county-denver

  ;; potatoes
  county-potato                                                  ;; dummy variable for whether the patch is located in a potato county
  county-potato-name                                             ;; text name of county
  potato-yes-no                                                  ;; whether patch grows potatoes
  potato-canela-mean-yield                                       ;; from DSSAT, mean potential yield in kg/ha from 38 years
  potato-canela-org-mean-yield                                   ;; from DSSAT, mean potential yield in kg/ha from 38 years
  potato-purple-mean-yield                                       ;; from DSSAT, mean potential yield in kg/ha from 38 years
  potato-purple-org-mean-yield                                   ;; from DSSAT, mean potential yield in kg/ha from 38 years
  potato-russet-canela-current-yield                             ;; from DSSAT, this year's potential yield in kg/ha
  potato-russet-canela-org-current-yield                         ;; from DSSAT, this year's potential yield in kg/ha
  potato-purple-current-yield                                    ;; from DSSAT, this year's potential yield in kg/ha
  potato-purple-org-current-yield                                ;; from DSSAT, this year's potential yield in kg/ha

  ;; wheat
  county-wheat
  county-wheat-name
  wheat-yes-no
  wheat-hrw-conv-mean-yield
  wheat-hrw-org-mean-yield
  wheat-snowmass-conv-mean-yield
  wheat-hrw-conv-current-yield
  wheat-hrw-org-current-yield
  wheat-snowmass-conv-current-yield
  patch-wheat-fallow-rotate
  patch-corn-wheat-fallow-rotate

  ;; peaches
  county-peach
  county-peach-name
  peach-yes-no
  peach-conventional-mean-yield
  peach-organic-mean-yield
  peach-conventional-current-yield                               ;; lbs/ha
  peach-organic-current-yield                                    ;; lbs/ha

  ;; beef
  county-beef
  county-beef-name
  private-public
  mean-forage-production
  ann-forage-production
  mean-forage-neighborhood
  year-precip
  precip-pct
  average-precip
  irrigated
  grazable

  ;; common
  occupied                                                       ;; whether patch is owned/occupied by a farm/ranch
  my-farmer                                                      ;; agentset that comprises my farmer
  farmer                                                         ;; id of farm/ranch that occupies patch
  certified-organic                                              ;; if patch is certified organic
  rotation                                                       ;; if wheat is currently being grown at all, "wheat". if only barley, "barley." diff for wheat.
  remainder-patch                                                ;; patch that is planted to the remainder of wheat, e.g. if farm has 250 hectares of wheat, this patch grows the 50
  organic-conversion-tracker                                     ;; tracks number of years spent converting a patch from conventional to organic use (1, 2, 3 then becomes fully organic)
  in-organic-transition                                          ;; tracks whether or not the patch is in the process of transitioning to organic --> 1 = yes

]


potato_farmers-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  short-suppply-chain-interactions
  profitability-average
  home-county                                                    ;; home county id of farmer
  hectares-farmed-potatoes                                       ;; total hectares farmed in potatoes
  hectares-farmed-total                                          ;; total hectares farmed potatoes and barley
  initialized                                                    ;; whether initialized yet in setup
  patches-occupied                                               ;; how many 100-ha patches farm occupies
  my-patches                                                     ; the list of patches owned by each farmer
  farm-id                                                        ;; unique identifier   we switched between id and farm-id at one point, probably need to check code to see which one used and delete the other  - el 5/21/21
  grows-organic                                                  ;; yes/no on whether has any certified organic patches
  fully-organic                                                  ;; 1 if all farmer's patches are organic, 0 otherwise
  loyalty-to-buyer-id                                            ;; id number of buying agent that farmer prefers to sell to based on loyalty from previous year's relationship

  russet-canela-allocation                                       ;; percent of potato production in russet-canela
  purple-allocation                                              ;; percent of potato production in purple (farmers currently grow 20% purple)

  my-russet-conventional-hectares-for-costs                      ; hectares for input costs and price received different if there are patches in transition (pay organic input costs for first three years during transition without receiving organic premiums on products)
  my-russet-organic-hectares-for-costs
  my-purple-conventional-hectares-for-costs
  my-purple-organic-hectares-for-costs

  russet-canela-current-production                               ;; total of this year's production of potatoes in lbs. (calculated from DSSAT data and converted to lbs. in "calculate-annual-production")
  russet-canela-org-current-production
  purple-current-production
  purple-org-current-production

  patches-in-potatoes                                            ;; number of patches needed to grow potatoes based on hectares of potatoes they grow- for rotation
  patches-in-rotation                                            ;; number of patches (if any) that may be entirely planted to barley in rotation (otherwise rotation is internal to patches for smaller operations, and yield doesn't change

  conventional-proportion                                        ;; percent of land in conventional production
  organic-proportion                                             ;; percent of land in organic production
  transition-proportion                                          ;; percent of land in transition between conventional and organic production

  potatoes-russet-conventional-fresh_inventory-current           ;; total inventory (in pounds) of conventional russet potatoes
  potatoes-russet-conventional-fresh_inventory-maximum
  potatoes-russet-conventional-fresh_price-to-sell               ;; set from distribution, used in contracting
  potato-farmers_yield-estimated_russet-conventional             ;; farmers estimate yield using historical average of their patches
  potatoes-russet-conventional-fresh-promised                    ;; how many potatoes of this type have been contracted away (to compare against how many are available, so the agent doesn't promise more than it has)

  potatoes-russet-organic-fresh_inventory-current                ;; total inventory (in pounds) of organic russet potatoes
  potatoes-russet-organic-fresh_inventory-maximum
  potatoes-russet-organic-fresh_price-to-sell
  potato-farmers_yield-estimated_russet-organic
  potatoes-russet-organic-fresh-promised

  potatoes-purple-conventional-fresh_inventory-current           ;; total inventory (in pounds) of conventional purple potatoes
  potatoes-purple-conventional-fresh_inventory-maximum
  potatoes-purple-conventional-fresh_price-to-sell
  potato-farmers_yield-estimated_purple-conventional
  potatoes-purple-conventional-fresh-promised

  potatoes-purple-organic-fresh_inventory-current                ;; total inventory (in pounds) of organic purple potatoes
  potatoes-purple-organic-fresh_inventory-maximum
  potatoes-purple-organic-fresh_price-to-sell
  potato-farmers_yield-estimated_purple-organic
  potatoes-purple-organic-fresh-promised

  potatoes-russet-conventional-fresh-small_inventory-current    ;; small potatoes are all russet conventional (taken as % of russet conventional grown)
  potatoes-russet-conventional-fresh-small_inventory-maximum
  potatoes-russet-conventional-fresh-small_price-to-sell
  potato-farmers_yield-estimated_russet-conventional-small
  potatoes-russet-conventional-fresh-small-promised

  potatoes-russet-conventional_passthrough-annual               ;; annual passthrough variables track how many lbs. of product any given agent has "touched" in a given year (inventory sometimes "ghosts" on plots when product is bought and sold in the same time period before plot can capture that info)
  potatoes-russet-organic_passthrough-annual
  potatoes-purple-conventional_passthrough-annual
  potatoes-purple-organic_passthrough-annual
  potatoes-russet-conventional-small_passthrough-annual

; socio-cultural decision-making variables
  transition-likelihood-score
  transition-profitable
  tls-initial
  tls-final
  tls-change
  not-male
  first-time-farmer
  young-farmer
  not-white
  primary-income
  alternative-farmer
  farm-size
  farm-transitioning
  mediocre-production-year
  bad-production-year

]

potato_repackers-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  profitability-average
  loyalty-to-buyer-id

  potatoes-russet-conventional-fresh_inventory-current
  potatoes-russet-conventional-fresh_inventory-maximum
  potatoes-russet-conventional-fresh_price-to-buy
  potatoes-russet-conventional-fresh_price-to-sell
  potatoes-russet-conventional-fresh_contract-space-available
  potatoes-russet-conventional-fresh_space-available
  potatoes-russet-conventional-fresh-promised
  potatoes-russet-conventional-fresh_my-incoming-total

  potatoes-russet-organic-fresh_inventory-current
  potatoes-russet-organic-fresh_inventory-maximum
  potatoes-russet-organic-fresh_price-to-buy
  potatoes-russet-organic-fresh_price-to-sell
  potatoes-russet-organic-fresh_contract-space-available
  potatoes-russet-organic-fresh-promised
  potatoes-russet-organic-fresh_my-incoming-total

  potatoes-purple-conventional-fresh_inventory-current
  potatoes-purple-conventional-fresh_inventory-maximum
  potatoes-purple-conventional-fresh_price-to-buy
  potatoes-purple-conventional-fresh_price-to-sell
  potatoes-purple-conventional-fresh_contract-space-available
  potatoes-purple-conventional-fresh-promised
  potatoes-purple-conventional-fresh_my-incoming-total

  potatoes-purple-organic-fresh_inventory-current
  potatoes-purple-organic-fresh_inventory-maximum
  potatoes-purple-organic-fresh_price-to-buy
  potatoes-purple-organic-fresh_price-to-sell
  potatoes-purple-organic-fresh_contract-space-available
  potatoes-purple-organic-fresh-promised
  potatoes-purple-organic-fresh_my-incoming-total

  potatoes-russet-conventional-fresh-small_inventory-current
  potatoes-russet-conventional-fresh-small_inventory-maximum
  potatoes-russet-conventional-fresh-small_price-to-buy
  potatoes-russet-conventional-fresh-small_price-to-sell
  potatoes-russet-conventional-fresh-small_contract-space-available
  potatoes-russet-conventional-fresh-small_space-available
  potatoes-russet-conventional-fresh-small-promised
  potatoes-russet-conventional-fresh-small_my-incoming-total

  ]


potato_shippers-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  short-supply-chain-interactions
  profitability-average
  loyalty-to-buyer-id

  potatoes-russet-conventional-fresh_inventory-current
  potatoes-russet-conventional-fresh_inventory-maximum
  potatoes-russet-conventional-fresh_price-to-buy
  potatoes-russet-conventional-fresh_price-to-sell
  potatoes-russet-conventional-fresh_contract-space-available
  potatoes-russet-conventional-fresh-promised
  potatoes-russet-conventional-fresh_my-incoming-total

  potatoes-russet-organic-fresh_inventory-current
  potatoes-russet-organic-fresh_inventory-maximum
  potatoes-russet-organic-fresh_price-to-buy
  potatoes-russet-organic-fresh_price-to-sell
  potatoes-russet-organic-fresh_contract-space-available
  potatoes-russet-organic-fresh-promised
  potatoes-russet-organic-fresh_my-incoming-total

  potatoes-purple-conventional-fresh_inventory-current
  potatoes-purple-conventional-fresh_inventory-maximum
  potatoes-purple-conventional-fresh_price-to-buy
  potatoes-purple-conventional-fresh_price-to-sell
  potatoes-purple-conventional-fresh_contract-space-available
  potatoes-purple-conventional-fresh-promised
  potatoes-purple-conventional-fresh_my-incoming-total

  potatoes-purple-organic-fresh_inventory-current
  potatoes-purple-organic-fresh_inventory-maximum
  potatoes-purple-organic-fresh_price-to-buy
  potatoes-purple-organic-fresh_price-to-sell
  potatoes-purple-organic-fresh_contract-space-available
  potatoes-purple-organic-fresh-promised
  potatoes-purple-organic-fresh_my-incoming-total

  potatoes-russet-conventional-fresh-small_inventory-current
  potatoes-russet-conventional-fresh-small_inventory-maximum
  potatoes-russet-conventional-fresh-small_price-to-buy
  potatoes-russet-conventional-fresh-small_price-to-sell
  potatoes-russet-conventional-fresh-small_contract-space-available
  potatoes-russet-conventional-fresh-small-promised
  potatoes-russet-conventional-fresh-small_my-incoming-total

  contract-short-inventory   ;i have no idea what this is or where it came from - el 5/21/21         It is used nowhere and is not included in the ODD - rb 6/4/21

  ]


potato_processors-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  profitability-average
  loyalty-to-buyer-id

  potatoes-russet-conventional-fresh_inventory-current
  potatoes-russet-conventional-fresh_inventory-maximum
  potatoes-russet-conventional-fresh_price-to-buy
  potatoes-russet-conventional-fresh_contract-space-available
  potatoes-russet-conventional-fresh_my-incoming-total

  potatoes-russet-organic-fresh_inventory-current
  potatoes-russet-organic-fresh_inventory-maximum
  potatoes-russet-organic-fresh_price-to-buy
  potatoes-russet-organic-fresh_contract-space-available
  potatoes-russet-organic-fresh_my-incoming-total

  potatoes-purple-conventional-fresh_inventory-current
  potatoes-purple-conventional-fresh_inventory-maximum
  potatoes-purple-conventional-fresh_price-to-buy
  potatoes-purple-conventional-fresh_contract-space-available
  potatoes-purple-conventional-fresh_my-incoming-total

  potatoes-purple-organic-fresh_inventory-current
  potatoes-purple-organic-fresh_inventory-maximum
  potatoes-purple-organic-fresh_price-to-buy
  potatoes-purple-organic-fresh_contract-space-available
  potatoes-purple-organic-fresh_my-incoming-total

  potatoes-russet-conventional-fresh-small_inventory-current
  potatoes-russet-conventional-fresh-small_inventory-maximum
  potatoes-russet-conventional-fresh-small_price-to-buy
  potatoes-russet-conventional-fresh-small_price-to-sell
  potatoes-russet-conventional-fresh-small_contract-space-available
  potatoes-russet-conventional-fresh-small-promised
  potatoes-russet-conventional-fresh-small_my-incoming-total

  potatoes-russet-conventional-processed_inventory-current
  potatoes-russet-conventional-processed_inventory-maximum
  potatoes-russet-conventional-processed_price-to-sell
  potatoes-russet-conventional-processed_contract-space-available
  potatoes-russet-conventional-processed-promised
  potatoes-russet-conventional-processed_my-incoming-total

  potatoes-russet-organic-processed_inventory-current
  potatoes-russet-organic-processed_inventory-maximum
  potatoes-russet-organic-processed_price-to-sell
  potatoes-russet-organic-processed_contract-space-available
  potatoes-russet-organic-processed-promised
  potatoes-russet-organic-processed_my-incoming-total

  potatoes-purple-conventional-processed_inventory-current
  potatoes-purple-conventional-processed_inventory-maximum
  potatoes-purple-conventional-processed_price-to-buy
  potatoes-purple-conventional-processed_price-to-sell
  potatoes-purple-conventional-processed_contract-space-available
  potatoes-purple-conventional-processed-promised
  potatoes-purple-conventional-processed_my-incoming-total

  potatoes-purple-organic-processed_inventory-current
  potatoes-purple-organic-processed_inventory-maximum
  potatoes-purple-organic-processed_price-to-buy
  potatoes-purple-organic-processed_price-to-sell
  potatoes-purple-organic-processed_contract-space-available
  potatoes-purple-organic-processed-promised
  potatoes-purple-organic-processed_my-incoming-total

  ]


wheat_farmers-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  profitability-average
  home-county
  hectares-farmed-wheat
  hectares-farmed-total
  initialized
  patches-occupied
  my-patches
  farm-id
  grows-organic
  fully-organic
  loyalty-to-buyer-id

  wheat-fallow-rotate                                            ;; rotation scheme either 2-year wehat-fallow or 3-year corn-wheat-fallow (we have wehat-fallow dssat files--except mean files!, awaiting corn-wheat-fallow files from francesco and nycole - el 5/21/21
  corn-wheat-fallow-rotate

  my-hrw-conventional-hectares-for-costs
  my-hrw-organic-hectares-for-costs
  my-snowmass-conventional-hectares-for-costs

  hrw-allocation                                       ;; percent of wheat production in hrw (95%)
  snowmass-allocation                                  ;; percent of wheat production in snowmass (5%)

  wheat-hrw-conventional-current-production
  wheat-hrw-organic-current-production
  wheat-snowmass-conventional-current-production
  wheat-snowmass-organic-current-production

  patches-in-wheat
  patches-in-rotation

  conventional-proportion                                        ;; percent of land in conventional production
  organic-proportion                                             ;; percent of land in organic production
  transition-proportion                                          ;; percent of land in transition between conventional and organic production

  wheat-hrw-conventional_inventory-current           ;; total inventory (in pounds)
  wheat-hrw-conventional_inventory-maximum
  wheat-hrw-conventional_price-to-sell
  wheat-farmers_yield-estimated_hrw-conventional
  wheat-hrw-conventional-promised

  wheat-hrw-organic_inventory-current
  wheat-hrw-organic_inventory-maximum
  wheat-hrw-organic_price-to-sell
  wheat-farmers_yield-estimated_hrw-organic
  wheat-hrw-organic-promised

  wheat-snowmass-conventional_inventory-current
  wheat-snowmass-conventional_inventory-maximum
  wheat-snowmass-conventional_price-to-sell
  wheat-farmers_yield-estimated_snowmass-conventional
  wheat-snowmass-conventional-promised

; socio-cultural decision-making variables
  transition-likelihood-score
  transition-profitable
  tls-initial
  tls-final
  tls-change
  not-male
  first-time-farmer
  young-farmer
  not-white
  primary-income
  alternative-farmer
  farm-size
  farm-transitioning
  mediocre-production-year
  bad-production-year

  ]


wheat_elevators-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  profitability-average
  loyalty-to-buyer-id

  wheat-hrw-conventional_inventory-current
  wheat-hrw-conventional_inventory-maximum
  wheat-hrw-conventional_price-to-buy
  wheat-hrw-conventional_price-to-sell
  wheat-hrw-conventional_contract-space-available
  wheat-hrw-conventional_space-available
  wheat-hrw-conventional-promised
  wheat-hrw-conventional_my-incoming-total

  wheat-hrw-organic_inventory-current
  wheat-hrw-organic_inventory-maximum
  wheat-hrw-organic_price-to-buy
  wheat-hrw-organic_price-to-sell
  wheat-hrw-organic_contract-space-available
  wheat-hrw-organic-promised
  wheat-hrw-organic_my-incoming-total

  wheat-snowmass-conventional_inventory-current
  wheat-snowmass-conventional_inventory-maximum
  wheat-snowmass-conventional_price-to-buy
  wheat-snowmass-conventional_price-to-sell
  wheat-snowmass-conventional_contract-space-available
  wheat-snowmass-conventional-promised
  wheat-snowmass-conventional_my-incoming-total


  ]


wheat_mills-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  profitability-average
  loyalty-to-buyer-id

  wheat-hrw-conventional_inventory-current
  wheat-hrw-conventional_inventory-maximum
  wheat-hrw-conventional_price-to-buy
  wheat-hrw-conventional_price-to-sell
  wheat-hrw-conventional_contract-space-available
  wheat-hrw-conventional-promised
  wheat-hrw-conventional_my-incoming-total

  wheat-hrw-organic_inventory-current
  wheat-hrw-organic_inventory-maximum
  wheat-hrw-organic_price-to-buy
  wheat-hrw-organic_price-to-sell
  wheat-hrw-organic_contract-space-available
  wheat-hrw-organic-promised
  wheat-hrw-organic_my-incoming-total

  wheat-snowmass-conventional_inventory-current
  wheat-snowmass-conventional_inventory-maximum
  wheat-snowmass-conventional_price-to-buy
  wheat-snowmass-conventional_price-to-sell
  wheat-snowmass-conventional_contract-space-available
  wheat-snowmass-conventional-promised
  wheat-snowmass-conventional_my-incoming-total

  wheat-hrw-conventional-flour_inventory-current
  wheat-hrw-conventional-flour_inventory-maximum
  wheat-hrw-conventional-flour_price-to-buy
  wheat-hrw-conventional-flour_price-to-sell
  wheat-hrw-conventional-flour_contract-space-available
  wheat-hrw-conventional-flour-promised
  wheat-hrw-conventional-flour_my-incoming-total

  wheat-hrw-organic-flour_inventory-current
  wheat-hrw-organic-flour_inventory-maximum
  wheat-hrw-organic-flour_price-to-buy
  wheat-hrw-organic-flour_price-to-sell
  wheat-hrw-organic-flour_contract-space-available
  wheat-hrw-organic-flour-promised
  wheat-hrw-organic-flour_my-incoming-total

  wheat-snowmass-conventional-flour_inventory-current
  wheat-snowmass-conventional-flour_inventory-maximum
  wheat-snowmass-conventional-flour_price-to-buy
  wheat-snowmass-conventional-flour_price-to-sell
  wheat-snowmass-conventional-flour_contract-space-available
  wheat-snowmass-conventional-flour-promised
  wheat-snowmass-conventional-flour_my-incoming-total

  contract-short-inventory

  ]


wheat_bakers-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  profitability-average
  loyalty-to-buyer-id

  wheat-hrw-conventional-flour_inventory-current
  wheat-hrw-conventional-flour_inventory-maximum
  wheat-hrw-conventional-flour_price-to-buy
  wheat-hrw-conventional-flour_price-to-sell
  wheat-hrw-conventional-flour_contract-space-available
  wheat-hrw-conventional-flour-promised
  wheat-hrw-conventional-flour_my-incoming-total

  wheat-hrw-organic-flour_inventory-current
  wheat-hrw-organic-flour_inventory-maximum
  wheat-hrw-organic-flour_price-to-buy
  wheat-hrw-organic-flour_price-to-sell
  wheat-hrw-organic-flour_contract-space-available
  wheat-hrw-organic-flour-promised
  wheat-hrw-organic-flour_my-incoming-total

  wheat-snowmass-conventional-flour_inventory-current
  wheat-snowmass-conventional-flour_inventory-maximum
  wheat-snowmass-conventional-flour_price-to-buy
  wheat-snowmass-conventional-flour_price-to-sell
  wheat-snowmass-conventional-flour_contract-space-available
  wheat-snowmass-conventional-flour-promised
  wheat-snowmass-conventional-flour_my-incoming-total

  wheat-hrw-conventional-bread_inventory-current
  wheat-hrw-conventional-bread_inventory-maximum
  wheat-hrw-conventional-bread_price-to-buy
  wheat-hrw-conventional-bread_price-to-sell
  wheat-hrw-conventional-bread_contract-space-available
  wheat-hrw-conventional-bread-promised
  wheat-hrw-conventional-bread_my-incoming-total

  wheat-hrw-organic-bread_inventory-current
  wheat-hrw-organic-bread_inventory-maximum
  wheat-hrw-organic-bread_price-to-buy
  wheat-hrw-organic-bread_price-to-sell
  wheat-hrw-organic-bread_contract-space-available
  wheat-hrw-organic-bread-promised
  wheat-hrw-organic-bread_my-incoming-total

  wheat-snowmass-conventional-bread_inventory-current
  wheat-snowmass-conventional-bread_inventory-maximum
  wheat-snowmass-conventional-bread_price-to-buy
  wheat-snowmass-conventional-bread_price-to-sell
  wheat-snowmass-conventional-bread_contract-space-available
  wheat-snowmass-conventional-bread-promised
  wheat-snowmass-conventional-bread_my-incoming-total

  ]


peach_farmers-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  profitability-average
  home-county
  hectares-farmed-peaches
  hectares-farmed-total
  initialized
  patches-occupied
  my-patches
  farm-id
  grows-organic
  fully-organic
  loyalty-to-buyer-id

  my-conventional-hectares-for-costs
  my-organic-hectares-for-costs

  conventional-current-production
  conventional-current-value
  organic-current-production
  organic-current-value
  total-peach-current-value
  patches-in-peaches

  peaches-conventional_inventory-current           ;; total inventory (in pounds)
  peaches-conventional_inventory-maximum
  peaches-conventional_price-to-sell-wholesale
  peaches-conventional_price-to-sell-altmarks
  peaches-conventional_price-to-buy
  peach-farmers_yield-estimated_conventional
  peaches-conventional_contract-space-available
  peaches-conventional_my-incoming-total
  peaches-conventional_promised

  peaches-organic_inventory-current
  peaches-organic_inventory-maximum
  peaches-organic_price-to-sell-wholesale
  peaches-organic_price-to-sell-altmarks
  peaches-organic_price-to-buy
  peach-farmers_yield-estimated_organic
  peaches-organic_contract-space-available
  peaches-organic_my-incoming-total
  peaches-organic_promised

  ;assume all seconds are conventional
  peaches-seconds_inventory-current
  peaches-seconds_inventory-maximum
  peaches-seconds_price-to-sell-wholesale
;  peaches-seconds_price-to-sell-altmarks
  peaches-seconds_price-to-buy
  peach-farmers_yield-estimated_seconds
  peaches-seconds_contract-space-available
  peaches-seconds_my-incoming-total
  peaches-seconds_promised

  peaches-conventional_passthrough-annual
  peaches-organic_passthrough-annual
  peaches-seconds_passthrough-annual

; socio-cultural decision-making variables
  transition-likelihood-score
  tls-initial
  tls-final
  tls-change
  male-gender
  first-time-farmer
  young-farmer
  not-white
  primary-income
  alternative-farmer
  farm-size
  farm-transitioning
  this-year-mediocre-production-year
  last-year-mediocre-production-year
  this-year-bad-production-year
  last-year-bad-production-year

  ; adds for peach supply chain
   split-pack                                     ; (yes or no - only applied to smallest of medium farms)
   outsource-packer                               ; (yes or no - only applies to largest farm, which packs for others)
  ]


peach_processors-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  profitability-average
  loyalty-to-buyer-id

  peaches-seconds_inventory-current
  peaches-seconds_inventory-maximum
  peaches-seconds_price-to-sell-wholesale
  peaches-seconds_price-to-buy
  peaches-seconds_contract-space-available
  peaches-seconds_my-incoming-total
  peaches-seconds_promised

  peaches-iqf_inventory-current
  peaches-iqf_inventory-maximum
  peaches-iqf_price-to-sell
  peaches-iqf_price-to-buy
  peaches-iqf_contract-space-available
  peaches-iqf_promised
  peaches-iqf_my-incoming-total

  ]


peach_altmarks-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  profitability-average
  loyalty-to-buyer-id

  peaches-conventional_inventory-current
  peaches-conventional_inventory-maximum
  peaches-conventional_price-to-buy
  peaches-conventional_price-to-sell
  peaches-conventional_contract-space-available
  peaches-conventional_promised
  peaches-conventional_my-incoming-total

  peaches-organic_inventory-current
  peaches-organic_inventory-maximum
  peaches-organic_price-to-buy
  peaches-organic_price-to-sell
  peaches-organic_contract-space-available
  peaches-organic_promised
  peaches-organic_my-incoming-total

  ]


beef_ranchers-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  profitability-average
  home-county
  initialized
  patches-occupied
  my-patches
  farm-id
  category
  specialty-product

  beef-conventional-current-production
  beef-conventional-current-value
  beef-grassfed-current-production
  beef-grassfed-current-value
  beef-colorado-source-id-current-production
  beef-colorado-source-id-current-value
  beef-animal-welfare-current-production
  beef-animal-welfare-current-value
  total-beef-current-value
  patches-in-beef

  beef-conventional_inventory-current           ;; total inventory (in pounds)  - i think we decided to use head instead of lbs. and convert to lbs. at packing house, right kevin? if so, can probably get rid of "inventory-current" vars. - el 5/21/21
  beef-conventional_inventory-maximum
  beef-conventional_price-to-sell
  beef-ranchers_yield-estimated_conventional
  beef-conventional_promised

  beef-grassfed_inventory-current
  beef-grassfed_inventory-maximum
  beef-grassfed_price-to-sell
  beef-ranchers_yield-estimated_grassfed
  beef-grassfed_promised

  beef-colorado-source-id_inventory-current
  beef-colorado-source-id_inventory-maximum
  beef-colorado-source-id_price-to-sell
  beef-ranchers_yield-estimated_colorado-source-id
  beef-colorado-source-id_promised

  beef-animal-welfare_inventory-current
  beef-animal-welfare_inventory-maximum
  beef-animal-welfare_price-to-sell
  beef-ranchers_yield-estimated_animal-welfare
  beef-animal-welfare_promised

  beef-conventional_passthrough-annual
  beef-grassfed_passthrough-annual
  beef-colorado-source-id_passthrough-annual
  beef-animal-welfare_passthrough-annual

  cows-that-calved
  total-cows
  total-cows-baseline
  replacement-cows
  forage-need
  owns-irrigated
  leases-grazing
  input-grazing-ratio
  input-grazing-ratio-private
  input-grazing-ratio-public
  input-hay-ratio
  irrig-owned
  non-irrig-owned
  total-ha-grazed
  stocking-rate
  ranch-average-precip
  year-rainfall-ratio
  year-cull-cows            ; Used more broadly to include all commodities while in the hands of the rancher.  Also was always used as the main tracker for selling animals.  November 10, 2023
  cull-cows_price-to-sell
  cull-cows_promised
  cull-cows_available

  ; probably can get rid of these bc we decided to have cows take on differentiated characteristics at the packing house stage -el 5/21/21
  ;year-cull-cows-conventional
  ;year-cull-cows-grassfed
  ;year-cull-cows-colorado-source-id
  ;year-cull-cows-animal-welfare

  year-calves-weaned
  year-calf-sale
  year-calf-revenue
  year-cull-revenue

; socio-cultural decision-making variables
  transition-likelihood-score
  tls-initial
  tls-final
  tls-change
  male-gender
  first-time-farmer
  young-farmer
  not-white
  distance-to-craig                                                 ; Note spatial specificitty
  farm-size
  farm-transitioning
  this-year-mediocre-production-year
  last-year-mediocre-production-year
  this-year-bad-production-year
  last-year-bad-production-year
]

beef_packing-houses-own [
  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  profitability-average
  loyalty-to-buyer-id

  small-size ; dummy variable for if the packing house is a JBS-style packing house or a small local packing house (only 1 of each). if small then small-size = 1.

  beef-needed ; beef needed in number of lbs. based on dps max storage
  cows-needed ; number of cows packing house would like to purchase assuming avg cow is 1200 lbs.

  beef-conventional_inventory-current           ;; total inventory (in pounds)
  beef-conventional_inventory-maximum
  beef-conventional_price-to-sell
  beef-conventional_price-to-buy
  beef-conventional_contract-space-available
  beef-conventional_my-incoming-total
  beef-conventional_promised

  beef-grassfed_inventory-current
  beef-grassfed_inventory-maximum
  beef-grassfed_price-to-sell
  beef-grassfed_price-to-buy
  beef-grassfed_contract-space-available
  beef-grassfed_my-incoming-total
  beef-grassfed_promised
  beef-grassfed-passthrough

  beef-colorado-source-id_inventory-current
  beef-colorado-source-id_inventory-maximum
  beef-colorado-source-id_price-to-sell
  beef-colorado-source-id_price-to-buy
  beef-colorado-source-id_contract-space-available
  beef-colorado-source-id_my-incoming-total
  beef-colorado-source-id_promised

  beef-animal-welfare_inventory-current
  beef-animal-welfare_inventory-maximum
  beef-animal-welfare_price-to-sell
  beef-animal-welfare_price-to-buy
  beef-animal-welfare_contract-space-available
  beef-animal-welfare_my-incoming-total
  beef-animal-welfare_promised
]


distributors-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  profitability-average
  loyalty-to-buyer-id

  ;; potatoes

  out-of-state-french-fry_inventory-current
  out-of-state-french-fry_inventory-maximum
  out-of-state-french-fry_price-to-buy
  out-of-state-french-fry_price-to-sell

  potatoes-russet-conventional-fresh_inventory-current
  potatoes-russet-conventional-fresh_inventory-maximum
  potatoes-russet-conventional-fresh_price-to-buy
  potatoes-russet-conventional-fresh_price-to-sell
  potatoes-russet-conventional-fresh_contract-space-available
  potatoes-russet-conventional-fresh-promised
  potatoes-russet-conventional-fresh_my-incoming-total

  potatoes-russet-organic-fresh_inventory-current
  potatoes-russet-organic-fresh_inventory-maximum
  potatoes-russet-organic-fresh_price-to-buy
  potatoes-russet-organic-fresh_price-to-sell
  potatoes-russet-organic-fresh_contract-space-available
  potatoes-russet-organic-fresh-promised
  potatoes-russet-organic-fresh_my-incoming-total

  potatoes-purple-conventional-fresh_inventory-current
  potatoes-purple-conventional-fresh_inventory-maximum
  potatoes-purple-conventional-fresh_price-to-buy
  potatoes-purple-conventional-fresh_price-to-sell
  potatoes-purple-conventional-fresh_contract-space-available
  potatoes-purple-conventional-fresh-promised
  potatoes-purple-conventional-fresh_my-incoming-total

  potatoes-purple-organic-fresh_inventory-current
  potatoes-purple-organic-fresh_inventory-maximum
  potatoes-purple-organic-fresh_price-to-buy
  potatoes-purple-organic-fresh_price-to-sell
  potatoes-purple-organic-fresh_contract-space-available
  potatoes-purple-organic-fresh-promised
  potatoes-purple-organic-fresh_my-incoming-total

  potatoes-russet-conventional-fresh-small_inventory-current
  potatoes-russet-conventional-fresh-small_inventory-maximum
  potatoes-russet-conventional-fresh-small_price-to-buy
  potatoes-russet-conventional-fresh-small_price-to-sell
  potatoes-russet-conventional-fresh-small_contract-space-available
  potatoes-russet-conventional-fresh-small-promised
  potatoes-russet-conventional-fresh-small_my-incoming-total

  potatoes-russet-conventional-processed_inventory-current
  potatoes-russet-conventional-processed_inventory-maximum
  potatoes-russet-conventional-processed_price-to-buy
  potatoes-russet-conventional-processed_price-to-sell
  potatoes-russet-conventional-processed_contract-space-available
  potatoes-russet-conventional-processed-promised
  potatoes-russet-conventional-processed_my-incoming-total

  potatoes-russet-organic-processed_inventory-current
  potatoes-russet-organic-processed_inventory-maximum
  potatoes-russet-organic-processed_price-to-buy
  potatoes-russet-organic-processed_price-to-sell
  potatoes-russet-organic-processed_contract-space-available
  potatoes-russet-organic-processed-promised
  potatoes-russet-organic-processed_my-incoming-total

  potatoes-purple-conventional-processed_inventory-current
  potatoes-purple-conventional-processed_inventory-maximum
  potatoes-purple-conventional-processed_price-to-buy
  potatoes-purple-conventional-processed_price-to-sell
  potatoes-purple-conventional-processed_contract-space-available
  potatoes-purple-conventional-processed-promised
  potatoes-purple-conventional-processed_my-incoming-total

  potatoes-purple-organic-processed_inventory-current
  potatoes-purple-organic-processed_inventory-maximum
  potatoes-purple-organic-processed_price-to-buy
  potatoes-purple-organic-processed_price-to-sell
  potatoes-purple-organic-processed_contract-space-available
  potatoes-purple-organic-processed-promised
  potatoes-purple-organic-processed_my-incoming-total

  ;; wheat

  wheat-hrw-conventional-flour_inventory-current
  wheat-hrw-conventional-flour_inventory-maximum
  wheat-hrw-conventional-flour_price-to-buy
  wheat-hrw-conventional-flour_price-to-sell
  wheat-hrw-conventional-flour_contract-space-available
  wheat-hrw-conventional-flour-promised
  wheat-hrw-conventional-flour_my-incoming-total

  wheat-hrw-organic-flour_inventory-current
  wheat-hrw-organic-flour_inventory-maximum
  wheat-hrw-organic-flour_price-to-buy
  wheat-hrw-organic-flour_price-to-sell
  wheat-hrw-organic-flour_contract-space-available
  wheat-hrw-organic-flour-promised
  wheat-hrw-organic-flour_my-incoming-total

  wheat-snowmass-conventional-flour_inventory-current
  wheat-snowmass-conventional-flour_inventory-maximum
  wheat-snowmass-conventional-flour_price-to-buy
  wheat-snowmass-conventional-flour_price-to-sell
  wheat-snowmass-conventional-flour_contract-space-available
  wheat-snowmass-conventional-flour-promised
  wheat-snowmass-conventional-flour_my-incoming-total

  wheat-hrw-conventional-bread_inventory-current
  wheat-hrw-conventional-bread_inventory-maximum
  wheat-hrw-conventional-bread_price-to-buy
  wheat-hrw-conventional-bread_price-to-sell
  wheat-hrw-conventional-bread_contract-space-available
  wheat-hrw-conventional-bread-promised
  wheat-hrw-conventional-bread_my-incoming-total

  wheat-hrw-organic-bread_inventory-current
  wheat-hrw-organic-bread_inventory-maximum
  wheat-hrw-organic-bread_price-to-buy
  wheat-hrw-organic-bread_price-to-sell
  wheat-hrw-organic-bread_contract-space-available
  wheat-hrw-organic-bread-promised
  wheat-hrw-organic-bread_my-incoming-total

  wheat-snowmass-conventional-bread_inventory-current
  wheat-snowmass-conventional-bread_inventory-maximum
  wheat-snowmass-conventional-bread_price-to-buy
  wheat-snowmass-conventional-bread_price-to-sell
  wheat-snowmass-conventional-bread_contract-space-available
  wheat-snowmass-conventional-bread-promised
  wheat-snowmass-conventional-bread_my-incoming-total

  ;; peaches

  peaches-out-of-state_inventory-current
  peaches-out-of-state_inventory-maximum
  peaches-out-of-state_price-to-buy
  peaches-out-of-state_price-to-sell
  peaches-out-of-state_contract-space-available
  peaches-out-of-state_promised
  peaches-out-of-state_my-incoming-total

  peaches-conventional_inventory-current
  peaches-conventional_inventory-maximum
  peaches-conventional_price-to-buy
  peaches-conventional_price-to-sell
  peaches-conventional_contract-space-available
  peaches-conventional_promised
  peaches-conventional_my-incoming-total

  peaches-organic_inventory-current
  peaches-organic_inventory-maximum
  peaches-organic_price-to-buy
  peaches-organic_price-to-sell
  peaches-organic_contract-space-available
  peaches-organic_promised
  peaches-organic_my-incoming-total

  peaches-seconds_inventory-current
  peaches-seconds_inventory-maximum
  peaches-seconds_price-to-buy
  peaches-seconds_price-to-sell
  peaches-seconds_contract-space-available
  peaches-seconds_promised
  peaches-seconds_my-incoming-total

  peaches-iqf_inventory-current
  peaches-iqf_inventory-maximum
  peaches-iqf_price-to-buy
  peaches-iqf_price-to-sell
  peaches-iqf_contract-space-available
  peaches-iqf_promised
  peaches-iqf_my-incoming-total

  ;; beef
  beef-conventional_inventory-current
  beef-conventional_inventory-maximum
  beef-conventional_price-to-sell
  beef-conventional_price-to-buy
  beef-conventional_contract-space-available
  beef-conventional_my-incoming-total
  beef-conventional_promised

  beef-grassfed_inventory-current
  beef-grassfed_inventory-maximum
  beef-grassfed_price-to-sell
  beef-grassfed_price-to-buy
  beef-grassfed_contract-space-available
  beef-grassfed_my-incoming-total
  beef-grassfed_promised

  beef-colorado-source-id_inventory-current
  beef-colorado-source-id_inventory-maximum
  beef-colorado-source-id_price-to-sell
  beef-colorado-source-id_price-to-buy
  beef-colorado-source-id_contract-space-available
  beef-colorado-source-id_my-incoming-total
  beef-colorado-source-id_promised

  beef-animal-welfare_inventory-current
  beef-animal-welfare_inventory-maximum
  beef-animal-welfare_price-to-sell
  beef-animal-welfare_price-to-buy
  beef-animal-welfare_contract-space-available
  beef-animal-welfare_my-incoming-total
  beef-animal-welfare_promised

 ]


dps_buyers-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  assets-change
  profitability-average
  loyalty-to-seller-id

  ;; potatoes

  out-of-state-french-fry_inventory-current
  out-of-state-french-fry_inventory-maximum
  out-of-state-french-fry_price-to-buy

  potatoes-russet-conventional-fresh_inventory-current
  potatoes-russet-conventional-fresh_inventory-maximum
  potatoes-russet-conventional-fresh_price-to-buy
  potatoes-russet-conventional-fresh_contract-space-available
  potatoes-russet-conventional-fresh_my-incoming-total

  potatoes-russet-organic-fresh_inventory-current
  potatoes-russet-organic-fresh_inventory-maximum
  potatoes-russet-organic-fresh_price-to-buy
  potatoes-russet-organic-fresh_contract-space-available
  potatoes-russet-organic-fresh_my-incoming-total

  potatoes-purple-conventional-fresh_inventory-current
  potatoes-purple-conventional-fresh_inventory-maximum
  potatoes-purple-conventional-fresh_price-to-buy
  potatoes-purple-conventional-fresh_contract-space-available
  potatoes-purple-conventional-fresh_my-incoming-total

  potatoes-purple-organic-fresh_inventory-current
  potatoes-purple-organic-fresh_inventory-maximum
  potatoes-purple-organic-fresh_price-to-buy
  potatoes-purple-organic-fresh_contract-space-available
  potatoes-purple-organic-fresh_my-incoming-total

  potatoes-russet-conventional-fresh-small_inventory-current
  potatoes-russet-conventional-fresh-small_inventory-maximum
  potatoes-russet-conventional-fresh-small_price-to-buy
  potatoes-russet-conventional-fresh-small_contract-space-available
  potatoes-russet-conventional-fresh-small_my-incoming-total

  potatoes-russet-conventional-processed_inventory-current
  potatoes-russet-conventional-processed_inventory-maximum
  potatoes-russet-conventional-processed_price-to-buy
  potatoes-russet-conventional-processed_contract-space-available
  potatoes-russet-conventional-processed_my-incoming-total

  potatoes-russet-organic-processed_inventory-current
  potatoes-russet-organic-processed_inventory-maximum
  potatoes-russet-organic-processed_price-to-buy
  potatoes-russet-organic-processed_contract-space-available
  potatoes-russet-organic-processed_my-incoming-total

  potatoes-purple-conventional-processed_inventory-current
  potatoes-purple-conventional-processed_inventory-maximum
  potatoes-purple-conventional-processed_price-to-buy
  potatoes-purple-conventional-processed_contract-space-available
  potatoes-purple-conventional-processed_my-incoming-total

  potatoes-purple-organic-processed_inventory-current
  potatoes-purple-organic-processed_inventory-maximum
  potatoes-purple-organic-processed_price-to-buy
  potatoes-purple-organic-processed_contract-space-available
  potatoes-purple-organic-processed_my-incoming-total

  ;; wheat

  wheat-hrw-conventional-flour_inventory-current
  wheat-hrw-conventional-flour_inventory-maximum
  wheat-hrw-conventional-flour_price-to-buy
  wheat-hrw-conventional-flour_contract-space-available
  wheat-hrw-conventional-flour_my-incoming-total

  wheat-hrw-organic-flour_inventory-current
  wheat-hrw-organic-flour_inventory-maximum
  wheat-hrw-organic-flour_price-to-buy
  wheat-hrw-organic-flour_contract-space-available
  wheat-hrw-organic-flour_my-incoming-total

  wheat-snowmass-conventional-flour_inventory-current
  wheat-snowmass-conventional-flour_inventory-maximum
  wheat-snowmass-conventional-flour_price-to-buy
  wheat-snowmass-conventional-flour_contract-space-available
  wheat-snowmass-conventional-flour_my-incoming-total

  wheat-hrw-conventional-bread_inventory-current
  wheat-hrw-conventional-bread_inventory-maximum
  wheat-hrw-conventional-bread_price-to-buy
  wheat-hrw-conventional-bread_contract-space-available
  wheat-hrw-conventional-bread_my-incoming-total

  wheat-hrw-organic-bread_inventory-current
  wheat-hrw-organic-bread_inventory-maximum
  wheat-hrw-organic-bread_price-to-buy
  wheat-hrw-organic-bread_contract-space-available
  wheat-hrw-organic-bread_my-incoming-total

  wheat-snowmass-conventional-bread_inventory-current
  wheat-snowmass-conventional-bread_inventory-maximum
  wheat-snowmass-conventional-bread_price-to-buy
  wheat-snowmass-conventional-bread_contract-space-available
  wheat-snowmass-conventional-bread_my-incoming-total

  ;; peaches

  peaches-conventional_inventory-current
  peaches-conventional_inventory-maximum
  peaches-conventional_price-to-buy
  peaches-conventional_contract-space-available
  peaches-conventional_my-incoming-total

  peaches-organic_inventory-current
  peaches-organic_inventory-maximum
  peaches-organic_price-to-buy
  peaches-organic_contract-space-available
  peaches-organic_my-incoming-total

  peaches-seconds_inventory-current
  peaches-seconds_inventory-maximum
  peaches-seconds_price-to-buy
  peaches-seconds_contract-space-available
  peaches-seconds_my-incoming-total

  peaches-iqf_inventory-current
  peaches-iqf_inventory-maximum
  peaches-iqf_price-to-buy
  peaches-iqf_contract-space-available
  peaches-iqf_my-incoming-total

  peaches-out-of-state_inventory-current
  peaches-out-of-state_inventory-maximum
  peaches-out-of-state_price-to-buy
  peaches-out-of-state_contract-space-available
  peaches-out-of-state_my-incoming-total


  ;; beef

  beef-conventional_inventory-current
  beef-conventional_inventory-maximum
  beef-conventional_price-to-buy
  beef-conventional_contract-space-available
  beef-conventional_my-incoming-total
  beef-conventional_promised

  beef-grassfed_inventory-current
  beef-grassfed_inventory-maximum
  beef-grassfed_price-to-buy
  beef-grassfed_contract-space-available
  beef-grassfed_my-incoming-total
  beef-grassfed_promised

  beef-colorado-source-id_inventory-current
  beef-colorado-source-id_inventory-maximum
  beef-colorado-source-id_price-to-buy
  beef-colorado-source-id_contract-space-available
  beef-colorado-source-id_my-incoming-total
  beef-colorado-source-id_promised

  beef-animal-welfare_inventory-current
  beef-animal-welfare_inventory-maximum
  beef-animal-welfare_price-to-buy
  beef-animal-welfare_contract-space-available
  beef-animal-welfare_my-incoming-total
  beef-animal-welfare_promised

 ]


to setup

  clear-all
  reset-ticks

  ;random-seed 999

  setup-world
  setup-static-names
  setup-parameters
  setup-dashboard

  set max-ticks (52 * years-in-model-run)

end


to setup-parameters

  ;; -------------------------
  ; number of agents
  ;; -------------------------

  ;; potatoes

  set number-potato_shippers 4
  set number-potato_repackers 4
  set number-potato_processors 2

  ;; wheat

  set number-wheat_elevators 4
  set number-wheat_mills 4
  set number-wheat_bakers 2

  ;; peaches

  set number-peach_processors 2
  set number-peach_altmarks 25
  set peaches-percent-seconds .10

  ;; beef
  set number-beef_packing-houses 2

  ;; common

  set number-distributors 1
  set number-dps_buyers 1

  ;; -------------------------
  ; lca variables
  ;; -------------------------
; these values directly from hailey/javier's spreadsheet in data folder on codebeamer

  ; per kg potato lca outputs

  ; --------------------------------------POTATOES

; Results from J. Antonanzas Torres, Nov 23, 2021 and Jan. 2022 - OLD
;
;                             	Total at farm gate  	              Total at truck gate (in Denver)
;                             	GHG 	Water depletion 	            GHG 	Water depletion
;                               kg CO2eq/kg potato 	m3/kg potato 	  kg CO2eq/kg potato 	m3/kg potato
; Russet Conventional 	             0,159 	           0,049 	             0,233 	          0,161
; Russet Organic 	                   0,128 	           0,063 	             0,197 	          0,178
; Purple Conventional 	             0,158           	 0,048 	             0,232 	          0,160
; Purple Organic 	                   0,133 	           0,065 	             0,203 	          0,180
; French fry                           --                --                0,577            0,081
; Specialty product                    --                --                0,572            0,236

; Results from J. Antonanzas Torres, Updated Feb 22, 2021 - MOST RECENT VERSION
;
;                             	Total at farm gate  	              Total at truck gate (in Denver)
;                             	GHG 	Water depletion 	            GHG 	Water depletion
;                               kg CO2eq/kg potato 	m3/kg potato 	  kg CO2eq/kg potato 	m3/kg potato
; Russet Conventional 	             0,159 	           0,049 	             0,233 	          0,058
; Russet Organic 	                   0,128 	           0,063 	             0,197 	          0,074
; Purple Conventional 	             0,158           	 0,049 	             0,232 	          0,057
; Purple Organic 	                   0,133 	           0,065 	             0,203 	          0,076
; French fry                           --                --                0,577            0,081
; Specialty product                    --                --                0,572            0,080

   ; GHG and Water Depletion parameters
  set potato-russet-conventional_per-kg-CO2-kg-eq-at-farm 0.159
  set potato-russet-conventional_per-kg-CO2-kg-eq-at-Denver 0.233
  set potato-russet-organic_per-kg-CO2-kg-eq-at-farm 0.128
  set potato-russet-organic_per-kg-CO2-kg-eq-at-Denver 0.197
  set potato-purple-conventional_per-kg-CO2-kg-eq-at-farm 0.158
  set potato-purple-conventional_per-kg-CO2-kg-eq-at-Denver 0.232
  set potato-purple-organic_per-kg-CO2-kg-eq-at-farm 0.133
  set potato-purple-organic_per-kg-CO2-kg-eq-at-Denver 0.203
  set potato-french-fry_per-kg-CO2-kg-eq-at-Denver 0.577
  set potato-specialty-product_per-kg-CO2-kg-eq-at-Denver 0.572

  set potato-russet-conventional_per-kg-h2o-m3-at-farm 0.049
  set potato-russet-conventional_per-kg-h2o-m3-at-Denver 0.058
  set potato-russet-organic_per-kg-h2o-m3-at-farm 0.063
  set potato-russet-organic_per-kg-h2o-m3-at-Denver 0.074
  set potato-purple-conventional_per-kg-h2o-m3-at-farm 0.049
  set potato-purple-conventional_per-kg-h2o-m3-at-Denver 0.057
  set potato-purple-organic_per-kg-h2o-m3-at-farm 0.065
  set potato-purple-organic_per-kg-h2o-m3-at-Denver 0.076
  set potato-french-fry_per-kg-h2o-m3-at-Denver 0.081
  set potato-specialty-product_per-kg-h2o-m3-at-Denver 0.080

  ; --------------------------------------WHEAT
  ; i have input the data from javier's farm-level lca. missing data from nycole so leave in random-normal numbers for now  - el 5/7/21

; Results from J. Antonanzas Torres, Feb 2, 2022
;
; 	                               Total at farm gate  	    Flour at DPS gate 	    Bread at DPS gate 	  Total at farm gate  	   Flour at DPS gate 	   Bread at DPS gate
;  	                                 kg CO2/kg wheat 	       kg CO2/kg flour 	       kg CO2/kg bread 	        m3/kg wheat 	          m3/kg flour 	        m3/kg bread
;  White winter conventional 	        4,39E-01 	               8,57E-01 	               8,51E-01 	           1,71E-01 	             5,79E-01 	           1,05E+00
;  Red winter conventional 	          4,61E-01 	               8,85E-01 	               8,69E-01 	           1,62E-01 	             5,67E-01 	           1,04E+00
;  Red winter organic 	              3,90E-01 	               7,92E-01 	               8,09E-01 	           2,56E-01 	             6,91E-01 	           1,12E+00
;  Baseline 	                                                 1,66E+00 	               1,37E+00 	  	  	

; Results from J. Antonanzas Torres, Updated Feb 22, 2022

; 	                               Total at farm gate  	    Flour at DPS gate 	    Bread at DPS gate 	  Total at farm gate  	   Flour at DPS gate 	   Bread at DPS gate
;  	                                 kg CO2/kg wheat 	       kg CO2/kg flour 	       kg CO2/kg bread 	        m3/kg wheat 	          m3/kg flour 	        m3/kg bread
;  White winter conventional 	        4,39E-01 	               8,57E-01 	               8,51E-01 	           1,71E-01 	             2,19E-01	             1,47E-01
;  Red winter conventional 	          4,61E-01 	               8,85E-01 	               8,69E-01 	           1,62E-01 	             2,08E-01	             1,40E-01
;  Red winter organic 	              3,90E-01 	               7,92E-01 	               8,09E-01 	           2,56E-01 	             3,32E-01	             2,20E-01
;  Baseline 	                                                 1,66E+00 	               1,37E+00 	  	  	

; Results from J. Antonanzas Torres, Updated March 22, 2022

; 	                               Total at farm gate  	    Flour at DPS gate 	    Bread at DPS gate 	  Total at farm gate  	   Flour at DPS gate 	   Bread at DPS gate
;  	                                 kg CO2/kg wheat 	       kg CO2/kg flour 	       kg CO2/kg bread 	        m3/kg wheat 	          m3/kg flour 	        m3/kg bread
;  White winter conventional 	        4,39E-01 	               8,57E-01 	               8,51E-01 	           1,71E-01 	             2,19E-01	             1,47E-01
;  Red winter conventional 	          4,61E-01 	               8,85E-01 	               8,69E-01 	           1,62E-01 	             2,08E-01	             1,40E-01
;  Red winter organic 	              3,90E-01 	               7,92E-01 	               8,09E-01 	           2,56E-01 	             3,32E-01	             2,20E-01
;  Baseline 	                                                 1,24E+00 	               1,02E+00 	  	  	



;3/31/22 Email Exchange About Baseline vs. HRW Conventional
;
;Erin: What is the difference between the new baseline numbers you sent and the red winter conventional bread/wheat at DPS? Are they all grown and processed in Colorado from conventional hard red winter wheat?
;Javier: Yes, they are all grown and processed in Colorado. The only difference is that I used the average carbon footprint for wheat in the US for the baseline instead of the results from our farm model with inputs provided by Francesco and Nicole. Our model resulted in less GHG emissions than the US average.
;Conclusion: Use HRW conventional for baseline scenario.

; Wheat per-kg CO2 Emissions
  set wheat-snowmass-conventional_per-kg-CO2-kg-eq-at-farm 0.439
  set wheat-hrw-conventional_per-kg-CO2-kg-eq-at-farm 0.461
  set wheat-hrw-organic_per-kg-CO2-kg-eq-at-farm 0.390
  set wheat-snowmass-conventional-flour_per-kg-CO2-kg-eq-at-Denver 0.857
  set wheat-hrw-conventional-flour_per-kg-CO2-kg-eq-at-Denver 0.885
  set wheat-hrw-organic-flour_per-kg-CO2-kg-eq-at-Denver 0.792
  set wheat-snowmass-conventional-bread_per-kg-CO2-kg-eq-at-Denver 0.851
  set wheat-hrw-conventional-bread_per-kg-CO2-kg-eq-at-Denver 0.869
  set wheat-hrw-organic-bread_per-kg-CO2-kg-eq-at-Denver 0.809

; Wheat per-kg H2O Use
  set wheat-snowmass-conventional_per-kg-h2o-m3-at-farm 0.171
  set wheat-hrw-conventional_per-kg-h2o-m3-at-farm 0.162
  set wheat-hrw-organic_per-kg-h2o-m3-at-farm 0.256
  set wheat-snowmass-conventional-flour_per-kg-h2o-m3-at-Denver 0.219
  set wheat-hrw-conventional-flour_per-kg-h2o-m3-at-Denver 0.208
  set wheat-hrw-organic-flour_per-kg-h2o-m3-at-Denver 0.332
  set wheat-snowmass-conventional-bread_per-kg-h2o-m3-at-Denver .147
  set wheat-hrw-conventional-bread_per-kg-h2o-m3-at-Denver .140
  set wheat-hrw-organic-bread_per-kg-h2o-m3-at-Denver .220


  ; --------------------------------------PEACHES
    ; add once LCA complete


  ; --------------------------------------BEEF
  ; products: conventional, grassfed, colorado-source-id, animal-welfare

  ;OUTDATED Results from Jasmine Dillon, May 9, 2022
  ;OUTDATED  ********************************************************
  ;OUTDATED  Baseline, AGA, & AWA beef 	  	
  ;OUTDATED  GWP       	5.6 	kg CO2e/kg cull cow LW
  ;OUTDATED      	     11.3  	kg CO2e/kg cull cow HCW
  ;OUTDATED  WF       	330.2 	L H2O/kg cull cow LW
  ;OUTDATED          	660.3  	L H2O/kg cull cow HCW
  ;OUTDATED  ********************************************************

;  New Data from Jasmine Dillon, Jan 13, 2023
;  Colorado		
;    Carbon footprint	         Water use
;    kg CO2e/kg ground beef	     L H2O/kg ground beef
;    Farm-gate	7.0	                706
;    DPS	      9.1               	726           (INCOMPLETE ... updated Jan 26)
;
;  Traditional		
;    Carbon footprint	         Water use
;    kg CO2e/kg ground beef	     L H2O/kg ground beef
;    Farm-gate	7.0	                706
;    DPS	      8.2	                707           (INCOMPLETE ... updated Jan 26)

; Jan 26, 2023
; AND FINAL BEEF NUMBERS ********************
;  (1) production in CO, traditional processing, & shipping to DPS in CO;
;  (2) production in CO, processing at a Craig county plant, & shipping to DPS:
;
;       Greenhouse gases	          Water
;  kg CO2e/kg ground beef	L H2O/kg ground beef
;      Traditional processing	    9.2	    707
;      NW CO processor	          8.1	    714
;
; So the Jan 13 values are farm gate essentially, and the Jan 26 values are at Denver
;
; Following discussions in September, 2023, values at (only) the farm gate for conventional and Colorado sourced apply to
; the other two scenarios as well, so running those.
; OCTOBER 6, 2023.  The values at DPS for Colorado sourced should be used in grassfed and welfare as well!   A new twist.

  ; LW is live weight.  HCW is hot carcass weight.
  set beef-conventional_per-kg-CO2-kg-eq-at-farm  7.0
  set beef-conventional_per-kg-h2o-m3-at-farm  0.706
  set beef-grassfed_per-kg-CO2-kg-eq-at-farm  7.0
  set beef-grassfed_per-kg-h2o-m3-at-farm  0.706
  set beef-colorado-source-id_per-kg-CO2-kg-eq-at-farm  7.0
  set beef-colorado-source-id_per-kg-h2o-m3-at-farm  0.706
  set beef-animal-welfare_per-kg-CO2-kg-eq-at-farm  7.0
  set beef-animal-welfare_per-kg-h2o-m3-at-farm  0.706

  set beef-conventional_per-kg-CO2-kg-eq-at-Denver  9.2
  set beef-conventional_per-kg-h2o-m3-at-Denver  0.707
  set beef-grassfed_per-kg-CO2-kg-eq-at-Denver  8.1
  set beef-grassfed_per-kg-h2o-m3-at-Denver  0.714
  set beef-colorado-source-id_per-kg-CO2-kg-eq-at-Denver  8.1
  set beef-colorado-source-id_per-kg-h2o-m3-at-Denver  0.714
  set beef-animal-welfare_per-kg-CO2-kg-eq-at-Denver  8.1
  set beef-animal-welfare_per-kg-h2o-m3-at-Denver  0.714


  ;; -------------------------
  ; input costs
  ;; -------------------------

  ; see data folders on codebeamer and dropbox for sources

  ;; potatoes
  set potato-conventional-russet_cost-input-per-acre 1430
  set potato-organic-russet_cost-input-per-acre 1439
  set potato-conventional-purple_cost-input-per-acre 719
  set potato-organic-purple_cost-input-per-acre 955
  ;breakeven prices (per lb.) using average dssat yields
  ; conv russet 370.8 cwt/acre = 37,080 lbs./acre
  ; $1430/37080 lbs. = $0.0386/lb.
  set potato-conventional-russet_price-farmer-breakeven 0.0386
  ; org russet 285.4 cwt/acre = 28,540 lbs./acre
  ; $1439/28,540 lbs./acre = $0.0504/lb.
  set potato-organic-russet_price-farmer-breakeven 0.0504
  ; conv purple 374.9 cwt/acre = 37,490 lbs./acre
  ; $719/37,490 lbs.= $0.0192
  set potato-conventional-purple_price-farmer-breakeven 0.0192
  ; org purple 276.4 cwt/acre = 27,640 lbs./acre
  ; $955/27,640 lbs. = $0.0346/lb.
  set potato-organic-purple_price-farmer-breakeven 0.0346

  ;; wheat
  set wheat-hrw-conventional_cost-input-per-acre 130
  set wheat-hrw-organic_cost-input-per-acre 88
  set wheat-snowmass-conventional_cost-input-per-acre 130

  ; wheat breakeven prices (per lb.)
  ; assume 60 lbs/bu and average conv yield is 48 bu/acre and avg org yield is 36 bu/acre from arms 2009
  set wheat-hrw-conventional_price-farmer-breakeven 0.045
  set wheat-hrw-organic_price-farmer-breakeven 0.040
  set wheat-snowmass-conventional_price-farmer-breakeven 0.045

  ;; peaches
  set peach-conventional_cost-input-per-acre 9165.98
  set peach-organic_cost-input-per-acre 9349.3

  ;breakeven prices (per lb.)
  set peach-conventional_price-farmer-breakeven 1.01
  set peach-organic_price-farmer-breakeven 0.93


  ;; beef
  set beef-conventional_cost_input_per_head 1050

  ;; -------------------------
  ; prices
  ;; -------------------------

  ; each commodity has a priceData excel spreadsheet on codebeamer with more information about price info by scenario

  ;; potatoes

  ; set sd for russets at 0.0291 and purple at 0.0539

  ;price farmer receives
  set potato-conventional-russet_price-farmgate-avg 0.1291
  set potato-conventional-russet_price-farmgate-stdev 0.0291
  set potato-organic-russet_price-farmgate-avg 0.2546
  set potato-organic-russet_price-farmgate-stdev 0.0291
  set potato-conventional-purple_price-farmgate-avg 0.2350
  set potato-conventional-purple_price-farmgate-stdev 0.0539
  set potato-organic-purple_price-farmgate-avg 0.4634
  set potato-organic-purple_price-farmgate-stdev 0.0539
  set potato-conventional-russet-small_price-farmgate-avg 0.0356
  set potato-conventional-russet-small_price-farmgate-stdev 0.005

  ;price shipper receives
  set potato-conventional-russet_price-shipper-receives-avg 0.358
  set potato-conventional-russet_price-shipper-receives-stdev 0.0291
  set potato-organic-russet_price-shipper-receives-avg 0.705
  set potato-organic-russet_price-shipper-receives-stdev 0.0291
  set potato-conventional-purple_price-shipper-receives-avg 0.651
  set potato-conventional-purple_price-shipper-receives-stdev 0.0539
  set potato-organic-purple_price-shipper-receives-avg 1.284
  set potato-organic-purple_price-shipper-receives-stdev 0.0539
  set potato-conventional-russet-small_price-shipper-receives-avg 0.0986
  set potato-conventional-russet-small_price-shipper-receives-stdev 0.005

  ;price repacker pays
  set potato-conventional-russet_price-repacker-pays-avg 0.0810
  set potato-conventional-russet_price-repacker-pays-stdev 0.0291
  set potato-organic-russet_price-repacker-pays-avg 0.160
  set potato-organic-russet_price-repacker-pays-stdev 0.0291
  set potato-conventional-purple_price-repacker-pays-avg 0.147
  set potato-conventional-purple_price-repacker-pays-stdev 0.0539
  set potato-organic-purple_price-repacker-pays-avg 0.291
  set potato-organic-purple_price-repacker-pays-stdev 0.0539
  set potato-conventional-russet-small_price-repacker-pays-avg 0.0223
  set potato-conventional-russet-small_price-repacker-pays-stdev 0.005

  ;price repacker receives
  set potato-conventional-russet_price-repacker-receives-avg .0816
  set potato-conventional-russet_price-repacker-receives-stdev 0.0291
  set potato-organic-russet_price-repacker-receives-avg .1611
  set potato-organic-russet_price-repacker-receives-stdev 0.0291
  set potato-conventional-purple_price-repacker-receives-avg .1480
  set potato-conventional-purple_price-repacker-receives-stdev 0.0539
  set potato-organic-purple_price-repacker-receives-avg .2930
  set potato-organic-purple_price-repacker-receives-stdev 0.0539
  set potato-conventional-russet-small_price-repacker-receives-avg .0225
  set potato-conventional-russet-small_price-repacker-receives-stdev 0.005

  ;price distributor receives
  set potato-conventional-russet_price-distributor-receives-avg 0.3605
  set potato-conventional-russet_price-distributor-receives-stdev 0.0291
  set potato-organic-russet_price-distributor-receives-avg 0.710
  set potato-organic-russet_price-distributor-receives-stdev 0.0291
  set potato-conventional-purple_price-distributor-receives-avg 0.656
  set potato-conventional-purple_price-distributor-receives-stdev 0.0539
  set potato-organic-purple_price-distributor-receives-avg 1.293
  set potato-organic-purple_price-distributor-receives-stdev 0.0539
  set potato-conventional-russet-small_price-distributor-receives-avg 0.0993
  set potato-conventional-russet-small_price-distributor-receives-avg 0.005

  ; price farmer receives from shipper in short supply chain
  set potato-conventional-russet_gfpp-price-farmgate-avg 0.246
  set potato-conventional-russet_gfpp-price-farmgate-stdev 0.0291
  set potato-organic-russet_gfpp-price-farmgate-avg 0.485
  set potato-organic-russet_gfpp-price-farmgate-stdev 0.0291
  set potato-conventional-purple_gfpp-price-farmgate-avg 0.448
  set potato-conventional-purple_gfpp-price-farmgate-stdev 0.0539
  set potato-organic-purple_gfpp-price-farmgate-avg 0.884
  set potato-organic-purple_gfpp-price-farmgate-stdev 0.0539
  set potato-conventional-russet-small_gfpp-price-farmgate-avg 0.068
  set potato-conventional-russet-small_gfpp-price-farmgate-stdev 0.005

  ; price shipper receives from dps in short supply chain
  set potato-conventional-russet_gfpp-price-shipper-receives-avg 0.465
  set potato-conventional-russet_gfpp-price-shipper-receives-stdev 0.0291
  set potato-organic-russet_gfpp-price-shipper-receives-avg 0.916
  set potato-organic-russet_gfpp-price-shipper-receives-stdev 0.0291
  set potato-conventional-purple_gfpp-price-shipper-receives-avg 0.846
  set potato-conventional-purple_gfpp-price-shipper-receives-stdev 0.0539
  set potato-organic-purple_gfpp-price-shipper-receives-avg 1.668
  set potato-organic-purple_gfpp-price-shipper-receives-stdev 0.0539
  set potato-conventional-russet-small_gfpp-price-shipper-receives-avg 0.128
  set potato-conventional-russet-small_gfpp-price-shipper-receives-stdev 0.005

  ; scenario 1 prices: baseline
  if potato-scenario = "baseline" [
    set potato-conventional-russet-processed_price-distributor-receives-avg 1.01
    set potato-conventional-russet-processed_price-distributor-receives-stdev .05
  ]

  ; scenario 2 prices: fresh CO
  if potato-scenario = "fresh-CO" [
    ; prices as set above
  ]

  ; scenario 3 prices: gfpp
  if potato-scenario = "gfpp" [
    ; alternative prices set within contracting procedure using gfpp prices set above
  ]

  ; scenario 4 prices: small potatoes
  if potato-scenario = "small-potatoes" [
     ; alternative prices set within contracting procedure using gfpp prices set above
  ]

  ; scenario 5 prices: specialty product
  if potato-scenario = "specialty-product" [
    ; CO potato_processor only becomes active in specialty-product scenario
  ;price processor receives
  set potato-conventional-russet-processed_price-processor-receives-avg 0.510
  set potato-conventional-russet-processed_price-processor-receives-stdev 0.0291
  set potato-organic-russet-processed_price-processor-receives-avg 1.004
  set potato-organic-russet-processed_price-processor-receives-stdev 0.0291
  set potato-conventional-purple-processed_price-processor-receives-avg 0.927
  set potato-conventional-purple-processed_price-processor-receives-stdev 0.0539
  set potato-organic-purple-processed_price-processor-receives-avg 1.829
  set potato-organic-purple-processed_price-processor-receives-stdev 0.0539
  ;;price distributor receives
  set potato-conventional-russet-processed_price-distributor-receives-avg 0.82
  set potato-conventional-russet-processed_price-distributor-receives-stdev 0.0291
  set potato-organic-russet-processed_price-distributor-receives-avg 1.614
  set potato-organic-russet-processed_price-distributor-receives-stdev 0.0291
  set potato-conventional-purple-processed_price-distributor-receives-avg 1.490
  set potato-conventional-purple-processed_price-distributor-receives-stdev 0.0539
  set potato-organic-purple-processed_price-distributor-receives-avg 2.941
  set potato-organic-purple-processed_price-distributor-receives-stdev 0.0539
  ]

  ;; wheat

  ;; setting sd for all at 0.04 which is what stdev was for most steps in supply chain in wheat yearbook dataset

  ;farmgate prices
  set wheat-hrw-conventional_price-farmgate-avg 0.0835
  set wheat-hrw-conventional_price-farmgate-stdev 0.04
  set wheat-hrw-organic_price-farmgate-avg 0.1318
  set wheat-hrw-organic_price-farmgate-stdev 0.04
  set wheat-snowmass-conventional_price-farmgate-avg 0.0952
  set wheat-snowmass-conventional_price-farmgate-stdev 0.04

  ;prices elevators receive
  set wheat-hrw-conventional_price-elevator-receives-avg 0.1651
  set wheat-hrw-conventional_price-elevator-receives-stdev 0.04
  set wheat-hrw-organic_price-elevator-receives-avg 0.2606
  set wheat-hrw-organic_price-elevator-receives-stdev 0.04
  set wheat-snowmass-conventional_price-elevator-receives-avg 0.1882
  set wheat-snowmass-conventional_price-elevator-receives-stdev 0.04

  ;prices mills receive
  set wheat-hrw-conventional-flour_price-mill-receives-avg 0.1771
  set wheat-hrw-conventional-flour_price-mill-receives-stdev 0.04
  set wheat-hrw-organic-flour_price-mill-receives-avg 0.2796
  set wheat-hrw-organic-flour_price-mill-receives-stdev 0.04
  set wheat-snowmass-conventional-flour_price-mill-receives-avg 0.2019
  set wheat-snowmass-conventional-flour_price-mill-receives-stdev 0.04

  ;prices bakers receive
  set wheat-hrw-conventional-bread_price-baker-receives-avg 0.2968
  set wheat-hrw-conventional-bread_price-baker-receives-stdev 0.04
  set wheat-hrw-organic-bread_price-baker-receives-avg 0.7494
  set wheat-hrw-organic-bread_price-baker-receives-stdev 0.04
  set wheat-snowmass-conventional-bread_price-baker-receives-avg 0.4591
  set wheat-snowmass-conventional-bread_price-baker-receives-stdev 0.04

  ;prices distributors receive
  set wheat-hrw-conventional-flour_price-distributor-receives-avg 0.2398
  set wheat-hrw-conventional-flour_price-distributor-receives-stdev 0.04
  set wheat-hrw-organic-flour_price-distributor-receives-avg 0.37   ;there was controversy about this price - see spreadsheet, replace if better data become available
  set wheat-hrw-organic-flour_price-distributor-receives-stdev 0.04
  set wheat-snowmass-conventional-flour_price-distributor-receives-avg 0.5153
  set wheat-snowmass-conventional-flour_price-distributor-receives-stdev 0.04
  set wheat-hrw-conventional-bread_price-distributor-receives-avg 0.793
  set wheat-hrw-conventional-bread_price-distributor-receives-stdev 0.04
  set wheat-hrw-organic-bread_price-distributor-receives-avg 3.11
  set wheat-hrw-organic-bread_price-distributor-receives-stdev 0.04
  set wheat-snowmass-conventional-bread_price-distributor-receives-avg 1.703
  set wheat-snowmass-conventional-bread_price-distributor-receives-stdev 0.04

  ;; peaches

  ;;prices farmers who self pack and/or are the outsource packer recieve
  set peach-conventional_price-farmgate-wholesale-avg 1.13
  set peach-conventional_price-farmgate-wholesale-stdev .07
  set peach-organic_price-farmgate-wholesale-avg 1.49
  set peach-organic_price-farmgate-wholesale-stdev .07
  set peach-seconds_price-farmgate-wholesale-avg 0.22
  set peach-seconds-to-iqf_price-farmgate-wholesale-avg 0.46
  set peach-seconds_price-farmgate-wholesale-stdev .07


  set peach-conventional_price-farmgate-altmark-avg 2.92
  set peach-conventional_price-farmgate-altmark-stdev .97
  set peach-organic_price-farmgate-altmark-avg 3.85
  set peach-organic_price-farmgate-altmark-stdev 1.28
;  set peach-seconds_price-farmgate-altmark-avg 1
;  set peach-seconds_price-farmgate-altmark-stdev .05

  ;; prices farmers who outsource pack receive
  ;; peaches are still purchased by distributor/altmark for the same amount, so producers who outsource pack take a hit to their farmgate price to cover the outsource packing
  set peach-conventional-outsourced_price-farmgate-avg ( peach-conventional_price-farmgate-wholesale-avg * .85 )
  set peach-conventional-outsourced_price-farmgate-stdev .07
  set peach-organic-outsourced_price-farmgate-avg ( peach-organic_price-farmgate-wholesale-avg * .85 )
  set peach-organic-outsourced_price-farmgate-stdev .07
  set peach-seconds-outsourced_price-farmgate-avg ( peach-seconds_price-farmgate-wholesale-avg * .85 )
  set peach-seconds-outsourced_price-farmgate-stdev .07

  ;; prices IQF receive
  set peach-iqf_price-iqf-receives-avg 1.32
  set peach-iqf_price-iqf-receives-stdev .07

  ;; prices distributors receive
  set peach-out-of-state_price-distributor-pays-avg 0.60
  set peach-out-of-state_price-distributor-pays-stdev 0.05

  set peach-out-of-state_price-distributor-receives-avg 0.82
  set peach-out-of-state_price-distributor-receives-stdev 0.05

  ;; peach iqf conversion rate
  set peaches-iqf-conversion-rate 0.93

  ;; beef prices

  ; kevin notes from beef model
  ;set feeder-cattle-price random-normal 173.65 42.24 * 5.5 ; per hundred weight LMIC 500-600 feeder data from 2010-2020 * 550 lbs
  ;set cull-cow-price random-normal 69.15 13.40 * 11 ; per hundred weight LMIC Boner Cull data from 2010-2018 (data stops) * 1100 lbs
  ; pricing has been updated, see spreadsheet beefSupplyChainPricing01202022 - el 4/27/22

  ;ranchers
  set beef-conventional-live-weight_price-farmgate-avg 0.692
  set beef-conventional-live-weight_price-farmgate-stdev 0.134
  set beef-grassfed-live-weight_price-farmgate-avg 1.194
  set beef-grassfed-live-weight_price-farmgate-stdev 0.134
  set beef-colorado-source-id-live-weight_price-farmgate-avg 0.934
  set beef-colorado-source-id-live-weight_price-farmgate-stdev 0.134
  set beef-animal-welfare-live-weight_price-farmgate-avg 1.048
  set beef-animal-welfare-live-weight_price-farmgate-stdev 0.134

  ;packing houses
  set beef-conventional_price-packing-house-receives-avg 2.324
  set beef-conventional_price-packing-house-receives-stdev 0.134
  set beef-grassfed_price-packing-house-receives-avg 4.509
  set beef-grassfed_price-packing-house-receives-stdev 0.134
  set beef-colorado-source-id_price-packing-house-receives-avg 3.889
  set beef-colorado-source-id_price-packing-house-receives-stdev 0.134
  set beef-animal-welfare_price-packing-house-receives-avg 4.143
  set beef-animal-welfare_price-packing-house-receives-stdev 0.134

  ; cow to ground beef conversion rate (live weight to retail weight. a separate metric was used for live weight to hot weight conversion for prices calculations. see beef price documentation for more details)
  set ground-beef-conversion-rate .42

  ;distributor
  set beef-conventional_price-distributor-receives-avg 2.715
  set beef-conventional_price-distributor-receives-stdev 0.134

  ;; ---------------
  ;;production variables -- stand-in for spatially explicit data
  ;;--------------------

  ask patches [

  ;; peach
    ;;may need to update this to be total in model, not on per ha basis for update-bad-production-year procedure to work correctly, also check units
   if county-peach = 1 [
     set peach-conventional-mean-yield 22338
     set peach-organic-mean-yield 24858
    ]

  ;; wheat - units are in lbs. per hectare
   if county-wheat = 1 [
     set wheat-hrw-conv-mean-yield 7116
     set wheat-hrw-org-mean-yield 5337
     set wheat-snowmass-conv-mean-yield 7116
    ]

  ]

  ;; -------------------------
  ; randoms
  ;; -------------------------

  set years-in-model-run 10
  set organic-planning-horizon 5

end


to go

  if ticks > max-ticks [ stop ]
  manage-dates

  if potato-model = TRUE [
    if ( week = 31 ) [
      reset-storage-potatoes
    ]
  ]


  if wheat-model = TRUE [

    if ( week = 31 ) [ reset-storage-wheat ]

    if ( week = 31 ) and ( year != 1 ) [
      transition-patches-wheat
      update-organic-wheat
      update-wheat-rotation
      update-display-wheat
    ]

    if ( week = 5 ) or ( week = 18 ) or ( week = 31 ) [
      reset-promised-amounts-wheat
      reset-tables-wheat
      set-contracts-wheat
    ]

    if week = 36 [
      produce-wheat
      update-wheat-production
    ]

    if ( week = 6 ) or ( week = 19 ) or ( week = 37 ) [
      fulfill-stage1-contracts-wheat
      make-flour
      fulfill-stage2-contracts-wheat
      make-bread
      fulfill-stage3-contracts-wheat
    ]

  ]

  if potato-model = TRUE [
    if ( week = 31 ) and ( year != 1 ) [
      profitability-check-potatoes
      transition-patches-potatoes
      update-organic-potatoes
      update-display-potatoes
    ]
  ]

  if potato-model = TRUE [
  if ( week = 5 ) or ( week = 18 ) or ( week = 31 ) [
    reset-promised-amounts-potatoes
    reset-tables-potatoes
    set-contracts-potatoes
    ]
  ]

  if potato-model = TRUE [
    if week = 36 [
      produce-potatoes
      update-potato-production
      output-print potato-data-year
    ]
  ]

  if beef-model = TRUE [
    if week = 31 [                ; per Kevin's 2/26/21 email most culls happen late summer/fall, so to keep model timing simple I'll schedule it same week as
      reset-storage-beef          ; potatoes, which is first full week of September - el
      set-precip                  ; changing from week 36 to week 31 so processes are in line with other commodities and everything gets counted in final tick of the model (ends on week 31)
      set-forage
      update-display-beef
      ranch-stats
      update-beef-production
      sell-beef-spot-market       ; the procedure takes the place of fulfilling and negotiating contracts. spot market sales only. for simplicity assume culls happen once per year.
    ]
  ]

  if potato-model = TRUE [
    if ( week = 6 ) or ( week = 19 ) or ( week = 37 ) [
      fulfill-contracts-potatoes
      process-potatoes
      fulfill-processor-contracts-potatoes
    ]
  ]

  if peach-model = TRUE [
    if ( week = 26 ) and ( year != 1 ) [
      profitability-check-peaches
      transition-patches-peaches
      update-organic-peaches
      update-display-peaches
    ]
    if week = 26  [
      reset-promised-amounts-peaches
      reset-tables-peaches
      set-contracts-peaches
    ]
    if week = 27 [
      produce-peaches
      update-peach-production
      output-print peach-data-year
    ]

    if ( week = 29 ) [   ;if ( week >= 29 ) and ( week <= 37 ) [   old version had peaches moving every week. simplified for now.
      ; weekly inventory variable available if want to go back to weekly product movement
      update-inventories-peaches  ; should this be happening every week? it sets seconds amts.
      fulfill-contracts-peaches
      if peach-scenario = "baseline" [
        dps-purchases-out-of-state-peaches
      ]
      reset-storage-peaches
    ]
  ]

  if potato-model = TRUE [
    if potato-scenario = "baseline" [
      if ((week > 33) and (week < 47)) or ((week > 47) and (week < 52)) or ((week > 2) and (week < 13)) or ((week > 13) and (week < 22)) [
        dps-purchases-baseline-french-fries
      ]
    ]
  ]


  if ticks = max-ticks [
    calculate-lca
    calculate-profitability
    calculate-tls
    ; moved all output-data variable pulls to behavior space and deleted output-data globals as well as related procedures from commodity dashboards - el 5/21/21
   ]

  tick

end


to manage-dates

  set week week + 1
  if week = 53 [ ;once the julian week counter surpasses 52 weeks, a year has passed and a new year starts
    set year year + 1
    set week 1
  ]

end


to updateTls [ farmer-group ]

  ask farmer-group [
    first-time-farmer-update
    neighborUpdate farmer-group
    bad-harvest-update
    if transition-likelihood-score > 1 [ set transition-likelihood-score 1 ]
    if transition-likelihood-score < 0 [ set transition-likelihood-score 0 ]
  ]

end

to first-time-farmer-update

  ;; update new-farmer status and TLS after year 5 of model (all farmers who were new farmers lose that status after 5 years)
  if ( first-time-farmer = 1 ) and ( year > 5 ) [
    set first-time-farmer 0
    set transition-likelihood-score ( transition-likelihood-score - ( transition-likelihood-score * .1 ) )
    if transition-likelihood-score > 1 [ set transition-likelihood-score 1 ]
    if transition-likelihood-score < 0 [ set transition-likelihood-score 0 ]
  ]

  ;; update alternative/mainstream status after new-farmer demographic update
  ifelse ( not-male = 0 ) and ( not-white = 0 )
  [ if ( first-time-farmer = 1 ) and ( young-farmer = 1 ) [ set alternative-farmer 1 ] ]
  [ if ( ( not-male + first-time-farmer + young-farmer + not-white ) > 1 ) [ set alternative-farmer 1 ] ]

end


; do we want to make it such that small/medium and large farms tend to have different "network" sizes by changing # of nearest neighbors?
to neighborUpdate [farmer-group]

  ;; alternative farmers are more likely to transition if there are other alternative farmers, or farms in transition, around them
  if alternative-farmer = 1 [
    let not-me other farmer-group
    let nearest-neighbors ( min-n-of 3 not-me [ distance myself ] )
    let like-neighbors nearest-neighbors with [ ( alternative-farmer = 1 ) or ( grows-organic = 1 ) or ( farm-transitioning = 1 ) ]
    let like-neighbor-decimal ( count like-neighbors ) / 10
    set transition-likelihood-score ( transition-likelihood-score + ( transition-likelihood-score * like-neighbor-decimal ) )
  ]

  ;; mainstream farmers are less likely to transition if there are alternative farmers, or farms in transition, around them
  if alternative-farmer = 0 [
    let not-me other farmer-group
    let nearest-neighbors ( min-n-of 3 not-me [distance myself] )
    let unlike-neighbors nearest-neighbors with [ ( alternative-farmer = 1 ) or ( grows-organic = 1 ) or ( farm-transitioning = 1 ) ]
    let unlike-neighbor-decimal ( count unlike-neighbors ) / 10
    set transition-likelihood-score ( transition-likelihood-score - ( transition-likelihood-score * unlike-neighbor-decimal ) )
  ]

end


to bad-harvest-update

  ;; after a bad harvest year farmers are more willing to try something new (could go the opposite way with higher risk aversion after bad event but we made a judgment call with james' help -- could change later if better evidence become available)
  if bad-production-year = 1 [
    set transition-likelihood-score ( transition-likelihood-score + .1 ) ]

  if mediocre-production-year = 1 [
    set transition-likelihood-score ( transition-likelihood-score + .025 )
  ]


end
@#$#@#$#@
GRAPHICS-WINDOW
250
17
883
479
-1
-1
1.0
1
10
1
1
1
0
0
0
1
0
624
0
452
0
0
1
weeks
30.0

BUTTON
16
16
118
86
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
128
18
232
51
go
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
128
53
232
86
go forever
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
16
381
237
426
potato-scenario
potato-scenario
"baseline" "fresh-CO" "gfpp" "small-potatoes" "specialty-product"
0

CHOOSER
16
475
237
520
peach-scenario
peach-scenario
"baseline" "CO-fresh" "IQF"
0

CHOOSER
16
323
237
368
display-style
display-style
"farm ownership" "crop rotation" "organic vs conventional" "bad vs good year" "transition likelihood score" "farm size/ideology" "beef: public-private" "beef: grazable" "beef: forage" "beef: irrigated" "beef: precip"
2

SWITCH
16
620
239
653
debug-mode
debug-mode
1
1
-1000

SWITCH
16
584
239
617
hide-turtles?
hide-turtles?
0
1
-1000

CHOOSER
16
428
237
473
wheat-scenario
wheat-scenario
"baseline" "organic" "snowmass"
0

PLOT
891
18
1331
185
Potato Farmer Total Inventory
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -13210332 true "" "plot sum [ potatoes-russet-conventional-fresh_inventory-current ] of potato_farmers "
"pen-1" 1.0 0 -8732573 true "" "plot sum [ potatoes-russet-organic-fresh_inventory-current ] of potato_farmers "
"pen-2" 1.0 0 -11783835 true "" "plot sum [ potatoes-purple-conventional-fresh_inventory-current ] of potato_farmers "
"pen-3" 1.0 0 -5204280 true "" "plot sum [potatoes-purple-organic-fresh_inventory-current ] of potato_farmers"
"pen-4" 1.0 0 -8275240 true "" "plot sum [ potatoes-russet-conventional-fresh-small_inventory-current ] of potato_farmers"

MONITOR
16
92
118
137
NIL
week
17
1
11

MONITOR
128
92
233
137
NIL
year
17
1
11

CHOOSER
16
522
237
567
beef-scenario
beef-scenario
"baseline" "grassfed" "colorado-source-id" "animal-welfare"
3

PLOT
1896
818
2339
1096
DPS Inventory
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -6459832 true "" "if potato-scenario = \"baseline\" [ plot sum [ out-of-state-french-fry_inventory-current ] of dps_buyers ]\nif potato-scenario = \"fresh-CO\" [ plot sum [ potatoes-russet-conventional-fresh_inventory-current ] of dps_buyers ]\nif potato-scenario = \"gfpp\" [ plot sum [ potatoes-russet-conventional-fresh_inventory-current ] of dps_buyers ]\nif potato-scenario = \"small-potatoes\" [ plot sum [ potatoes-russet-conventional-fresh-small_inventory-current ] of dps_buyers ]\nif potato-scenario = \"specialty-product\" [ plot sum [ potatoes-purple-conventional-processed_inventory-current ] of dps_buyers ]"
"pen-1" 1.0 0 -2139308 true "" "if beef-scenario = \"baseline\" [ plot sum [beef-conventional_inventory-current] of dps_buyers]\nif beef-scenario = \"grassfed\" [ plot sum [beef-grassfed_inventory-current] of dps_buyers]\nif beef-scenario = \"colorado-source-id\" [ plot sum [beef-colorado-source-id_inventory-current] of dps_buyers]\nif beef-scenario = \"animal-welfare\" [ plot sum [beef-animal-welfare_inventory-current] of dps_buyers]"
"pen-2" 1.0 0 -612749 true "" "if peach-scenario = \"baseline\" [ plot sum [ peaches-out-of-state_inventory-current] of dps_buyers ]\nif peach-scenario = \"CO-fresh\" [ plot sum [ peaches-conventional_inventory-current] of dps_buyers ]\nif peach-scenario = \"IQF\" [ plot sum [ peaches-iqf_inventory-current] of dps_buyers ]"
"pen-3" 1.0 0 -10649926 true "" "if wheat-scenario = \"baseline\" [ plot (sum [ wheat-hrw-conventional-flour_inventory-current ] of dps_buyers + sum [wheat-hrw-conventional-bread_inventory-current] of dps_buyers )]\nif wheat-scenario = \"organic\" [ plot (sum [ wheat-hrw-organic-flour_inventory-current ] of dps_buyers + sum [wheat-hrw-organic-bread_inventory-current] of dps_buyers )]\nif wheat-scenario = \"snowmass\" [ plot (sum [ wheat-snowmass-conventional-flour_inventory-current ] of dps_buyers + sum [wheat-snowmass-conventional-bread_inventory-current] of dps_buyers )]"

MONITOR
250
487
407
532
Potatoes purchased by DPS
round potatoes-dps
17
1
11

OUTPUT
15
663
886
803
11

MONITOR
414
487
568
532
Flour purchased by DPS
flour-dps
17
1
11

MONITOR
577
487
730
532
Peaches purchased by DPS
peaches-dps
17
1
11

MONITOR
737
487
883
532
Beef purchased by DPS
beef-dps
17
1
11

MONITOR
250
537
407
582
Potatoes outside the DPS system
potatoes-outside
17
1
11

MONITOR
414
537
587
582
Bread purchased by DPS
bread-dps
17
1
11

MONITOR
577
538
731
583
Peaches outside the DPS system
peaches-outside
17
1
11

MONITOR
737
538
884
583
Beef outside the DPS system
beef-outside
17
1
11

TEXTBOX
1886
37
1928
55
Potato
11
0.0
1

PLOT
1339
15
1845
188
Wheat Farmer Total Inventory
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"HRW conventional" 1.0 0 -4699768 true "" "plot sum [ wheat-hrw-conventional_inventory-current ] of wheat_farmers "
"HRW organic" 1.0 0 -13345367 true "" "plot sum [ wheat-hrw-organic_inventory-current ] of wheat_farmers"
"Snowmass" 1.0 0 -2674135 true "" "plot sum [ wheat-snowmass-conventional_inventory-current ] of wheat_farmers"

PLOT
892
192
1334
365
Peach Farmer Total Inventory
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -408670 true "" "plot sum [peaches-conventional_inventory-current] of peach_farmers "
"pen-1" 1.0 0 -5509967 true "" "plot sum [peaches-organic_inventory-current] of peach_farmers "
"pen-2" 1.0 0 -5204280 true "" "plot sum [peaches-seconds_inventory-current] of peach_farmers"

PLOT
2683
395
3029
599
potato farmer cash avg
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -8330359 true "" "plot mean [assets] of potato_farmers"

SWITCH
16
145
118
178
potato-model
potato-model
1
1
-1000

SWITCH
128
145
235
178
wheat-model
wheat-model
1
1
-1000

SWITCH
16
231
119
264
peach-model
peach-model
1
1
-1000

SWITCH
128
231
236
264
beef-model
beef-model
0
1
-1000

PLOT
892
369
1335
542
Beef Rancher Total Inventory
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -10649926 true "" "plot sum [year-cull-cows] of beef_ranchers \n;plot sum [beef-conventional_inventory-current] of beef_ranchers "
"pen-1" 1.0 0 -14835848 true "" "plot (sum [beef-grassfed_inventory-current] of beef_ranchers) * 1200"
"pen-2" 1.0 0 -8630108 true "" "plot (sum [beef-colorado-source-id_inventory-current] of beef_ranchers) * 1200"
"pen-3" 1.0 0 -5825686 true "" "plot (sum [beef-animal-welfare_inventory-current] of beef_ranchers) * 1200"

PLOT
1894
429
2238
575
shipper cash
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [assets] of potato_shippers"

PLOT
1896
597
2239
805
Beef Packing House Inventory 
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot sum [beef-conventional_inventory-current] of beef_packing-houses "
"pen-1" 1.0 0 -11085214 true "" "plot sum [ beef-grassfed-passthrough ] of beef_packing-houses"
"pen-2" 1.0 0 -8275240 true "" "plot sum [ beef-colorado-source-id_inventory-current ] of beef_packing-houses"
"pen-3" 1.0 0 -6917194 true "" "plot sum [ beef-animal-welfare_inventory-current ] of beef_packing-houses"

MONITOR
16
180
118
225
NIL
potato-data-year
17
1
11

MONITOR
128
181
235
226
NIL
wheat-data-year
17
1
11

TEXTBOX
1898
397
2048
415
old plots for diagnostics\n
11
0.0
1

MONITOR
414
587
569
632
Wheat outside the DPS system
wheat-outside
17
1
11

MONITOR
16
266
119
311
NIL
peach-data-year
17
1
11

MONITOR
128
266
236
311
NIL
beef-data-year
17
1
11

PLOT
1339
192
1845
365
Proportion of Wheat Land in Organic vs Conventional Management
Year
Percent
1.0
0.0
0.0
0.0
false
true
"" ""
PENS
"Conventional" 1.0 1 -10402772 true "" ""
"In Transition" 1.0 1 -8732573 true "" ""
"Organic" 1.0 1 -14333415 true "" ""

PLOT
1339
369
1845
542
Total Production by Wheat Type
Year
Pounds
0.0
0.0
0.0
0.0
true
true
"set-current-plot-pen \"HRW conventional\"\nset-plot-pen-interval .33\nset-current-plot-pen \"HRW organic\"\nset-plot-pen-interval .33\nset-current-plot-pen \"Snowmass\"\nset-plot-pen-interval .33" ""
PENS
"HRW conventional" 1.0 1 -3844592 true "" ""
"HRW organic" 1.0 1 -14439633 true "" ""
"Snowmass" 1.0 1 -14454117 true "" ""

PLOT
892
548
1845
803
Mean Assets by Agent Type
NIL
NIL
0.0
0.0
0.0
0.0
true
true
"" ""
PENS
"Wheat Farmers" 1.0 0 -14439633 true "" "plot mean [ assets ] of wheat_farmers"
"Wheat Elevators" 1.0 0 -9276814 true "" "plot mean [ assets ] of wheat_elevators"
"Wheat Mills" 1.0 0 -8431303 true "" "plot mean [ assets ] of wheat_mills"
"Wheat Bakers" 1.0 0 -14454117 true "" "plot mean [ assets ] of wheat_bakers"
"Distributors" 1.0 0 -4757638 true "" "plot mean [ assets ] of distributors"
"Y=0" 1.0 0 -16777216 true "" "plotxy ticks 0"

INPUTBOX
248
592
403
652
market-knowledge
0.5
1
0
Number

MONITOR
1965
65
2178
110
NIL
potato_CO2-kg-eq-at-Denver-model-run
17
1
11

MONITOR
1965
115
2178
160
NIL
potato_CO2-kg-eq-at-farm-model-run
17
1
11

TEXTBOX
1877
10
2129
38
LCAs (these update at the end of the model)\n
11
0.0
1

PLOT
2282
460
2622
627
rancher assets
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot sum [assets] of beef_ranchers"

PLOT
2281
631
2650
812
dps profitability
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot sum [assets] of dps_buyers"

MONITOR
1966
236
2180
281
wheat_CO2-kg-eq-at-Denver-model-run
wheat_CO2-kg-eq-at-Denver-model-run
17
1
11

MONITOR
1966
287
2180
332
wheat_CO2-kg-eq-at-farm-model-run
wheat_CO2-kg-eq-at-farm-model-run
17
1
11

MONITOR
2185
236
2400
281
wheat_H2O-m3-at-Denver-model-run
wheat_h2o-m3-at-Denver-model-run
17
1
11

MONITOR
2185
286
2400
331
wheat_H2O-m3-at-farm-model-run
wheat_h2o-m3-at-farm-model-run
17
1
11

PLOT
2366
828
2753
1022
wheat farmer prof
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [assets] of wheat_farmers"

TEXTBOX
1886
80
1940
98
At Denver
11
0.0
1

TEXTBOX
1887
132
1931
150
At Farm
11
0.0
1

TEXTBOX
2036
36
2118
54
CO2 Emissions
11
0.0
1

TEXTBOX
2266
34
2321
52
H2O Use
11
0.0
1

MONITOR
2183
65
2395
110
NIL
potato_H2O-m3-at-Denver-model-run
17
1
11

MONITOR
2183
115
2391
160
NIL
potato_H2O-m3-at-farm-model-run
17
1
11

TEXTBOX
1888
201
2038
219
Wheat
11
0.0
1

TEXTBOX
1891
254
1964
272
At Denver
11
0.0
1

TEXTBOX
1892
304
1941
322
At Farm
11
0.0
1

TEXTBOX
2036
199
2186
217
CO2 Emissions
11
0.0
1

TEXTBOX
2267
198
2335
216
H2O Use
11
0.0
1

PLOT
1397
822
1844
1012
Proportion of Potato Land in Organic vs Conventional Management
Year
Percent
0.0
10.0
0.0
100.0
true
false
"" ""
PENS
"Conventional" 1.0 0 -12440034 true "" ""
"In Transition" 1.0 0 -8732573 true "" ""
"Organic" 1.0 0 -15575016 true "" ""

TEXTBOX
2482
31
2632
49
Beef
11
0.0
1

TEXTBOX
2412
80
2562
98
At Denver
11
0.0
1

TEXTBOX
2414
125
2564
143
At Farm
11
0.0
1

TEXTBOX
2592
31
2669
49
CO2 Emissions
11
0.0
1

TEXTBOX
2845
33
2903
51
H2O Use
11
0.0
1

TEXTBOX
2616
86
2650
104
TBD
11
0.0
1

TEXTBOX
2857
86
2894
104
TBD
11
0.0
1

MONITOR
2524
111
2735
156
NIL
beef_CO2-kg-eq-at-farm-model-run
17
1
11

MONITOR
2780
111
2973
156
NIL
beef_h2o-m3-at-farm-model-run
17
1
11

SWITCH
17
812
142
845
DPS_x1000?
DPS_x1000?
1
1
-1000

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

The GIS landscape for the model is based on the county-id variable. Variables are assigned as follows:

  1. Alamosa
  2. Delta
  3. Denver
  4. Mesa
  5. Moffat
  6. Rio grande
  7. Routt
  8. Saguache
  9. Washington

Potato farm size typology derived from National Agricultural Statistics Services: https://www.nass.usda.gov/

County-level producer socio-demographic characteristics from the 2017 USDA Ag Census:

  * Potatoes: https://www.nass.usda.gov/Publications/AgCensus/2017/Online_Resources/County_Profiles/Colorado/cp08003.pdf

Primary income values derived from https://www.nass.usda.gov/Publications/AgCensus/2017/Full_Report/Volume_1,_Chapter_2_County_Level/Colorado/st08_2_0045_0045.pdf

Contracting for wheat is complex because end users don't buy raw wheat, they buy flour or bread. Because of this, contracting between agent types is separated into three stages, built around the need to mill flour and then bake bread in the middle of the contracting process:

  * Phase 1: farm-elevator contracts, elevator-mill contracts, make flour
  * Phase 2: mill-distributor contracts, mill-baker contracts, make bread
  * Phase 3: baker-distributor contracts, distributor-dpsbuyer contracts

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

Sociodemographic farmer/rancher variables (being young, non-male, non-white, and/or a first-time farmer) are each assigned independently. There may be interaction effects between these variables; for example, non-white farmers might be more likely to be women, or first-time farmers might be more likely to be young, etc. If those types of relationships exist, they are not available in our data set and thus are not accounted for in this model. A better understanding of those relationships would make our sociodemographic assignments, and thus our TLS procedure, more nuanced.

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

The code for this model was written by Stefanie Berganini and Erin Love, with help from Francesco Serafin and Randall Boone. It was created as part of the Rural Wealth Creation project at Colorado State University, which is partly funded by the Foundation for Food and Agricutural Research.

Some notes on sources for wheat data used in the model:

  * County-level producer characteristics come from the 2017 USDA Ag Census: https://www.nass.usda.gov/Publications/AgCensus/2017/Online_Resources/County_Profiles/Colorado/cp08121.pdf
  * Primary income values are derived from https://www.nass.usda.gov/Publications/AgCensus/2017/Full_Report/Volume_1,_Chapter_2_County_Level/Colorado/st08_2_0045_0045.pdf
  * The 95% Hard Red Winter / 5% Snowmass allocation amounts come from Brad Erker via email. For more info about this datapoint, contact Meagan Schipanski. 
  * The percentage of organic wheat assigned at model start was calculated as follows:
    * The total amount of wheat produced comes from the Colorado "specificed crops harvested" state-level report, found here: https://www.nass.usda.gov/Publications/AgCensus/2017/Full_Report/Volume_1,_Chapter_1_State_Level/Colorado/st08_1_0032_0034.pdf: 347,674 total acres of winter wheat across both irrigated and non-irrigated production. 
    * The amount of organic production comes from the 2017 NASS ag census
2017 Organic Production report, specifically the Colorado values for "Wheat, Winter for Grain or Seed": 24,458 acres. Report available at https://downloads.usda.library.cornell.edu/usda-esmis/files/zg64tk92g/70795b52w/4m90dz33q/OrganicProduction-09-20-2017_correction.pdf. 
    * 24,458 organic acres / 347,674 total acres = 7% of total starting wheat acreage is organic.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="potatoes_baseline" repetitions="60" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>count potato_farmers with [fully-organic = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [conventional-proportion] of potato_farmers</metric>
    <metric>max [conventional-proportion] of potato_farmers</metric>
    <metric>mean [conventional-proportion] of potato_farmers</metric>
    <metric>median [conventional-proportion] of potato_farmers</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers</metric>
    <metric>min [organic-proportion] of potato_farmers</metric>
    <metric>max [organic-proportion] of potato_farmers</metric>
    <metric>mean [organic-proportion] of potato_farmers</metric>
    <metric>median [organic-proportion] of potato_farmers</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers</metric>
    <metric>min [transition-proportion] of potato_farmers</metric>
    <metric>max [transition-proportion] of potato_farmers</metric>
    <metric>mean [transition-proportion] of potato_farmers</metric>
    <metric>median [transition-proportion] of potato_farmers</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [tls-initial] of potato_farmers</metric>
    <metric>max [tls-initial] of potato_farmers</metric>
    <metric>mean [tls-initial] of potato_farmers</metric>
    <metric>median [tls-initial] of potato_farmers</metric>
    <metric>standard-deviation [tls-initial] of potato_farmers</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers</metric>
    <metric>max [tls-change] of potato_farmers</metric>
    <metric>mean [tls-change] of potato_farmers</metric>
    <metric>median [tls-change] of potato_farmers</metric>
    <metric>standard-deviation [tls-change] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_fresh-CO" repetitions="60" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>count potato_farmers with [fully-organic = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [conventional-proportion] of potato_farmers</metric>
    <metric>max [conventional-proportion] of potato_farmers</metric>
    <metric>mean [conventional-proportion] of potato_farmers</metric>
    <metric>median [conventional-proportion] of potato_farmers</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers</metric>
    <metric>min [organic-proportion] of potato_farmers</metric>
    <metric>max [organic-proportion] of potato_farmers</metric>
    <metric>mean [organic-proportion] of potato_farmers</metric>
    <metric>median [organic-proportion] of potato_farmers</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers</metric>
    <metric>min [transition-proportion] of potato_farmers</metric>
    <metric>max [transition-proportion] of potato_farmers</metric>
    <metric>mean [transition-proportion] of potato_farmers</metric>
    <metric>median [transition-proportion] of potato_farmers</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [tls-initial] of potato_farmers</metric>
    <metric>max [tls-initial] of potato_farmers</metric>
    <metric>mean [tls-initial] of potato_farmers</metric>
    <metric>median [tls-initial] of potato_farmers</metric>
    <metric>standard-deviation [tls-initial] of potato_farmers</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers</metric>
    <metric>max [tls-change] of potato_farmers</metric>
    <metric>mean [tls-change] of potato_farmers</metric>
    <metric>median [tls-change] of potato_farmers</metric>
    <metric>standard-deviation [tls-change] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;fresh-CO&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_gfpp" repetitions="60" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>count potato_farmers with [fully-organic = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [conventional-proportion] of potato_farmers</metric>
    <metric>max [conventional-proportion] of potato_farmers</metric>
    <metric>mean [conventional-proportion] of potato_farmers</metric>
    <metric>median [conventional-proportion] of potato_farmers</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers</metric>
    <metric>min [organic-proportion] of potato_farmers</metric>
    <metric>max [organic-proportion] of potato_farmers</metric>
    <metric>mean [organic-proportion] of potato_farmers</metric>
    <metric>median [organic-proportion] of potato_farmers</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers</metric>
    <metric>min [transition-proportion] of potato_farmers</metric>
    <metric>max [transition-proportion] of potato_farmers</metric>
    <metric>mean [transition-proportion] of potato_farmers</metric>
    <metric>median [transition-proportion] of potato_farmers</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [tls-initial] of potato_farmers</metric>
    <metric>max [tls-initial] of potato_farmers</metric>
    <metric>mean [tls-initial] of potato_farmers</metric>
    <metric>median [tls-initial] of potato_farmers</metric>
    <metric>standard-deviation [tls-initial] of potato_farmers</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers</metric>
    <metric>max [tls-change] of potato_farmers</metric>
    <metric>mean [tls-change] of potato_farmers</metric>
    <metric>median [tls-change] of potato_farmers</metric>
    <metric>standard-deviation [tls-change] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;gfpp&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_small-potatoes" repetitions="60" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>count potato_farmers with [fully-organic = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [conventional-proportion] of potato_farmers</metric>
    <metric>max [conventional-proportion] of potato_farmers</metric>
    <metric>mean [conventional-proportion] of potato_farmers</metric>
    <metric>median [conventional-proportion] of potato_farmers</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers</metric>
    <metric>min [organic-proportion] of potato_farmers</metric>
    <metric>max [organic-proportion] of potato_farmers</metric>
    <metric>mean [organic-proportion] of potato_farmers</metric>
    <metric>median [organic-proportion] of potato_farmers</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers</metric>
    <metric>min [transition-proportion] of potato_farmers</metric>
    <metric>max [transition-proportion] of potato_farmers</metric>
    <metric>mean [transition-proportion] of potato_farmers</metric>
    <metric>median [transition-proportion] of potato_farmers</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [tls-initial] of potato_farmers</metric>
    <metric>max [tls-initial] of potato_farmers</metric>
    <metric>mean [tls-initial] of potato_farmers</metric>
    <metric>median [tls-initial] of potato_farmers</metric>
    <metric>standard-deviation [tls-initial] of potato_farmers</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers</metric>
    <metric>max [tls-change] of potato_farmers</metric>
    <metric>mean [tls-change] of potato_farmers</metric>
    <metric>median [tls-change] of potato_farmers</metric>
    <metric>standard-deviation [tls-change] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;small-potatoes&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_specialty-product" repetitions="60" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>count potato_farmers with [fully-organic = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [conventional-proportion] of potato_farmers</metric>
    <metric>max [conventional-proportion] of potato_farmers</metric>
    <metric>mean [conventional-proportion] of potato_farmers</metric>
    <metric>median [conventional-proportion] of potato_farmers</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers</metric>
    <metric>min [organic-proportion] of potato_farmers</metric>
    <metric>max [organic-proportion] of potato_farmers</metric>
    <metric>mean [organic-proportion] of potato_farmers</metric>
    <metric>median [organic-proportion] of potato_farmers</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers</metric>
    <metric>min [transition-proportion] of potato_farmers</metric>
    <metric>max [transition-proportion] of potato_farmers</metric>
    <metric>mean [transition-proportion] of potato_farmers</metric>
    <metric>median [transition-proportion] of potato_farmers</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [tls-initial] of potato_farmers</metric>
    <metric>max [tls-initial] of potato_farmers</metric>
    <metric>mean [tls-initial] of potato_farmers</metric>
    <metric>median [tls-initial] of potato_farmers</metric>
    <metric>standard-deviation [tls-initial] of potato_farmers</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers</metric>
    <metric>max [tls-change] of potato_farmers</metric>
    <metric>mean [tls-change] of potato_farmers</metric>
    <metric>median [tls-change] of potato_farmers</metric>
    <metric>standard-deviation [tls-change] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;specialty-product&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="peaches_baseline" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>peach-conventional_production-total-model-run</metric>
    <metric>peach-organic_production-total-model-run</metric>
    <metric>peach-seconds_production-total-model-run</metric>
    <metric>sum [hectares-farmed-peaches] of peach_farmers</metric>
    <metric>min [assets-change] of peach_farmers</metric>
    <metric>max [assets-change] of peach_farmers</metric>
    <metric>mean [assets-change] of peach_farmers</metric>
    <metric>median [assets-change] of peach_farmers</metric>
    <metric>standard-deviation [assets-change] of peach_farmers</metric>
    <metric>min [assets-change] of peach_processors</metric>
    <metric>max [assets-change] of peach_processors</metric>
    <metric>mean [assets-change] of peach_processors</metric>
    <metric>median [assets-change] of peach_processors</metric>
    <metric>standard-deviation [assets-change] of peach_processors</metric>
    <metric>min [assets-change] of peach_altmarks</metric>
    <metric>max [assets-change] of peach_altmarks</metric>
    <metric>mean [assets-change] of peach_altmarks</metric>
    <metric>median [assets-change] of peach_altmarks</metric>
    <metric>standard-deviation [assets-change] of peach_altmarks</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-initial] of peach_farmers</metric>
    <metric>max [tls-initial] of peach_farmers</metric>
    <metric>mean [tls-initial] of peach_farmers</metric>
    <metric>median [tls-initial] of peach_farmers</metric>
    <metric>standard-deviation [tls-initial] of peach_farmers</metric>
    <metric>min [tls-final] of peach_farmers</metric>
    <metric>max [tls-final] of peach_farmers</metric>
    <metric>mean [tls-final] of peach_farmers</metric>
    <metric>median [tls-final] of peach_farmers</metric>
    <metric>standard-deviation [tls-final] of peach_farmers</metric>
    <metric>min [tls-change] of peach_farmers</metric>
    <metric>max [tls-change] of peach_farmers</metric>
    <metric>mean [tls-change] of peach_farmers</metric>
    <metric>median [tls-change] of peach_farmers</metric>
    <metric>standard-deviation [tls-change] of peach_farmers</metric>
    <metric>min [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>peach_CO2-kg-eq-at-farm-model-run</metric>
    <metric>peach _CO2-kg-eq-at-Denver-model-run</metric>
    <metric>peach _h2o-m3-at-farm-model-run</metric>
    <metric>peach _h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="peaches_CO-fresh" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>peach-conventional_production-total-model-run</metric>
    <metric>peach-organic_production-total-model-run</metric>
    <metric>peach-seconds_production-total-model-run</metric>
    <metric>sum [hectares-farmed-peaches] of peach_farmers</metric>
    <metric>min [assets-change] of peach_farmers</metric>
    <metric>max [assets-change] of peach_farmers</metric>
    <metric>mean [assets-change] of peach_farmers</metric>
    <metric>median [assets-change] of peach_farmers</metric>
    <metric>standard-deviation [assets-change] of peach_farmers</metric>
    <metric>min [assets-change] of peach_processors</metric>
    <metric>max [assets-change] of peach_processors</metric>
    <metric>mean [assets-change] of peach_processors</metric>
    <metric>median [assets-change] of peach_processors</metric>
    <metric>standard-deviation [assets-change] of peach_processors</metric>
    <metric>min [assets-change] of peach_altmarks</metric>
    <metric>max [assets-change] of peach_altmarks</metric>
    <metric>mean [assets-change] of peach_altmarks</metric>
    <metric>median [assets-change] of peach_altmarks</metric>
    <metric>standard-deviation [assets-change] of peach_altmarks</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-initial] of peach_farmers</metric>
    <metric>max [tls-initial] of peach_farmers</metric>
    <metric>mean [tls-initial] of peach_farmers</metric>
    <metric>median [tls-initial] of peach_farmers</metric>
    <metric>standard-deviation [tls-initial] of peach_farmers</metric>
    <metric>min [tls-final] of peach_farmers</metric>
    <metric>max [tls-final] of peach_farmers</metric>
    <metric>mean [tls-final] of peach_farmers</metric>
    <metric>median [tls-final] of peach_farmers</metric>
    <metric>standard-deviation [tls-final] of peach_farmers</metric>
    <metric>min [tls-change] of peach_farmers</metric>
    <metric>max [tls-change] of peach_farmers</metric>
    <metric>mean [tls-change] of peach_farmers</metric>
    <metric>median [tls-change] of peach_farmers</metric>
    <metric>standard-deviation [tls-change] of peach_farmers</metric>
    <metric>min [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>peach_CO2-kg-eq-at-farm-model-run</metric>
    <metric>peach _CO2-kg-eq-at-Denver-model-run</metric>
    <metric>peach _h2o-m3-at-farm-model-run</metric>
    <metric>peach _h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;CO-fresh&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="peaches_IQF" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>peach-conventional_production-total-model-run</metric>
    <metric>peach-organic_production-total-model-run</metric>
    <metric>peach-seconds_production-total-model-run</metric>
    <metric>sum [hectares-farmed-peaches] of peach_farmers</metric>
    <metric>min [assets-change] of peach_farmers</metric>
    <metric>max [assets-change] of peach_farmers</metric>
    <metric>mean [assets-change] of peach_farmers</metric>
    <metric>median [assets-change] of peach_farmers</metric>
    <metric>standard-deviation [assets-change] of peach_farmers</metric>
    <metric>min [assets-change] of peach_processors</metric>
    <metric>max [assets-change] of peach_processors</metric>
    <metric>mean [assets-change] of peach_processors</metric>
    <metric>median [assets-change] of peach_processors</metric>
    <metric>standard-deviation [assets-change] of peach_processors</metric>
    <metric>min [assets-change] of peach_altmarks</metric>
    <metric>max [assets-change] of peach_altmarks</metric>
    <metric>mean [assets-change] of peach_altmarks</metric>
    <metric>median [assets-change] of peach_altmarks</metric>
    <metric>standard-deviation [assets-change] of peach_altmarks</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of peach_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-initial] of peach_farmers</metric>
    <metric>max [tls-initial] of peach_farmers</metric>
    <metric>mean [tls-initial] of peach_farmers</metric>
    <metric>median [tls-initial] of peach_farmers</metric>
    <metric>standard-deviation [tls-initial] of peach_farmers</metric>
    <metric>min [tls-final] of peach_farmers</metric>
    <metric>max [tls-final] of peach_farmers</metric>
    <metric>mean [tls-final] of peach_farmers</metric>
    <metric>median [tls-final] of peach_farmers</metric>
    <metric>standard-deviation [tls-final] of peach_farmers</metric>
    <metric>min [tls-change] of peach_farmers</metric>
    <metric>max [tls-change] of peach_farmers</metric>
    <metric>mean [tls-change] of peach_farmers</metric>
    <metric>median [tls-change] of peach_farmers</metric>
    <metric>standard-deviation [tls-change] of peach_farmers</metric>
    <metric>min [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of peach_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>peach_CO2-kg-eq-at-farm-model-run</metric>
    <metric>peach _CO2-kg-eq-at-Denver-model-run</metric>
    <metric>peach _h2o-m3-at-farm-model-run</metric>
    <metric>peach _h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;IQF&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="beef_baseline" repetitions="60" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>beef-conventional_production-total-model-run</metric>
    <metric>beef-grassfed_production-total-model-run</metric>
    <metric>beef-colorado-source-id_production-total-model-run</metric>
    <metric>beef-animal-welfare_production-total-model-run</metric>
    <metric>min [assets-change] of beef_ranchers</metric>
    <metric>max [assets-change] of beef_ranchers</metric>
    <metric>mean [assets-change] of beef_ranchers</metric>
    <metric>median [assets-change] of beef_ranchers</metric>
    <metric>standard-deviation [assets-change] of beef_ranchers</metric>
    <metric>min [assets-change] of beef_packing-houses</metric>
    <metric>max [assets-change] of beef_packing-houses</metric>
    <metric>mean [assets-change] of beef_packing-houses</metric>
    <metric>median [assets-change] of beef_packing-houses</metric>
    <metric>standard-deviation [assets-change] of beef_packing-houses</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [tls-initial] of beef_ranchers</metric>
    <metric>max [tls-initial] of beef_ranchers</metric>
    <metric>mean [tls-initial] of beef_ranchers</metric>
    <metric>median [tls-initial] of beef_ranchers</metric>
    <metric>standard-deviation [tls-initial] of beef_ranchers</metric>
    <metric>min [tls-final] of beef_ranchers</metric>
    <metric>max [tls-final] of beef_ranchers</metric>
    <metric>mean [tls-final] of beef_ranchers</metric>
    <metric>median [tls-final] of beef_ranchers</metric>
    <metric>standard-deviation [tls-final] of beef_ranchers</metric>
    <metric>min [tls-change] of beef_ranchers</metric>
    <metric>max [tls-change] of beef_ranchers</metric>
    <metric>mean [tls-change] of beef_ranchers</metric>
    <metric>median [tls-change] of beef_ranchers</metric>
    <metric>standard-deviation [tls-change] of beef_ranchers</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>beef_CO2-kg-eq-at-farm-model-run</metric>
    <metric>beef_h2o-m3-at-farm-model-run</metric>
    <metric>beef_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>beef_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="beef_grassfed" repetitions="60" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>beef-conventional_production-total-model-run</metric>
    <metric>beef-grassfed_production-total-model-run</metric>
    <metric>beef-colorado-source-id_production-total-model-run</metric>
    <metric>beef-animal-welfare_production-total-model-run</metric>
    <metric>min [assets-change] of beef_ranchers</metric>
    <metric>max [assets-change] of beef_ranchers</metric>
    <metric>mean [assets-change] of beef_ranchers</metric>
    <metric>median [assets-change] of beef_ranchers</metric>
    <metric>standard-deviation [assets-change] of beef_ranchers</metric>
    <metric>min [assets-change] of beef_packing-houses</metric>
    <metric>max [assets-change] of beef_packing-houses</metric>
    <metric>mean [assets-change] of beef_packing-houses</metric>
    <metric>median [assets-change] of beef_packing-houses</metric>
    <metric>standard-deviation [assets-change] of beef_packing-houses</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [tls-initial] of beef_ranchers</metric>
    <metric>max [tls-initial] of beef_ranchers</metric>
    <metric>mean [tls-initial] of beef_ranchers</metric>
    <metric>median [tls-initial] of beef_ranchers</metric>
    <metric>standard-deviation [tls-initial] of beef_ranchers</metric>
    <metric>min [tls-final] of beef_ranchers</metric>
    <metric>max [tls-final] of beef_ranchers</metric>
    <metric>mean [tls-final] of beef_ranchers</metric>
    <metric>median [tls-final] of beef_ranchers</metric>
    <metric>standard-deviation [tls-final] of beef_ranchers</metric>
    <metric>min [tls-change] of beef_ranchers</metric>
    <metric>max [tls-change] of beef_ranchers</metric>
    <metric>mean [tls-change] of beef_ranchers</metric>
    <metric>median [tls-change] of beef_ranchers</metric>
    <metric>standard-deviation [tls-change] of beef_ranchers</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>beef_CO2-kg-eq-at-farm-model-run</metric>
    <metric>beef_h2o-m3-at-farm-model-run</metric>
    <metric>beef_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>beef_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;grassfed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="beef_colorado-source-id" repetitions="60" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>beef-conventional_production-total-model-run</metric>
    <metric>beef-grassfed_production-total-model-run</metric>
    <metric>beef-colorado-source-id_production-total-model-run</metric>
    <metric>beef-animal-welfare_production-total-model-run</metric>
    <metric>min [assets-change] of beef_ranchers</metric>
    <metric>max [assets-change] of beef_ranchers</metric>
    <metric>mean [assets-change] of beef_ranchers</metric>
    <metric>median [assets-change] of beef_ranchers</metric>
    <metric>standard-deviation [assets-change] of beef_ranchers</metric>
    <metric>min [assets-change] of beef_packing-houses</metric>
    <metric>max [assets-change] of beef_packing-houses</metric>
    <metric>mean [assets-change] of beef_packing-houses</metric>
    <metric>median [assets-change] of beef_packing-houses</metric>
    <metric>standard-deviation [assets-change] of beef_packing-houses</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [tls-initial] of beef_ranchers</metric>
    <metric>max [tls-initial] of beef_ranchers</metric>
    <metric>mean [tls-initial] of beef_ranchers</metric>
    <metric>median [tls-initial] of beef_ranchers</metric>
    <metric>standard-deviation [tls-initial] of beef_ranchers</metric>
    <metric>min [tls-final] of beef_ranchers</metric>
    <metric>max [tls-final] of beef_ranchers</metric>
    <metric>mean [tls-final] of beef_ranchers</metric>
    <metric>median [tls-final] of beef_ranchers</metric>
    <metric>standard-deviation [tls-final] of beef_ranchers</metric>
    <metric>min [tls-change] of beef_ranchers</metric>
    <metric>max [tls-change] of beef_ranchers</metric>
    <metric>mean [tls-change] of beef_ranchers</metric>
    <metric>median [tls-change] of beef_ranchers</metric>
    <metric>standard-deviation [tls-change] of beef_ranchers</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>beef_CO2-kg-eq-at-farm-model-run</metric>
    <metric>beef_h2o-m3-at-farm-model-run</metric>
    <metric>beef_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>beef_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;colorado-source-id&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="beef_animal-welfare" repetitions="60" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>beef-conventional_production-total-model-run</metric>
    <metric>beef-grassfed_production-total-model-run</metric>
    <metric>beef-colorado-source-id_production-total-model-run</metric>
    <metric>beef-animal-welfare_production-total-model-run</metric>
    <metric>min [assets-change] of beef_ranchers</metric>
    <metric>max [assets-change] of beef_ranchers</metric>
    <metric>mean [assets-change] of beef_ranchers</metric>
    <metric>median [assets-change] of beef_ranchers</metric>
    <metric>standard-deviation [assets-change] of beef_ranchers</metric>
    <metric>min [assets-change] of beef_packing-houses</metric>
    <metric>max [assets-change] of beef_packing-houses</metric>
    <metric>mean [assets-change] of beef_packing-houses</metric>
    <metric>median [assets-change] of beef_packing-houses</metric>
    <metric>standard-deviation [assets-change] of beef_packing-houses</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [tls-initial] of beef_ranchers</metric>
    <metric>max [tls-initial] of beef_ranchers</metric>
    <metric>mean [tls-initial] of beef_ranchers</metric>
    <metric>median [tls-initial] of beef_ranchers</metric>
    <metric>standard-deviation [tls-initial] of beef_ranchers</metric>
    <metric>min [tls-final] of beef_ranchers</metric>
    <metric>max [tls-final] of beef_ranchers</metric>
    <metric>mean [tls-final] of beef_ranchers</metric>
    <metric>median [tls-final] of beef_ranchers</metric>
    <metric>standard-deviation [tls-final] of beef_ranchers</metric>
    <metric>min [tls-change] of beef_ranchers</metric>
    <metric>max [tls-change] of beef_ranchers</metric>
    <metric>mean [tls-change] of beef_ranchers</metric>
    <metric>median [tls-change] of beef_ranchers</metric>
    <metric>standard-deviation [tls-change] of beef_ranchers</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>beef_CO2-kg-eq-at-farm-model-run</metric>
    <metric>beef_h2o-m3-at-farm-model-run</metric>
    <metric>beef_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>beef_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;animal-welfare&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="wheat_baseline" repetitions="60" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>wheat-hrw-conventional_production-total-model-run</metric>
    <metric>wheat-hrw-organic_production-total-model-run</metric>
    <metric>wheat-snowmass-conventional_production-total-model-run</metric>
    <metric>sum [hectares-farmed-wheat] of wheat_farmers</metric>
    <metric>count wheat_farmers with [fully-organic = 1]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [conventional-proportion] of wheat_farmers</metric>
    <metric>max [conventional-proportion] of wheat_farmers</metric>
    <metric>mean [conventional-proportion] of wheat_farmers</metric>
    <metric>median [conventional-proportion] of wheat_farmers</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers</metric>
    <metric>min [organic-proportion] of wheat_farmers</metric>
    <metric>max [organic-proportion] of wheat_farmers</metric>
    <metric>mean [organic-proportion] of wheat_farmers</metric>
    <metric>median [organic-proportion] of wheat_farmers</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers</metric>
    <metric>min [transition-proportion] of wheat_farmers</metric>
    <metric>max [transition-proportion] of wheat_farmers</metric>
    <metric>mean [transition-proportion] of wheat_farmers</metric>
    <metric>median [transition-proportion] of wheat_farmers</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of wheat_farmers</metric>
    <metric>max [assets-change] of wheat_farmers</metric>
    <metric>mean [assets-change] of wheat_farmers</metric>
    <metric>median [assets-change] of wheat_farmers</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers</metric>
    <metric>min [assets-change] of wheat_elevators</metric>
    <metric>max [assets-change] of wheat_elevators</metric>
    <metric>mean [assets-change] of wheat_elevators</metric>
    <metric>median [assets-change] of wheat_elevators</metric>
    <metric>standard-deviation [assets-change] of wheat_elevators</metric>
    <metric>min [assets-change] of wheat_mills</metric>
    <metric>max [assets-change] of wheat_mills</metric>
    <metric>mean [assets-change] of wheat_mills</metric>
    <metric>median [assets-change] of wheat_mills</metric>
    <metric>standard-deviation [assets-change] of wheat_mills</metric>
    <metric>min [assets-change] of wheat_bakers</metric>
    <metric>max [assets-change] of wheat_bakers</metric>
    <metric>mean [assets-change] of wheat_bakers</metric>
    <metric>median [assets-change] of wheat_bakers</metric>
    <metric>standard-deviation [assets-change] of wheat_bakers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [tls-initial] of wheat_farmers</metric>
    <metric>max [tls-initial] of wheat_farmers</metric>
    <metric>mean [tls-initial] of wheat_farmers</metric>
    <metric>median [tls-initial] of wheat_farmers</metric>
    <metric>standard-deviation [tls-initial] of wheat_farmers</metric>
    <metric>min [tls-final] of wheat_farmers</metric>
    <metric>max [tls-final] of wheat_farmers</metric>
    <metric>mean [tls-final] of wheat_farmers</metric>
    <metric>median [tls-final] of wheat_farmers</metric>
    <metric>standard-deviation [tls-final] of wheat_farmers</metric>
    <metric>min [tls-change] of wheat_farmers</metric>
    <metric>max [tls-change] of wheat_farmers</metric>
    <metric>mean [tls-change] of wheat_farmers</metric>
    <metric>median [tls-change] of wheat_farmers</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers</metric>
    <metric>min [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>wheat_CO2-kg-eq-at-farm-model-run</metric>
    <metric>wheat_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>wheat_h2o-m3-at-farm-model-run</metric>
    <metric>wheat_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="wheat_organic" repetitions="60" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>wheat-hrw-conventional_production-total-model-run</metric>
    <metric>wheat-hrw-organic_production-total-model-run</metric>
    <metric>wheat-snowmass-conventional_production-total-model-run</metric>
    <metric>sum [hectares-farmed-wheat] of wheat_farmers</metric>
    <metric>count wheat_farmers with [fully-organic = 1]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [conventional-proportion] of wheat_farmers</metric>
    <metric>max [conventional-proportion] of wheat_farmers</metric>
    <metric>mean [conventional-proportion] of wheat_farmers</metric>
    <metric>median [conventional-proportion] of wheat_farmers</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers</metric>
    <metric>min [organic-proportion] of wheat_farmers</metric>
    <metric>max [organic-proportion] of wheat_farmers</metric>
    <metric>mean [organic-proportion] of wheat_farmers</metric>
    <metric>median [organic-proportion] of wheat_farmers</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers</metric>
    <metric>min [transition-proportion] of wheat_farmers</metric>
    <metric>max [transition-proportion] of wheat_farmers</metric>
    <metric>mean [transition-proportion] of wheat_farmers</metric>
    <metric>median [transition-proportion] of wheat_farmers</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of wheat_farmers</metric>
    <metric>max [assets-change] of wheat_farmers</metric>
    <metric>mean [assets-change] of wheat_farmers</metric>
    <metric>median [assets-change] of wheat_farmers</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers</metric>
    <metric>min [assets-change] of wheat_elevators</metric>
    <metric>max [assets-change] of wheat_elevators</metric>
    <metric>mean [assets-change] of wheat_elevators</metric>
    <metric>median [assets-change] of wheat_elevators</metric>
    <metric>standard-deviation [assets-change] of wheat_elevators</metric>
    <metric>min [assets-change] of wheat_mills</metric>
    <metric>max [assets-change] of wheat_mills</metric>
    <metric>mean [assets-change] of wheat_mills</metric>
    <metric>median [assets-change] of wheat_mills</metric>
    <metric>standard-deviation [assets-change] of wheat_mills</metric>
    <metric>min [assets-change] of wheat_bakers</metric>
    <metric>max [assets-change] of wheat_bakers</metric>
    <metric>mean [assets-change] of wheat_bakers</metric>
    <metric>median [assets-change] of wheat_bakers</metric>
    <metric>standard-deviation [assets-change] of wheat_bakers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [tls-initial] of wheat_farmers</metric>
    <metric>max [tls-initial] of wheat_farmers</metric>
    <metric>mean [tls-initial] of wheat_farmers</metric>
    <metric>median [tls-initial] of wheat_farmers</metric>
    <metric>standard-deviation [tls-initial] of wheat_farmers</metric>
    <metric>min [tls-final] of wheat_farmers</metric>
    <metric>max [tls-final] of wheat_farmers</metric>
    <metric>mean [tls-final] of wheat_farmers</metric>
    <metric>median [tls-final] of wheat_farmers</metric>
    <metric>standard-deviation [tls-final] of wheat_farmers</metric>
    <metric>min [tls-change] of wheat_farmers</metric>
    <metric>max [tls-change] of wheat_farmers</metric>
    <metric>mean [tls-change] of wheat_farmers</metric>
    <metric>median [tls-change] of wheat_farmers</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers</metric>
    <metric>min [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>wheat_CO2-kg-eq-at-farm-model-run</metric>
    <metric>wheat_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>wheat_h2o-m3-at-farm-model-run</metric>
    <metric>wheat_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;organic&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="wheat_snowmass" repetitions="60" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>wheat-hrw-conventional_production-total-model-run</metric>
    <metric>wheat-hrw-organic_production-total-model-run</metric>
    <metric>wheat-snowmass-conventional_production-total-model-run</metric>
    <metric>sum [hectares-farmed-wheat] of wheat_farmers</metric>
    <metric>count wheat_farmers with [fully-organic = 1]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>count wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>count wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>count wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [conventional-proportion] of wheat_farmers</metric>
    <metric>max [conventional-proportion] of wheat_farmers</metric>
    <metric>mean [conventional-proportion] of wheat_farmers</metric>
    <metric>median [conventional-proportion] of wheat_farmers</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers</metric>
    <metric>min [organic-proportion] of wheat_farmers</metric>
    <metric>max [organic-proportion] of wheat_farmers</metric>
    <metric>mean [organic-proportion] of wheat_farmers</metric>
    <metric>median [organic-proportion] of wheat_farmers</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers</metric>
    <metric>min [transition-proportion] of wheat_farmers</metric>
    <metric>max [transition-proportion] of wheat_farmers</metric>
    <metric>mean [transition-proportion] of wheat_farmers</metric>
    <metric>median [transition-proportion] of wheat_farmers</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>min [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>max [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>mean [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>median [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [conventional-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>min [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>max [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>mean [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>median [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [organic-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>min [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>max [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>mean [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>median [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [transition-proportion] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of wheat_farmers</metric>
    <metric>max [assets-change] of wheat_farmers</metric>
    <metric>mean [assets-change] of wheat_farmers</metric>
    <metric>median [assets-change] of wheat_farmers</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers</metric>
    <metric>min [assets-change] of wheat_elevators</metric>
    <metric>max [assets-change] of wheat_elevators</metric>
    <metric>mean [assets-change] of wheat_elevators</metric>
    <metric>median [assets-change] of wheat_elevators</metric>
    <metric>standard-deviation [assets-change] of wheat_elevators</metric>
    <metric>min [assets-change] of wheat_mills</metric>
    <metric>max [assets-change] of wheat_mills</metric>
    <metric>mean [assets-change] of wheat_mills</metric>
    <metric>median [assets-change] of wheat_mills</metric>
    <metric>standard-deviation [assets-change] of wheat_mills</metric>
    <metric>min [assets-change] of wheat_bakers</metric>
    <metric>max [assets-change] of wheat_bakers</metric>
    <metric>mean [assets-change] of wheat_bakers</metric>
    <metric>median [assets-change] of wheat_bakers</metric>
    <metric>standard-deviation [assets-change] of wheat_bakers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>min [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>min [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of wheat_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [tls-initial] of wheat_farmers</metric>
    <metric>max [tls-initial] of wheat_farmers</metric>
    <metric>mean [tls-initial] of wheat_farmers</metric>
    <metric>median [tls-initial] of wheat_farmers</metric>
    <metric>standard-deviation [tls-initial] of wheat_farmers</metric>
    <metric>min [tls-final] of wheat_farmers</metric>
    <metric>max [tls-final] of wheat_farmers</metric>
    <metric>mean [tls-final] of wheat_farmers</metric>
    <metric>median [tls-final] of wheat_farmers</metric>
    <metric>standard-deviation [tls-final] of wheat_farmers</metric>
    <metric>min [tls-change] of wheat_farmers</metric>
    <metric>max [tls-change] of wheat_farmers</metric>
    <metric>mean [tls-change] of wheat_farmers</metric>
    <metric>median [tls-change] of wheat_farmers</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers</metric>
    <metric>min [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of wheat_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>wheat_CO2-kg-eq-at-farm-model-run</metric>
    <metric>wheat_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>wheat_h2o-m3-at-farm-model-run</metric>
    <metric>wheat_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;snowmass&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_baseline_mk0.25" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_fresh-CO_mk0.25" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;fresh-CO&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_gfpp_mk0.25" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;gfpp&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_small-potatoes_mk0.25" repetitions="10" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;small-potatoes&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_specialty-product_mk0.25" repetitions="10" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;specialty-product&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_baseline_mk1.0" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_fresh-CO_mk1.0" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;fresh-CO&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_gfpp_mk1.0" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;gfpp&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_small-potatoes_mk1.0" repetitions="10" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;small-potatoes&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_specialty-product_mk1.0" repetitions="10" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;specialty-product&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_baseline_mk0.0" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_fresh-CO_mk0.0" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;fresh-CO&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_gfpp_mk0.0" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;gfpp&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_small-potatoes_mk0.0" repetitions="30" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;small-potatoes&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_specialty-product_mk0.0" repetitions="30" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;specialty-product&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_baseline_mk0.75" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.75"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_fresh-CO_mk0.75" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;fresh-CO&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.75"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_gfpp_mk0.75" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;gfpp&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.75"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_small-potatoes_mk0.75" repetitions="30" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;small-potatoes&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.75"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_specialty-product_mk0.75" repetitions="30" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [potatoes-russet-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-conventional_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-purple-organic_passthrough-annual] of potato_farmers</metric>
    <metric>sum [potatoes-russet-conventional-small_passthrough-annual] of potato_farmers</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>standard-deviation [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>standard-deviation [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;specialty-product&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.75"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_baseline_x1000_for_DPS" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>count potato_farmers with [fully-organic = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [conventional-proportion] of potato_farmers</metric>
    <metric>max [conventional-proportion] of potato_farmers</metric>
    <metric>mean [conventional-proportion] of potato_farmers</metric>
    <metric>median [conventional-proportion] of potato_farmers</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers</metric>
    <metric>min [organic-proportion] of potato_farmers</metric>
    <metric>max [organic-proportion] of potato_farmers</metric>
    <metric>mean [organic-proportion] of potato_farmers</metric>
    <metric>median [organic-proportion] of potato_farmers</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers</metric>
    <metric>min [transition-proportion] of potato_farmers</metric>
    <metric>max [transition-proportion] of potato_farmers</metric>
    <metric>mean [transition-proportion] of potato_farmers</metric>
    <metric>median [transition-proportion] of potato_farmers</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [tls-initial] of potato_farmers</metric>
    <metric>max [tls-initial] of potato_farmers</metric>
    <metric>mean [tls-initial] of potato_farmers</metric>
    <metric>median [tls-initial] of potato_farmers</metric>
    <metric>standard-deviation [tls-initial] of potato_farmers</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers</metric>
    <metric>max [tls-change] of potato_farmers</metric>
    <metric>mean [tls-change] of potato_farmers</metric>
    <metric>median [tls-change] of potato_farmers</metric>
    <metric>standard-deviation [tls-change] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DPS_x1000?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_fresh-CO_x1000_for_DPS" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>count potato_farmers with [fully-organic = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [conventional-proportion] of potato_farmers</metric>
    <metric>max [conventional-proportion] of potato_farmers</metric>
    <metric>mean [conventional-proportion] of potato_farmers</metric>
    <metric>median [conventional-proportion] of potato_farmers</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers</metric>
    <metric>min [organic-proportion] of potato_farmers</metric>
    <metric>max [organic-proportion] of potato_farmers</metric>
    <metric>mean [organic-proportion] of potato_farmers</metric>
    <metric>median [organic-proportion] of potato_farmers</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers</metric>
    <metric>min [transition-proportion] of potato_farmers</metric>
    <metric>max [transition-proportion] of potato_farmers</metric>
    <metric>mean [transition-proportion] of potato_farmers</metric>
    <metric>median [transition-proportion] of potato_farmers</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [tls-initial] of potato_farmers</metric>
    <metric>max [tls-initial] of potato_farmers</metric>
    <metric>mean [tls-initial] of potato_farmers</metric>
    <metric>median [tls-initial] of potato_farmers</metric>
    <metric>standard-deviation [tls-initial] of potato_farmers</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers</metric>
    <metric>max [tls-change] of potato_farmers</metric>
    <metric>mean [tls-change] of potato_farmers</metric>
    <metric>median [tls-change] of potato_farmers</metric>
    <metric>standard-deviation [tls-change] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;fresh-CO&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DPS_x1000?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_gfpp_x1000_for_DPS" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>count potato_farmers with [fully-organic = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [conventional-proportion] of potato_farmers</metric>
    <metric>max [conventional-proportion] of potato_farmers</metric>
    <metric>mean [conventional-proportion] of potato_farmers</metric>
    <metric>median [conventional-proportion] of potato_farmers</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers</metric>
    <metric>min [organic-proportion] of potato_farmers</metric>
    <metric>max [organic-proportion] of potato_farmers</metric>
    <metric>mean [organic-proportion] of potato_farmers</metric>
    <metric>median [organic-proportion] of potato_farmers</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers</metric>
    <metric>min [transition-proportion] of potato_farmers</metric>
    <metric>max [transition-proportion] of potato_farmers</metric>
    <metric>mean [transition-proportion] of potato_farmers</metric>
    <metric>median [transition-proportion] of potato_farmers</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [tls-initial] of potato_farmers</metric>
    <metric>max [tls-initial] of potato_farmers</metric>
    <metric>mean [tls-initial] of potato_farmers</metric>
    <metric>median [tls-initial] of potato_farmers</metric>
    <metric>standard-deviation [tls-initial] of potato_farmers</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers</metric>
    <metric>max [tls-change] of potato_farmers</metric>
    <metric>mean [tls-change] of potato_farmers</metric>
    <metric>median [tls-change] of potato_farmers</metric>
    <metric>standard-deviation [tls-change] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;gfpp&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DPS_x1000?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_small-potatoes_x1000_for_DPS" repetitions="30" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>count potato_farmers with [fully-organic = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [conventional-proportion] of potato_farmers</metric>
    <metric>max [conventional-proportion] of potato_farmers</metric>
    <metric>mean [conventional-proportion] of potato_farmers</metric>
    <metric>median [conventional-proportion] of potato_farmers</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers</metric>
    <metric>min [organic-proportion] of potato_farmers</metric>
    <metric>max [organic-proportion] of potato_farmers</metric>
    <metric>mean [organic-proportion] of potato_farmers</metric>
    <metric>median [organic-proportion] of potato_farmers</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers</metric>
    <metric>min [transition-proportion] of potato_farmers</metric>
    <metric>max [transition-proportion] of potato_farmers</metric>
    <metric>mean [transition-proportion] of potato_farmers</metric>
    <metric>median [transition-proportion] of potato_farmers</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [tls-initial] of potato_farmers</metric>
    <metric>max [tls-initial] of potato_farmers</metric>
    <metric>mean [tls-initial] of potato_farmers</metric>
    <metric>median [tls-initial] of potato_farmers</metric>
    <metric>standard-deviation [tls-initial] of potato_farmers</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers</metric>
    <metric>max [tls-change] of potato_farmers</metric>
    <metric>mean [tls-change] of potato_farmers</metric>
    <metric>median [tls-change] of potato_farmers</metric>
    <metric>standard-deviation [tls-change] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;small-potatoes&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DPS_x1000?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="potatoes_specialty-product_x1000_for_DPS" repetitions="30" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>potato-model</metric>
    <metric>wheat-model</metric>
    <metric>peach-model</metric>
    <metric>beef-model</metric>
    <metric>potato-scenario</metric>
    <metric>wheat-scenario</metric>
    <metric>peach-scenario</metric>
    <metric>beef-scenario</metric>
    <metric>potato-russet-conventional_production-total-model-run</metric>
    <metric>potato-russet-organic_production-total-model-run</metric>
    <metric>potato-purple-conventional_production-total-model-run</metric>
    <metric>potato-purple-organic_production-total-model-run</metric>
    <metric>sum [hectares-farmed-potatoes] of potato_farmers</metric>
    <metric>count potato_farmers with [fully-organic = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>count potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>count potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [conventional-proportion] of potato_farmers</metric>
    <metric>max [conventional-proportion] of potato_farmers</metric>
    <metric>mean [conventional-proportion] of potato_farmers</metric>
    <metric>median [conventional-proportion] of potato_farmers</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers</metric>
    <metric>min [organic-proportion] of potato_farmers</metric>
    <metric>max [organic-proportion] of potato_farmers</metric>
    <metric>mean [organic-proportion] of potato_farmers</metric>
    <metric>median [organic-proportion] of potato_farmers</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers</metric>
    <metric>min [transition-proportion] of potato_farmers</metric>
    <metric>max [transition-proportion] of potato_farmers</metric>
    <metric>mean [transition-proportion] of potato_farmers</metric>
    <metric>median [transition-proportion] of potato_farmers</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [conventional-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [organic-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [transition-proportion] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers</metric>
    <metric>max [assets-change] of potato_farmers</metric>
    <metric>mean [assets-change] of potato_farmers</metric>
    <metric>median [assets-change] of potato_farmers</metric>
    <metric>standard-deviation [assets-change] of potato_farmers</metric>
    <metric>min [assets-change] of potato_shippers</metric>
    <metric>max [assets-change] of potato_shippers</metric>
    <metric>mean [assets-change] of potato_shippers</metric>
    <metric>median [assets-change] of potato_shippers</metric>
    <metric>standard-deviation [assets-change] of potato_shippers</metric>
    <metric>min [assets-change] of potato_repackers</metric>
    <metric>max [assets-change] of potato_repackers</metric>
    <metric>mean [assets-change] of potato_repackers</metric>
    <metric>median [assets-change] of potato_repackers</metric>
    <metric>standard-deviation [assets-change] of potato_repackers</metric>
    <metric>min [assets-change] of distributors</metric>
    <metric>max [assets-change] of distributors</metric>
    <metric>mean [assets-change] of distributors</metric>
    <metric>median [assets-change] of distributors</metric>
    <metric>min [assets-change] of dps_buyers</metric>
    <metric>max [assets-change] of dps_buyers</metric>
    <metric>mean [assets-change] of dps_buyers</metric>
    <metric>median [assets-change] of dps_buyers</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 0]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and alternative-farmer = 1]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "small"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "medium"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 1 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [fully-organic = 0 and organic-proportion &gt; 0 and farm-size = "large"]</metric>
    <metric>min [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>max [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>mean [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>median [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>standard-deviation [assets-change] of potato_farmers with [organic-proportion = 0 and farm-size = "large"]</metric>
    <metric>min [tls-initial] of potato_farmers</metric>
    <metric>max [tls-initial] of potato_farmers</metric>
    <metric>mean [tls-initial] of potato_farmers</metric>
    <metric>median [tls-initial] of potato_farmers</metric>
    <metric>standard-deviation [tls-initial] of potato_farmers</metric>
    <metric>min [tls-final] of potato_farmers</metric>
    <metric>max [tls-final] of potato_farmers</metric>
    <metric>mean [tls-final] of potato_farmers</metric>
    <metric>median [tls-final] of potato_farmers</metric>
    <metric>standard-deviation [tls-final] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers</metric>
    <metric>max [tls-change] of potato_farmers</metric>
    <metric>mean [tls-change] of potato_farmers</metric>
    <metric>median [tls-change] of potato_farmers</metric>
    <metric>standard-deviation [tls-change] of potato_farmers</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 0 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>max [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>median [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ alternative-farmer = 1 ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "small" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "medium" ]</metric>
    <metric>min [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>max [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>mean [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>median [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>standard-deviation [tls-change] of potato_farmers with [ farm-size = "large" ]</metric>
    <metric>delta-hei-low-income</metric>
    <metric>delta-hei-high-income</metric>
    <metric>potato_CO2-kg-eq-at-farm-model-run</metric>
    <metric>potato_CO2-kg-eq-at-Denver-model-run</metric>
    <metric>potato_h2o-m3-at-farm-model-run</metric>
    <metric>potato_h2o-m3-at-Denver-model-run</metric>
    <enumeratedValueSet variable="wheat-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wheat-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-model">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-scenario">
      <value value="&quot;baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="display-style">
      <value value="&quot;organic vs conventional&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hide-turtles?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peach-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beef-model">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug-mode">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="potato-scenario">
      <value value="&quot;specialty-product&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DPS_x1000?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
