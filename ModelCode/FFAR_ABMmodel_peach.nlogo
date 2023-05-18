extensions [ matrix table GIS ]


__includes [ "peachMatrixToTableAPI.nls"  "peachStaticNames.nls"  "peachContractNegotiation.nls" "peachContractFulfillment.nls" "peachResetStorage.nls" ]


globals [

  ; kevin's variables
  county-load peach-patches-load conventional-mean-load organic-mean-load conventional-load organic-load ; all for loading GIS data

  data-year ;; added to differentiate the year needed for kevin's GIS rasters from the year tracker on the model interface

  total-current-year-peach-sales

  ;for output to excel
  peach-conventional-yield
  peach-conventional-value
  peach-organic-yield
  peach-organic-value

  output_peaches-conventional_inventory-current

  mean-peach-producer-inventory
  sum-peach-producer-inventory
  mean-peach-producer-cash
  sum-peach-producer-cash

  mean-peach-processor-inventory
  sum-peach-processor-inventory
  mean-peach-processor-cash
  sum-peach-processor-cash

  mean-distributor-inventory
  sum-distributor-inventory
  mean-distributor-cash
  sum-distributor-cash

  mean-school-inventory
  sum-school-inventory
  mean-school-cash
  sum-school-cash

  week                                                           ;; week in year the model is in
  year                                                           ;; year the model is in
  max-ticks

  number-peach_shippers
  number-peach_processors
  number-distributors
  school-count
  number-households
  market-knowledge
  packer ;; the farmer who is an outsource packer

  peach-fresh_hei
  iqf-conventional_hei


  ;; prices for all four potato varieties (avg and standard deviation)

  peach-conventional_price-farmgate-avg                  ;; .0963906, price per pount at farm gate
  peach-conventional_price-farmgate-stdev                ;; .0407041, standard deviation of farm gate price
  peach-organic_price-farmgate-avg                       ;; TBD   Not known at this time
  peach-organic_price-farmgate-stdev                     ;; TBD

  iqf-conventional_price-wholesale-avg                   ;; 1.01, price per pound to school
  peach-conventional_price-wholesale-avg                 ;; .35, price per pound
  peach-organic_price-wholesale-avg                      ;; TBD
  sd-wholesale                                                   ;; .051175, standard deviation of both manufactured (fresh and processed) potato product prices

  ; prices for peaches NOT sold to/at school --> ex: at farmer's markets (from martha sullins' data)
  iqf-conventional_price-retail-avg
  peach-conventional_price-retail-avg                    ;; $3.20/lb
  peach-organic_price-retail-avg
  sd-retail                                              ;; $1.223585/lb

  ;; buckets for counting

  meals-missed                                                   ;; tally of meals when there wasn't enough food to feed someone (mostly for debugging)
  peaches-outside                                               ;; potatoes sent outside the system (no capacity for them in the model world)
  conventional-spoiled-in-storage                                ;; potatoes left in storage at end of each year, presumed to have spoiled
  organic-spoiled-in-storage
  iqf-spoiled-in-storage
  servings-spoiled-in-storage                                       ;; number of servings left at end of year

  peach-table_conventional                                                   ;; potato contracting tables
  peach-table_organic

  ;; francesco's wizardly integration section
  workspace
  osSeparator
  paramDir
  outputDir
]


