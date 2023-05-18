;using export diff function in this version

extensions [ matrix table GIS ]


;MATRIX NOTES:
;NetLogo's matrix dimensions start with 0!!!
;An entry in row i and column j represents the receipts of account i from account j (columns sell to rows)


__includes [ "wheatMatrixToTableAPI.nls"  "wheatStaticNames.nls"  "wheatContractNegotiation.nls" "wheatContractFulfillment.nls" "wheatResetStorage.nls" ]


globals [

  ; kevin's variables
  county-load
  wheat-patches-load
  wheat-hrw-conventional_mean-load
  wheat-hrw-organic_mean-load
  wheat-snowmass-conventional_mean-load
  wheat-snowmass-organic_mean-load
  wheat-hrw-conventional_load
  wheat-hrw-organic_load
  wheat-snowmass-conventional_load
  wheat-snowmass-organic_load ; all for loading GIS data
  rotation-year

  data-year ;; added to differentiate the year needed for kevin's GIS rasters from the year tracker on the model interface

  total-current-year-wheat-sales

  ;for output to excel
  wheat-hrw-conventional_yield
  wheat-snowmass-conventional_yield
  wheat-hrw-organic_yield
  wheat-snowmass-organic_yield
  wheat-hrw-conventional_value
  wheat-snowmass-conventional_value
  wheat-hrw-organic_value
  wheat-snowmass-organic_value

  output_wheat-hrw-conventional_inventory-current

  mean-wheat-producer-inventory
  sum-wheat-producer-inventory
  mean-wheat-producer-cash
  sum-wheat-producer-cash

  mean-wheat-mill-inventory
  sum-wheat-mill-inventory
  mean-wheat-mill-cash
  sum-wheat-mill-cash

  mean-wheat-elevator-inventory
  sum-wheat-elevator-inventory
  mean-wheat-elevator-cash
  sum-wheat-elevator-cash

  mean-wheat-baker-inventory
  sum-wheat-baker-inventory
  mean-wheat-baker-cash
  sum-wheat-baker-cash

  mean-distributor-inventory
  sum-distributor-inventory
  mean-distributor-cash
  sum-distributor-cash

  mean-school-inventory
  sum-school-inventory
  mean-school-cash
  sum-school-cash


  i
  julian                                                         ;; day in julian year the model is in
  week                                                           ;; week in year the model is in
  year                                                           ;; year the model is in
  max-ticks

  count_wheat-farmers

  wheat_hei
  wheat-conventional-processed_hei


  ;; prices for all wheat varieties (avg and standard deviation) !!! THESE PRICES HAVE NOT BEEN UPDATED FOR WHEAT !!!

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

  ;; buckets for counting

  meals-missed                                                   ;; tally of meals when there wasn't enough food to feed someone (mostly for debugging)
  wheat-outside                                               ;; potatoes sent outside the system (no capacity for them in the model world)
  conventional-spoiled-in-storage                                ;; potatoes left in storage at end of each year, presumed to have spoiled
  organic-spoiled-in-storage
  processed-spoiled-in-storage
  servings-spoiled-in-storage                                       ;; number of servings left at end of year
  school-count

  ;;matrix globals
  contract-price-matrix
  contract-quantity-matrix
  quantity-sent-matrix
  quantity-outstanding-matrix
  projected-income-matrix ; test!

  wheat-table_hrw-conventional                                                   ;; potato contracting tables
  wheat-table_hrw-organic
  wheat-table_snowmass-conventional
  wheat-table_snowmass-organic

  ;; francesco's wizardly integration section
  workspace
  osSeparator
  paramDir
  outputDir
]


breed [wheat_farmers wheat_farmer]
breed [wheat_elevators wheat_elevator]
breed [wheat_mills wheat_mill]                           ;; this was previously named [potato_distributors]
breed [wheat_bakers wheat_baker]
breed [distributors distributor]
breed [schools school]
breed [households household]


patches-own

[
  county-wheat                                                   ;; numerical county id, from raster
  county-wheat-name                                              ;; text name of county
  wheat-yes-no                                                   ;; whether patch grows potatoes
  wheat-hrw-conventional-mean-yield                              ;; from DSSAT, mean potential yield in kg/ha from 38 years
  wheat-hrw-organic-mean-yield                                   ;; from DSSAT, mean potential yield in kg/ha from 38 years
  wheat-snowmass-conventional-mean-yield                         ;; from DSSAT, mean potential yield in kg/ha from 38 years
  wheat-snowmass-organic-mean-yield                               ;; from DSSAT, mean potential yield in kg/ha from 38 years
  wheat-hrw-conventional-current-yield                             ;; from DSSAT, this year's potential yield in kg/ha
  wheat-hrw-organic-current-yield                         ;; from DSSAT, this year's potential yield in kg/ha
  wheat-snowmass-conventional-current-yield                                    ;; from DSSAT, this year's potential yield in kg/ha
  wheat-snowmass-organic-current-yield                                ;; from DSSAT, this year's potential yield in kg/ha
  occupied                                                       ;; whether patch is owned/occupied by a potato farm
  farmer                                                         ;; id of farm that occupies patch
  certified-organic                                              ;; if patch is certified organic
  rotation                                                       ;; if potatoes are currently being grown at all, "potatoes". If only barley, "barley"
  remainder-patch                                                ;; patch that is planted to the remainder of potatoes, e.g. if farm has 250 hectares of potatoes, this patch grows the 50
  organic-conversion-tracker                                     ;; tracks number of years spent converting a patch from conventional to organic use
  in-organic-transition                                          ;; tracks whether or not the patch is in the process of transitioning to organic --> 1 = yes
]


wheat_farmers-own [

  id
  agent-name
  assets
  home-county                                                    ;; home county id of farmer
  hectares-farmed-wheat                                       ;; total hectares farmed in potatoes
  hectares-farmed-total                                          ;; total hectares farmed potatoes and barley
  initialized                                                    ;; whether initialized yet in setup
  patches-occupied                                               ;; how many 100-ha patches farm occupies
  farm-id                                                        ;; unique identifier --> CAN GET RID OF THIS SINCE WE COVER IT IN STEF/ERIN MODEL
  grows-organic                                                  ;; yes/no on whether has certified organic land
  loyalty-to-buyer-id                                            ;; id number of buying agent that farmer prefers to sell to based on loyalty from previous year's relationship

  wheat-hrw-allocation                                       ;; percent of potato production in russet-canela
  wheat-hrw-conventional-current-production                               ;; total of this year's production of potatoes in kg
  wheat-hrw-conventional-current-value                                    ;; value of this year's production of potatoes, based on slider input --> UPDATE WITH ECONOMIC DATA FROM STEF/ERIN MODEL
  wheat-hrw-organic-current-production                           ;; this is what the land produces annually, so we may want to factor in waste at a later step
  wheat-hrw-organic-current-value                                ;; --> UPDATE WITH ECONOMIC DATA FROM STEF/ERIN MODEL
  wheat-snowmass-allocation                                              ;; percent of potato production in purple (farmers currently grow 20% purple)
  wheat-snowmass-conventional-current-production
  wheat-snowmass-conventional-current-value                                           ;; --> UPDATE WITH ECONOMIC DATA FROM STEF/ERIN MODEL
  wheat-snowmass-organic-current-production
  wheat-snowmass-organic-current-value                                       ;; --> UPDATE WITH ECONOMIC DATA FROM STEF/ERIN MODEL
  total-wheat-current-value                                     ;; sum of all potato production ; --> UPDATE WITH ECONOMIC DATA FROM STEF/ERIN MODEL
  patches-in-wheat                                            ;; number of patches needed to grow potatoes based on hectares of potatoes they grow- for rotation
  patches-in-rotation                                            ;; number of patches (if any) that may be entirely planted to barley in rotation (otherwise rotation is internal to patches for smaller operations, and yield doesn't change

  wheat-hrw-conventional_inventory-current           ;; total inventory (in pounds) of conventional russet potatoes
  wheat-hrw-conventional_inventory-maximum
  ;; --------------------------------------
  ;; WHEAT VARIABLE RENAMING STOPPED HERE
  ;; --------------------------------------
  wheat-hrw-conventional_price-to-sell
  wheat-farmers_yield-estimated_hrw-conventional
  wheat-hrw-conventional-promised                    ;; how many potatoes of this type have been contracted away (to compare against how many are available, so the agent doesn't promise more than it has)

  wheat-hrw-organic_inventory-current                ;; total inventory (in pounds) of organic russet potatoes
  wheat-hrw-organic_inventory-maximum
  wheat-hrw-organic_price-to-sell
  wheat-farmers_yield-estimated_hrw-organic
  wheat-hrw-organic-promised

  wheat-snowmass-conventional_inventory-current           ;; total inventory (in pounds) of conventional purple potatoes
  wheat-snowmass-conventional_inventory-maximum
  wheat-snowmass-conventional_price-to-sell
  wheat-farmers_yield-estimated_snowmass-conventional
  wheat-snowmass-conventional-promised

  wheat-snowmass-organic_inventory-current                ;; total inventory (in pounds) of organic purple potatoes
  wheat-snowmass-organic_inventory-maximum
  wheat-snowmass-organic_price-to-sell
  wheat-farmers_yield-estimated_snowmass-organic
  wheat-snowmass-organic-promised

; test variables for social stuff with james
  risk-aversion
  male-gender
  first-time-farmer
  young-farmer
  not-white
  primary-income

  ]


wheat_elevators-own [

  id
  agent-name
  assets
  loyalty-to-buyer-id                                            ;; id number of buying agent that elevator prefers to sell to based on loyalty from previous year's relationship

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

  wheat-snowmass-organic_inventory-current
  wheat-snowmass-organic_inventory-maximum
  wheat-snowmass-organic_price-to-buy
  wheat-snowmass-organic_price-to-sell
  wheat-snowmass-organic_contract-space-available
  wheat-snowmass-organic-promised
  wheat-snowmass-organic_my-incoming-total

  ]


wheat_mills-own [

  id
  agent-name
  assets
  loyalty-to-buyer-id                                            ;; id number of buying agent that mill prefers to sell to based on loyalty from previous year's relationship

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

  wheat-snowmass-organic_inventory-current
  wheat-snowmass-organic_inventory-maximum
  wheat-snowmass-organic_price-to-buy
  wheat-snowmass-organic_price-to-sell
  wheat-snowmass-organic_contract-space-available
  wheat-snowmass-organic-promised
  wheat-snowmass-organic_my-incoming-total

  contract-short-inventory

  ]


wheat_bakers-own[

  id
  agent-name
  assets
  loyalty-to-buyer-id                                            ;; id number of buying agent that baker prefers to sell to based on loyalty from previous year's relationship

  wheat-hrw-conventional_inventory-current
  wheat-hrw-conventional_inventory-maximum
  wheat-hrw-conventional_price-to-buy
  wheat-hrw-conventional_contract-space-available
  wheat-hrw-conventional_my-incoming-total

  wheat-hrw-organic_inventory-current
  wheat-hrw-organic_inventory-maximum
  wheat-hrw-organic_price-to-buy
  wheat-hrw-organic_contract-space-available
  wheat-hrw-organic_my-incoming-total

  wheat-snowmass-conventional_inventory-current
  wheat-snowmass-conventional_inventory-maximum
  wheat-snowmass-conventional_price-to-buy
  wheat-snowmass-conventional_contract-space-available
  wheat-snowmass-conventional_my-incoming-total

  wheat-snowmass-organic_inventory-current
  wheat-snowmass-organic_inventory-maximum
  wheat-snowmass-organic_price-to-buy
  wheat-snowmass-organic_contract-space-available
  wheat-snowmass-organic_my-incoming-total

  bun-hrw-conventional_inventory-current
  bun-hrw-conventional_inventory-maximum
  bun-hrw-conventional_price-to-sell
  bun-hrw-conventional_contract-space-available
  bun-hrw-conventional-promised
  bun-hrw-conventional_my-incoming-total

  bun-hrw-organic_inventory-current
  bun-hrw-organic_inventory-maximum
  bun-hrw-organic_price-to-buy
  bun-hrw-organic_price-to-sell
  bun-hrw-organic_contract-space-available
  bun-hrw-organic-promised
  bun-hrw-organic_my-incoming-total

  flour-snowmass-conventional_inventory-current
  flour-snowmass-conventional_inventory-maximum
  flour-snowmass-conventional_price-to-buy
  flour-snowmass-conventional_price-to-sell
  flour-snowmass-conventional_contract-space-available
  flour-snowmass-conventional-promised
  flour-snowmass-conventional_my-incoming-total

  ]


distributors-own [

  id
  agent-name
  assets
  loyalty-to-buyer-id                                            ;; id number of buying agent that distributor prefers to sell to based on loyalty from previous year's relationship

  out-of-state-french-fry_inventory-current
  out-of-state-french-fry_price-to-buy
  out-of-state-french-fry_price-to-sell

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

  wheat-snowmass-organic_inventory-current
  wheat-snowmass-organic_inventory-maximum
  wheat-snowmass-organic_price-to-buy
  wheat-snowmass-organic_price-to-sell
  wheat-snowmass-organic_contract-space-available
  wheat-snowmass-organic-promised
  wheat-snowmass-organic_my-incoming-total

  bun-hrw-conventional_inventory-current
  bun-hrw-conventional_inventory-maximum
  bun-hrw-conventional_price-to-buy
  bun-hrw-conventional_price-to-sell
  bun-hrw-conventional_contract-space-available
  bun-hrw-conventional-promised
  bun-hrw-conventional_my-incoming-total

  bun-hrw-organic_inventory-current
  bun-hrw-organic_inventory-maximum
  bun-hrw-organic_price-to-buy
  bun-hrw-organic_price-to-sell
  bun-hrw-organic_contract-space-available
  bun-hrw-organic-promised
  bun-hrw-organic_my-incoming-total

  flour-snowmass-conventional_inventory-current
  flour-snowmass-conventional_inventory-maximum
  flour-snowmass-conventional_price-to-buy
  flour-snowmass-conventional_price-to-sell
  flour-snowmass-conventional_contract-space-available
  flour-snowmass-conventional-promised
  flour-snowmass-conventional_my-incoming-total

 ]


schools-own [

  id
  agent-name
  school-type
  assets
  loyalty-to-seller-id                                            ;; id number of selling agent that school prefers to buy from based on loyalty from previous year's relationship

  out-of-state-french-fry_inventory-current
  out-of-state-french-fry_inventory-maximum
  out-of-state-french-fry_price-to-buy

  wheat-hrw-conventional_inventory-current
  wheat-hrw-conventional_inventory-maximum
  wheat-hrw-conventional_price-to-buy
  wheat-hrw-conventional_contract-space-available
  wheat-hrw-conventional_my-incoming-total

  wheat-hrw-organic_inventory-current
  wheat-hrw-organic_inventory-maximum
  wheat-hrw-organic_price-to-buy
  wheat-hrw-organic_contract-space-available
  wheat-hrw-organic_my-incoming-total

  wheat-snowmass-conventional_inventory-current
  wheat-snowmass-conventional_inventory-maximum
  wheat-snowmass-conventional_price-to-buy
  wheat-snowmass-conventional_contract-space-available
  wheat-snowmass-conventional_my-incoming-total

  wheat-snowmass-organic_inventory-current
  wheat-snowmass-organic_inventory-maximum
  wheat-snowmass-organic_price-to-buy
  wheat-snowmass-organic_contract-space-available
  wheat-snowmass-organic_my-incoming-total

  bun-hrw-conventional_inventory-current
  bun-hrw-conventional_inventory-maximum
  bun-hrw-conventional_price-to-buy
  bun-hrw-conventional_contract-space-available
  bun-hrw-conventional_my-incoming-total

  bun-hrw-organic_inventory-current
  bun-hrw-organic_inventory-maximum
  bun-hrw-organic_price-to-buy
  bun-hrw-organic_contract-space-available
  bun-hrw-organic_my-incoming-total

  flour-snowmass-conventional_inventory-current
  flour-snowmass-conventional_inventory-maximum
  flour-snowmass-conventional_price-to-buy
  flour-snowmass-conventional_contract-space-available
  flour-snowmass-conventional_my-incoming-total

  wheat-hrw-conventional_servings                    ;; current inventory of fresh russet conventional potatoes (in individual servings)
  bun-hrw-conventional_servings                ;; current inventory of processed russet conventional potatoes (in individual servings)
  wheat-hrw-organic_servings                         ;; current inventory of fresh russet organic potatoes (in individual servings)
  bun-hrw-organic_servings                     ;; current inventory of processed russet organic potatoes (in individual servings)
  wheat-snowmass-conventional_servings                    ;; current inventory of fresh purple conventional potatoes (in individual servings)
  flour-snowmass-conventional_servings                ;; current inventory of processed purple conventional potatoes (in individual servings)
  wheat-snowmass-organic_servings                         ;; current inventory of fresh purple organic potatoes (in individual servings)
  flour-snowmass-organic_servings                     ;; current inventory of processed purple organic potatoes (in individual servings)

 ]


households-own [

  id
  agent-name
  school-id                                                    ;; value to link a household with a particular school so they eat at the same school each week
  household-size                                               ;; number of poeple in this household
  home-xcor                                                    ;; home x-coordinate
  home-ycor                                                    ;; home y-coordinate
  hei-baseline                                                 ;; household hei at the start of the model run (based on range from foodaps data)
  hei-updated                                                  ;; updated hei based on eating habits within the model
  hei-delta                                                    ;; change in hei from baseline to updated
  student_count                                                ;; number of students in the household
  breakfast_total-needed                                       ;; total breakfasts this household requires each week (based on range from foodaps data)
  lunch_total-needed                                           ;; total lunches this household requires each week (based on range from foodaps data)
  meals_total-needed                                           ;; total meals this household requires each week

  ]


;to setup-matrix
;
;  set contract-price-matrix matrix:make-constant ( max-one-of turtles [ who ] ) ( max-one-of turtles [ who ] ) 0   ;will need to reference contracted amounts, max capacity, and historical averages when setting contracts
;  set contract-quantity-matrix matrix:make-constant ( max-one-of turtles [ who ] ) ( max-one-of turtles [ who ] )) 0
;  set quantity-sent-matrix matrix:make-constant ( max-one-of turtles [ who ] ) ( max-one-of turtles [ who ] ) 0
;  set quantity-outstanding-matrix matrix:minus contract-quantity-matrix quantity-sent-matrix
;
;end


to setup

;  random-seed 666
  clear-all
  reset-ticks
  resize-world 0 139 0 123
  set-patch-size 5
  setup-start-dates
  setup-gis-landscape
  setup-static-names
  setup-parameters
  setup-wheat_farmers
  setup-certified-organic
  setup-display
  setup-output-lists
  setup-wheat_elevators
  setup-wheat_mills
  setup-wheat_bakers
  setup-distributors
  setup-schools
  setup-households
  setup-wheat-farm-crop-allocation
  setup-estimated-yields
  set wheat-table_hrw-conventional table:make
  set wheat-table_hrw-organic table:make
  set wheat-table_snowmass-conventional table:make
  set wheat-table_snowmass-organic table:make
;  setup-matrix
;  if debug-mode = TRUE [ setup-matrix ]
  set wheat_hei 25                                     ;; per https://epi.grants.cancer.gov/hei/developing.html vegetables are worth a max of 5 points if ≥1.1 cup equiv. per 1,000 kcal
  set wheat-conventional-processed_hei 0                     ;; per https://epi.grants.cancer.gov/hei/developing.html empty calories are worth a max of 20 points if held to less than 19% of total energy --> a score of zero is earned if empty calories are over 50% of total energy --> i've estiamted a processed potato to be very unhealthy, and given it 0 points from this category
  set max-ticks (52 * years-in-model-run)
end


to setup-start-dates

  set year 1
  set week 30

end


;************************
;   SETUP GIS LANDSCAPE
;************************
to setup-gis-landscape

  set county-load gis:load-dataset "slv_counties.asc"; load county name and outside counties
  set wheat-patches-load gis:load-dataset "potato_patches.asc"; load patches where potato production occurred any year 2011-2017 re: Colorado DNR Water Resource Division. Compared against DSSAT, removed <10 patches
  set wheat-hrw-conventional_mean-load gis:load-dataset "mean_canela.asc"; load mean canela russet yield 1980-2018 DSSAT, kgs per ha
  set wheat-hrw-organic_mean-load gis:load-dataset "mean_canela_org.asc"
  set wheat-snowmass-conventional_mean-load gis:load-dataset "mean_purple.asc" ; load mean purple yield 1980-2018 DSSAT, kgs per ha
  set wheat-snowmass-organic_mean-load gis:load-dataset "mean_purple_org.asc"
  gis:set-world-envelope-ds gis:envelope-of county-load
  gis:apply-raster county-load county-wheat
  gis:apply-raster wheat-patches-load wheat-yes-no
  gis:apply-raster wheat-hrw-conventional_mean-load wheat-hrw-conventional-mean-yield
  gis:apply-raster wheat-hrw-organic_mean-load wheat-hrw-organic-mean-yield
  gis:apply-raster wheat-snowmass-conventional_mean-load wheat-snowmass-conventional-mean-yield
  gis:apply-raster wheat-snowmass-organic_mean-load wheat-snowmass-organic-mean-yield

  ask patches with [wheat-yes-no = 1]
  [if county-wheat = 4 [set wheat-yes-no 0]]; fix couple of patches that fall outside border (right on border but resolution puts them outside)

ask patches
  [
    if county-wheat = 1 [set pcolor 47 set county-wheat-name "Alamosa"]
    if county-wheat = 2 [set pcolor 57 set county-wheat-name "Rio Grande"]
    if county-wheat = 3 [set pcolor 87 set county-wheat-name "Saguache"]
    if county-wheat = 4 [set pcolor 9.9 set county-wheat-name "NA"]
    if wheat-yes-no = 1 [set pcolor black]
    if pycor = 0 [set pcolor 9.9]
  ]

end


;SETUP PARAMETERS
to setup-parameters

  ; setting sd for all at 0.04 which is what stdev was for most steps in supply chain in wheat yearbook dataset

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

  set wheat-hrw-organic-flour_price-distributor-receives-avg 0.37   ;there was controversy about this price (check with Meagan/James)
  set wheat-hrw-organic-flour_price-distributor-receives-stdev 0.04

  set wheat-snowmass-conventional-flour_price-distributor-receives-avg 0.5153
  set wheat-snowmass-conventional-flour_price-distributor-receives-stdev 0.04

  set wheat-hrw-conventional-bread_price-distributor-receives-avg 0.793
  set wheat-hrw-conventional-bread_price-distributor-receives-stdev 0.04

  set wheat-hrw-organic-bread_price-distributor-receives-avg 3.11
  set wheat-hrw-organic-bread_price-distributor-receives-stdev 0.04

  set wheat-snowmass-conventional-bread_price-distributor-receives-avg 1.703
  set wheat-snowmass-conventional-bread_price-distributor-receives-stdev 0.04

  set school-count 207

end


to setup-wheat_farmers

  ;; -------------------------------------------------

  ;; initialize potato producers by county

  create-wheat_farmers 26; Alamosa County
  [
    set home-county 1
    set initialized 0
    set id who
    set agent-name word "Alamosa wheat farmer " id
  ]

    ask n-of 5 wheat_farmers with [initialized = 0]; set parameters for farms farming between 100 and 250 acres of potatoes per year
     [
      set hectares-farmed-wheat random-normal 175 25 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
     ]
    ask n-of 11 wheat_farmers with [initialized = 0]; set parameters for farms farming between 250 and 500 acres of potatoes per year
     [
      set hectares-farmed-wheat random-normal 375 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
     ]
    ask n-of 3 wheat_farmers with [initialized = 0]; set parameters for farms farming between 500 and 750 acres of potatoes per year
     [
      set hectares-farmed-wheat random-normal 625 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
     ]
    ask n-of 3 wheat_farmers with [initialized = 0]; set parameters for farms farming between 750 and 1000 acres of potatoes per year
     [
      set hectares-farmed-wheat random-normal 875 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
     ]
    ask n-of 4 wheat_farmers with [initialized = 0]; set parameters for farms farming >1000 acres
     [
      set hectares-farmed-wheat random-normal 1601 100 * 0.405 ; assign acreage and convert to hectares of potatoes per year
      set initialized 1
     ]

  create-wheat_farmers 41; Rio Grande County
  [
    set home-county 2
    set initialized 0
    set id who
    set agent-name word "Rio Grande wheat farmer " id
  ]

  ask n-of 21 wheat_farmers with [initialized = 0]; set parameters for farms farming between 100 and 250 acres of potatoes per year
     [
      set hectares-farmed-wheat random-normal 175 25 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
     ]
    ask n-of 10 wheat_farmers with [initialized = 0]; set parameters for farms farming between 250 and 500 acres of potatoes per year
     [
      set hectares-farmed-wheat random-normal 375 41.67 * 0.405 ; assign acreage and convert to hectares
      set hectares-farmed-total hectares-farmed-wheat * 2; allows for simple 1:1 rotation with barley
      set initialized 1
     ]
    ask n-of 4 wheat_farmers with [initialized = 0]; set parameters for farms farming between 500 and 750 acres of potatoes per year
     [
      set hectares-farmed-wheat random-normal 625 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
     ]
    ask n-of 3 wheat_farmers with [initialized = 0]; set parameters for farms farming between 750 and 1000 acres of potatoes per year
     [
      set hectares-farmed-wheat random-normal 875 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
     ]
    ask n-of 3 wheat_farmers with [initialized = 0]; set parameters for farms farming >1000 acres of potatoes per year
     [
      set hectares-farmed-wheat random-normal 1561 100 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
     ]

create-wheat_farmers 29; Saguache County
  [
    set home-county 3
    set initialized 0
    set id who
    set agent-name word "Saguache wheat farmer " id
  ]

  ask n-of 11 wheat_farmers with [initialized = 0]; set parameters for farms farming between 100 and 250 acres of potatoes per year
     [
      set hectares-farmed-wheat random-normal 175 25 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
     ]
    ask n-of 9 wheat_farmers with [initialized = 0]; set parameters for farms farming between 250 and 500 acres of potatoes per year
     [
      set hectares-farmed-wheat random-normal 375 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
     ]
    ask n-of 3 wheat_farmers with [initialized = 0]; set parameters for farms farming between 500 and 750 acres of potatoes per year
     [
      set hectares-farmed-wheat random-normal 625 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
     ]
    ask n-of 3 wheat_farmers with [initialized = 0]; set parameters for farms farming between 750 and 1000 acres of potatoes per year
     [
      set hectares-farmed-wheat random-normal 875 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
     ]
    ask n-of 3 wheat_farmers with [initialized = 0]; set parameters for farms farming >1000 acres of potatoes per year
     [
      set hectares-farmed-wheat random-normal 2255 100 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
     ]

  ;; -------------------------------------------------

  ;; set general potato producer variables

  ask wheat_farmers
  [
    set assets 10000 ; probably need to make this starting amount more realistic
    set loyalty-to-buyer-id 0
    set wheat-hrw-conventional_inventory-maximum 450000000
    set wheat-hrw-conventional_price-to-sell precision (random-normal wheat-hrw-conventional_price-farmgate-avg wheat-hrw-conventional_price-farmgate-stdev)  3  ; do we need to update this price variable every season?
    set hectares-farmed-wheat round hectares-farmed-wheat
    set hectares-farmed-total hectares-farmed-wheat * 1.5; allows for simple 2:1 rotation with potato:barley
    set farm-id who + 1
    set color green
    set shape "circle"
    set size 0.5
    set patches-occupied round (hectares-farmed-total / 100 - 0.5) + 1 ; results in number of patches owned equal to rounded up to next highest hundred hectares / 100
    move-to one-of patches with [county-wheat = [home-county] of myself] with [wheat-yes-no = 1]
    ask min-n-of (patches-occupied) patches with [wheat-yes-no = 1] with [occupied = 0] [distance myself]; settling on correct number of patches-
    ; Note- I removed the requirement to only settle land in the home county as in about one out of ten Setup instances Saguache would fill up and throw an error. Because they
    ; are starting from their home county, they will tend to settle there, but if they are close to the border they may cross over. I think this is fine and actually more realistic
    [
      set occupied 1
      set farmer [farm-id] of myself
      set pcolor farmer
    ]
    move-to one-of patches with [farmer = [farm-id] of myself]; farm moves to a patch it occupies
  ]

  ;; -------------------------------------------------

  ;; set potato producer demographics: calculations in "2020-08-01 wheat farmer demographics.txt"

  ;; alamosa county
  ask n-of 16 wheat_farmers with [ home-county = 1 ] [ set male-gender 1 ]
  ask n-of 7 wheat_farmers with [ home-county = 1 ] [ set first-time-farmer 1 ]
  ask n-of 2 wheat_farmers with [ home-county = 1 ] [ set young-farmer 1 ]
  ask n-of 3 wheat_farmers with [ home-county = 1 ] [ set not-white 1 ]
  ask n-of 13 wheat_farmers with [ home-county = 1 ] [ set primary-income 1 ]

  ;; rio grande county
  ask n-of 27 wheat_farmers with [ home-county = 2 ] [ set male-gender 1 ]
  ask n-of 11 wheat_farmers with [ home-county = 2 ] [ set first-time-farmer 1 ]
  ask n-of 7 wheat_farmers with [ home-county = 2 ] [ set young-farmer 1 ]
  ask n-of 3 wheat_farmers with [ home-county = 2 ] [ set not-white 1 ]
  ask n-of 25 wheat_farmers with [ home-county = 2 ] [ set primary-income 1 ]

  ;; saguache county
  ask n-of 19 wheat_farmers with [ home-county = 3 ] [ set male-gender 1 ]
  ask n-of 7 wheat_farmers with [ home-county = 3 ] [ set first-time-farmer 1 ]
  ask n-of 2 wheat_farmers with [ home-county = 3 ] [ set young-farmer 1 ]
  ask n-of 3 wheat_farmers with [ home-county = 3 ] [ set not-white 1 ]
  ask n-of 21 wheat_farmers with [ home-county = 3 ] [ set primary-income 1 ]

  ;; -------------------------------------------------

  ;; test sub-procedure for adding farmer risk tolerance
  ;; risk aversion is set from 0 - 1 --> 1 is LEAST tolerant of risk (assume smaller farms are more willing to take risks)
  ;; factors that currently increase risk aversion: male-gender, not-white

  ask wheat_farmers [
    let max-farm max-one-of wheat_farmers [ hectares-farmed-wheat ]
    let max-farm-hectares [ hectares-farmed-wheat ] of max-farm
    set risk-aversion ( hectares-farmed-wheat / max-farm-hectares )
    if male-gender = 1 [
      set risk-aversion ( risk-aversion * 1.1 ) ]
    if first-time-farmer = 0 [
      set risk-aversion ( risk-aversion * 1.1 ) ]
    if young-farmer = 0 [
      set risk-aversion ( risk-aversion * 1.1 ) ]
    if not-white = 1 [
      set risk-aversion ( risk-aversion * 1.1 )
    if risk-aversion > 1 [
      set risk-aversion 1 ]
    ]
  ]

  ;; -------------------------------------------------

  ; initialize crop rotations

  ask wheat_farmers
  [
    set patches-in-wheat round (hectares-farmed-wheat / 100 + 0.5)
    set patches-in-rotation patches-occupied - patches-in-wheat
    ifelse patches-in-rotation > 0
     [
       ask n-of patches-in-wheat patches with [farmer = [farm-id] of myself]
         [set rotation "wheat"]
      ask patches with [farmer = [farm-id] of myself] with [rotation = 0]
         [set rotation "barley"]
    ]
    [
      ask patches with [farmer = [farm-id] of myself]
          [set rotation "wheat"]
    ]
    ask one-of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
          [set remainder-patch 1]  ; need to identify which patch grows less then 100 ha of potatoes and catches the remainder
  ]
  set rotation-year 1 ; first year of rotation is set as of above, 3-year cycle


  set count_wheat-farmers count wheat_farmers

end


;*************************
; SETUP CERTIFIED ORGANIC
; ************************
to setup-certified-organic

  ask n-of (0.007 * round count patches with [occupied = 1]) patches with [occupied = 1]; updated based on erin math
  [set certified-organic 1]
  ask wheat_farmers
  [
  ifelse sum [certified-organic] of patches with [farmer = [farm-id] of myself] > 0 ; set turtle variable to identify whether potato-farm has any cert. organic land
  [set grows-organic 1]
  [set grows-organic 0]
  ]

end


to setup-display

  if display-style = "farm ownership"
  [
    ask patches with [ occupied = 1 ]
    [ set pcolor farmer ]
  ]

  if display-style = "wheat vs barley rotation"
  [
    ask patches with [ rotation = "barley" ] [ set pcolor 125 ]
    ask patches with [ rotation = "wheat" ] [ set pcolor 34 ]
  ]

  if display-style = "organic vs conventional"
  [
    ask patches with [ county-wheat = 1] [
      set pcolor 109 ]
    ask patches with [ county-wheat = 2] [
      set pcolor 19 ]
    ask patches with [ county-wheat = 3] [
      set pcolor 69 ]
    ask patches with [ occupied = 1 ] [
      if certified-organic = 0 [ set pcolor 36 ]
      if in-organic-transition = 1 [ set pcolor 56 ]
      if certified-organic = 1 [ set pcolor 62 ] ]
  ]

end


;*************************
; SETUP OUTPUT LISTS
; ************************
to setup-output-lists

;  set wheat-hrw-conventional_yield 0
;  set wheat-snowmass-conventional_yield 0
;  set wheat-hrw-organic_yield 0
;  set wheat-snowmass-organic_yield 0
;  set wheat-hrw-conventional_value 0
;  set wheat-snowmass-conventional_value 0
;  set wheat-hrw-organic_value 0
;  set wheat-snowmass-organic_value 0
;  set output_wheat-hrw-conventional_inventory-current 0

;  set mean-wheat-producer-inventory-2yr []
;  set sum-wheat-producer-inventory-2yr []
;  set mean-wheat-producer-cash-2yr []
;  set sum-wheat-producer-cash-2yr []
;
;  set mean-wheat-mill-inventory-2yr []
;  set sum-wheat-mill-inventory-2yr []
;  set mean-wheat-mill-cash-2yr []
;  set sum-wheat-mill-cash-2yr []
;
;  set mean-wheat-elevator-inventory-2yr []
;  set sum-wheat-elevator-inventory-2yr []
;  set mean-wheat-elevator-cash-2yr []
;  set sum-wheat-elevator-cash-2yr []
;
;  set mean-wheat-baker-inventory-2yr []
;  set sum-wheat-baker-inventory-2yr []
;  set mean-wheat-baker-cash-2yr []
;  set sum-wheat-baker-cash-2yr []
;
;  set mean-distributor-inventory-2yr []
;  set sum-distributor-inventory-2yr []
;  set mean-distributor-cash-2yr []
;  set sum-distributor-cash-2yr []
;
;  set mean-school-inventory-2yr []
;  set sum-school-inventory-2yr []
;  set mean-school-cash-2yr []
;  set sum-school-cash-2yr []

end


to setup-wheat_elevators

  create-wheat_elevators number-wheat_elevators
  [
    set heading 0
    setxy random max-pxcor random max-pycor
    set shape "house"
    set size 2
    set color pink
    set id who
    set agent-name word "elevator " who
    set assets 10000

    set wheat-hrw-conventional_inventory-maximum 1000000000000
    set wheat-hrw-organic_inventory-maximum 1000000000000
    set wheat-snowmass-conventional_inventory-maximum 1000000000000
    set wheat-snowmass-organic_inventory-maximum 1000000000000

    set wheat-hrw-conventional_price-to-buy precision ( random-normal wheat-hrw-conventional_price-farmgate-avg wheat-hrw-conventional_price-farmgate-stdev ) 2
    if wheat-hrw-conventional_price-to-buy < conv-input-price-per-lb [ set wheat-hrw-conventional_price-to-buy conv-input-price-per-lb ]

    if debug-mode = TRUE [
      print "elevator conventional russet price to buy"
      print wheat-hrw-conventional_price-to-buy ]

    if hide-turtles? = TRUE [ ht ]
    ]

end


to setup-wheat_mills

  create-wheat_mills number-wheat_mills
  [
    set heading 0
    setxy random max-pxcor random max-pycor
    set shape "house"
    set size 2
    set color blue
    set id who
    set agent-name word "mill " id
    set assets 10000

    set wheat-hrw-conventional_inventory-maximum random-normal 20000000 3000000
    set wheat-hrw-organic_inventory-maximum random-normal 20000000 3000000
    set wheat-snowmass-conventional_inventory-maximum random-normal 20000000 3000000
    set wheat-snowmass-organic_inventory-maximum random-normal 20000000 3000000

    set wheat-hrw-conventional_price-to-buy precision ( random-normal wheat-hrw-conventional_price-farmgate-avg wheat-hrw-conventional_price-farmgate-stdev ) 2
    if wheat-hrw-conventional_price-to-buy < conv-input-price-per-lb [ set wheat-hrw-conventional_price-to-buy conv-input-price-per-lb ]

    if debug-mode = TRUE [
      print "mill conventional russet price to buy"
      print wheat-hrw-conventional_price-to-buy ]

    if hide-turtles? = TRUE [ ht ]
    ]

end


to setup-wheat_bakers

  create-wheat_bakers number-wheat_bakers
  [
    set heading 0
    setxy random max-pxcor random max-pycor
    set shape "house"
    set size 2
    set color orange
    set id who
    set agent-name word "baker " id
    set assets 10000

    set wheat-hrw-conventional_inventory-maximum 200000000
    set bun-hrw-conventional_inventory-maximum 200000000
    set wheat-hrw-organic_inventory-maximum 200000000
    set wheat-snowmass-conventional_inventory-maximum 200000000
    set flour-snowmass-conventional_inventory-maximum 200000000
    set wheat-snowmass-organic_inventory-maximum 200000000
    set bun-hrw-organic_inventory-maximum 200000000

    set wheat-hrw-conventional_price-to-buy precision (random-normal wheat-hrw-conventional-flour_price-mill-receives-avg wheat-hrw-conventional-flour_price-mill-receives-stdev) 2
    if wheat-hrw-conventional_price-to-buy < wheat-hrw-conventional_price-farmgate-avg [ set wheat-hrw-conventional_price-to-buy wheat-hrw-conventional_price-farmgate-avg ]

    if debug-mode = TRUE [
     print "baker conventional russet fresh price to buy"
     print wheat-hrw-conventional_price-to-buy ]

    if hide-turtles? = TRUE [ ht ]
  ]

end


to setup-distributors

  set-default-shape distributors "house"
  create-distributors number-distributors
  [
    setxy random max-pxcor random max-pycor
    set size 2
    set color green
    set id who
    set agent-name word "distributor " id
    set assets 10000

    set wheat-hrw-conventional_inventory-maximum 1000000000000
    set bun-hrw-conventional_inventory-maximum 1000000000000
    set wheat-hrw-organic_inventory-maximum 1000000000000
    set wheat-snowmass-conventional_inventory-maximum 1000000000000
    set flour-snowmass-conventional_inventory-maximum 1000000000000
    set wheat-snowmass-organic_inventory-maximum 1000000000000
    set bun-hrw-organic_inventory-maximum 1000000000000

    set wheat-hrw-conventional_price-to-buy precision ( random-normal wheat-hrw-conventional-flour_price-mill-receives-avg wheat-hrw-conventional-flour_price-mill-receives-stdev ) 2
    if wheat-hrw-conventional_price-to-buy < wheat-hrw-conventional_price-farmgate-avg [ set wheat-hrw-conventional_price-to-buy wheat-hrw-conventional_price-farmgate-avg ]

    set bun-hrw-conventional_price-to-buy precision ( ( random-normal wheat-hrw-conventional_price-baker-receives-avg wheat-hrw-conventional_price-baker-receives-stdev ) * 1.6 ) 2
    if bun-hrw-conventional_price-to-buy < ( wheat-hrw-conventional_price-mill-receives-avg * 1.25 ) [ set bun-hrw-conventional_price-to-buy ( wheat-hrw-conventional_price-mill-receives-avg * 1.25 ) ]

    if debug-mode = TRUE [
      print "distributor conventional russet fresh price to buy"
      print wheat-hrw-conventional_price-to-buy ]

    if hide-turtles? = TRUE [ ht ]
   ]

end


to setup-schools

  set-default-shape schools "house"

  ;; create elementary schools
  create-schools 117
  [
    set school-type "elementary"
    setxy random max-pxcor random max-pycor                        ;; in order for this to work correctly, the origin of the netlogo display must be set at the corner
    set size 2
;    set color red
    set id who
    set agent-name word "school " id
    set assets 10000

    set wheat-hrw-conventional_inventory-maximum 10
    set bun-hrw-conventional_inventory-maximum 10
    set wheat-hrw-organic_inventory-maximum 10
    set wheat-snowmass-conventional_inventory-maximum 10
    set flour-snowmass-conventional_inventory-maximum 10
    set wheat-snowmass-organic_inventory-maximum 10
    set bun-hrw-organic_inventory-maximum 10

    if debug-mode = TRUE [
      print "school conventional russet fresh price to buy"
      print wheat-hrw-conventional_price-to-buy ]

    if hide-turtles? = TRUE [ ht ]
  ]

  ;; create middle schools
  create-schools 33
  [
    set school-type "middle"
    setxy random max-pxcor random max-pycor                        ;; in order for this to work correctly, the origin of the netlogo display must be set at the corner
    set size 2
;    set color red
    set id who
    set agent-name word "school " id
    set assets 10000

    set wheat-hrw-conventional_inventory-maximum 10
    set bun-hrw-conventional_inventory-maximum 10
    set wheat-hrw-organic_inventory-maximum 10
    set wheat-snowmass-conventional_inventory-maximum 10
    set flour-snowmass-conventional_inventory-maximum 10
    set wheat-snowmass-organic_inventory-maximum 10
    set bun-hrw-organic_inventory-maximum 10

    if debug-mode = TRUE [
      print "school conventional russet fresh price to buy"
      print wheat-hrw-conventional_price-to-buy ]

    if hide-turtles? = TRUE [ ht ]
  ]

  ;; create high schools
  create-schools 57
  [
    set school-type "high"
    setxy random max-pxcor random max-pycor                        ;; in order for this to work correctly, the origin of the netlogo display must be set at the corner
    set size 2
;    set color red
    set id who
    set agent-name word "school " id
    set assets 10000

    set wheat-hrw-conventional_inventory-maximum 10
    set bun-hrw-conventional_inventory-maximum 10
    set wheat-hrw-organic_inventory-maximum 10
    set wheat-snowmass-conventional_inventory-maximum 10
    set flour-snowmass-conventional_inventory-maximum 10
    set wheat-snowmass-organic_inventory-maximum 10
    set bun-hrw-organic_inventory-maximum 10

     if debug-mode = TRUE [
       print "school conventional russet fresh price to buy"
       print wheat-hrw-conventional_price-to-buy ]

    if hide-turtles? = TRUE [ ht ]
  ]


  ask schools [
   set wheat-hrw-conventional_price-to-buy precision ( random-normal wheat-hrw-conventional_price-distributor-receives-avg wheat-hrw-conventional_price-distributor-receives-stdev ) 2
   if wheat-hrw-conventional_price-to-buy < wheat-hrw-conventional_price-mill-receives-avg [ set wheat-hrw-conventional_price-to-buy wheat-hrw-conventional_price-mill-receives-avg ]

   set bun-hrw-conventional_price-to-buy precision ( random-normal PROCESSED-hrw-conventional_price-wholesale-avg sd-wholesale ) 2
   if bun-hrw-conventional_price-to-buy < ( wheat-hrw-conventional_price-baker-receives-avg * 1.25 ) [ set bun-hrw-conventional_price-to-buy ( wheat-hrw-conventional_price-baker-receives-avg * 1.25 ) ] ]

end


to setup-households

  set-default-shape households "person"
  create-households number-households
    [
      setxy random max-pxcor random max-pycor                        ;; in order for this to work correctly, the origin of the netlogo display must be set at the corner
      set home-xcor pxcor
      set home-ycor pycor
      set id who
      set agent-name word "household " id
      set household-size (random 7 + 1)
      set hei-baseline 96 - (random 79)                             ;; this sets a baseline hei within the range of my foodaps data set (hei range of 16-95)
      set hei-updated hei-baseline                                  ;; this sets the updated hei equal to the baseline --> this is the value that will shift over time due to eating choices
      ifelse  household-size > 2                                    ;; this sets a number of students for the family, making the assumption that every household contains 2 parents, and everyone else is getting a distributor meal
        [set student_count household-size - 2]
        [set student_count 0]

      set breakfast_total-needed student_count * (random 5 + 1)          ;; sets the total weekly number of household breakfasts by multiplying the total number of students by a random amount of distributor days/week
      set lunch_total-needed student_count * (random 5 + 1)             ;; sets the total weekly number of household lunches by multiplying the total number of students by a random amount of distributor days/week

      set school-id [id] of min-one-of schools [distance myself]
      set color [color] of min-one-of schools [distance myself]

      if hide-turtles? = TRUE [ ht ]
      ]

end


;;to set-global-prices
;;  set PROCESSED-hrw-conventional_price-wholesale-avg 1.01
;;  set wheat-hrw-conventional_price-wholesale-avg .35
;;  set wheat-hrw-organic_price-wholesale-avg .7                              ;; this is an arbitrary price - real-world data to come
;;end


to setup-wheat-farm-crop-allocation

  ask wheat_farmers
  [
    set wheat-hrw-allocation 0.8
    set wheat-snowmass-allocation 0.2
  ]

end


to setup-estimated-yields

    ask wheat_farmers [
    set wheat-farmers_yield-estimated_hrw-conventional (2.20462 * (((sum [wheat-hrw-conventional-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
      with [certified-organic = 0] with [remainder-patch = 0] * 100 * wheat-hrw-allocation)) + (sum [wheat-hrw-conventional-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
      with [certified-organic = 0] with [remainder-patch = 1] * wheat-hrw-allocation * (hectares-farmed-wheat - (100 * (patches-in-wheat - 1))))))

    set wheat-farmers_yield-estimated_snowmass-conventional (2.20462 * (((sum [wheat-snowmass-conventional-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
      with [certified-organic = 0] with [remainder-patch = 0] * 100 * wheat-snowmass-allocation)) + (sum [wheat-snowmass-conventional-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
      with [certified-organic = 0] with [remainder-patch = 1] * wheat-snowmass-allocation * (hectares-farmed-wheat - (100 * (patches-in-wheat - 1))))))

    set wheat-farmers_yield-estimated_hrw-organic (2.20462 * (((sum [wheat-hrw-organic-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
      with [certified-organic = 1] with [remainder-patch = 0] * 100 * wheat-hrw-allocation)) + (sum [wheat-hrw-organic-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
      with [certified-organic = 1] with [remainder-patch = 1] * wheat-hrw-allocation * (hectares-farmed-wheat - (100 * (patches-in-wheat - 1))))))

    set wheat-farmers_yield-estimated_snowmass-organic (2.20462 * (((sum [wheat-snowmass-organic-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
      with [certified-organic = 1] with [remainder-patch = 0] * 100 * wheat-snowmass-allocation)) + (sum [wheat-snowmass-organic-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
      with [certified-organic = 1] with [remainder-patch = 1] * wheat-snowmass-allocation * (hectares-farmed-wheat - (100 * (patches-in-wheat - 1))))))
  ]

end


to go

  if ticks > max-ticks [ stop ]
  manage-dates
  if ( week = 31 ) [ reset-storage ]
  if ( week = 31 ) and ( year != 1 ) [
    transition-patches
    update-organic
    update-display ]
  if week = 31 [ setup-estimated-yields ]
  if ( week = 5 ) or ( week = 18 ) or ( week = 31 ) [
    reset-promised-amounts
    table:clear wheat-table_hrw-conventional
    table:clear wheat-table_hrw-organic
    table:clear wheat-table_snowmass-conventional
    table:clear wheat-table_snowmass-organic
    ifelse gfpp? = TRUE
      [ set-gfpp-contracts ]
      [ set-contracts_hrw-conventional
        set-contracts_hrw-organic
        set-contracts_snowmass-conventional
        set-contracts_snowmass-organic
      ] ]
  if week = 36 [
    produce-wheat
    output-print data-year ]    ; tracker for debugging
  if ( week = 6 ) or ( week = 19 ) or ( week = 37 ) [
  fulfill-contracts ; right now this send all contracted potatoes at once, but we could go back and devide it into weekly shipments if wanted/needed
  process-wheat
  fulfill-baker-contracts ]
  if baseline = TRUE [
    if ((week > 33) and (week < 47)) or ((week > 47) and (week < 52)) or ((week > 2) and (week < 13)) or ((week > 13) and (week < 22))
    [school-purchases-baseline-french-fries]
  ]
;  if week = 29 [spot-market-sales wheat_farmers wheat_elevators number-wheat_elevators] ;double check that this is the correct week for this
  ;; --------------------------------------------------
  ;; somewhere here we need to resolve when potatoes get processed, and how we track baker/school inventory (it introduces all the differentiated products into our table setup)
  ;; --------------------------------------------------
  scuola-cucina-cibo
  eat-breakfast
  eat-lunch
  tally-hei
  output-data ;--> not needed during normal model runs, only for outputting results to spreadsheet as needed
  tick

end


;MANAGE DATES, moves julian and year calendars forward every tick
to manage-dates

  set week week + 1
  if week = 53 [ ;once the julian calendar reaches 365 days, a year has passed and a new year starts
    set year year + 1
    set week 1
  ]

end


;******************************
; UPDATE AMOUNT OF ORGANIC LAND
;******************************

to transition-patches

  ; we probably need to add something here that charges farmers for organic input costs on these patches, even though they're getting conventional yields
  ;; ideas: track # of years since first transition, and shift willingness to transition based on how long land has been in transition (more time since first transition means less likely to switch back to convetnional, and more likely to convert all land to organic
  ;; threshold (% vs # of patches) that trigger conversion of entire farm to convert

  ask wheat_farmers [
    if risk-aversion < .4 [
      let my-patches patches with [ farmer = [ farm-id ] of myself ]
      let patches-organic my-patches with [ certified-organic = 1 ]
      let patches-conventional my-patches with [ certified-organic =  0  and in-organic-transition = 0 ]
      if ( count patches-conventional ) > 0 [
        ifelse ( count patches-organic >= 1 )
          [ ask patches-conventional [ set in-organic-transition 1 set organic-conversion-tracker 1 ] ]
          [ let conversion-amount round ( ( count patches-conventional ) * percent-transition )
            let conversion-patches n-of conversion-amount patches-conventional
            ask conversion-patches [
              set in-organic-transition 1
              set organic-conversion-tracker 1 ] ]
      ]
    ]
  ]

end


to update-organic

  ask patches [
    if in-organic-transition = 1 [ into-organic ]
;    if ( certified-organic = 1 ) and ( in-organic-transition = 0 ) [ undo-organic ] ;; need to fix/refine this --> right now it will turn all organic patches back into conventional
  ]

end


to into-organic

; transition from conventional to organic
  set organic-conversion-tracker ( organic-conversion-tracker + 1 )
  if organic-conversion-tracker = 4 [
    set certified-organic 1
    set organic-conversion-tracker 0
    set in-organic-transition 0  ]

end


to undo-organic

; transitioning from conventional back to organic
  set organic-conversion-tracker 0
  set certified-organic 0

end


to update-display

  if display-style = "farm ownership"
  [
    ask patches with [ occupied = 1 ]
    [ set pcolor farmer ]
  ]
  if display-style = "wheat vs barley rotation"
  [
    ask patches with [ rotation = "barley" ] [ set pcolor 125 ]
    ask patches with [ rotation = "wheat" ] [ set pcolor 34 ]
  ]
  if display-style = "organic vs conventional"
  [
    ask patches with [ occupied = 1 ] [
      if certified-organic = 0 [ set pcolor 36 ]
      if organic-conversion-tracker = 1 [ set pcolor 67 ]
      if organic-conversion-tracker = 2 [ set pcolor 56 ]
      if organic-conversion-tracker = 3 [ set pcolor 54 ]
      if certified-organic = 1 [ set pcolor 62 ] ]
  ]

end

to school-purchases-baseline-french-fries
  ; assume from 2018-19 DPS purchase records courtesy of Chef Ann Wilson via Marion Kalb that DPS purchases 281,427 lbs. french fries annually (we are adding french
  ;fries, seasoned diced potatoes, and fresh baking potatoes purchased in 18-19 to get this number).  Divide total lbs. by number of weeks school lunch is served
  ;to get weekly purchase amount.  assume lunch is served 35 weeks out of the year. so the weekly amount is 8,041 lbs. for the school district.


;  let schools pick a distributor (price shop based on market knowledge)--pull code from contract fulfillment
;  then set school inventory and cash to change based on amount french fries purchased by DPS annually divided by number of weeks in school year
;  then set distributor inventory and cash to change by same amount

  ask distributors [
    set out-of-state-french-fry_price-to-sell random-normal 1.01 .05
  ]

    ask schools [ if out-of-state-french-fry_inventory-current < out-of-state-french-fry_inventory-maximum
    [
      let my-distributor n-of 1 ( distributors with-min [ out-of-state-french-fry_price-to-sell ] )
      let amount-exchanged 8041
      let price-exchanged [out-of-state-french-fry_price-to-sell] of my-distributor
      let price-tag (amount-exchanged * price-exchanged)

      set out-of-state-french-fry_inventory-current out-of-state-french-fry_inventory-current + amount-exchanged
      set assets assets - price-tag

      ask my-distributor [
        set out-of-state-french-fry_inventory-current out-of-state-french-fry_inventory-current - amount-exchanged
        set assets assets + price-tag
      ]
    ]
  ]


end

to set-contracts

;  these exist:
;  setContracts_hrwConventionalWheat sellers  buyers  buyer_count
;
;  setContracts_hrwConventionalBun
;  setContracts_hrwOrganicWheat
;  setContracts_snowmassConventionalWheat
;  setContracts_snowmassConventionalFlour
;
;  these need to be made:
;  setContracts_hrwConventionalFlour
;  setContracts_hrwConventionalBread (rename)
;
;  setContracts_hrwOrganicFlour
;  setContracts_hrwOrganicBread
;
;  setContracts_snowmassConventionalBread
;
;
;  ;set
;  farm to elevator all three types
;  elevator to mill all three types
;
;  mill to distrib all three types
;  mill to baker all three types
;  baker to distrib all three types
;
;  ;scenario 1: DPS purchases conventional HRW flour and sliced bread from distributor
;  ;assume 50/50 transaction percent breakdown between flour and bread
;
;  distrib to DPS flour HRW conv
;  distrib to DPS bread HRW conv
;
;  ;scenario 2: DPS purchases all bread products in the form of organic HRW bread
;  distrib to DPS flour HRW org
;  distrib to DPS bread HRW org
;
;  ;scenario 3: DPS purchases all bread products in the form of snowmass bread
;  distrib to DPS flour snowmass conv
;  distrib to DPS bread snowmass conv

end




to set-gfpp-contracts

  ;  farmers to mills
  setContracts_hrwConventionalWheat  wheat_farmers  wheat_mills  number-wheat_mills  FALSE

  ;  mills to school
  setContracts_hrwConventionalWheat  wheat_mills  schools  school-count  FALSE

end


to set-contracts_hrw-conventional

  ;; -------------------------------------------------------------------------------------------------------------------
  ;; add something here to check week to decided if it's time to contract, and if so if it's prime/off season
  ;; also add something here so that if it's off-season contract negotiation, all buy prices are increased by 10% (prices are higher in the off season)
  ;; -------------------------------------------------------------------------------------------------------------------
  ;; potato to standard french fry, baker needed

  ;  farmers to mills
  setContracts_hrwConventionalWheat  wheat_farmers  wheat_mills  number-wheat_mills  TRUE

  ;  farmers to elevators
  setContracts_hrwConventionalWheat  wheat_farmers  wheat_elevators  number-wheat_elevators  TRUE

  ; elevators to mills
  setContracts_hrwConventionalWheat  wheat_elevators  wheat_mills  number-wheat_elevators  TRUE

  ;  mills to bakers
  setContracts_hrwConventionalWheat  wheat_mills  wheat_bakers  number-wheat_bakers  TRUE

  ;  mills to distributors
  setContracts_hrwConventionalWheat  wheat_mills  distributors  number-distributors  TRUE

  ;  bakers to distributors
  setContracts_hrwConventionalBun  wheat_bakers  distributors  number-distributors  TRUE

  ;  distributors to school
  if baseline = FALSE [
  setContracts_hrwConventionalWheat  distributors  schools  number-distributors  FALSE
  setContracts_hrwConventionalBun  distributors  schools  number-distributors  FALSE
  ]

end


to set-contracts_hrw-organic

  ;; -------------------------------------------------------------------------------------------------------------------
  ;; add something here to check week to decided if it's time to contract, and if so if it's prime/off season
  ;; also add something here so that if it's off-season contract negotiation, all buy prices are increased by 10% (prices are higher in the off season)
  ;; -------------------------------------------------------------------------------------------------------------------
  ;; potato to baked potatoes, no baker needed

  ;  farmers to mills
  setContracts_hrwOrganicWheat  wheat_farmers  wheat_mills  number-wheat_mills  TRUE

  ;  farmers to elevators
  setContracts_hrwOrganicWheat  wheat_farmers  wheat_elevators  number-wheat_elevators  TRUE

    ; elevators to mills
  setContracts_hrwOrganicWheat  wheat_elevators  wheat_mills  number-wheat_elevators  TRUE

  ;  mills to distributors
  setContracts_hrwOrganicWheat  wheat_mills  distributors  number-distributors  TRUE

  ;  distributors to school
  if baseline = FALSE [
  setContracts_hrwOrganicWheat  distributors  schools  number-distributors  FALSE
  ]

end


to set-contracts_snowmass-conventional

  ;; -------------------------------------------------------------------------------------------------------------------
  ;; add something here to check week to decided if it's time to contract, and if so if it's prime/off season
  ;; also add something here so that if it's off-season contract negotiation, all buy prices are increased by 10% (prices are higher in the off season)
  ;; -------------------------------------------------------------------------------------------------------------------
  ;; potato to specialty potato chip, baker needed

  ;  farmers to mills
  setContracts_snowmassConventionalWheat  wheat_farmers  wheat_mills  number-wheat_mills  TRUE

  ;  farmers to elevators
  setContracts_snowmassConventionalWheat  wheat_farmers  wheat_elevators  number-wheat_elevators  TRUE

  ; elevators to mills
  setContracts_snowmassConventionalWheat  wheat_elevators  wheat_mills  number-wheat_elevators  TRUE

  ;  mills to bakers
  setContracts_snowmassConventionalWheat  wheat_mills  wheat_bakers  number-wheat_bakers  TRUE

  ;  mills to distributors
  setContracts_snowmassConventionalWheat  wheat_mills  distributors  number-distributors  TRUE

  ;  bakers to distributors
  setContracts_snowmassConventionalFlour  wheat_bakers  distributors  number-distributors  TRUE

  ;  distributors to school
  if baseline = FALSE [
  setContracts_snowmassConventionalWheat  distributors  schools  number-distributors  FALSE
  setContracts_snowmassConventionalFlour   distributors  schools  number-distributors  FALSE
  ]

end


to set-contracts_snowmass-organic

  ;; -------------------------------------------------------------------------------------------------------------------
  ;; add something here to check week to decided if it's time to contract, and if so if it's prime/off season
  ;; also add something here so that if it's off-season contract negotiation, all buy prices are increased by 10% (prices are higher in the off season)
  ;; -------------------------------------------------------------------------------------------------------------------
  ;; potato to organic specialty wedge, baker needed

  ;  farmers to mills
  setContracts_snowmassOrganicWheat  wheat_farmers  wheat_mills  number-wheat_mills  TRUE

  ;  farmers to elevators
  setContracts_snowmassOrganicWheat  wheat_farmers  wheat_elevators  number-wheat_elevators  TRUE

  ; elevators to mills
  setContracts_snowmassOrganicWheat  wheat_elevators  wheat_mills  number-wheat_elevators  TRUE

  ;  mills to bakers
  setContracts_snowmassOrganicWheat  wheat_mills  wheat_bakers  number-wheat_bakers  TRUE

  ;  mills to distributors
  setContracts_snowmassOrganicWheat  wheat_mills  distributors  number-distributors  TRUE

  ;  bakers to distributors
  setContracts_snowmassOrganicFlour  wheat_bakers  distributors  number-distributors  TRUE

  ;  distributors to school
  if baseline = FALSE [
  setContracts_snowmassOrganicWheat  distributors  schools  number-distributors  FALSE
  setContracts_snowmassOrganicFlour   distributors  schools  number-distributors  FALSE
  ]

end


;; -------------------------------------
;; right now this happens all at once, but it could be made weekly by having farmers harvest 1/7th (the harvest season is 7 weeks long) of their annual production each week of the harvest season
;; come back to this later is necessary
; --------------------------------------
to produce-wheat

  set-wheat-yield ; annual, planning stage
  set-wheat-farm-crop-allocation ; annual, planning steage
  set-wheat-barley-rotation ; annual, planning stage
  calculate-annual-production ; annual, harvest stage

end


to fulfill-contracts

  ;; --------------------------------------------------------------------------------
  ;; NEED TO MAKE SURE FARMERS GET PAID WHEN mill/WAREHOUSE CONTRACT ARE FULFILLED
  ;; --------------------------------------------------------------------------------

  ; FARMER TO mill CONTRACT FULFILLMENT
  fulfillContracts_hrwConventionalWheat wheat_farmers wheat_mills
  fulfillContracts_hrwOrganicWheat wheat_farmers wheat_mills
  fulfillContracts_snowmassConventionalWheat wheat_farmers wheat_mills
  fulfillContracts_snowmassOrganicWheat wheat_farmers wheat_mills

  ; FARMER TO elevator CONTRACT FULFILLMENT
  fulfillContracts_hrwConventionalWheat wheat_farmers wheat_elevators
  fulfillContracts_hrwOrganicWheat wheat_farmers wheat_elevators
  fulfillContracts_snowmassConventionalWheat wheat_farmers wheat_elevators
  fulfillContracts_snowmassOrganicWheat wheat_farmers wheat_elevators

  ; elevators to mills contract fulfillment
  fulfillContracts_hrwConventionalWheat wheat_elevators  wheat_mills
  fulfillContracts_hrwOrganicWheat wheat_elevators  wheat_mills
  fulfillContracts_snowmassConventionalWheat wheat_elevators  wheat_mills
  fulfillContracts_snowmassOrganicWheat wheat_elevators  wheat_mills

  ; mill TO baker CONTRACT FULFILLMENT
  fulfillContracts_hrwConventionalWheat wheat_mills wheat_bakers
  fulfillContracts_snowmassConventionalWheat wheat_mills wheat_bakers
  fulfillContracts_snowmassOrganicWheat wheat_mills wheat_bakers

  ; mill TO DISTRIBUTOR CONTRACT FULFILLMENT
  fulfillContracts_hrwConventionalWheat wheat_mills distributors
  fulfillContracts_hrwOrganicWheat wheat_mills distributors
  fulfillContracts_snowmassConventionalWheat wheat_mills distributors
  fulfillContracts_snowmassOrganicWheat wheat_mills distributors

  ; DISTRIBUTOR TO SCHOOL CONTRACT FULFILLMENT
  fulfillContracts_hrwConventionalWheat distributors schools
  fulfillContracts_hrwOrganicWheat distributors schools
  fulfillContracts_snowmassConventionalWheat distributors schools
  fulfillContracts_snowmassOrganicWheat distributors schools

  ; ^ do this during fulfillment with amount-exchanged variable so don't accidentally double count if potatoes remain in elevator inventory between ticks for some reason?

;  ask wheat_mills [
;    if wheat-hrw-conventional_inventory-current < 0 [ set wheat-hrw-conventional_inventory-current 0 ] ] ; this line forces no negative inventory amounts

end


to fulfill-baker-contracts

  ; baker TO DISTRIBUTOR CONTRACT FULFILLMENT
  fulfillContracts_hrwConventionalBun wheat_bakers distributors
  fulfillContracts_snowmassConventionalFlour wheat_bakers distributors
  fulfillContracts_snowmassOrganicFlour wheat_bakers distributors

  ; DISTRIBUTOR TO SCHOOL CONTRACT FULFILLMENT
  fulfillContracts_hrwConventionalBun distributors schools
  fulfillContracts_snowmassConventionalFlour distributors schools
  fulfillContracts_snowmassOrganicFlour distributors schools

end


to spot-market-sales [ sellers buyers buyer_count]   ; only set up for farmers to elevators right now (if want to include other agents, will need to make space availabel variable for them.
  let amount-exchanged 0                             ; the way this process is set up, farmers get one chance to sell potatoes to a elevator and the rest go to waste
  let price-exchanged 0                              ; the farmer chooses the elevator based on price, not space available....maybe should change this.
  let price-tag 0                                    ; maybe it should be buyers with capacity = space for all potatoes

  ask buyers [
    set wheat-hrw-conventional_space-available ( wheat-hrw-conventional_inventory-maximum - wheat-hrw-conventional_inventory-current )
  ]

  ask sellers [
    if wheat-hrw-conventional_inventory-current > 0 [

    let buyers-with-capacity ( buyers with [ wheat-hrw-conventional_contract-space-available > 0 ] )
    let bidding_buyers 0
    if any? buyers-with-capacity [
      ifelse ( count buyers-with-capacity ) >= ( round ( market-knowledge * buyer_count ) )
      [ set bidding_buyers n-of ( round ( market-knowledge * buyer_count ) ) buyers-with-capacity ]
      [ set bidding_buyers buyers-with-capacity ]

      let my-buyer n-of 1 ( bidding_buyers with-max [ wheat-hrw-conventional_price-to-buy ] )
      let space-avail item 0 ([wheat-hrw-conventional_contract-space-available] of my-buyer )
      ifelse wheat-hrw-conventional_inventory-current > space-avail
        [ set amount-exchanged space-avail ]
        [ set amount-exchanged wheat-hrw-conventional_inventory-current ]
     set price-exchanged item 0 ([wheat-hrw-conventional_price-to-buy] of my-buyer )
     set price-tag (amount-exchanged * price-exchanged)
     set wheat-hrw-conventional_inventory-current (wheat-hrw-conventional_inventory-current - amount-exchanged)
     set assets (assets + price-tag)
    ]
   ]
  ]
  ask buyers [
    set wheat-hrw-conventional_inventory-current (wheat-hrw-conventional_inventory-current + amount-exchanged)
    set assets (assets - price-tag)
  ]

  ask sellers [
    set wheat-hrw-conventional_inventory-current 0
  ]
end

to out-of-state-sales

end

to reset-promised-amounts

  ask wheat_farmers [
    set wheat-hrw-conventional-promised 0
    set wheat-hrw-organic-promised 0
    set wheat-snowmass-conventional-promised 0
    set wheat-snowmass-organic-promised 0 ]

  ask wheat_mills [
    set wheat-hrw-conventional_my-incoming-total 0
    set wheat-hrw-conventional-promised 0
    set wheat-hrw-organic_my-incoming-total 0
    set wheat-hrw-organic-promised 0
    set wheat-snowmass-conventional_my-incoming-total 0
    set wheat-snowmass-conventional-promised 0
    set wheat-snowmass-organic_my-incoming-total 0
    set wheat-snowmass-organic-promised 0 ]

  ask wheat_elevators [
    set wheat-hrw-conventional_my-incoming-total 0
    set wheat-hrw-conventional-promised 0
    set wheat-hrw-organic_my-incoming-total 0
    set wheat-hrw-organic-promised 0
    set wheat-snowmass-conventional_my-incoming-total 0
    set wheat-snowmass-conventional-promised 0
    set wheat-snowmass-organic_my-incoming-total 0
    set wheat-snowmass-organic-promised 0 ]

  ask wheat_bakers [
    set wheat-hrw-conventional_my-incoming-total 0
    set bun-hrw-conventional-promised 0
    set wheat-snowmass-conventional_my-incoming-total 0
    set flour-snowmass-conventional-promised 0
    set wheat-snowmass-organic_my-incoming-total 0
    set bun-hrw-organic-promised 0 ]

  ask distributors [
    set wheat-hrw-conventional_my-incoming-total 0
    set wheat-hrw-conventional-promised 0
    set bun-hrw-conventional_my-incoming-total 0
    set bun-hrw-conventional-promised 0
    set wheat-hrw-organic_my-incoming-total 0
    set wheat-hrw-organic-promised 0
    set wheat-snowmass-conventional_my-incoming-total 0
    set wheat-snowmass-conventional-promised 0
    set flour-snowmass-conventional_my-incoming-total 0
    set flour-snowmass-conventional-promised 0
    set wheat-snowmass-organic_my-incoming-total 0
    set wheat-snowmass-organic-promised 0
    set bun-hrw-organic_my-incoming-total 0
    set bun-hrw-organic-promised 0 ]

end

;*************************
;  SET POTATO YIELD DSSAT ; input 38 years of DSSAT yield data into patches
;*************************
to set-wheat-yield ; set single-year random potato yield

  set data-year 1980 + random 39
;  set data-year 1981 --> for debugging (we know 1981 was a very bad production year)

  let file-name-canela (word data-year "_canela.asc")
  set wheat-hrw-conventional_load gis:load-dataset file-name-canela
  gis:apply-raster wheat-hrw-conventional_load wheat-hrw-conventional-current-yield

  let file-name-canela-org (word data-year "_canela_org.asc")
  set wheat-hrw-organic_load gis:load-dataset file-name-canela-org
  gis:apply-raster wheat-hrw-organic_load wheat-hrw-organic-current-yield

  let file-name-purple (word data-year "_purple.asc")
  set wheat-snowmass-conventional_load gis:load-dataset file-name-purple
  gis:apply-raster wheat-snowmass-conventional_load wheat-snowmass-conventional-current-yield

  let file-name-purple-org (word data-year "_purple_org.asc")
  set wheat-snowmass-organic_load gis:load-dataset file-name-purple-org
  gis:apply-raster wheat-snowmass-organic_load wheat-snowmass-organic-current-yield

  ask patches
 [
    ifelse wheat-hrw-conventional-current-yield >= 0; sets all non-producing patches to 0, otherwise they are NaN. Also see next set of commands re: NaN
    []
    [
      set wheat-hrw-conventional-current-yield 0
      set wheat-hrw-organic-current-yield 0
      set wheat-snowmass-conventional-current-yield 0
      set wheat-snowmass-organic-current-yield 0
    ]
  ]

  ask patches with [occupied = 1]; this fixes the situation where some years from DSSAT seem to produce NaN for a small number of patches. I think this is a DSSAT error
  [
    if wheat-hrw-conventional-current-yield = 0
    [
      set wheat-hrw-conventional-current-yield mean [wheat-hrw-conventional-current-yield] of patches with [wheat-yes-no = 1]
      set wheat-hrw-organic-current-yield mean [wheat-hrw-organic-current-yield] of patches with [wheat-yes-no = 1]
      set wheat-snowmass-conventional-current-yield mean [wheat-snowmass-conventional-current-yield] of patches with [wheat-yes-no = 1]
      set wheat-snowmass-organic-current-yield mean [wheat-snowmass-organic-current-yield] of patches with [wheat-yes-no = 1]
    ]
  ]

end


;************************************
;  SET POTATO FARM CROP ALLOCATION   ; this can become dynamic
;************************************
to set-wheat-farm-crop-allocation

  ask wheat_farmers
  [
    set wheat-hrw-allocation 0.8
    set wheat-snowmass-allocation 0.2
  ]

end


;**********************************
;  TO SET POTATO BARLEY ROTATION
;********************************
to set-wheat-barley-rotation

  if rotation-year = 3; all producers on same schedule but don't need to be- just doesn't seem to be important to model different schedules
  [
    ask wheat_farmers with [patches-in-rotation > 0]; those with patches that rotate, otherwise just grow within 1 or 2 patches
        [
          ask patches with [rotation = "barley"] with [farmer = [farm-id] of myself]
          [set rotation "transition"]
          ask n-of (patches-in-rotation) patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
          [set rotation "barley"]
          ask patches with [rotation = "transition"] with [farmer = [farm-id] of myself]
          [set rotation "wheat"]
         ]
    set rotation-year 0
  ]

    set rotation-year rotation-year + 1

end


;**********************************
;  CALCULATE ANNUAL PRODUCTION
;********************************
to calculate-annual-production

  ask wheat_farmers
   [
      set wheat-hrw-conventional-current-production (2.20462 *(((sum [wheat-hrw-conventional-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
        with [certified-organic = 0] with [remainder-patch = 0] * 100 * wheat-hrw-allocation)) + (sum [wheat-hrw-conventional-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
         with [certified-organic = 0] with [remainder-patch = 1] * wheat-hrw-allocation * (hectares-farmed-wheat - (100 * (patches-in-wheat - 1))))))

      set wheat-snowmass-conventional-current-production (2.20462 * (((sum [wheat-snowmass-conventional-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
        with [certified-organic = 0] with [remainder-patch = 0] * 100 * wheat-snowmass-allocation)) + (sum [wheat-snowmass-conventional-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
         with [certified-organic = 0] with [remainder-patch = 1] * wheat-snowmass-allocation * (hectares-farmed-wheat - (100 * (patches-in-wheat - 1))))))

      set wheat-hrw-organic-current-production (2.20462 * (((sum [wheat-hrw-organic-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
        with [certified-organic = 1] with [remainder-patch = 0] * 100 * wheat-hrw-allocation)) + (sum [wheat-hrw-organic-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
         with [certified-organic = 1] with [remainder-patch = 1] * wheat-hrw-allocation * (hectares-farmed-wheat - (100 * (patches-in-wheat - 1))))))

      set wheat-snowmass-organic-current-production (2.20462 * (((sum [wheat-snowmass-organic-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
        with [certified-organic = 1] with [remainder-patch = 0] * 100 * wheat-snowmass-allocation)) + (sum [wheat-snowmass-organic-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "wheat"]
         with [certified-organic = 1] with [remainder-patch = 1] * wheat-snowmass-allocation * (hectares-farmed-wheat - (100 * (patches-in-wheat - 1))))))

;     ------------------------------
;     stef note (8/30/20):
;     farmer input costs: farmers need to be paying organic input costs on both organic and in-transition patches, conventional input costs for everything else
;     this means input costs are calculated on what is planted, not what is harvested, which seems more realistic
;     NEED TO ADJUST UNITS HERE: LAND CALCULATION IS PER PATCH, COSTS ARE PER ACRE
;     ------------------------------

      let my-wheat-patches patches with [ farmer = [ id ] of myself and rotation = "wheat"]
      let my-organic-patches count my-wheat-patches with [ certified-organic = 1 or in-organic-transition = 1 ]
      let my-conventional-patches ( ( count my-wheat-patches ) - my-organic-patches )

      set assets ( assets - ( my-conventional-patches * (random-normal conv-input-price-per-lb conv-input-price-stdev) ) )
      set assets ( assets - ( my-organic-patches * (random-normal org-input-price org-input-price-stdev) ) )

;      set assets ( assets - ( wheat-hrw-conventional-current-production * (random-normal conv-input-price-per-lb conv-input-price-stdev) )) ; Add input prices for all potato product types: CHECK UNITS: input prices are per acre
      ;-----------------------------------------------------
      ; for now, going to do input costs by production weight but that will not reflect amount potatoes PLANTED vs. harvested so need to come back to this later!
      ;-----------------------------------------------------
      ; 1 kg = 2.20462 lbs.
      ; convert when update farmer inventory

      ; UPDATE FARMER INVENTORY HERE
      set wheat-hrw-conventional_inventory-current wheat-hrw-conventional-current-production
      set wheat-hrw-organic_inventory-current wheat-hrw-organic-current-production
      set wheat-snowmass-conventional_inventory-current wheat-snowmass-conventional-current-production
      set wheat-snowmass-organic_inventory-current wheat-snowmass-organic-current-production

   ]

  ask wheat_farmers; economic stats
  [
    set wheat-hrw-conventional-current-value wheat-hrw-conventional-current-production * wheat-hrw-conventional_price-farmgate-avg
    set wheat-snowmass-conventional-current-value wheat-snowmass-conventional-current-production * wheat-snowmass-conventional_price-farmgate-avg
    set wheat-hrw-organic-current-value wheat-hrw-organic-current-production * wheat-hrw-organic_price-farmgate-avg
    set wheat-snowmass-organic-current-value wheat-snowmass-organic-current-production * wheat-snowmass-organic_price-farmgate-avg
    set total-wheat-current-value wheat-hrw-conventional-current-value + wheat-snowmass-conventional-current-value + wheat-hrw-organic-current-value + wheat-snowmass-organic-current-value
  ]

  set total-current-year-wheat-sales sum [wheat-hrw-conventional-current-value] of wheat_farmers + sum [wheat-snowmass-conventional-current-value] of wheat_farmers +
    sum [wheat-hrw-organic-current-value] of wheat_farmers + sum [wheat-snowmass-organic-current-value] of wheat_farmers

end


;**********************************
;  OUTPUT PRODUCTION AND SALES TO EXCEL
;********************************
to output-data

;  ; yield
;  set wheat-hrw-conventional_yield  (sum [ wheat-hrw-conventional-current-production ] of wheat_farmers)
;  set wheat-snowmass-conventional_yield  (sum [ wheat-snowmass-conventional-current-production ] of wheat_farmers)
;  set wheat-hrw-organic_yield (sum [ wheat-hrw-organic-current-production ] of wheat_farmers)
;  set wheat-snowmass-organic_yield (sum [ wheat-snowmass-organic-current-production ] of wheat_farmers)
;  set output_wheat-hrw-conventional_inventory-current ( sum [ wheat-hrw-conventional_inventory-current ] of wheat_farmers )
;
;  ; crop value
;  set wheat-hrw-conventional_value (sum [ wheat-hrw-conventional-current-value ] of wheat_farmers)
;  set wheat-snowmass-conventional_value (sum [ wheat-snowmass-conventional-current-value ] of wheat_farmers)
;  set wheat-hrw-organic_value (sum [ wheat-hrw-organic-current-value ] of wheat_farmers)
;  set wheat-snowmass-organic_value (sum [ wheat-snowmass-organic-current-value ] of wheat_farmers)

    if year >= (years-in-model-run - years-of-data-collection)  ; only gathers output data in the last 2 years of the model (lets patterns emerge before gathering data).
                 ; takes mean and sum of cash and inventory by agent type.
                 ; processed potatoes not included atm
  [
    set mean-wheat-producer-inventory mean [ wheat-hrw-conventional_inventory-current ] of wheat_farmers
    set sum-wheat-producer-inventory sum [ wheat-hrw-conventional_inventory-current ] of wheat_farmers
    set mean-wheat-producer-cash  mean [ assets ] of wheat_farmers
    set sum-wheat-producer-cash sum [ assets ] of wheat_farmers

    set mean-wheat-mill-inventory mean [ wheat-hrw-conventional_inventory-current ] of wheat_mills
    set sum-wheat-mill-inventory sum [ wheat-hrw-conventional_inventory-current ] of wheat_mills
    set mean-wheat-mill-cash mean [ assets ] of wheat_mills
    set sum-wheat-mill-cash sum [ assets ] of wheat_mills

    set mean-wheat-elevator-inventory mean [ wheat-hrw-conventional_inventory-current ] of wheat_elevators
    set sum-wheat-elevator-inventory sum [ wheat-hrw-conventional_inventory-current ] of wheat_elevators
    set mean-wheat-elevator-cash mean [ assets ] of wheat_elevators
    set sum-wheat-elevator-cash sum [ assets ] of wheat_elevators

    set mean-wheat-baker-inventory mean [ wheat-hrw-conventional_inventory-current ] of wheat_bakers
    set sum-wheat-baker-inventory sum [ wheat-hrw-conventional_inventory-current ] of wheat_bakers
    set mean-wheat-baker-cash mean [ assets ] of wheat_bakers
    set sum-wheat-baker-cash sum [ assets ] of wheat_bakers

    set mean-distributor-inventory mean [ wheat-hrw-conventional_inventory-current ] of distributors
    set sum-distributor-inventory sum [ wheat-hrw-conventional_inventory-current ] of distributors
    set mean-distributor-cash mean [ assets ] of distributors
    set sum-distributor-cash sum [ assets ] of distributors

    set mean-school-inventory mean [ wheat-hrw-conventional_inventory-current ] of schools
    set sum-school-inventory sum [ wheat-hrw-conventional_inventory-current ] of schools
    set mean-school-cash mean [ assets ] of schools
    set sum-school-cash sum [ assets ] of schools

  ]

end


;;*************************************
;; PROCESS POTATOES
;;*************************************
to process-wheat

  ask wheat_bakers [
    if wheat-hrw-conventional_inventory-current > 1 [
      let conversion ( wheat-hrw-conventional_inventory-current ) ; * .8 ) ;; assumes 20% waste during fresh-to-processed conversion (stef's random value - needs to be made realistic)
      let processed-space-available ( bun-hrw-conventional_inventory-maximum - bun-hrw-conventional_inventory-current )
      ifelse processed-space-available >= conversion
      [ set bun-hrw-conventional_inventory-current ( bun-hrw-conventional_inventory-current + conversion )
        set wheat-hrw-conventional_inventory-current 0 ]
      [ set bun-hrw-conventional_inventory-current ( bun-hrw-conventional_inventory-current + processed-space-available )
        set wheat-hrw-conventional_inventory-current ( wheat-hrw-conventional_inventory-current - processed-space-available ) ] ;* 1.25 ) ]
    ]
  ]

end


;converts uncooked potatoes into individual serving sizes --> NOTE: MAKE SURE TO CHECK UNITS BETWEEN INVENTORY AND SERVINGS CONVERSION
to scuola-cucina-cibo

  ask schools
    [
    set bun-hrw-conventional_servings ( bun-hrw-conventional_servings + ( bun-hrw-conventional_inventory-current * 14 ) ) ;; 14 servings per unit of processed potatoes
    set bun-hrw-conventional_inventory-current 0
    set wheat-hrw-conventional_servings ( wheat-hrw-conventional_servings + (wheat-hrw-conventional_inventory-current * 8.9 ) ) ;; 8.9 servings per unit of fresh potatoes
    set wheat-hrw-conventional_inventory-current 0
    set wheat-hrw-organic_servings ( wheat-hrw-organic_servings + ( wheat-hrw-organic_inventory-current * 8.9 ) ) ;; 8.9 servings per unit of fresh potatoes
    set wheat-hrw-organic_inventory-current 0
    ]

end


to eat-breakfast

  if ( ( week >= 2 ) and ( week <= 12 ) ) or ( ( week >= 14 ) and ( week >= 21 ) ) or ( ( week >= 34 ) and ( week >= 46 ) ) or ( ( week >= 48 ) and ( week >= 52 ) ) ; these are the weeks that school is in session
  [
    ask households [
    let school-p-meals ( [ bun-hrw-conventional_servings ] of one-of schools with [ id = [ school-id ] of myself ] )           ;; check how many processed servings of potatoes my school has
    let school-c-meals ( [ wheat-hrw-conventional_servings ] of one-of schools with [ id = [ school-id ] of myself ] )               ;; check how many fresh conventional servings of potatoes my school has
    let school-o-meals ( [ wheat-hrw-organic_servings ] of one-of schools with [ id = [ school-id ] of myself ] )                    ;; check how many fresh organic servings of potatoes my school has
    ifelse school-p-meals >= breakfast_total-needed                                                                         ;; if my school has enough processed potatoes to feed my household, eat those potatoes, update household hei based on processed potato hei score, and adjust school porcessed potato inventory
    [
     set hei-updated ( hei-updated + ( breakfast_total-needed * wheat-conventional-processed_hei ) )
     ask schools with [ id = [ school-id ] of myself ]
       [ set bun-hrw-conventional_servings ( bun-hrw-conventional_servings - [ breakfast_total-needed ] of myself )
         set assets ( assets + ( [ breakfast_total-needed ] of myself * 1.54 ) ) ]
    ]
    [ ifelse ( school-c-meals >= breakfast_total-needed )                                                                        ;; if my school doesn't have enough processed potatoes, students will try to eat fresh conventional potatoes (then adjusting hei and inventory), and finally to eat fresh organic potatoes (then adjusting hei and inventory)
      [
        set hei-updated ( hei-updated + ( breakfast_total-needed * wheat_hei ) )
        ask schools with [id = [ school-id ] of myself ]
          [ set wheat-hrw-conventional_servings ( wheat-hrw-conventional_servings - [ breakfast_total-needed ] of myself )
            set assets ( assets + ( [ breakfast_total-needed ] of myself * 1.54 ) )]
      ]
      [ ifelse ( school-o-meals >= breakfast_total-needed )                                                                        ;; if my school doesn't have enough processed potatoes, students will try to eat fresh conventional potatoes (then adjusting hei and inventory), and finally to eat fresh organic potatoes (then adjusting hei and inventory)
        [
        set hei-updated ( hei-updated + ( breakfast_total-needed * wheat_hei ) )
        ask schools with [id = [school-id] of myself]
          [ set wheat-hrw-organic_servings ( wheat-hrw-organic_servings - [ breakfast_total-needed ] of myself )
            set assets ( assets + ( [ breakfast_total-needed ] of myself * 1.54 ) )]
        ]
          [ set meals-missed ( meals-missed + breakfast_total-needed ) ]
        ]
      ]
    ]
  ]

end


to eat-lunch

  if ( ( week >= 2 ) and ( week <= 12 ) ) or ( ( week >= 14 ) and ( week >= 21 ) ) or ( ( week >= 34 ) and ( week >= 46 ) ) or ( ( week >= 48 ) and ( week >= 52 ) ) ; these are the weeks that school is in session
  [
    ask households [
    let school-p-meals ( [ bun-hrw-conventional_servings ] of one-of schools with [ id = [ school-id ] of myself ] )             ;; check how many processed servings of potatoes my school has
    let school-c-meals ( [ wheat-hrw-conventional_servings ] of one-of schools with [ id = [ school-id ] of myself ] )               ;; check how many fresh conventional servings of potatoes my school has
    let school-o-meals ( [ wheat-hrw-organic_servings ] of one-of schools with [ id = [ school-id ] of myself ] )                    ;; check how many fresh organic servings of potatoes my school has
    ifelse school-p-meals > lunch_total-needed                                                                         ;; if my school has enough processed potatoes to feed my household, eat those potatoes, update household hei based on processed potato hei score, and adjust school porcessed potato inventory
    [
     set hei-updated ( hei-updated + ( lunch_total-needed * wheat-conventional-processed_hei ) )
     ask schools with [ id = [ school-id ] of myself ]
       [ set bun-hrw-conventional_servings ( bun-hrw-conventional_servings - [ lunch_total-needed ] of myself )
         set assets ( assets + ( [ lunch_total-needed ] of myself * 3.01 ) ) ]
    ]
    [ ifelse ( school-c-meals > lunch_total-needed )                                                                        ;; if my school doesn't have enough processed potatoes, students will try to eat fresh conventional potatoes (then adjusting hei and inventory), and finally to eat fresh organic potatoes (then adjusting hei and inventory)
      [
        set hei-updated ( hei-updated + ( lunch_total-needed * wheat_hei ) )
        ask schools with [ id = [ school-id ] of myself ]
          [ set wheat-hrw-conventional_servings ( wheat-hrw-conventional_servings - [ lunch_total-needed ] of myself )
            set assets ( assets + ( [ lunch_total-needed ] of myself * 3.01 ) ) ]
      ]
      [ ifelse ( school-o-meals > lunch_total-needed )                                                                        ;; if my school doesn't have enough processed potatoes, students will try to eat fresh conventional potatoes (then adjusting hei and inventory), and finally to eat fresh organic potatoes (then adjusting hei and inventory)
        [
        set hei-updated ( hei-updated + ( lunch_total-needed * wheat_hei ) )
        ask schools with [ id = [ school-id ] of myself ]
          [ set wheat-hrw-organic_servings ( wheat-hrw-organic_servings - [ lunch_total-needed ] of myself )
            set assets ( assets + ( [ lunch_total-needed ] of myself * 3.01 ) ) ]
        ]
          [ set meals-missed ( meals-missed + lunch_total-needed) ]
        ]
      ]
    ]
  ]

end


to tally-hei

if ( ( week >= 2 ) and ( week <= 12 ) ) or ( ( week >= 14 ) and ( week >= 21 ) ) or ( ( week >= 34 ) and ( week >= 46 ) ) or ( ( week >= 48 ) and ( week >= 52 ) )
  [
    ask households with [hei-updated != hei-baseline]
  [
    set meals_total-needed (meals_total-needed + (breakfast_total-needed + lunch_total-needed))
    set hei-delta (hei-updated / meals_total-needed)
  ]
  ]

end


to reset-storage

  reset-storage_wheat wheat_farmers
  reset-storage_wheat wheat_elevators
  reset-storage_wheat wheat_mills
  reset-storage_wheat wheat_bakers
  reset-storage_wheat distributors
  reset-storage_wheat schools

end
@#$#@#$#@
GRAPHICS-WINDOW
270
15
978
644
-1
-1
5.0
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
139
0
123
1
1
1
ticks
30.0

BUTTON
12
14
79
47
NIL
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
88
14
151
47
NIL
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
159
14
259
47
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

SLIDER
12
58
258
91
number-wheat_mills
number-wheat_mills
0
15
4.0
1
1
NIL
HORIZONTAL

MONITOR
52
302
102
347
NIL
year
17
1
11

PLOT
1870
67
2218
217
farmer mean assets
Time
Cash
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [assets] of wheat_farmers"
"pen-1" 1.0 0 -7500403 true "" "plot 0"

PLOT
1520
688
1866
838
distributor assets
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
"pen-1" 1.0 0 -5298144 true "" "ask distributors with [ agent-name = \"distributor 106\" ]\n[ plot assets ]"
"pen-2" 1.0 0 -4079321 true "" "ask distributors with [ agent-name = \"distributor 107\" ]\n[ plot assets ]"
"pen-3" 1.0 0 -14439633 true "" "ask distributors with [ agent-name = \"distributor 108\" ]\n[ plot assets ]"
"pen-4" 1.0 0 -14070903 true "" "ask distributors with [ agent-name = \"distributor 109\" ]\n[ plot assets ]"
"pen-5" 1.0 0 -11053225 true "" "plot 0"

INPUTBOX
2613
606
2768
666
conv-input-price-per-lb
0.04
1
0
Number

INPUTBOX
2615
673
2770
733
conv-input-price-stdev
0.01
1
0
Number

INPUTBOX
2615
739
2770
799
org-input-price
0.0
1
0
Number

INPUTBOX
2615
808
2770
868
org-input-price-stdev
0.0
1
0
Number

MONITOR
105
302
155
347
NIL
week
17
1
11

PLOT
1167
683
1515
833
distributor inventory
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
"conv-p" 1.0 0 -1069655 true "" "ask distributors with [ agent-name = \"distributor 106\" ]\n[ plot bun-hrw-conventional_inventory-current ]"
"conv-f" 1.0 0 -723837 true "" "ask distributors with [ agent-name = \"distributor 107\" ]\n[ plot bun-hrw-conventional_inventory-current ]"
"pen-2" 1.0 0 -5509967 true "" "ask distributors with [ agent-name = \"distributor 108\" ]\n[ plot bun-hrw-conventional_inventory-current ]"
"pen-3" 1.0 0 -8275240 true "" "ask distributors with [ agent-name = \"distributor 109\" ]\n[ plot bun-hrw-conventional_inventory-current ]"
"pen-4" 1.0 0 -5298144 true "" "ask distributors with [ agent-name = \"distributor 106\" ]\n[ plot wheat-hrw-conventional_inventory-current ]"
"pen-5" 1.0 0 -4079321 true "" "ask distributors with [ agent-name = \"distributor 107\" ]\n[ plot wheat-hrw-conventional_inventory-current ]"
"pen-6" 1.0 0 -14439633 true "" "ask distributors with [ agent-name = \"distributor 108\" ]\n[ plot wheat-hrw-conventional_inventory-current ]"
"pen-7" 1.0 0 -14070903 true "" "ask distributors with [ agent-name = \"distributor 109\" ]\n[ plot wheat-hrw-conventional_inventory-current ]"
"pen-8" 1.0 0 -7500403 true "" "plot 0"

PLOT
1164
17
1863
217
sum farmer inventories
Time
Inventory
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"r. conv-fresh" 1.0 0 -14439633 true "" "plot sum [wheat-hrw-conventional_inventory-current] of wheat_farmers"
"r. org-fresh" 1.0 0 -5509967 true "" "plot sum [wheat-hrw-organic_inventory-current] of wheat_farmers"
"p. conv-fresh" 1.0 0 -11783835 true "" "plot sum [wheat-snowmass-conventional_inventory-current] of wheat_farmers"
"p. org-fresh" 1.0 0 -6917194 true "" "plot sum [wheat-snowmass-organic_inventory-current] of wheat_farmers"

PLOT
1167
376
1513
526
mills conventional inventory
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
"shipper 104" 1.0 0 -5298144 true "" "ask wheat_mills with [ agent-name = \"mill 100\" ]\n[ plot wheat-hrw-conventional_inventory-current ]"
"shipper 105" 1.0 0 -4079321 true "" "ask wheat_mills with [ agent-name = \"mill 101\" ]\n[ plot wheat-hrw-conventional_inventory-current ]"
"shipper 106" 1.0 0 -14439633 true "" "ask wheat_mills with [ agent-name = \"mill 102\" ]\n[ plot wheat-hrw-conventional_inventory-current ]"
"shipper 107" 1.0 0 -14070903 true "" "ask wheat_mills with [ agent-name = \"mill 103\" ]\n[ plot wheat-hrw-conventional_inventory-current ]"

PLOT
1519
376
1867
526
mill assets
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
"pen-1" 1.0 0 -5298144 true "" "ask wheat_mills with [ agent-name = \"mill 100\" ]\n[ plot assets ]"
"pen-2" 1.0 0 -4079321 true "" "ask wheat_mills with [ agent-name = \"mill 101\" ]\n[ plot assets ]"
"pen-3" 1.0 0 -14439633 true "" "ask wheat_mills with [ agent-name = \"mill 102\" ]\n[ plot assets ]"
"pen-4" 1.0 0 -14070903 true "" "ask wheat_mills with [ agent-name = \"mill 103\" ]\n[ plot assets ]"
"pen-5" 1.0 0 -7500403 true "" "plot 0"

PLOT
1164
220
1510
370
elevators conventional inventory
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
"repacker 100" 1.0 0 -5298144 true "" "ask wheat_elevators with [ agent-name = \"elevator 96\" ]\n[ plot wheat-hrw-conventional_inventory-current ]"
"repacker 101" 1.0 0 -4079321 true "" "ask wheat_elevators with [ agent-name = \"elevator 97\" ]\n[ plot wheat-hrw-conventional_inventory-current ]"
"repacker 102" 1.0 0 -14439633 true "" "ask wheat_elevators with [ agent-name = \"elevator 98\" ]\n[ plot wheat-hrw-conventional_inventory-current ]"
"repacker 103" 1.0 0 -14070903 true "" "ask wheat_elevators with [ agent-name = \"elevator 99\" ]\n[ plot wheat-hrw-conventional_inventory-current ]"

PLOT
1516
220
1864
370
elevator assets
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
"pen-1" 1.0 0 -5298144 true "" "ask wheat_elevators with [ agent-name = \"elevator 96\" ]\n[ plot assets ]"
"pen-2" 1.0 0 -4079321 true "" "ask wheat_elevators with [ agent-name = \"elevator 97\" ]\n[ plot assets ]"
"pen-3" 1.0 0 -14439633 true "" "ask wheat_elevators with [ agent-name = \"elevator 98\" ]\n[ plot assets ]"
"pen-4" 1.0 0 -14070903 true "" "ask wheat_elevators with [ agent-name = \"elevator 99\" ]\n[ plot assets ]"
"pen-5" 1.0 0 -16777216 true "" "plot 0"

PLOT
1167
530
1515
680
bakers conventional inventory
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
"processor 108" 1.0 0 -1069655 true "" "ask wheat_bakers with [ agent-name = \"baker 104\" ]\n[ plot bun-hrw-conventional_inventory-current ]"
"processor 109" 1.0 0 -8275240 true "" "ask wheat_bakers with [ agent-name = \"baker 105\" ]\n[ plot bun-hrw-conventional_inventory-current ]"
"pen-2" 1.0 0 -5298144 true "" "ask wheat_bakers with [ agent-name = \"baker 106\" ]\n[ plot bun-hrw-conventional_inventory-current ]"
"pen-3" 1.0 0 -14070903 true "" "ask wheat_bakers with [ agent-name = \"baker 107\" ]\n[ plot bun-hrw-conventional_inventory-current ]"

PLOT
1519
532
1867
682
baker assets
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
"pen-1" 1.0 0 -5298144 true "" "ask wheat_bakers with [ agent-name = \"baker 104\" ]\n[ plot assets ]"
"pen-2" 1.0 0 -14070903 true "" "ask wheat_bakers with [ agent-name = \"baker 105\" ]\n[ plot assets ]"
"pen-3" 1.0 0 -7500403 true "" "plot 0"

SLIDER
12
101
257
134
market-knowledge
market-knowledge
.25
1
0.5
.25
1
NIL
HORIZONTAL

SLIDER
13
142
257
175
number-wheat_elevators
number-wheat_elevators
0
50
4.0
1
1
NIL
HORIZONTAL

TEXTBOX
2457
575
2607
603
Note: These two input values must add up to 1. 
11
0.0
1

INPUTBOX
2453
607
2602
667
percent-mills-to-distributors
0.5
1
0
Number

INPUTBOX
2453
669
2602
729
percent-mills-to-bakers
0.5
1
0
Number

SLIDER
13
179
257
212
number-wheat_bakers
number-wheat_bakers
2
10
2.0
1
1
NIL
HORIZONTAL

SLIDER
13
217
257
250
number-distributors
number-distributors
0
100
4.0
1
1
NIL
HORIZONTAL

SLIDER
12
258
258
291
number-households
number-households
0
500
250.0
1
1
NIL
HORIZONTAL

SWITCH
2799
608
2914
641
debug-mode
debug-mode
1
1
-1000

SWITCH
2917
608
3044
641
add-russet-o
add-russet-o
1
1
-1000

MONITOR
158
302
218
347
data-year
data-year
17
1
11

MONITOR
13
357
262
402
NIL
wheat-outside
0
1
11

MONITOR
2614
344
2745
389
NIL
meals-missed
17
1
11

MONITOR
2614
394
2861
439
NIL
conventional-spoiled-in-storage
0
1
11

MONITOR
2614
445
2861
490
NIL
organic-spoiled-in-storage
0
1
11

MONITOR
2614
495
2861
540
NIL
processed-spoiled-in-storage
0
1
11

MONITOR
2614
544
2861
589
NIL
servings-spoiled-in-storage
0
1
11

PLOT
13
457
262
610
total organic patches
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
"default" 1.0 0 -16777216 true "" "plot count patches with [ certified-organic = 1 ]"

PLOT
13
614
262
767
total patches in transition
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
"default" 1.0 0 -16777216 true "" "plot count patches with [ in-organic-transition = 1 ]"

MONITOR
13
407
262
452
total conventional patches
count patches with [ certified-organic = 0 ]
17
1
11

CHOOSER
272
847
492
892
display-style
display-style
"farm ownership" "wheat vs barley rotation" "organic vs conventional"
2

MONITOR
2614
295
2771
340
total processed servings
sum [bun-hrw-conventional_servings] of schools
17
1
11

SWITCH
2799
645
2914
678
add-purple-c
add-purple-c
1
1
-1000

SWITCH
2917
645
3044
678
add-purple-o
add-purple-o
1
1
-1000

PLOT
1167
838
1515
988
school sum servings
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
"conv-p" 1.0 0 -2674135 true "" "plot sum [bun-hrw-conventional_servings] of schools"
"conv-f" 1.0 0 -10899396 true "" "plot sum [wheat-hrw-conventional_servings] of schools"

PLOT
1520
840
1868
990
school mean cash
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
"default" 1.0 0 -16777216 true "" "plot mean [assets] of schools"

SWITCH
272
808
492
841
hide-turtles?
hide-turtles?
0
1
-1000

SLIDER
498
809
713
842
percent-transition
percent-transition
0
1
0.2
.1
1
NIL
HORIZONTAL

PLOT
1872
376
2224
526
mill price to buy
NIL
NIL
0.0
10.0
0.0
0.2
true
false
"" ""
PENS
"default" 1.0 0 -5298144 true "" "ask wheat_mills with [ agent-name = \"mill 100\" ]\n[ plot wheat-hrw-conventional_price-to-buy ]"
"pen-1" 1.0 0 -4079321 true "" "ask wheat_mills with [ agent-name = \"mill 101\" ]\n[ plot wheat-hrw-conventional_price-to-buy ]"
"pen-2" 1.0 0 -14439633 true "" "ask wheat_mills with [ agent-name = \"mill 102\" ]\n[ plot wheat-hrw-conventional_price-to-buy ]"
"pen-3" 1.0 0 -14070903 true "" "ask wheat_mills with [ agent-name = \"mill 103\" ]\n[ plot wheat-hrw-conventional_price-to-buy ]"

PLOT
1877
843
2231
993
school mean price to buy
NIL
NIL
0.0
10.0
0.0
2.0
true
false
"" ""
PENS
"default" 1.0 0 -14439633 true "" "plot mean [ wheat-hrw-conventional_price-to-buy ] of schools"
"pen-1" 1.0 0 -5298144 true "" "plot mean [ bun-hrw-conventional_price-to-buy ] of schools"

PLOT
1871
221
2224
371
elevator price to buy
NIL
NIL
0.0
10.0
0.0
0.2
true
false
"" ""
PENS
"default" 1.0 0 -5298144 true "" "ask wheat_elevators with [ agent-name = \"elevator 96\" ]\n[ plot wheat-hrw-conventional_price-to-buy ]"
"pen-1" 1.0 0 -4079321 true "" "ask wheat_elevators with [ agent-name = \"elevator 97\" ]\n[ plot wheat-hrw-conventional_price-to-buy ]"
"pen-2" 1.0 0 -14439633 true "" "ask wheat_elevators with [ agent-name = \"elevator 98\" ]\n[ plot wheat-hrw-conventional_price-to-buy ]"
"pen-3" 1.0 0 -14070903 true "" "ask wheat_elevators with [ agent-name = \"elevator 99\" ]\n[ plot wheat-hrw-conventional_price-to-buy ]"

PLOT
1874
533
2228
683
baker price to buy
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -5298144 true "" "ask wheat_bakers with [ agent-name = \"baker 104\" ]\n[ plot wheat-hrw-conventional_price-to-buy ]"
"pen-1" 1.0 0 -14070903 true "" "ask wheat_bakers with [ agent-name = \"baker 105\" ]\n[ plot wheat-hrw-conventional_price-to-buy ]"

PLOT
1874
688
2229
838
distributor price to buy
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -5298144 true "" "ask distributors with [ agent-name = \"distributor 106\" ]\n[ plot wheat-hrw-conventional_price-to-buy ]"
"pen-1" 1.0 0 -1069655 true "" "ask distributors with [ agent-name = \"distributor 106\" ]\n[ plot bun-hrw-conventional_price-to-buy ]"
"pen-2" 1.0 0 -4079321 true "" "ask distributors with [ agent-name = \"distributor 107\" ]\n[ plot wheat-hrw-conventional_price-to-buy ]"
"pen-3" 1.0 0 -723837 true "" "ask distributors with [ agent-name = \"distributor 107\" ]\n[ plot bun-hrw-conventional_price-to-buy ]"
"pen-4" 1.0 0 -14439633 true "" "ask distributors with [ agent-name = \"distributor 108\" ]\n[ plot wheat-hrw-conventional_price-to-buy ]"
"pen-5" 1.0 0 -5509967 true "" "ask distributors with [ agent-name = \"distributor 108\" ]\n[ plot bun-hrw-conventional_price-to-buy ]"
"pen-6" 1.0 0 -14070903 true "" "ask distributors with [ agent-name = \"distributor 109\" ]\n[ plot wheat-hrw-conventional_price-to-buy ]"
"pen-7" 1.0 0 -8275240 true "" "ask distributors with [ agent-name = \"distributor 109\" ]\n[ plot bun-hrw-conventional_price-to-buy ]"

SWITCH
2623
228
2800
261
gfpp?
gfpp?
1
1
-1000

SLIDER
719
809
934
842
years-in-model-run
years-in-model-run
3
20
10.0
1
1
years
HORIZONTAL

SLIDER
940
809
1157
842
years-of-data-collection
years-of-data-collection
0
years-in-model-run
2.0
1
1
years
HORIZONTAL

OUTPUT
13
779
263
952
11

SWITCH
2622
177
2800
210
baseline
baseline
0
1
-1000

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

model calendar is based on julian calendar weeks, from here: http://www.krisweb.com/biblio/trinity_cdfg_cdfg_xxxx_monitoring/9293mon/fta/chp2/app1.pdf

**potato production data/price sources:**

* a sack of potatoes (for use in calculating farmer input costs) is 100 pounds: https://www.ers.usda.gov/webdocs/publications/41880/33132_ah697_002.pdf?v=0
* operating costs for potato producers are $1922.98/acre, and $7.69 per sack, per CSU Extension (2015 irrigated potato budget for san luis valley)
* potato repacker.distributor sales price: summary stats for 20-years of AMS potato data (Table 4 in Erin's thesis)
* potato distributor sales price for processed potato: $1.01 --> price DPS pays for processed curly fries

**inventory data sources:**

* for potato farmers: SLV rough upper bound of annual production: 20mil CWT = 907184740 kg 

**demographic info (From 2017 USDA Census of Ag county profiles)**

* Alamosa county: https://www.nass.usda.gov/Publications/AgCensus/2017/Online_Resources/County_Profiles/Colorado/cp08003.pdf
* Rio Grande county: https://www.nass.usda.gov/Publications/AgCensus/2017/Online_Resources/County_Profiles/Colorado/cp08105.pdf
* Saguache county: https://www.nass.usda.gov/Publications/AgCensus/2017/Online_Resources/County_Profiles/Colorado/cp08109.pdf
* off-farm income: https://www.nass.usda.gov/Publications/AgCensus/2017/Full_Report/Volume_1,_Chapter_2_County_Level/Colorado/st08_2_0045_0045.pdf
* days worked off farm (not currently used, but here if we need/want it later):
    * tiers:  none, any, 1-49 days, 50-99 days, 100-199 days, 200+ days
    * alamosa: 201 306 43 34 45 184
    * rio grande: 224 246 46 16 24 160
    * saguache: 205 202 51 7 22 122 


**school info**

* 207 denver public schools: 57% elementary, 15% middle, 27% high schools --> per https://www.dpsk12.org/about/facts-figures/#1568924309847-7ded863d-5bce

**plot colors**

* fresh:
    * red: 14
    * yellow: 44
    * green: 64
    * blue: 104
* processed:
    * red: 18
    * yellow: 47
    * green: 68
    * blue: 97
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
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="test output" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>mean-potato-producer-inventory</metric>
    <metric>sum-potato-producer-inventory</metric>
    <metric>mean-potato-producer-cash</metric>
    <metric>sum-potato-producer-cash</metric>
    <metric>mean-potato-shipper-inventory</metric>
    <metric>sum-potato-shipper-inventory</metric>
    <metric>mean-potato-shipper-cash</metric>
    <metric>sum-potato-shipper-cash</metric>
    <metric>mean-potato-repacker-inventory</metric>
    <metric>sum-potato-repacker-inventory</metric>
    <metric>mean-potato-repacker-cash</metric>
    <metric>sum-potato-repacker-cash</metric>
    <metric>mean-potato-processor-inventory</metric>
    <metric>sum-potato-processor-inventory</metric>
    <metric>mean-potato-processor-cash</metric>
    <metric>sum-potato-processor-cash</metric>
    <metric>mean-distributor-inventory</metric>
    <metric>sum-distributor-inventory</metric>
    <metric>mean-distributor-cash</metric>
    <metric>sum-distributor-cash</metric>
    <metric>mean-school-inventory</metric>
    <metric>sum-school-inventory</metric>
    <metric>mean-school-cash</metric>
    <metric>sum-school-cash</metric>
  </experiment>
  <experiment name="2020-08-18 all-team scenarios" repetitions="2" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>mean-potato-producer-inventory</metric>
    <metric>sum-potato-producer-inventory</metric>
    <metric>mean-potato-producer-cash</metric>
    <metric>sum-potato-producer-cash</metric>
    <metric>mean-potato-shipper-inventory</metric>
    <metric>sum-potato-shipper-inventory</metric>
    <metric>mean-potato-shipper-cash</metric>
    <metric>sum-potato-shipper-cash</metric>
    <metric>mean-potato-repacker-inventory</metric>
    <metric>sum-potato-repacker-inventory</metric>
    <metric>mean-potato-repacker-cash</metric>
    <metric>sum-potato-repacker-cash</metric>
    <metric>mean-potato-processor-inventory</metric>
    <metric>sum-potato-processor-inventory</metric>
    <metric>mean-potato-processor-cash</metric>
    <metric>sum-potato-processor-cash</metric>
    <metric>mean-distributor-inventory</metric>
    <metric>sum-distributor-inventory</metric>
    <metric>mean-distributor-cash</metric>
    <metric>sum-distributor-cash</metric>
    <metric>mean-school-inventory</metric>
    <metric>sum-school-inventory</metric>
    <metric>mean-school-cash</metric>
    <metric>sum-school-cash</metric>
    <enumeratedValueSet variable="market-knowledge">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-transition">
      <value value="0.2"/>
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