breed [peach_farmers peach_farmer]
breed [peach_processors peach_processor]
breed [peach_altmarks peach_altmark]                             ;; alternative market (e.g. farmer's market) for peach sales
breed [distributors distributor]
breed [schools school]
breed [households household]


patches-own

[
  county-peach                                                   ;; numerical county id, from raster
  county-peach-name                                              ;; text name of county
  peach-yes-no                                                   ;; whether patch grows potatoes
  peach-conventional-mean-yield                                  ;; from DSSAT, mean potential yield in kg/ha from 38 years
  peach-organic-mean-yield                                       ;; from DSSAT, mean potential yield in kg/ha from 38 years
  peach-conventional-current-yield                               ;; from DSSAT, this year's potential yield in kg/ha
  peach-organic-current-yield                                    ;; from DSSAT, this year's potential yield in kg/ha
  occupied                                                       ;; whether patch is owned/occupied by a potato farm
  farmer                                                         ;; id of farm that occupies patch
  certified-organic                                              ;; if patch is certified organic
  remainder-patch                                                ;; patch that is planted to the remainder of potatoes, e.g. if farm has 250 hectares of potatoes, this patch grows the 50
  organic-conversion-tracker                                     ;; tracks number of years spent converting a patch from conventional to organic use
  in-organic-transition                                          ;; tracks whether or not the patch is in the process of transitioning to organic --> 1 = yes
]


peach_farmers-own [

  id
  agent-name
  assets
  home-county                                                    ;; home county id of farmer
  hectares-farmed-peaches                                       ;; total hectares farmed in potatoes
  hectares-farmed-total                                          ;; total hectares farmed potatoes and barley
  initialized                                                    ;; whether initialized yet in setup
  patches-occupied                                               ;; how many 100-ha patches farm occupies
  farm-id                                                        ;; unique identifier --> CAN GET RID OF THIS SINCE WE COVER IT IN STEF/ERIN MODEL
  grows-organic                                                  ;; yes/no on whether has certified organic land
  fully-organic                                                   ;; 1 if all farmer's patches are organic, 0 otherwise
  loyalty-to-buyer-id                                            ;; id number of buying agent that farmer prefers to sell to based on loyalty from previous year's relationship

  conventional-current-production                               ;; total of this year's production of potatoes in kg
  conventional-current-value                                    ;; value of this year's production of potatoes, based on slider input --> UPDATE WITH ECONOMIC DATA FROM STEF/ERIN MODEL
  organic-current-production                           ;; this is what the land produces annually, so we may want to factor in waste at a later step
  organic-current-value                                ;; --> UPDATE WITH ECONOMIC DATA FROM STEF/ERIN MODEL
  total-peach-current-value                                     ;; sum of all potato production ; --> UPDATE WITH ECONOMIC DATA FROM STEF/ERIN MODEL
  patches-in-peaches                                            ;; number of patches needed to grow potatoes based on hectares of potatoes they grow- for rotation

  peaches-conventional_inventory-current           ;; total inventory (in pounds) of conventional russet potatoes
  peaches-conventional_inventory-maximum
  peaches-conventional_price-to-sell
  peaches-conventional_price-to-buy
  peach-farmers_yield-estimated_conventional
  peaches-conventional_contract-space-available
  peaches-conventional_my-incoming-total
  peaches-conventional_promised                    ;; how many potatoes of this type have been contracted away (to compare against how many are available, so the agent doesn't promise more than it has)

  peaches-organic_inventory-current                ;; total inventory (in pounds) of organic russet potatoes
  peaches-organic_inventory-maximum
  peaches-organic_price-to-sell
  peaches-organic_price-to-buy
  peach-farmers_yield-estimated_organic
  peaches-organic_contract-space-available
  peaches-organic_my-incoming-total
  peaches-organic_promised

  iqf-conventional_inventory-current
  iqf-conventional_inventory-maximum
  iqf-conventional_price-to-sell
  iqf-conventional_price-to-buy
  iqf-peach-farmers_yield-estimated_conventional
  iqf-conventional_contract-space-available
  iqf-conventional_promised

  iqf-organic_inventory-current
  iqf-organic_inventory-maximum
  iqf-organic_price-to-sell
  iqf-organic_price-to-buy
  iqf-peach-farmers_yield-estimated_organic
  iqf-organic_contract-space-available
  iqf-organic_promised

; socio-cultural decision-making variables
  transition-likelihood-score
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


peach_processors-own[

  id
  agent-name
  assets
  loyalty-to-buyer-id                                            ;; id number of buying agent that processor prefers to sell to based on loyalty from previous year's relationship

  iqf-conventional_inventory-current
  iqf-conventional_inventory-maximum
  iqf-conventional_price-to-sell
  iqf-conventional_price-to-buy
  iqf-peach-farmers_yield-estimated_conventional
  iqf-conventional_contract-space-available
  iqf-conventional_promised
  iqf-conventional_my-incoming-total

  iqf-organic_inventory-current
  iqf-organic_inventory-maximum
  iqf-organic_price-to-sell
  iqf-organic_price-to-buy
  iqf-peach-farmers_yield-estimated_organic
  iqf-organic_contract-space-available
  iqf-organic_promised
  iqf-organic_my-incoming-total

  ]


peach_altmarks-own [

  id
  agent-name
  assets
  loyalty-to-buyer-id                                            ;; id number of buying agent that distributor prefers to sell to based on loyalty from previous year's relationship

  out-of-state-peach_inventory-current
  out-of-state-peach_price-to-buy
  out-of-state-peach_price-to-sell

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

  iqf-conventional_inventory-current
  iqf-conventional_inventory-maximum
  iqf-conventional_price-to-buy
  iqf-conventional_price-to-sell
  iqf-conventional_contract-space-available
  iqf-conventional_promised
  iqf-conventional_my-incoming-total
 ]


distributors-own [

  id
  agent-name
  assets
  loyalty-to-buyer-id                                            ;; id number of buying agent that distributor prefers to sell to based on loyalty from previous year's relationship

  out-of-state-peach_inventory-current
  out-of-state-peach_price-to-buy
  out-of-state-peach_price-to-sell

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

  iqf-conventional_inventory-current
  iqf-conventional_inventory-maximum
  iqf-conventional_price-to-buy
  iqf-conventional_price-to-sell
  iqf-conventional_contract-space-available
  iqf-conventional_promised
  iqf-conventional_my-incoming-total
 ]


schools-own [

  id
  agent-name
  school-type
  assets
  loyalty-to-seller-id                                            ;; id number of selling agent that school prefers to buy from based on loyalty from previous year's relationship

  out-of-state-peach_inventory-current
  out-of-state-peach_inventory-maximum
  out-of-state-peach_price-to-buy

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

  iqf-conventional_inventory-current
  iqf-conventional_inventory-maximum
  iqf-conventional_price-to-buy
  iqf-conventional_contract-space-available
  iqf-conventional_my-incoming-total

  peach-conventional_servings                    ;; current inventory of fresh russet conventional potatoes (in individual servings)
  peach-organic_servings                         ;; current inventory of fresh russet organic potatoes (in individual servings)
  peach-iqf-servings                ;; current inventory of processed russet conventional potatoes (in individual servings)
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
  setup-peach_farmers
  setup-certified-organic
  setup-display
  setup-peach_processors
  setup-distributors
  setup-schools
  setup-households
  setup-estimated-yields
  set peach-table_conventional table:make
  set peach-table_organic table:make
  set peach-fresh_hei 25                                     ;; per https://epi.grants.cancer.gov/hei/developing.html vegetables are worth a max of 5 points if ≥1.1 cup equiv. per 1,000 kcal
  set iqf-conventional_hei 0                     ;; per https://epi.grants.cancer.gov/hei/developing.html empty calories are worth a max of 20 points if held to less than 19% of total energy --> a score of zero is earned if empty calories are over 50% of total energy --> i've estiamted a processed potato to be very unhealthy, and given it 0 points from this category
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
  set peach-patches-load gis:load-dataset "potato_patches.asc"; load patches where potato production occurred any year 2011-2017 re: Colorado DNR Water Resource Division. Compared against DSSAT, removed <10 patches
  set conventional-mean-load gis:load-dataset "mean_canela.asc"; load mean canela russet yield 1980-2018 DSSAT, kgs per ha
  set organic-mean-load gis:load-dataset "mean_canela_org.asc"
  gis:set-world-envelope-ds gis:envelope-of county-load
  gis:apply-raster county-load county-peach
  gis:apply-raster peach-patches-load peach-yes-no
  gis:apply-raster conventional-mean-load peach-conventional-mean-yield
  gis:apply-raster organic-mean-load peach-organic-mean-yield

  ask patches with [peach-yes-no = 1]
  [if county-peach = 4 [set peach-yes-no 0]]; fix couple of patches that fall outside border (right on border but resolution puts them outside)

ask patches
  [
    if county-peach = 1 [set pcolor 9 set county-peach-name "Alamosa"]
    if county-peach = 2 [set pcolor 8 set county-peach-name "Rio Grande"]
    if county-peach = 3 [set pcolor 7 set county-peach-name "Saguache"]
    if county-peach = 4 [set pcolor 9.9 set county-peach-name "NA"]
    if peach-yes-no = 1 [set pcolor 9.9]
    if pycor = 0 [set pcolor 9.9]
  ]

end


;SETUP PARAMETERS
to setup-parameters

  ;; farmgate prices

  set peach-conventional_price-farmgate-avg .0963906                      ;; .0963906, price per pount at farm gate
  set peach-conventional_price-farmgate-stdev .0407041                    ;; .0407041, standard deviation of farm gate price

  set peach-organic_price-farmgate-avg .1927812                           ;; TBD! for now just 2 x conventional
  set peach-organic_price-farmgate-stdev .0407041                         ;; TBD! for now just same as conventional

  ;; wholesale prices

  set iqf-conventional_price-wholesale-avg 1.01                     ;; 1.01, price per pound to distributor
  set peach-conventional_price-wholesale-avg .35                          ;; .35, price per pound
  set peach-organic_price-wholesale-avg .7                                ;; TBD! for now 2 x conventional
  set sd-wholesale .051175                                                       ;; .051175, standard deviation of both manufactured (fresh and processed) potato product prices

  set number-peach_shippers 4
  set number-peach_processors 2
  set number-distributors 4
  set school-count 207
  set number-households 250
  set market-knowledge .5

end


to setup-peach_farmers

  ;; -------------------------------------------------

  ;; initialize peach producers by county

  ;; REDO THIS BASED ON PROPORTIONAL PEACH AMOUNTS

  ask patches [ set farmer -1 ]
  create-peach_farmers 26; Delta County
  [
    set home-county 1
    set initialized 0
    set id who
    set agent-name word "Delta peach farmer " id
  ]

    ask n-of 5 peach_farmers with [initialized = 0]; set parameters for farms farming between 100 and 250 acres of potatoes per year
     [
      set hectares-farmed-peaches random-normal 175 25 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "small"
     ]
    ask n-of 11 peach_farmers with [initialized = 0]; set parameters for farms farming between 250 and 500 acres of potatoes per year
     [
      set hectares-farmed-peaches random-normal 375 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 3 peach_farmers with [initialized = 0]; set parameters for farms farming between 500 and 750 acres of potatoes per year
     [
      set hectares-farmed-peaches random-normal 625 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 3 peach_farmers with [initialized = 0]; set parameters for farms farming between 750 and 1000 acres of potatoes per year
     [
      set hectares-farmed-peaches random-normal 875 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 4 peach_farmers with [initialized = 0]; set parameters for farms farming >1000 acres
     [
      set hectares-farmed-peaches random-normal 1601 100 * 0.405 ; assign acreage and convert to hectares of potatoes per year
      set initialized 1
      set farm-size "large"
     ]

  create-peach_farmers 41; Mesa County
  [
    set home-county 2
    set initialized 0
    set id who
    set agent-name word "Mesa peach farmer " id
  ]

  ask n-of 21 peach_farmers with [initialized = 0]; set parameters for farms farming between 100 and 250 acres of potatoes per year
     [
      set hectares-farmed-peaches random-normal 175 25 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "small"
     ]
    ask n-of 10 peach_farmers with [initialized = 0]; set parameters for farms farming between 250 and 500 acres of potatoes per year
     [
      set hectares-farmed-peaches random-normal 375 41.67 * 0.405 ; assign acreage and convert to hectares
      set hectares-farmed-total hectares-farmed-peaches
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 4 peach_farmers with [initialized = 0]; set parameters for farms farming between 500 and 750 acres of potatoes per year
     [
      set hectares-farmed-peaches random-normal 625 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 3 peach_farmers with [initialized = 0]; set parameters for farms farming between 750 and 1000 acres of potatoes per year
     [
      set hectares-farmed-peaches random-normal 875 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 3 peach_farmers with [initialized = 0]; set parameters for farms farming >1000 acres of potatoes per year
     [
      set hectares-farmed-peaches random-normal 1561 100 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "large"
     ]

  ;; set largest farmer to be the farm that is packing for others
  ;; set smallest 50% of farms in the medium size range to become split-packers (both self pack and outsource packing)

  ask max-one-of peach_farmers [hectares-farmed-peaches] [ set outsource-packer 1 ]
  set packer peach_farmers with [ outsource-packer = 1 ]

  let medium-farmers ( peach_farmers with [ farm-size = "medium" ] )
  let half-mediums round ( ( count medium-farmers ) / 2 )
  let split-packers min-n-of half-mediums medium-farmers [ hectares-farmed-peaches ]
  ask split-packers [ set split-pack 1 ]


  ;; -------------------------------------------------

  ;; set general potato producer variables

  ask peach_farmers
  [
    set assets 10000 ; probably need to make this starting amount more realistic
    set loyalty-to-buyer-id 0
    set peaches-conventional_inventory-maximum 450000000
    set peaches-conventional_price-to-sell precision (random-normal peach-conventional_price-farmgate-avg peach-conventional_price-farmgate-stdev)  3  ; do we need to update this price variable every season?
    set hectares-farmed-peaches round hectares-farmed-peaches
    set hectares-farmed-total hectares-farmed-peaches
    set farm-id who
    set color green
    set shape "circle"
    set size 0.5
    set patches-occupied round (hectares-farmed-total / 100 - 0.5) + 1 ; results in number of patches owned equal to rounded up to next highest hundred hectares / 100
    move-to one-of patches with [county-peach = [home-county] of myself] with [peach-yes-no = 1]
    ask min-n-of (patches-occupied) patches with [peach-yes-no = 1] with [occupied = 0] [distance myself]; settling on correct number of patches-
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

  ;; set peach producer demographics

  ;; delta county
  let delta-farmers peach_farmers with [ home-county = 1 ]
  let farmer-number count delta-farmers
  ask n-of ( round ( farmer-number * .5656 ) ) delta-farmers [ set male-gender 1 ]
  ask n-of ( round ( farmer-number * .3368 ) ) delta-farmers [ set first-time-farmer 1 ]
  ask n-of ( round ( farmer-number * .0818 ) ) delta-farmers [ set young-farmer 1 ]
  ask n-of ( round ( farmer-number * .0224 ) ) delta-farmers [ set not-white 1 ]

  ;; mesa county
  let mesa-farmers peach_farmers with [ home-county = 2 ]
  set farmer-number count mesa-farmers
  ask n-of ( round ( farmer-number * .5578 ) ) mesa-farmers [ set male-gender 1 ]
  ask n-of ( round ( farmer-number * .3335 ) ) mesa-farmers [ set first-time-farmer 1 ]
  ask n-of ( round ( farmer-number * .0745 ) ) mesa-farmers [ set young-farmer 1 ]
  ask n-of ( round ( farmer-number * .0190 ) ) mesa-farmers [ set not-white 1 ]


  ;; -------------------------------------------------

  ;; test sub-procedure for adding farmer risk tolerance
  ;; risk aversion is set from 0 - 1 --> 1 is LEAST tolerant of risk (assume smaller farms are more willing to take risks)
  ;; factors that currently increase risk aversion: male-gender, not-white

  ask peach_farmers [
    let max-farm max-one-of peach_farmers [ hectares-farmed-peaches ]
    let max-farm-hectares [ hectares-farmed-peaches ] of max-farm
    set transition-likelihood-score ( .5 - (hectares-farmed-peaches / max-farm-hectares ))
    if male-gender = 0 [
      set transition-likelihood-score ( transition-likelihood-score * 1.1 ) ]
    if first-time-farmer = 1 [
      set transition-likelihood-score ( transition-likelihood-score * 1.1 ) ]
    if young-farmer = 1 [
      set transition-likelihood-score ( transition-likelihood-score * 1.1 ) ]
    if not-white = 1 [
      set transition-likelihood-score ( transition-likelihood-score * 1.1 ) ]
    if transition-likelihood-score > 1 [ set transition-likelihood-score 1 ]
    if transition-likelihood-score < 0 [ set transition-likelihood-score 0 ]

    ifelse ( male-gender = 1 ) and ( not-white = 0 ) [
        if (( male-gender + first-time-farmer + young-farmer + not-white ) / 4 ) > .25
          [ set alternative-farmer 1 ] ] [
        if (( male-gender + first-time-farmer + young-farmer + not-white ) / 4 ) > .0
          [ set alternative-farmer 1 ] ] ]

  ;; -------------------------------------------------

  ; initialize crop rotations

  ask peach_farmers
  [
    set patches-in-peaches round (hectares-farmed-peaches / 100 + 0.5) ;; leaving this line in case it does anything functional, but removed the rest of this section
  ]

end


;*************************
; SETUP CERTIFIED ORGANIC
; ************************
to setup-certified-organic

  ask n-of (0.007 * round count patches with [occupied = 1]) patches with [occupied = 1]; updated based on erin math
  [set certified-organic 1]
  ask peach_farmers
  [
  ifelse sum [certified-organic] of patches with [farmer = [farm-id] of myself] > 0 ; set turtle variable to identify whether peach-farm has any cert. organic land
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

  if display-style = "organic vs conventional"
  [
    ask patches with [ occupied = 1 ]
    [
      if certified-organic = 0 [ set pcolor 36 ]
      if in-organic-transition = 1 [ set pcolor 56 ]
      if certified-organic = 1 [ set pcolor 62 ]
    ]
  ]

  if display-style = "farm size/ideology"
  [
    ask peach_farmers
    [ let my-patches patches with [ farmer = [ farm-id ] of myself ]
      if ( farm-size = "small" and alternative-farmer = 0 )  [ ask my-patches [set pcolor 63 ] ]
      if ( farm-size = "small" and alternative-farmer = 1 ) [ ask my-patches [set pcolor 67 ] ]
      if ( farm-size = "medium" and alternative-farmer = 0 ) [ ask my-patches [set pcolor 94 ] ]
      if ( farm-size = "medium" and alternative-farmer = 1 ) [ ask my-patches [set pcolor 97 ] ]
      if ( farm-size = "large" and alternative-farmer = 0 ) [ ask my-patches [set pcolor 14 ] ]
      if ( farm-size = "large" and alternative-farmer = 1 ) [ ask my-patches [set pcolor 17 ] ]
    ]
  ]

end


to setup-peach_processors

  create-peach_processors number-peach_processors
  [
    set heading 0
    setxy random max-pxcor random max-pycor
    set shape "house"
    set size 2
    set color orange
    set id who
    set agent-name word "processor " id
    set assets 10000

    set iqf-conventional_inventory-maximum 200000000
    set iqf-organic_inventory-maximum 200000000
    set iqf-conventional_inventory-maximum 200000000

    set iqf-conventional_price-to-buy precision (random-normal peach-conventional_price-wholesale-avg sd-wholesale) 2
    if iqf-conventional_price-to-buy < peach-conventional_price-farmgate-avg [ set peaches-conventional_price-to-buy peach-conventional_price-farmgate-avg ]

    if debug-mode = TRUE [
     print "processor conventional russet fresh price to buy"
     print iqf-conventional_price-to-buy ]

    if hide-turtles? = TRUE [ ht ]
  ]

end


to setup-peach_altmarks

  set-default-shape distributors "plant"
  create-peach_altmarks 60
  [
    setxy random max-pxcor random max-pycor
    set size 2
    set color green
    set id who
    set agent-name word "alternative market " id
    set assets 10000

    set peaches-conventional_inventory-maximum 4500
    set peaches-organic_inventory-maximum 4500


    set peaches-conventional_price-to-buy precision ( random-normal peach-conventional_price-wholesale-avg sd-wholesale ) 2
    if peaches-conventional_price-to-buy < peach-conventional_price-farmgate-avg [ set peaches-conventional_price-to-buy peach-conventional_price-farmgate-avg ]

    set iqf-conventional_price-to-buy precision ( ( random-normal peach-conventional_price-wholesale-avg sd-wholesale ) * 1.6 ) 2
    if iqf-conventional_price-to-buy < ( peach-conventional_price-wholesale-avg * 1.25 ) [ set iqf-conventional_price-to-buy ( peach-conventional_price-wholesale-avg * 1.25 ) ]

    if debug-mode = TRUE [
      print "distributor conventional russet fresh price to buy"
      print peaches-conventional_price-to-buy ]

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

    set peaches-conventional_inventory-maximum 1000000000000
    set iqf-conventional_inventory-maximum 1000000000000

    set peaches-conventional_price-to-buy precision ( random-normal peach-conventional_price-wholesale-avg sd-wholesale ) 2
    if peaches-conventional_price-to-buy < peach-conventional_price-farmgate-avg [ set peaches-conventional_price-to-buy peach-conventional_price-farmgate-avg ]

    set iqf-conventional_price-to-buy precision ( ( random-normal peach-conventional_price-wholesale-avg sd-wholesale ) * 1.6 ) 2
    if iqf-conventional_price-to-buy < ( peach-conventional_price-wholesale-avg * 1.25 ) [ set iqf-conventional_price-to-buy ( peach-conventional_price-wholesale-avg * 1.25 ) ]

    if debug-mode = TRUE [
      print "distributor conventional russet fresh price to buy"
      print peaches-conventional_price-to-buy ]

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

    set peaches-conventional_inventory-maximum 10
    set iqf-conventional_inventory-maximum 10
    set peaches-organic_inventory-maximum 10

    if debug-mode = TRUE [
      print "school conventional russet fresh price to buy"
      print peaches-conventional_price-to-buy ]

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

    set peaches-conventional_inventory-maximum 10
    set iqf-conventional_inventory-maximum 10
    set peaches-organic_inventory-maximum 10

    if debug-mode = TRUE [
      print "school conventional russet fresh price to buy"
      print peaches-conventional_price-to-buy ]

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

    set peaches-conventional_inventory-maximum 10
    set iqf-conventional_inventory-maximum 10
    set peaches-organic_inventory-maximum 10

     if debug-mode = TRUE [
       print "school conventional russet fresh price to buy"
       print peaches-conventional_price-to-buy ]

    if hide-turtles? = TRUE [ ht ]
  ]

  ask schools [
   set peaches-conventional_price-to-buy precision ( random-normal .5 sd-wholesale ) 2
   if peaches-conventional_price-to-buy < peach-conventional_price-wholesale-avg [ set peaches-conventional_price-to-buy peach-conventional_price-wholesale-avg ]

   set iqf-conventional_price-to-buy precision ( random-normal iqf-conventional_price-wholesale-avg sd-wholesale ) 2
   if iqf-conventional_price-to-buy < ( peach-conventional_price-wholesale-avg * 1.25 ) [ set iqf-conventional_price-to-buy ( peach-conventional_price-wholesale-avg * 1.25 ) ] ]

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
;;  set iqf-conventional_price-wholesale-avg 1.01
;;  set peach-conventional_price-wholesale-avg .35
;;  set peach-organic_price-wholesale-avg .7                              ;; this is an arbitrary price - real-world data to come
;;end


to setup-estimated-yields

  ask peach_farmers [
    let f-id  farm-id

    ; All conventional potatoes, creating p-set0 and p-set1 based on, ultimately, remainder-patch (i.e., 0 or 1)
    let p-set patches with [ farmer = f-id ]
    set p-set p-set with [ certified-organic = 0 ]
    let p-set0 p-set with [ remainder-patch = 0 ]
    let p-set1 p-set with [ remainder-patch = 1 ]

    ; Russet conventional
    set peach-farmers_yield-estimated_conventional  sum [ peach-conventional-mean-yield ] of p-set0 * 100
    set peach-farmers_yield-estimated_conventional  peach-farmers_yield-estimated_conventional + ( sum [ peach-conventional-mean-yield ] of p-set1 * ( hectares-farmed-peaches - ( 100 * ( patches-in-peaches - 1 ) ) ) )
    set peach-farmers_yield-estimated_conventional  2.20462 * peach-farmers_yield-estimated_conventional

    ; All organic potatoes, creating p-set0 and p-set1 based on, ultimately, remainder-patch (i.e., 0 or 1)
    set p-set patches with [ farmer = f-id ]
    set p-set p-set with [ certified-organic = 1 ]
    set p-set0 p-set with [ remainder-patch = 0 ]
    set p-set1 p-set with [ remainder-patch = 1 ]

      ; Russet organic
    set peach-farmers_yield-estimated_organic  sum [ peach-organic-mean-yield ] of p-set0 * 100
    set peach-farmers_yield-estimated_organic  peach-farmers_yield-estimated_organic + ( sum [ peach-organic-mean-yield ] of p-set1 * ( hectares-farmed-peaches - ( 100 * ( patches-in-peaches - 1 ) ) ) )
    set peach-farmers_yield-estimated_organic  2.20462 * peach-farmers_yield-estimated_organic
  ]

end


to go

  if ticks > max-ticks [ stop ]
  manage-dates
  if ( week = 26 ) and ( year != 1 ) [
    profitability-check
    transition-patches
    update-organic
    update-display ]
  if week = 26 [ setup-estimated-yields ]
  if week = 26  [
    reset-promised-amounts
    table:clear peach-table_conventional
    table:clear peach-table_organic
    set-contracts_conventional
    set-contracts_organic
  ]
  if week = 27 [
    produce-peaches
    output-print data-year ]    ; tracker for debugging
  if ( week >= 29 ) and ( week <= 37 ) [
    update-inventories
    fulfill-contracts
    process-peaches
    fulfill-processor-contracts
    ]
  if ( week >= 29 and week <= 37 ) [ reset-storage ]
  ;  pillar 3 confusion begins here
  if baseline = TRUE [
    if ((week > 33) and (week < 47)) or ((week > 47) and (week < 52)) or ((week > 2) and (week < 13)) or ((week > 13) and (week < 22))
    [school-purchases-baseline-french-fries]
  ]
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

to profitability-check
ask peach_farmers [
    let predicted-org-profit 0
    let predicted-conv-profit 0

    if farm-transitioning = 1 [
      update-tls
      transition-patches
    ]

    if farm-transitioning = 0
    [
      ;basic-profitability-calculation
      let estimated-conv-yield 2.20462 * (mean [peach-conventional-mean-yield] of patches with [farmer = [farm-id] of myself] * hectares-farmed-peaches)  ;; 1 kg = 2.20462 lbs. so the above shows the yield in lbs.
      let conventional-revenue-for-conv-calc (estimated-conv-yield * peach-conventional_price-farmgate-avg * organic-planning-horizon)
      let conventional-costs (estimated-conv-yield * conv-input-price-per-lb * organic-planning-horizon)
       ; ^ running into same hectares vs. lbs for input price issue from other parts of the model
      set predicted-conv-profit (conventional-revenue-for-conv-calc - conventional-costs)

      ;organic-profitability-calculation
      let estimated-org-yield 2.20462 * (mean [peach-organic-mean-yield] of patches with [farmer = [farm-id] of myself] * hectares-farmed-peaches)
      let conventional-revenue-for-org-calc (estimated-org-yield * peach-organic_price-farmgate-avg * 3)  ; get organic yields even though getting conventional price per lb.
      let organic-revenue (estimated-org-yield * peach-organic_price-farmgate-avg * (organic-planning-horizon - 3))
      let organic-costs (estimated-org-yield * org-input-price * organic-planning-horizon)
      ; ^ running into same hectares vs. lbs for input price issue from other parts of the model
      set predicted-org-profit (conventional-revenue-for-org-calc + organic-revenue - organic-costs)

      if (farm-size = "small") or (farm-size = "medium")
        [ ifelse predicted-org-profit > predicted-conv-profit
          ; probably it makes sense to compare conventional profit to organic profit, not just is organic profit greater than 0, so including both calcs for a comparison of
          ; org vs. conventional profitability
          [ ;print "organic profitable"
            update-tls
            transition-patches
          ]
          [ ;print "organic unprofitable"
            set transition-likelihood-score (transition-likelihood-score - (.025 * transition-likelihood-score) )
            update-tls
            transition-patches
          ]
        ]

        if farm-size = "large"
          [ if predicted-org-profit > predicted-conv-profit
            [ ;print "large profitable"
              let my-patches patches with [ farmer = [ farm-id ] of myself ]
              let patches-conventional my-patches with [ certified-organic =  0  and in-organic-transition = 0 ]
              let conversion-patches n-of 1 patches-conventional
              ask conversion-patches [
                set in-organic-transition 1
              set organic-conversion-tracker 1 ]
              set farm-transitioning 1
;              ifelse patches-organic = my-patches
;                [set fully-converted 1]
;                [set fully-converted 0]
            ]
           ;don't transition anything if not profitable: just end procedure
        ]
      ]


;    print " "
;    print "mean TLS"
;    print mean [transition-likelihood-score ] of peach_farmers
;    print count peach_farmers with [ transition-likelihood-score >= .5 ]
;    print " "
;    print transition-likelihood-score
    ]
end


to breakeven-calculation

end


to update-tls

    first-time-farmer-update
    neighbor-update
    bad-harvest-update

  if transition-likelihood-score > 1 [ set transition-likelihood-score 1 ]
  if transition-likelihood-score < 0 [ set transition-likelihood-score 0 ]

end


to first-time-farmer-update
  ; update new farmer status and TLS after year 5 of model
    if ( first-time-farmer = 1 ) and ( year > 5 ) [
      set first-time-farmer 0
      set transition-likelihood-score ( transition-likelihood-score - ( transition-likelihood-score * .1 ) )
      if transition-likelihood-score > 1 [ set transition-likelihood-score 1 ]
      if transition-likelihood-score < 0 [ set transition-likelihood-score 0 ]
      ]
  ; update alternative/mainstream status after new farmer demographic update
    ifelse ( male-gender = 1 ) and ( not-white = 0 ) [
      if (( male-gender + first-time-farmer + young-farmer + not-white ) / 4 ) > .25
        [ set alternative-farmer 1 ] ] [
      if (( male-gender + first-time-farmer + young-farmer + not-white ) / 4 ) > .0
        [ set alternative-farmer 1 ] ]
end


; do we want to make it such that small/medium and large farms tend to have different "network" sizes?
to neighbor-update

  if ( farm-size = "small" ) or ( ( farm-size = "medium" ) and (alternative-farmer = 1 ) ) [
    let not-me other peach_farmers
    let nearest-neighbors ( min-n-of 3 not-me [distance myself] )
    let like-neighbors ( nearest-neighbors with [ ( farm-size = "small" ) or ( ( farm-size = "medium" ) and ( alternative-farmer = 1 ) ) ] )
;    print id
;    print [ id ] of like-neighbors
    if any? like-neighbors [
      if sum [ farm-transitioning ] of like-neighbors = 1 [
        set transition-likelihood-score ( transition-likelihood-score + ( transition-likelihood-score * .1 ) )
      ]
      if sum [ farm-transitioning ] of like-neighbors > 1 [
        set transition-likelihood-score ( transition-likelihood-score + ( transition-likelihood-score * .2 ) )
      ]
    ]
  ]

  if ( farm-size = "large" ) or ( ( farm-size = "medium" ) and (alternative-farmer = 0 ) ) [
    let not-me other peach_farmers
    let nearest-neighbors ( min-n-of 3 not-me [distance myself] )
;    print id
;    print [ id ] of like-neighbors
    if sum [ farm-transitioning ] of nearest-neighbors = 1 [
      set transition-likelihood-score ( transition-likelihood-score - ( transition-likelihood-score * .1 ) )
    ]
    if sum [ farm-transitioning ] of nearest-neighbors > 1 [
      set transition-likelihood-score ( transition-likelihood-score - ( transition-likelihood-score * .2 ) )
    ]
  ]

end


to bad-harvest-update

  if this-year-bad-production-year  = 1 [
    set transition-likelihood-score ( transition-likelihood-score + .1 * transition-likelihood-score )]

  if this-year-mediocre-production-year = 1 [
    set transition-likelihood-score ( transition-likelihood-score + .025 * transition-likelihood-score )
  ]

end


to transition-patches
;want to include a years-until-breakeven calculation in the procedure above or in its own procedue
;need to round to nearest integer and use algebra to come up with formula where x = years until breakeven and set that formula equal to the years-until-breakeven variable

  ask peach_farmers [

    ;transition into organic
    if transition-likelihood-score >= .5 [
      let my-patches patches with [ farmer = [ farm-id ] of myself ]
      let patches-organic my-patches with [ certified-organic = 1 ]
      let patches-conventional my-patches with [ certified-organic =  0  and in-organic-transition = 0 ]

      if ( count patches-conventional ) > 0 [
        let patches-org count patches-organic
        let patches-all count my-patches
        let organic-percentage ( patches-org / patches-all)

        ; once a farmer reaches 25% of land in organic production and they meet TLS score, they convert the rest of the their land to organic
        ; if they are still below 25% then they transition only one patch to organic
        ifelse organic-percentage > .25
          [ ask patches-conventional [
            set in-organic-transition 1
            set organic-conversion-tracker 1
;            ifelse patches-organic = my-patches
;              [set fully-converted 1]
;              [set fully-converted 0]
        ] ]
          [ let conversion-patches n-of 1 patches-conventional
            ask conversion-patches [
              set in-organic-transition 1
              set organic-conversion-tracker 1
;              ifelse patches-organic = my-patches
;                [set fully-converted 1]
;                [set fully-converted 0]
          ]
        ]
      set farm-transitioning 1
      ]
    ]

    ;transition out of organic
    if (transition-likelihood-score < .5) and ((farm-size = "large") or ((farm-size = "medium") and (alternative-farmer = 0)) or ((farm-size = "small") and (fully-organic = 0)) or (((farm-size = "medium") and (alternative-farmer = 1 )) and (fully-organic = 0)))
    [
      let my-patches patches with [ farmer = [ farm-id ] of myself ]
      let patches-organic my-patches with [ certified-organic = 1 ]
      let patches-conventional my-patches with [ certified-organic =  0  and in-organic-transition = 0 ]
      ask patches-organic [
        set in-organic-transition 0
        set organic-conversion-tracker 0
        set certified-organic 0 ]
      set grows-organic 0
      set farm-transitioning 0
;      ifelse patches-organic = my-patches
;      [set fully-converted 1]
;      [set fully-converted 0]
    ]
   ]
end


to update-organic

  ask patches [
    if in-organic-transition = 1 [ into-organic ]
  ]

end


to into-organic

; transition from conventional to organic
  set organic-conversion-tracker ( organic-conversion-tracker + 1 )
  if organic-conversion-tracker = 4 [
    set certified-organic 1
    set organic-conversion-tracker 0
    set in-organic-transition 0
  ]

  let my-farmer peach_farmers with [ farm-id = [farmer] of myself]
  ask my-farmer [
    let my-patches patches with [ farmer = [ farm-id ] of myself ]
    let patches-organic my-patches with [ certified-organic = 1 ]
    let patches-conventional my-patches with [ certified-organic =  0  and in-organic-transition = 0 ]
    ifelse patches-organic = my-patches
              [set fully-organic 1]
              [set fully-organic 0]
  ]

end


to update-display

  if display-style = "farm ownership"
  [
    ask patches with [ occupied = 1 ]
    [ set pcolor farmer ]
  ]

  if display-style = "organic vs conventional"
  [
    ask patches with [ occupied = 1 ]
    [
      if certified-organic = 0 [ set pcolor 36 ]
      if organic-conversion-tracker = 1 [ set pcolor 67 ]
      if organic-conversion-tracker = 2 [ set pcolor 56 ]
      if organic-conversion-tracker = 3 [ set pcolor 54 ]
      if certified-organic = 1 [ set pcolor 62 ]
    ]
    ask peach_farmers with ( [ fully-organic = 1 and ( farm-size = "small" or ( farm-size = "medium" and alternative-farmer = 1 ) ) ] )
    [
      let my-patches patches with [ farmer = [ farm-id ] of myself ]
      ask my-patches [set pcolor 45 ]
    ]
  ]

  if display-style = "bad vs good year"
  [
    ask patches with [ occupied = 1 ] [
      set pcolor 5
      if ( peach-conventional-current-yield > 1.2 * peach-conventional-mean-yield ) [ set pcolor 125 ]
      if ( peach-conventional-current-yield <= 1.2 * peach-conventional-mean-yield ) [ set pcolor 135 ]
      if ( peach-conventional-current-yield <= 1.1 * peach-conventional-mean-yield ) [ set pcolor 63 ]
      if ( peach-conventional-current-yield <= 1 * peach-conventional-mean-yield ) [ set pcolor 66 ]
      if ( peach-conventional-current-yield <= .9 * peach-conventional-mean-yield ) [ set pcolor 45 ]
      if ( peach-conventional-current-yield <= .8 * peach-conventional-mean-yield ) [ set pcolor 43 ]
      if ( peach-conventional-current-yield <= .7 * peach-conventional-mean-yield ) [ set pcolor 27 ]
      if ( peach-conventional-current-yield <= .6 * peach-conventional-mean-yield ) [ set pcolor 25 ]
      if ( peach-conventional-current-yield <= .5 * peach-conventional-mean-yield ) [ set pcolor 23 ]
      if ( peach-conventional-current-yield <= .4 * peach-conventional-mean-yield ) [ set pcolor 17 ]
      if ( peach-conventional-current-yield <= .3 * peach-conventional-mean-yield ) [ set pcolor 15 ]
      if ( peach-conventional-current-yield <= .2 * peach-conventional-mean-yield ) [ set pcolor 12 ]
    ]
  ]

  if display-style = "transition likelihood score"
  [
    ask peach_farmers
    [ let my-patches patches with [ farmer = [ farm-id ] of myself ]
      if ( transition-likelihood-score <  1 )  [ ask my-patches [set pcolor 104 ] ]
      if ( transition-likelihood-score < .9 ) [ ask my-patches [set pcolor 62 ] ]
      if ( transition-likelihood-score < .8 ) [ ask my-patches [set pcolor 63 ] ]
      if ( transition-likelihood-score < .7 ) [ ask my-patches [set pcolor 65 ] ]
      if ( transition-likelihood-score < .6 ) [ ask my-patches [set pcolor 67 ] ]
      if ( transition-likelihood-score < .5 ) [ ask my-patches [set pcolor 17 ] ]
      if ( transition-likelihood-score < .4 ) [ ask my-patches [set pcolor 16 ] ]
      if ( transition-likelihood-score < .3 ) [ ask my-patches [set pcolor 15 ] ]
      if ( transition-likelihood-score < .2 ) [ ask my-patches [set pcolor 14 ] ]
      if ( transition-likelihood-score < .1 ) [ ask my-patches [set pcolor 13 ] ]
    ]
  ]

  if display-style = "farm size/ideology"
  [
    ask peach_farmers
    [ let my-patches patches with [ farmer = [ farm-id ] of myself ]
      if ( farm-size = "small" and alternative-farmer = 0 )  [ ask my-patches [set pcolor 63 ] ]
      if ( farm-size = "small" and alternative-farmer = 1 ) [ ask my-patches [set pcolor 67 ] ]
      if ( farm-size = "medium" and alternative-farmer = 0 ) [ ask my-patches [set pcolor 94 ] ]
      if ( farm-size = "medium" and alternative-farmer = 1 ) [ ask my-patches [set pcolor 97 ] ]
      if ( farm-size = "large" and alternative-farmer = 0 ) [ ask my-patches [set pcolor 14 ] ]
      if ( farm-size = "large" and alternative-farmer = 1 ) [ ask my-patches [set pcolor 17 ] ]
    ]
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
    set out-of-state-peach_price-to-sell random-normal 1.01 .05
  ]

    ask schools [ if out-of-state-peach_inventory-current < out-of-state-peach_inventory-maximum
    [
      let my-distributor n-of 1 ( distributors with-min [ out-of-state-peach_price-to-sell ] )
      let amount-exchanged 8041
      let price-exchanged [out-of-state-peach_price-to-sell] of my-distributor
      let price-tag (amount-exchanged * price-exchanged)

      set out-of-state-peach_inventory-current out-of-state-peach_inventory-current + amount-exchanged
      set assets assets - price-tag

      ask my-distributor [
        set out-of-state-peach_inventory-current out-of-state-peach_inventory-current - amount-exchanged
        set assets assets + price-tag
      ]
    ]
  ]


end


to set-contracts_conventional

  ;  farmers to outsource packer
  setContracts_peachesConventional  peach_farmers  packer  1  FALSE

  ;  outsource packer to distributors
  setContracts_peachesConventional  packer  distributors  1  FALSE

  ;  farmers to distributors
  setContracts_peachesConventional  peach_farmers  distributors  number-distributors  FALSE

  ;  farmers to alt markets
  setContracts_peachesConventional  peach_farmers  peach_altmarks  number-distributors  FALSE

  ;  farmers to processors
  if scenario = "IQF" [
    setContracts_iqfConventional  peach_farmers  peach_processors  number-peach_processors  FALSE
    ]

  ;  processors to distributors
  if scenario = "IQF" [
    setContracts_iqfConventional  peach_processors  distributors  number-distributors  FALSE
    ]

end


to set-contracts_organic

  ;  farmers to outsource packer
  setContracts_peachesOrganic  peach_farmers  packer  1  FALSE

  ;  outsource packer to distributors
  setContracts_peachesOrganic  packer  distributors  1  FALSE

  ;  farmers to distributors
  setContracts_peachesOrganic  peach_farmers  distributors  number-distributors  FALSE

  ;  farmers to alt markets
  setContracts_peachesOrganic  peach_farmers  peach_altmarks  number-distributors  FALSE

end


to produce-peaches

  set-peach-yield ; annual, planning stage
  calculate-annual-production ; annual, harvest stage

end


to update-inventories

;; UPDATE FARMER INVENTORY, including 10% of production as seconds
;; this is divided into ninths so that farmers get an equal share of the annual production each week during the 9-week growing season

  ask peach_farmers [

    let conv-seconds ( conventional-current-production * .10 )
    set peaches-conventional_inventory-current ( conventional-current-production - conv-seconds )
    set peaches-conventional_inventory-current ( peaches-conventional_inventory-current / 9 )
    set iqf-conventional_inventory-current conv-seconds
    set iqf-conventional_inventory-current ( iqf-conventional_inventory-current / 9 )

    let org-seconds ( organic-current-production * .10 )
    set peaches-organic_inventory-current ( organic-current-production - org-seconds )
    set peaches-organic_inventory-current ( peaches-organic_inventory-current / 9 )
    set iqf-organic_inventory-current org-seconds
    set iqf-organic_inventory-current ( iqf-organic_inventory-current / 9 )

    ]

end


to fulfill-contracts

  ;  farmers to outsource packer
  fulfillContracts_peachesConventional  peach_farmers  packer
  fulfillContracts_peachesOrganic  peach_farmers  packer

  ;  outsource packer to distributors
  fulfillContracts_peachesConventional  packer  distributors
  fulfillContracts_peachesOrganic  packer  distributors

  ;  farmers to distributors
  fulfillContracts_peachesConventional  peach_farmers  distributors
  fulfillContracts_peachesOrganic  peach_farmers  distributors

  ;  farmers to alt markets
  fulfillContracts_peachesConventional  peach_farmers  peach_altmarks
  fulfillContracts_peachesOrganic  peach_farmers  peach_altmarks

  if scenario = "IQF" [
;    IF IQF SCENARIO, farmers to processors
    fulfillContracts_peachesConventional  peach_farmers  peach_processors
  ;  IF GFPP SCENARIO, farmers to school
    fulfillContracts_peachesConventional  peach_farmers  schools
    fulfillContracts_peachesOrganic  peach_farmers  schools
    ]


end


to fulfill-processor-contracts

  ;  IF IQF SCENARIO, processors to distributors
;  fulfillContracts_iqfConventional peach_processors distributors

  ; IF GFPP SCENARIO, DISTRIBUTOR TO SCHOOL CONTRACT FULFILLMENT
;  fulfillContracts_iqfConventional distributors schools

end


to spot-market-sales [ sellers buyers buyer_count]   ; only set up for farmers to repackers right now (if want to include other agents, will need to make space availabel variable for them.
  let amount-exchanged 0                             ; the way this process is set up, farmers get one chance to sell potatoes to a repacker and the rest go to waste
  let price-exchanged 0                              ; the farmer chooses the repacker based on price, not space available....maybe should change this.
  let price-tag 0                                    ; maybe it should be buyers with capacity = space for all potatoes
  let peaches-conventional_space-available 0

  ask buyers [
    set peaches-conventional_space-available ( peaches-conventional_inventory-maximum - peaches-conventional_inventory-current )
  ]

  ask sellers [
    if peaches-conventional_inventory-current > 0 [

    let buyers-with-capacity ( buyers with [ peaches-conventional_contract-space-available > 0 ] )
    let bidding_buyers 0
    if any? buyers-with-capacity [
      ifelse ( count buyers-with-capacity ) >= ( round ( market-knowledge * buyer_count ) )
      [ set bidding_buyers n-of ( round ( market-knowledge * buyer_count ) ) buyers-with-capacity ]
      [ set bidding_buyers buyers-with-capacity ]

      let my-buyer n-of 1 ( bidding_buyers with-max [ peaches-conventional_price-to-buy ] )
      let space-avail item 0 ([peaches-conventional_contract-space-available] of my-buyer )
      ifelse peaches-conventional_inventory-current > space-avail
        [ set amount-exchanged space-avail ]
        [ set amount-exchanged peaches-conventional_inventory-current ]
     set price-exchanged item 0 ([peaches-conventional_price-to-buy] of my-buyer )
     set price-tag (amount-exchanged * price-exchanged)
     set peaches-conventional_inventory-current (peaches-conventional_inventory-current - amount-exchanged)
     set assets (assets + price-tag)
    ]
   ]
  ]
  ask buyers [
    set peaches-conventional_inventory-current (peaches-conventional_inventory-current + amount-exchanged)
    set assets (assets - price-tag)
  ]

  ask sellers [
    set peaches-conventional_inventory-current 0
  ]
end


to out-of-state-sales

end


to reset-promised-amounts

  ask peach_farmers [
    set peaches-conventional_promised 0
    set peaches-organic_promised 0 ]

  ask peach_processors [
    set iqf-conventional_my-incoming-total 0
    set iqf-conventional_promised 0 ]

  ask distributors [
    set peaches-conventional_my-incoming-total 0
    set peaches-conventional_promised 0
    set iqf-conventional_my-incoming-total 0
    set iqf-conventional_promised 0
    set peaches-organic_my-incoming-total 0
    set peaches-organic_promised 0 ]

end

;*************************
;  SET POTATO YIELD DSSAT ; input 38 years of DSSAT yield data into patches
;*************************
to set-peach-yield ; set single-year random potato yield

  set data-year 1980 + random 39
;  set data-year 1981 --> for testing/debugging (we know 1981 was a very bad production year)

  let file-name-canela (word data-year "_canela.asc")
  set conventional-load gis:load-dataset file-name-canela
  gis:apply-raster conventional-load peach-conventional-current-yield

  let file-name-organic (word data-year "_canela_org.asc")
  set organic-load gis:load-dataset file-name-organic
  gis:apply-raster organic-load peach-organic-current-yield

  ask patches
 [
    ifelse peach-conventional-current-yield >= 0; sets all non-producing patches to 0, otherwise they are NaN. Also see next set of commands re: NaN
    []
    [
      set peach-conventional-current-yield 0
      set peach-organic-current-yield 0
    ]
  ]

  ask patches with [occupied = 1]; this fixes the situation where some years from DSSAT seem to produce NaN for a small number of patches. I think this is a DSSAT error
  [
    if peach-conventional-current-yield = 0
    [
      set peach-conventional-current-yield mean [peach-conventional-current-yield] of patches with [peach-yes-no = 1]
      set peach-organic-current-yield mean [peach-organic-current-yield] of patches with [peach-yes-no = 1]
    ]
  ]

end


;**********************************
;  CALCULATE ANNUAL PRODUCTION
;********************************
to calculate-annual-production

  ; based on randy's simplified version of kevin's original potato yield code

  ask peach_farmers
   [
      let f-id farm-id

      ; All conventional potatoes, creating p-set0 and p-set1 based on, ultimately, remainder-patch (i.e., 0 or 1)
      let p-set patches with [ farmer = f-id ]
      set p-set p-set with [ certified-organic = 0 ]
      let p-set0 p-set with [ remainder-patch = 0 ]
      let p-set1 p-set with [ remainder-patch = 1 ]

      set conventional-current-production  sum [ peach-conventional-current-yield ] of p-set0 * 100
      set conventional-current-production  conventional-current-production + ( sum [ peach-conventional-mean-yield ] of p-set1 * ( hectares-farmed-peaches - ( 100 * ( patches-in-peaches - 1 ) ) ) )
      set conventional-current-production  ( 2.20462 * conventional-current-production )

      ; All organic potatoes, creating p-set0 and p-set1 based on, ultimately, remainder-patch (i.e., 0 or 1)
      set p-set patches with [ farmer = f-id ]
      set p-set p-set with [ certified-organic = 1 ]
      set p-set0 p-set with [ remainder-patch = 0 ]
      set p-set1 p-set with [ remainder-patch = 1 ]

      set organic-current-production  sum [ peach-organic-current-yield ] of p-set0 * 100
      set organic-current-production  organic-current-production + ( sum [ peach-organic-mean-yield ] of p-set1 * ( hectares-farmed-peaches - ( 100 * ( patches-in-peaches - 1 ) ) ) )
      set organic-current-production  ( 2.20462 * organic-current-production )

;     ------------------------------
;     stef note (8/30/20):
;     farmer input costs: farmers need to be paying organic input costs on both organic and in-transition patches, conventional input costs for everything else
;     this means input costs are calculated on what is planted, not what is harvested, which seems more realistic
;     NEED TO ADJUST UNITS HERE: LAND CALCULATION IS PER PATCH, COSTS ARE PER ACRE
;     ------------------------------

      let my-peach-patches patches with [ farmer = [ id ] of myself ]
      let my-organic-patches count my-peach-patches with [ certified-organic = 1 or in-organic-transition = 1 ]
      let my-conventional-patches ( ( count my-peach-patches ) - my-organic-patches )

      set assets ( assets - ( my-conventional-patches * (random-normal conv-input-price-per-lb conv-input-price-stdev) ) )
      set assets ( assets - ( my-organic-patches * (random-normal org-input-price org-input-price-stdev) ) )

;      set assets ( assets - ( conventional-current-production * (random-normal conv-input-price-per-lb conv-input-price-stdev) )) ; Add input prices for all potato product types: CHECK UNITS: input prices are per acre
      ;-----------------------------------------------------
      ; for now, going to do input costs by production weight but that will not reflect amount potatoes PLANTED vs. harvested so need to come back to this later!
      ;-----------------------------------------------------
   ]

;  stef note, 10/23: commenting this section out because i don't think it's needed (this was a kevin idea that we haven't been using)
;  ask peach_farmers; economic stats
;  [
;    set conventional-current-value conventional-current-production * peach-conventional_price-farmgate-avg
;    set organic-current-value organic-current-production * peach-organic_price-farmgate-avg
;    set total-peach-current-value conventional-current-value + organic-current-value
;  ]
;
;  set total-current-year-peach-sales sum [conventional-current-value] of peach_farmers + sum [organic-current-value] of peach_farmers

end


;**********************************
;  OUTPUT PRODUCTION AND SALES TO EXCEL
;********************************
to output-data

;  ; yield
;  set peach-conventional-yield  (sum [ conventional-current-production ] of peach_farmers)
;  set peach-organic-yield (sum [ organic-current-production ] of peach_farmers)
;  set output_peaches-conventional_inventory-current ( sum [ peaches-conventional_inventory-current ] of peach_farmers )
;
;  ; crop value
;  set peach-conventional-value (sum [ conventional-current-value ] of peach_farmers)
;  set peach-organic-value (sum [ organic-current-value ] of peach_farmers)

    if year >= (years-in-model-run - years-of-data-collection)  ; only gathers output data in the last 2 years of the model (lets patterns emerge before gathering data).
                 ; takes mean and sum of cash and inventory by agent type.
                 ; processed potatoes not included atm
  [
    set mean-peach-producer-inventory mean [ peaches-conventional_inventory-current ] of peach_farmers
    set sum-peach-producer-inventory sum [ peaches-conventional_inventory-current ] of peach_farmers
    set mean-peach-producer-cash  mean [ assets ] of peach_farmers
    set sum-peach-producer-cash sum [ assets ] of peach_farmers

    set mean-peach-processor-inventory mean [ iqf-conventional_inventory-current ] of peach_processors
    set sum-peach-processor-inventory sum [ iqf-conventional_inventory-current ] of peach_processors
    set mean-peach-processor-cash mean [ assets ] of peach_processors
    set sum-peach-processor-cash sum [ assets ] of peach_processors

    set mean-distributor-inventory mean [ peaches-conventional_inventory-current ] of distributors
    set sum-distributor-inventory sum [ peaches-conventional_inventory-current ] of distributors
    set mean-distributor-cash mean [ assets ] of distributors
    set sum-distributor-cash sum [ assets ] of distributors

    set mean-school-inventory mean [ peaches-conventional_inventory-current ] of schools
    set sum-school-inventory sum [ peaches-conventional_inventory-current ] of schools
    set mean-school-cash mean [ assets ] of schools
    set sum-school-cash sum [ assets ] of schools

  ]

end


;;*************************************
;; PROCESS POTATOES
;;*************************************
to process-peaches

  ask peach_processors [
    if iqf-conventional_inventory-current > 1 [
      let conversion ( iqf-conventional_inventory-current ) ; * .8 ) ;; assumes 20% waste during fresh-to-processed conversion (stef's random value - needs to be made realistic)
      let processed-space-available ( iqf-conventional_inventory-maximum - iqf-conventional_inventory-current )
      ifelse processed-space-available >= conversion
      [ set iqf-conventional_inventory-current ( iqf-conventional_inventory-current + conversion )
        set iqf-conventional_inventory-current 0 ]
      [ set iqf-conventional_inventory-current ( iqf-conventional_inventory-current + processed-space-available )
        set iqf-conventional_inventory-current ( iqf-conventional_inventory-current - processed-space-available ) ] ;* 1.25 ) ]
    ]
  ]

end


;converts uncooked potatoes into individual serving sizes --> NOTE: MAKE SURE TO CHECK UNITS BETWEEN INVENTORY AND SERVINGS CONVERSION
to scuola-cucina-cibo

  ask schools
    [
    set peach-iqf-servings ( peach-iqf-servings + ( iqf-conventional_inventory-current * 14 ) ) ;; 14 servings per unit of processed potatoes
    set iqf-conventional_inventory-current 0
    set peach-conventional_servings ( peach-conventional_servings + (peaches-conventional_inventory-current * 8.9 ) ) ;; 8.9 servings per unit of fresh potatoes
    set peaches-conventional_inventory-current 0
    set peach-organic_servings ( peach-organic_servings + ( peaches-organic_inventory-current * 8.9 ) ) ;; 8.9 servings per unit of fresh potatoes
    set peaches-organic_inventory-current 0
    ]

end


to eat-breakfast

  if ( ( week >= 2 ) and ( week <= 12 ) ) or ( ( week >= 14 ) and ( week >= 21 ) ) or ( ( week >= 34 ) and ( week >= 46 ) ) or ( ( week >= 48 ) and ( week >= 52 ) ) ; these are the weeks that school is in session
  [
    ask households [
    let school-p-meals ( [ peach-iqf-servings ] of one-of schools with [ id = [ school-id ] of myself ] )           ;; check how many processed servings of potatoes my school has
    let school-c-meals ( [ peach-conventional_servings ] of one-of schools with [ id = [ school-id ] of myself ] )               ;; check how many fresh conventional servings of potatoes my school has
    let school-o-meals ( [ peach-organic_servings ] of one-of schools with [ id = [ school-id ] of myself ] )                    ;; check how many fresh organic servings of potatoes my school has
    ifelse school-p-meals >= breakfast_total-needed                                                                         ;; if my school has enough processed potatoes to feed my household, eat those potatoes, update household hei based on processed potato hei score, and adjust school porcessed potato inventory
    [
     set hei-updated ( hei-updated + ( breakfast_total-needed * iqf-conventional_hei ) )
     ask schools with [ id = [ school-id ] of myself ]
       [ set peach-iqf-servings ( peach-iqf-servings - [ breakfast_total-needed ] of myself )
         set assets ( assets + ( [ breakfast_total-needed ] of myself * 1.54 ) ) ]
    ]
    [ ifelse ( school-c-meals >= breakfast_total-needed )                                                                        ;; if my school doesn't have enough processed potatoes, students will try to eat fresh conventional potatoes (then adjusting hei and inventory), and finally to eat fresh organic potatoes (then adjusting hei and inventory)
      [
        set hei-updated ( hei-updated + ( breakfast_total-needed * peach-fresh_hei ) )
        ask schools with [id = [ school-id ] of myself ]
          [ set peach-conventional_servings ( peach-conventional_servings - [ breakfast_total-needed ] of myself )
            set assets ( assets + ( [ breakfast_total-needed ] of myself * 1.54 ) )]
      ]
      [ ifelse ( school-o-meals >= breakfast_total-needed )                                                                        ;; if my school doesn't have enough processed potatoes, students will try to eat fresh conventional potatoes (then adjusting hei and inventory), and finally to eat fresh organic potatoes (then adjusting hei and inventory)
        [
        set hei-updated ( hei-updated + ( breakfast_total-needed * peach-fresh_hei ) )
        ask schools with [id = [school-id] of myself]
          [ set peach-organic_servings ( peach-organic_servings - [ breakfast_total-needed ] of myself )
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
    let school-p-meals ( [ peach-iqf-servings ] of one-of schools with [ id = [ school-id ] of myself ] )             ;; check how many processed servings of potatoes my school has
    let school-c-meals ( [ peach-conventional_servings ] of one-of schools with [ id = [ school-id ] of myself ] )               ;; check how many fresh conventional servings of potatoes my school has
    let school-o-meals ( [ peach-organic_servings ] of one-of schools with [ id = [ school-id ] of myself ] )                    ;; check how many fresh organic servings of potatoes my school has
    ifelse school-p-meals > lunch_total-needed                                                                         ;; if my school has enough processed potatoes to feed my household, eat those potatoes, update household hei based on processed potato hei score, and adjust school porcessed potato inventory
    [
     set hei-updated ( hei-updated + ( lunch_total-needed * iqf-conventional_hei ) )
     ask schools with [ id = [ school-id ] of myself ]
       [ set peach-iqf-servings ( peach-iqf-servings - [ lunch_total-needed ] of myself )
         set assets ( assets + ( [ lunch_total-needed ] of myself * 3.01 ) ) ]
    ]
    [ ifelse ( school-c-meals > lunch_total-needed )                                                                        ;; if my school doesn't have enough processed potatoes, students will try to eat fresh conventional potatoes (then adjusting hei and inventory), and finally to eat fresh organic potatoes (then adjusting hei and inventory)
      [
        set hei-updated ( hei-updated + ( lunch_total-needed * peach-fresh_hei ) )
        ask schools with [ id = [ school-id ] of myself ]
          [ set peach-conventional_servings ( peach-conventional_servings - [ lunch_total-needed ] of myself )
            set assets ( assets + ( [ lunch_total-needed ] of myself * 3.01 ) ) ]
      ]
      [ ifelse ( school-o-meals > lunch_total-needed )                                                                        ;; if my school doesn't have enough processed potatoes, students will try to eat fresh conventional potatoes (then adjusting hei and inventory), and finally to eat fresh organic potatoes (then adjusting hei and inventory)
        [
        set hei-updated ( hei-updated + ( lunch_total-needed * peach-fresh_hei ) )
        ask schools with [ id = [ school-id ] of myself ]
          [ set peach-organic_servings ( peach-organic_servings - [ lunch_total-needed ] of myself )
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

  reset-storage_peaches peach_farmers
  reset-storage_peaches peach_altmarks
  reset-storage_peaches peach_processors
  reset-storage_peaches distributors
  reset-storage_peaches schools

end
@#$#@#$#@
GRAPHICS-WINDOW
270
16
978
645
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

MONITOR
53
160
103
205
NIL
year
17
1
11

PLOT
983
222
1331
372
sum farmer assets
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
"default" 1.0 0 -16777216 true "" "plot sum [assets] of peach_farmers"
"pen-1" 1.0 0 -7500403 true "" "plot 0"

PLOT
1336
222
1682
372
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
"pen-1" 1.0 0 -5298144 true "" "ask distributors with [ agent-name = \"distributor 69\" ]\n[ plot assets ]"
"pen-2" 1.0 0 -4079321 true "" "ask distributors with [ agent-name = \"distributor 70\" ]\n[ plot assets ]"
"pen-3" 1.0 0 -14439633 true "" "ask distributors with [ agent-name = \"distributor 71\" ]\n[ plot assets ]"
"pen-4" 1.0 0 -14070903 true "" "ask distributors with [ agent-name = \"distributor 72\" ]\n[ plot assets ]"
"pen-5" 1.0 0 -11053225 true "" "plot 0"
"pen-6" 1.0 0 -7500403 true "" "plot sum [ assets ] of distributors"

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
160
155
205
NIL
week
17
1
11

PLOT
983
16
1682
216
sum farmer inventories by farm size and organic/conventional
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
"conv-small" 1.0 0 -14439633 true "" "plot sum [ peaches-conventional_inventory-current ] of peach_farmers with [ farm-size = \"small\" ]"
"org-small" 1.0 0 -5509967 true "" "plot sum [ peaches-organic_inventory-current ] of peach_farmers with [ farm-size = \"small\" ]"
"conv-medium" 1.0 0 -11783835 true "" "plot sum [ peaches-conventional_inventory-current ] of peach_farmers with [ farm-size = \"medium\" ]"
"org-medium" 1.0 0 -6917194 true "" "plot sum [ peaches-organic_inventory-current ] of peach_farmers with [ farm-size = \"medium\" ]"
"conv-large" 1.0 0 -8053223 true "" "plot sum [ peaches-conventional_inventory-current ] of peach_farmers with [ farm-size = \"large\" ]"
"org-large" 1.0 0 -2139308 true "" "plot sum [ peaches-organic_inventory-current ] of peach_farmers with [ farm-size = \"large\" ]"
"seconds-s" 1.0 0 -14454117 true "" "plot sum [ iqf-conventional_inventory-current ] of peach_farmers with [ farm-size = \"small\" ]"
"seconds-m" 1.0 0 -11033397 true "" "plot sum [ iqf-conventional_inventory-current ] of peach_farmers with [ farm-size = \"medium\" ]"
"seconds-l" 1.0 0 -5516827 true "" "plot sum [ iqf-conventional_inventory-current ] of peach_farmers with [ farm-size = \"large\" ]"

PLOT
984
530
1332
680
sum processor assets
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
"pen-3" 1.0 0 -7500403 true "" "plot 0"
"pen-4" 1.0 0 -2674135 true "" "plot sum [ assets ] of peach_processors"

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

MONITOR
159
160
219
205
data-year
data-year
17
1
11

MONITOR
13
215
262
260
NIL
peaches-outside
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
iqf-spoiled-in-storage
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
315
262
468
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
472
262
625
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
265
262
310
total conventional patches
count patches with [ certified-organic = 0 ]
17
1
11

CHOOSER
14
106
262
151
display-style
display-style
"farm ownership" "organic vs conventional" "bad vs good year" "transition likelihood score" "farm size/ideology"
4

SWITCH
270
657
490
690
hide-turtles?
hide-turtles?
0
1
-1000

PLOT
2259
236
2613
386
processor price to buy
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
"default" 1.0 0 -5298144 true "" "ask potato_processors with [ agent-name = \"processor 104\" ]\n[ plot potatoes-russet-conventional-fresh_price-to-buy ]"
"pen-1" 1.0 0 -14070903 true "" "ask potato_processors with [ agent-name = \"processor 105\" ]\n[ plot potatoes-russet-conventional-fresh_price-to-buy ]"

PLOT
2259
392
2614
542
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
"default" 1.0 0 -5298144 true "" "ask distributors with [ agent-name = \"distributor 106\" ]\n[ plot potatoes-russet-conventional-fresh_price-to-buy ]"
"pen-1" 1.0 0 -1069655 true "" "ask distributors with [ agent-name = \"distributor 106\" ]\n[ plot potatoes-russet-conventional-processed_price-to-buy ]"
"pen-2" 1.0 0 -4079321 true "" "ask distributors with [ agent-name = \"distributor 107\" ]\n[ plot potatoes-russet-conventional-fresh_price-to-buy ]"
"pen-3" 1.0 0 -723837 true "" "ask distributors with [ agent-name = \"distributor 107\" ]\n[ plot potatoes-russet-conventional-processed_price-to-buy ]"
"pen-4" 1.0 0 -14439633 true "" "ask distributors with [ agent-name = \"distributor 108\" ]\n[ plot potatoes-russet-conventional-fresh_price-to-buy ]"
"pen-5" 1.0 0 -5509967 true "" "ask distributors with [ agent-name = \"distributor 108\" ]\n[ plot potatoes-russet-conventional-processed_price-to-buy ]"
"pen-6" 1.0 0 -14070903 true "" "ask distributors with [ agent-name = \"distributor 109\" ]\n[ plot potatoes-russet-conventional-fresh_price-to-buy ]"
"pen-7" 1.0 0 -8275240 true "" "ask distributors with [ agent-name = \"distributor 109\" ]\n[ plot potatoes-russet-conventional-processed_price-to-buy ]"

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
271
731
491
764
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
271
768
491
801
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
14
656
264
829
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

SLIDER
271
693
491
726
organic-planning-horizon
organic-planning-horizon
0
30
5.0
1
1
 years
HORIZONTAL

PLOT
1337
376
1687
525
sum assets of alternative markets
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
"default" 1.0 0 -16777216 true "" "plot sum [ assets ] of peach_altmarks"

PLOT
983
376
1331
526
outsource-packer assets
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
"default" 1.0 0 -16777216 true "" "plot sum [ assets ] of ( peach_farmers with [ outsource-packer = 1 ] )"

CHOOSER
14
55
262
100
scenario
scenario
"baseline" "IQF"
1

TEXTBOX
15
640
165
658
data year:
11
0.0
1

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

* Delta county: https://www.nass.usda.gov/Publications/AgCensus/2017/Online_Resources/County_Profiles/Colorado/cp08029.pdf
* Mesa county: https://www.nass.usda.gov/Publications/AgCensus/2017/Online_Resources/County_Profiles/Colorado/cp08077.pdf


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
