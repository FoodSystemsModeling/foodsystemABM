extensions [ matrix table GIS ]


;MATRIX NOTES:
;NetLogo's matrix dimensions start with 0!!!
;An entry in row i and column j represents the receipts of account i from account j (columns sell to rows)


__includes [ "potatoMatrixToTableAPI.nls"  "potatoStaticNames.nls"  "potatoContractNegotiation.nls" "potatoContractFulfillment.nls" "potatoResetStorage.nls" ]


globals [

  ; kevin's variables
  ; confirming with kevin that all load variables are in hectares
  county-load potato-patches-load canela-mean-load canela-org-mean-load purple-mean-load purple-org-mean-load canela-load canela-org-load purple-load purple-org-load ; all for loading GIS data
  rotation-year

  data-year ;; added to differentiate the year needed for kevin's GIS rasters from the year tracker on the model interface

  total-current-year-potato-sales ; dollars

  ;numbers of agents
  number-potato_shippers
  number-potato_repackers
  number-potato_processors
  number-distributors
  number-households

  ;for output to excel
  mean-potato-producer-inventory ;inventory variables in lbs.
  sum-potato-producer-inventory
  mean-potato-producer-cash
  sum-potato-producer-cash

  mean-potato-shipper-inventory
  sum-potato-shipper-inventory
  mean-potato-shipper-cash
  sum-potato-shipper-cash

  mean-potato-repacker-inventory
  sum-potato-repacker-inventory
  mean-potato-repacker-cash
  sum-potato-repacker-cash

  mean-potato-processor-inventory
  sum-potato-processor-inventory
  mean-potato-processor-cash
  sum-potato-processor-cash

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

  potato_distributors_sell-date-julian                           ;; day of the julian year on which potato distributors sell their potatoes

  potato-fresh_hei
  potato-conventional-processed_hei


  ;; prices for all four potato varieties (avg and standard deviation) in $/lb.

  ;input costs per acre
  potato-conventional-russet_cost-input-per-acre
  potato-organic-russet_cost-input-per-acre
  potato-conventional-purple_cost-input-per-acre
  potato-organic-purple_cost-input-per-acre

  ;farmer breakeven per lb. prices
  potato-conventional-russet_price-farmer-breakeven
  potato-organic-russet_price-farmer-breakeven
  potato-conventional-purple_price-farmer-breakeven
  potato-organic-purple_price-farmer-breakeven

  ;farmgate prices
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

  ;price repacker pays
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


  ;old prices and variable names
  potato-conventional-processed_price-wholesale-avg              ;; 1.01, price per pound to school
  potato-conventional-processed_price-wholesale-stdev

  potato-conventional-fresh_price-wholesale-avg                  ;; .35, price per pound

  potato-organic-fresh_price-wholesale-avg                       ;; TBD
  sd-wholesale                                                   ;; .051175, standard deviation of both manufactured (fresh and processed) potato product prices


  ;; buckets for counting

  meals-missed                                                   ;; tally of meals when there wasn't enough food to feed someone (mostly for debugging)
  potatoes-outside                                               ;; potatoes sent outside the system (no capacity for them in the model world) in lbs. ALL POTATOES (raw, processed)
  potatoes-dps
  conventional-spoiled-in-storage                                ;; potatoes left in storage at end of each year, presumed to have spoiled in lbs.
  organic-spoiled-in-storage
  processed-spoiled-in-storage
  servings-spoiled-in-storage                                    ;; number of servings left at end of year in servings
  school-count

  ;;matrix globals
  contract-price-matrix
  contract-quantity-matrix
  quantity-sent-matrix
  quantity-outstanding-matrix
  projected-income-matrix ; test!

  potato-table_russet-conventional
  potato-table_russet-organic
  potato-table_purple-conventional
  potato-table_purple-organic
  potato-table_russet-conventional-small
  potato-table_russet-conventional-processed
  potato-table_russet-organic-processed
  potato-table_purple-conventional-processed
  potato-table_purple-organic-processed

  ;; francesco's wizardly integration section
  workspace
  osSeparator
  paramDir
  outputDir
]


breed [potato_farmers potato_farmer]
breed [potato_repackers potato_repacker]
breed [potato_shippers potato_shipper]
breed [potato_processors potato_processor]
breed [distributors distributor]
breed [schools school]
breed [dps_buyers bps_buyer ]
breed [households household]


patches-own

[
  county-potato                                                  ;; numerical county id, from raster
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
  occupied                                                       ;; whether patch is owned/occupied by a potato farm
  farmer                                                         ;; id of farm that occupies patch
  certified-organic                                              ;; if patch is certified organic
  rotation                                                       ;; if potatoes are currently being grown at all, "potatoes". If only barley, "barley"
  remainder-patch                                                ;; patch that is planted to the remainder of potatoes, e.g. if farm has 250 hectares of potatoes, this patch grows the 50
  organic-conversion-tracker                                     ;; tracks number of years spent converting a patch from conventional to organic use
  in-organic-transition                                          ;; tracks whether or not the patch is in the process of transitioning to organic --> 1 = yes
]


potato_farmers-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  home-county                                                    ;; home county id of farmer
  hectares-farmed-potatoes                                       ;; total hectares farmed in potatoes
  hectares-farmed-total                                          ;; total hectares farmed potatoes and barley
  initialized                                                    ;; whether initialized yet in setup
  patches-occupied                                               ;; how many 100-ha patches farm occupies
  farm-id                                                        ;; unique identifier --> CAN GET RID OF THIS SINCE WE COVER IT IN STEF/ERIN MODEL
  grows-organic                                                  ;; yes/no on whether has certified organic land
  fully-organic                                                   ;; 1 if all farmer's patches are organic, 0 otherwise
  loyalty-to-buyer-id                                            ;; id number of buying agent that farmer prefers to sell to based on loyalty from previous year's relationship

  russet-canela-allocation                                       ;; percent of potato production in russet-canela
  purple-allocation                                              ;; percent of potato production in purple (farmers currently grow 20% purple)

  russet-canela-current-production                               ;; total of this year's production of potatoes in lbs. (calculated from DSSAT data and converted to lbs. in "calculate-annual-production")
  russet-canela-org-current-production
  purple-current-production
  purple-org-current-production

  patches-in-potatoes                                            ;; number of patches needed to grow potatoes based on hectares of potatoes they grow- for rotation
  patches-in-rotation                                            ;; number of patches (if any) that may be entirely planted to barley in rotation (otherwise rotation is internal to patches for smaller operations, and yield doesn't change

  potatoes-russet-conventional-fresh_inventory-current           ;; total inventory (in pounds) of conventional russet potatoes
  potatoes-russet-conventional-fresh_inventory-maximum
  potatoes-russet-conventional-fresh_price-to-sell
  potato-farmers_yield-estimated_russet-conventional
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

  potatoes-russet-conventional-fresh-small_inventory-current
  potatoes-russet-conventional-fresh-small_inventory-maximum
  potatoes-russet-conventional-fresh-small_price-to-sell
  potato-farmers_yield-estimated_russet-conventional-small
  potatoes-russet-conventional-fresh-small-promised

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


  ]


potato_repackers-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  loyalty-to-buyer-id                                            ;; id number of buying agent that repacker prefers to sell to based on loyalty from previous year's relationship

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
  loyalty-to-buyer-id                                            ;; id number of buying agent that shipper prefers to sell to based on loyalty from previous year's relationship

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

  contract-short-inventory

  ]


potato_processors-own[

  id
  agent-name
  assets
  assets-initial
  assets-final
  loyalty-to-buyer-id                                            ;; id number of buying agent that processor prefers to sell to based on loyalty from previous year's relationship

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


distributors-own [

  id
  agent-name
  assets
  assets-initial
  assets-final
  loyalty-to-buyer-id                                            ;; id number of buying agent that distributor prefers to sell to based on loyalty from previous year's relationship

  out-of-state-french-fry_inventory-current
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

 ]


dps_buyers-own [

  id
  agent-name
  school-type
  assets
  assets-initial
  assets-final
  loyalty-to-seller-id                                            ;; id number of selling agent that school prefers to buy from based on loyalty from previous year's relationship

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

  potato-russet-conventional-fresh_servings                    ;; current inventory of fresh russet conventional potatoes (in individual servings)
  potato-russet-conventional-processed_servings                ;; current inventory of processed russet conventional potatoes (in individual servings)
  potato-russet-organic-fresh_servings                         ;; current inventory of fresh russet organic potatoes (in individual servings)
  potato-russet-organic-processed_servings                     ;; current inventory of processed russet organic potatoes (in individual servings)
  potato-purple-conventional-fresh_servings                    ;; current inventory of fresh purple conventional potatoes (in individual servings)
  potato-purple-conventional-processed_servings                ;; current inventory of processed purple conventional potatoes (in individual servings)
  potato-purple-organic-fresh_servings                         ;; current inventory of fresh purple organic potatoes (in individual servings)
  potato-purple-organic-processed_servings                     ;; current inventory of processed purple organic potatoes (in individual servings)

 ]

schools-own [
  id
  agent-name
  school-id                                                    ;; value to link a household with a particular school so they eat at the same school each week
  household-size                                               ;; number of poeple in this household
  home-xcor                                                    ;; home x-coordinate
  home-ycor
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
  setup-potato_farmers
  setup-certified-organic
  setup-display
  setup-output-lists
  setup-potato_repackers
  setup-potato_shippers
  setup-potato_processors
  setup-distributors
  setup-dps_buyers
  ;setup-schools
  ;setup-households
  setup-potato-farm-crop-allocation
  setup-estimated-yields
  set potato-table_russet-conventional table:make
  set potato-table_russet-organic table:make
  set potato-table_purple-conventional table:make
  set potato-table_purple-organic table:make
  set potato-table_russet-conventional-small table:make
  set potato-table_russet-conventional-processed table:make                                                  ;; potato contracting tables
  set potato-table_russet-organic-processed table:make
  set potato-table_purple-conventional-processed table:make
  set potato-table_purple-organic-processed table:make

;  setup-matrix
;  if debug-mode = TRUE [ setup-matrix ]
  set potato-fresh_hei 25                                     ;; per https://epi.grants.cancer.gov/hei/developing.html vegetables are worth a max of 5 points if ≥1.1 cup equiv. per 1,000 kcal
  set potato-conventional-processed_hei 0                     ;; per https://epi.grants.cancer.gov/hei/developing.html empty calories are worth a max of 20 points if held to less than 19% of total energy --> a score of zero is earned if empty calories are over 50% of total energy --> i've estiamted a processed potato to be very unhealthy, and given it 0 points from this category
  set max-ticks (52 * years-in-model-run)
;  print mean [transition-likelihood-score ] of potato_farmers
;  print count potato_farmers with [ transition-likelihood-score >= .5 ]
;  print " "
;  ask potato_farmers [ print transition-likelihood-score ]

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
  set potato-patches-load gis:load-dataset "potato_patches.asc"; load patches where potato production occurred any year 2011-2017 re: Colorado DNR Water Resource Division. Compared against DSSAT, removed <10 patches
  set canela-mean-load gis:load-dataset "mean_canela.asc"; load mean canela russet yield 1980-2018 DSSAT, kgs per ha
  set canela-org-mean-load gis:load-dataset "mean_canela_org.asc"
  set purple-mean-load gis:load-dataset "mean_purple.asc" ; load mean purple yield 1980-2018 DSSAT, kgs per ha
  set purple-org-mean-load gis:load-dataset "mean_purple_org.asc"
  gis:set-world-envelope-ds gis:envelope-of county-load
  gis:apply-raster county-load county-potato
  gis:apply-raster potato-patches-load potato-yes-no
  gis:apply-raster canela-mean-load potato-canela-mean-yield
  gis:apply-raster canela-org-mean-load potato-canela-org-mean-yield
  gis:apply-raster purple-mean-load potato-purple-mean-yield
  gis:apply-raster purple-org-mean-load potato-purple-org-mean-yield

  ask patches with [potato-yes-no = 1]
  [if county-potato = 4 [set potato-yes-no 0]]; fix couple of patches that fall outside border (right on border but resolution puts them outside)

ask patches
  [
    if county-potato = 1 [set pcolor 9 set county-potato-name "Alamosa"]
    if county-potato = 2 [set pcolor 8 set county-potato-name "Rio Grande"]
    if county-potato = 3 [set pcolor 7 set county-potato-name "Saguache"]
    if county-potato = 4 [set pcolor 9.9 set county-potato-name "NA"]
    if potato-yes-no = 1 [set pcolor 9.9]
    if pycor = 0 [set pcolor 9.9]
  ]

end


;SETUP PARAMETERS
;THIS WILL CHANGE ONCE WE DECIDE HOW TO HANDLE SCENARIOS
to setup-parameters

  ; hard coded numbers of agents
  set number-potato_shippers 4
  set number-potato_repackers 4
  set number-potato_processors 2
  set number-distributors 4
  set number-households 250

  ;input costs
  set potato-conventional-russet_cost-input-per-acre 1338.65
  set potato-organic-russet_cost-input-per-acre 1346.57
  set potato-conventional-purple_cost-input-per-acre 672.66
  set potato-organic-purple_cost-input-per-acre 894.48

  ;breakeven prices (per lb.) using yields from wisconsin
  set potato-conventional-russet_price-farmer-breakeven 0.0330
  set potato-organic-russet_price-farmer-breakeven 0.0409
  set potato-conventional-purple_price-farmer-breakeven 0.0218
  set potato-organic-purple_price-farmer-breakeven 0.0716

  ; NEED TO GO THROUGH CODE AND MAKE SURE NAMES ARE CHANGED

  ;default prices

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


  ; scenario 1 prices: baseline
  if potato-scenario = "baseline" [
    set potato-conventional-russet-processed_price-distributor-receives-avg 1.01
    set potato-conventional-russet-processed_price-distributor-receives-stdev .05
  ]

  ; scenario 2 prices: fresh CO
  if potato-scenario = "fresh-CO" [

  ]

  ; scenario 3 prices: gfpp
  ; SCENARIO 3 PRICES NEED RECALCULATING ONCE ERIN HAS TALKED TO DAWN
  if potato-scenario = "gfpp" [
    ;price farmer receives
    set potato-conventional-russet_price-farmgate-avg 0.222
    set potato-conventional-russet_price-farmgate-stdev 0.0291

    set potato-organic-russet_price-farmgate-avg 0.437
    set potato-organic-russet_price-farmgate-stdev 0.0291

    set potato-conventional-purple_price-farmgate-avg 0.404
    set potato-conventional-purple_price-farmgate-stdev 0.0539

    set potato-organic-purple_price-farmgate-avg 0.796
    set potato-organic-purple_price-farmgate-stdev 0.0539


    ;price shipper receives
    set potato-conventional-russet_price-shipper-receives-avg 0.358
    set potato-conventional-russet_price-shipper-receives-stdev 0.0291

    set potato-organic-russet_price-shipper-receives-avg 0.705
    set potato-organic-russet_price-shipper-receives-stdev 0.0291

    set potato-conventional-purple_price-shipper-receives-avg 0.651
    set potato-conventional-purple_price-shipper-receives-stdev 0.0539

    set potato-organic-purple_price-shipper-receives-avg 1.284
    set potato-organic-purple_price-shipper-receives-stdev 0.0539


    ;price repacker pays
    set potato-conventional-russet_price-repacker-pays-avg 0.0810
    set potato-conventional-russet_price-repacker-pays-stdev 0.0291

    set potato-organic-russet_price-repacker-pays-avg 0.160
    set potato-organic-russet_price-repacker-pays-stdev 0.0291

    set potato-conventional-purple_price-repacker-pays-avg 0.147
    set potato-conventional-purple_price-repacker-pays-stdev 0.0539

    set potato-organic-purple_price-repacker-pays-avg 0.291
    set potato-organic-purple_price-repacker-pays-stdev 0.0539
  ]

  ; scenario 4 prices: small potatoes
  if potato-scenario = "small-potatoes" [

    ;price farmer receives

    ;NEED SLIGHTLY HIGHER PRICES HERE FOR WHEN DPS PURCHASES SMALL POTATOES DIRECTLY FROM SHIPPER

    ;price shipper receives


  ]

  ; scenario 5 prices: specialty product
  if potato-scenario = "specialty-product" [

;price processor receives
  set potato-conventional-russet-processed_price-processor-receives-avg 0.510
  set potato-conventional-russet-processed_price-processor-receives-stdev 0.0291

  set potato-organic-russet-processed_price-processor-receives-avg 1.004
  set potato-organic-russet-processed_price-processor-receives-stdev 0.0291

  set potato-conventional-purple-processed_price-processor-receives-avg 0.927
  set potato-conventional-purple-processed_price-processor-receives-stdev 0.0539

  set potato-organic-purple-processed_price-processor-receives-avg 1.829
  set potato-organic-purple-processed_price-processor-receives-stdev 0.0539

;  ;price distributor receives
  set potato-conventional-russet-processed_price-distributor-receives-avg 0.82
  set potato-conventional-russet-processed_price-distributor-receives-stdev 0.0291

  set potato-organic-russet-processed_price-distributor-receives-avg 1.614
  set potato-organic-russet-processed_price-distributor-receives-stdev 0.0291

  set potato-conventional-purple-processed_price-distributor-receives-avg 1.490
  set potato-conventional-purple-processed_price-distributor-receives-stdev 0.0539

  set potato-organic-purple-processed_price-distributor-receives-avg 2.941
  set potato-organic-purple-processed_price-distributor-receives-stdev 0.0539
  ]


; THE MODEL SHOULD RUN WITH THESE PRICES. STILL WORKING ON THE ONES ABOVE.
  ;; farmgate prices--same variable names as above so should be fine to switch

  set potato-conventional-russet_price-farmgate-avg .0963906                      ;; .0963906, price per pount at farm gate
  set potato-conventional-russet_price-farmgate-stdev .0407041                    ;; .0407041, standard deviation of farm gate price

  set potato-organic-russet_price-farmgate-avg .1927812                           ;; TBD! for now just 2 x conventional
  set potato-organic-russet_price-farmgate-stdev .0407041                         ;; TBD! for now just same as conventional

  set potato-conventional-purple_price-farmgate-avg .0963906                      ;; .0963906, price per pount at farm gate
  set potato-conventional-purple_price-farmgate-stdev .0407041                    ;; .0407041, standard deviation of farm gate price

  set potato-organic-purple_price-farmgate-avg .1927812                           ;; TBD! for now just 2 x conventional
  set potato-organic-purple_price-farmgate-stdev .0407041                         ;; TBD! for now just same as conventional

  ;; wholesale prices--need to change variable names

  set potato-conventional-processed_price-wholesale-avg 1.01                     ;; 1.01, price per pound to distributor
  set potato-conventional-fresh_price-wholesale-avg .35                          ;; .35, price per pound
  set potato-organic-fresh_price-wholesale-avg .7                                ;; TBD! for now 2 x conventional
  set sd-wholesale .051175                                                       ;; .051175, standard deviation of both manufactured (fresh and processed) potato product prices

  set school-count 207

end


to setup-potato_farmers

  ;; -------------------------------------------------

  ;; initialize potato producers by county

  ask patches [ set farmer -1 ]
  create-potato_farmers 26; Alamosa County
  [
    set home-county 1
    set initialized 0
    set id who
    set agent-name word "Alamosa potato farmer " id
  ]

    ask n-of 5 potato_farmers with [initialized = 0]; set parameters for farms farming between 100 and 250 acres of potatoes per year
     [
      set hectares-farmed-potatoes random-normal 175 25 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "small"
     ]
    ask n-of 11 potato_farmers with [initialized = 0]; set parameters for farms farming between 250 and 500 acres of potatoes per year
     [
      set hectares-farmed-potatoes random-normal 375 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 3 potato_farmers with [initialized = 0]; set parameters for farms farming between 500 and 750 acres of potatoes per year
     [
      set hectares-farmed-potatoes random-normal 625 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 3 potato_farmers with [initialized = 0]; set parameters for farms farming between 750 and 1000 acres of potatoes per year
     [
      set hectares-farmed-potatoes random-normal 875 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 4 potato_farmers with [initialized = 0]; set parameters for farms farming >1000 acres
     [
      set hectares-farmed-potatoes random-normal 1601 100 * 0.405 ; assign acreage and convert to hectares of potatoes per year
      set initialized 1
      set farm-size "large"
     ]

  create-potato_farmers 41; Rio Grande County
  [
    set home-county 2
    set initialized 0
    set id who
    set agent-name word "Rio Grande potato farmer " id
  ]

  ask n-of 21 potato_farmers with [initialized = 0]; set parameters for farms farming between 100 and 250 acres of potatoes per year
     [
      set hectares-farmed-potatoes random-normal 175 25 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "small"
     ]
    ask n-of 10 potato_farmers with [initialized = 0]; set parameters for farms farming between 250 and 500 acres of potatoes per year
     [
      set hectares-farmed-potatoes random-normal 375 41.67 * 0.405 ; assign acreage and convert to hectares
      set hectares-farmed-total hectares-farmed-potatoes * 2; allows for simple 1:1 rotation with barley
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 4 potato_farmers with [initialized = 0]; set parameters for farms farming between 500 and 750 acres of potatoes per year
     [
      set hectares-farmed-potatoes random-normal 625 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 3 potato_farmers with [initialized = 0]; set parameters for farms farming between 750 and 1000 acres of potatoes per year
     [
      set hectares-farmed-potatoes random-normal 875 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 3 potato_farmers with [initialized = 0]; set parameters for farms farming >1000 acres of potatoes per year
     [
      set hectares-farmed-potatoes random-normal 1561 100 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "large"
     ]

create-potato_farmers 29; Saguache County
  [
    set home-county 3
    set initialized 0
    set id who
    set agent-name word "Saguache potato farmer " id
  ]

  ask n-of 11 potato_farmers with [initialized = 0]; set parameters for farms farming between 100 and 250 acres of potatoes per year
     [
      set hectares-farmed-potatoes random-normal 175 25 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "small"
     ]
    ask n-of 9 potato_farmers with [initialized = 0]; set parameters for farms farming between 250 and 500 acres of potatoes per year
     [
      set hectares-farmed-potatoes random-normal 375 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 3 potato_farmers with [initialized = 0]; set parameters for farms farming between 500 and 750 acres of potatoes per year
     [
      set hectares-farmed-potatoes random-normal 625 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 3 potato_farmers with [initialized = 0]; set parameters for farms farming between 750 and 1000 acres of potatoes per year
     [
      set hectares-farmed-potatoes random-normal 875 41.67 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "medium"
     ]
    ask n-of 3 potato_farmers with [initialized = 0]; set parameters for farms farming >1000 acres of potatoes per year
     [
      set hectares-farmed-potatoes random-normal 2255 100 * 0.405 ; assign acreage and convert to hectares
      set initialized 1
      set farm-size "large"
     ]

  ;; -------------------------------------------------

  ;; set general potato producer variables

  ask potato_farmers
  [
    set assets 10000 ; maybe make starting assets value based on their size OR just track change in assets over the course of the model
    set assets-initial assets
    set loyalty-to-buyer-id 0
    set potatoes-russet-conventional-fresh_inventory-maximum 450000000
    set potatoes-russet-conventional-fresh-small_inventory-maximum 450000000
    set potatoes-russet-conventional-fresh_price-to-sell precision (random-normal potato-conventional-russet_price-farmgate-avg potato-conventional-russet_price-farmgate-stdev)  3  ; do we need to update this price variable every season?
    set hectares-farmed-potatoes round hectares-farmed-potatoes
    set hectares-farmed-total hectares-farmed-potatoes * 1.5; allows for simple 2:1 rotation with potato:barley ; are we sure that this always holds?
    set farm-id who ;+ 1
    set color green
    set shape "circle"
    set size 0.5
    set patches-occupied round (hectares-farmed-total / 100 - 0.5) + 1 ; results in number of patches owned equal to rounded up to next highest hundred hectares / 100
    move-to one-of patches with [county-potato = [home-county] of myself] with [potato-yes-no = 1]
    ask min-n-of (patches-occupied) patches with [potato-yes-no = 1] with [occupied = 0] [distance myself]; settling on correct number of patches-
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

  ;; set potato producer demographics: calculations in "2020-08-01 potato farmer demographics.txt"

  ;; alamosa county
  ask n-of 16 potato_farmers with [ home-county = 1 ] [ set male-gender 1 ]
  ask n-of 7 potato_farmers with [ home-county = 1 ] [ set first-time-farmer 1 ]
  ask n-of 2 potato_farmers with [ home-county = 1 ] [ set young-farmer 1 ]
  ask n-of 3 potato_farmers with [ home-county = 1 ] [ set not-white 1 ]
  ask n-of 13 potato_farmers with [ home-county = 1 ] [ set primary-income 1 ]

  ;; rio grande county
  ask n-of 27 potato_farmers with [ home-county = 2 ] [ set male-gender 1 ]
  ask n-of 11 potato_farmers with [ home-county = 2 ] [ set first-time-farmer 1 ]
  ask n-of 7 potato_farmers with [ home-county = 2 ] [ set young-farmer 1 ]
  ask n-of 3 potato_farmers with [ home-county = 2 ] [ set not-white 1 ]
  ask n-of 25 potato_farmers with [ home-county = 2 ] [ set primary-income 1 ]

  ;; saguache county
  ask n-of 19 potato_farmers with [ home-county = 3 ] [ set male-gender 1 ]
  ask n-of 7 potato_farmers with [ home-county = 3 ] [ set first-time-farmer 1 ]
  ask n-of 2 potato_farmers with [ home-county = 3 ] [ set young-farmer 1 ]
  ask n-of 3 potato_farmers with [ home-county = 3 ] [ set not-white 1 ]
  ask n-of 21 potato_farmers with [ home-county = 3 ] [ set primary-income 1 ]

  ;; -------------------------------------------------

  ;; test sub-procedure for adding farmer risk tolerance
  ;; risk aversion is set from 0 - 1 --> 1 is LEAST tolerant of risk (assume smaller farms are more willing to take risks)
  ;; factors that currently increase risk aversion: male-gender, not-white

  ask potato_farmers [
    let max-farm max-one-of potato_farmers [ hectares-farmed-potatoes ]
    let max-farm-hectares [ hectares-farmed-potatoes ] of max-farm
    set transition-likelihood-score ( .5 - (hectares-farmed-potatoes / max-farm-hectares ))
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
          [ set alternative-farmer 1 ] ]

  ]




  ;; -------------------------------------------------

  ; initialize crop rotations

  ask potato_farmers
  [
    set patches-in-potatoes round (hectares-farmed-potatoes / 100 + 0.5)
    set patches-in-rotation patches-occupied - patches-in-potatoes
    ifelse patches-in-rotation > 0
     [
       ask n-of patches-in-potatoes patches with [farmer = [farm-id] of myself]
         [set rotation "potato"]
      ask patches with [farmer = [farm-id] of myself] with [rotation = 0]
         [set rotation "barley"]
    ]
    [
      ask patches with [farmer = [farm-id] of myself]
          [set rotation "potato"]
    ]
    ask one-of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
          [set remainder-patch 1]  ; need to identify which patch grows less then 100 ha of potatoes and catches the remainder
  ]
  set rotation-year 1 ; first year of rotation is set as of above, 3-year cycle

end


;*************************
; SETUP CERTIFIED ORGANIC
; ************************
to setup-certified-organic

  ask n-of (0.007 * round count patches with [occupied = 1]) patches with [occupied = 1]; updated based on erin math
  [set certified-organic 1]
  ask potato_farmers
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

  if display-style = "potato vs barley rotation"
  [
    ask patches with [ rotation = "barley" ] [ set pcolor 125 ]
    ask patches with [ rotation = "potato" ] [ set pcolor 34 ]
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
    ask potato_farmers
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


to setup-output-lists
;probably can delete this later
end


to setup-potato_repackers

  create-potato_repackers number-potato_repackers
  [
    set heading 0
    setxy random max-pxcor random max-pycor
    set shape "house"
    set size 2
    set color pink
    set id who
    set agent-name word "repacker " who
    set assets 10000
    set assets-initial assets

    set potatoes-russet-conventional-fresh_inventory-maximum 1000000000000
    set potatoes-russet-organic-fresh_inventory-maximum 1000000000000
    set potatoes-purple-conventional-fresh_inventory-maximum 1000000000000
    set potatoes-purple-organic-fresh_inventory-maximum 1000000000000
    set potatoes-russet-conventional-fresh-small_inventory-maximum 1000000000000

    ;; conventional input price is $2340/acre (see info tab for details)
    set potatoes-russet-conventional-fresh_price-to-buy precision ( random-normal potato-conventional-russet_price-repacker-pays-avg potato-conventional-russet_price-repacker-pays-stdev ) 2
    if potatoes-russet-conventional-fresh_price-to-buy < potato-conventional-russet_price-farmer-breakeven [ set potatoes-russet-conventional-fresh_price-to-buy potato-conventional-russet_price-farmer-breakeven ]

    set potatoes-russet-organic-fresh_price-to-buy precision ( random-normal potato-organic-russet_price-repacker-pays-avg potato-organic-russet_price-repacker-pays-stdev ) 2
    if potatoes-russet-organic-fresh_price-to-buy < potato-organic-russet_price-farmer-breakeven [ set potatoes-russet-organic-fresh_price-to-buy potato-organic-russet_price-farmer-breakeven ]

    set potatoes-purple-conventional-fresh_price-to-buy precision ( random-normal potato-conventional-purple_price-repacker-pays-avg potato-conventional-purple_price-repacker-pays-stdev ) 2
    if potatoes-purple-conventional-fresh_price-to-buy < potato-conventional-purple_price-farmer-breakeven [ set potatoes-purple-conventional-fresh_price-to-buy potato-conventional-purple_price-farmer-breakeven ]

    set potatoes-purple-organic-fresh_price-to-buy precision ( random-normal potato-organic-purple_price-repacker-pays-avg potato-organic-purple_price-repacker-pays-stdev ) 2
    if potatoes-purple-organic-fresh_price-to-buy < potato-organic-purple_price-farmer-breakeven [ set potatoes-purple-organic-fresh_price-to-buy potato-organic-purple_price-farmer-breakeven ]

    set potatoes-russet-conventional-fresh-small_price-to-buy precision ( random-normal potato-conventional-russet-small_price-repacker-pays-avg potato-conventional-russet-small_price-repacker-pays-stdev ) 2
    ;if potatoes-russet-conventional-fresh-small_price-to-buy < conv-input-price-per-lb [ set potatoes-russet-conventional-fresh-small_price-to-buy conv-input-price-per-lb ]

    if debug-mode = TRUE [
      print "repacker conventional russet price to buy"
      print potatoes-russet-conventional-fresh_price-to-buy ]

    if hide-turtles? = TRUE [ ht ]
    ]

end


to setup-potato_shippers

  create-potato_shippers number-potato_shippers
  [
    set heading 0
    setxy random max-pxcor random max-pycor
    set shape "house"
    set size 2
    set color blue
    set id who
    set agent-name word "shipper " id
    set assets 10000
    set assets-initial assets

    set potatoes-russet-conventional-fresh_inventory-maximum random-normal 20000000 3000000
    set potatoes-russet-organic-fresh_inventory-maximum random-normal 20000000 3000000
    set potatoes-purple-conventional-fresh_inventory-maximum random-normal 20000000 3000000
    set potatoes-purple-organic-fresh_inventory-maximum random-normal 20000000 3000000
    set potatoes-russet-conventional-fresh-small_inventory-maximum random-normal 20000000 3000000

    set potatoes-russet-conventional-fresh_price-to-buy precision ( random-normal potato-conventional-russet_price-farmgate-avg potato-conventional-russet_price-farmgate-stdev ) 2
    if potatoes-russet-conventional-fresh_price-to-buy < potato-conventional-russet_price-farmer-breakeven [ set potatoes-russet-conventional-fresh_price-to-buy potato-conventional-russet_price-farmer-breakeven ]

    set potatoes-russet-organic-fresh_price-to-buy precision ( random-normal potato-organic-russet_price-farmgate-avg potato-organic-russet_price-farmgate-stdev ) 2
    if potatoes-russet-organic-fresh_price-to-buy < potato-organic-russet_price-farmer-breakeven [ set potatoes-russet-organic-fresh_price-to-buy potato-organic-russet_price-farmer-breakeven ]

    set potatoes-purple-conventional-fresh_price-to-buy precision ( random-normal potato-conventional-purple_price-farmgate-avg potato-conventional-purple_price-farmgate-stdev ) 2
    if potatoes-purple-conventional-fresh_price-to-buy < potato-conventional-purple_price-farmer-breakeven [ set potatoes-purple-conventional-fresh_price-to-buy potato-conventional-purple_price-farmer-breakeven ]

    set potatoes-purple-organic-fresh_price-to-buy precision ( random-normal potato-organic-purple_price-farmgate-avg potato-organic-purple_price-farmgate-stdev ) 2
    if potatoes-purple-organic-fresh_price-to-buy < potato-organic-purple_price-farmer-breakeven [ set potatoes-purple-organic-fresh_price-to-buy potato-organic-purple_price-farmer-breakeven ]

    set potatoes-russet-conventional-fresh-small_price-to-buy precision ( random-normal potato-conventional-russet-small_price-shipper-receives-avg potato-conventional-russet-small_price-shipper-receives-stdev ) 2
    ;if potatoes-russet-conventional-fresh-small_price-to-buy < conv-input-price-per-lb [ set potatoes-russet-conventional-fresh-small_price-to-buy conv-input-price-per-lb ]
    ; small potatoes will likely be less than input costs

    if debug-mode = TRUE [
      print "shipper conventional russet price to buy"
      print potatoes-russet-conventional-fresh_price-to-buy ]

    if hide-turtles? = TRUE [ ht ]
    ]

end




to setup-potato_processors

  create-potato_processors number-potato_processors
  [
    set heading 0
    setxy random max-pxcor random max-pycor
    set shape "house"
    set size 2
    set color orange
    set id who
    set agent-name word "processor " id
    set assets 10000
    set assets-initial assets

    set potatoes-russet-conventional-fresh_inventory-maximum 200000000
    set potatoes-russet-conventional-processed_inventory-maximum 200000000
    set potatoes-russet-organic-fresh_inventory-maximum 200000000
    set potatoes-russet-conventional-fresh-small_inventory-maximum 200000000
    set potatoes-purple-conventional-fresh_inventory-maximum 200000000
    set potatoes-purple-conventional-processed_inventory-maximum 200000000
    set potatoes-purple-organic-fresh_inventory-maximum 200000000
    set potatoes-purple-organic-processed_inventory-maximum 200000000


    set potatoes-russet-conventional-fresh_price-to-buy precision ( random-normal potato-conventional-russet_price-shipper-receives-avg potato-conventional-russet_price-shipper-receives-stdev ) 2
    if potatoes-russet-conventional-fresh_price-to-buy < potato-conventional-russet_price-farmgate-avg [ set potatoes-russet-conventional-fresh_price-to-buy potato-conventional-russet_price-farmgate-avg ]

    set potatoes-russet-organic-fresh_price-to-buy precision ( random-normal potato-organic-russet_price-shipper-receives-avg potato-organic-russet_price-shipper-receives-stdev ) 2
    if potatoes-russet-organic-fresh_price-to-buy < potato-organic-russet_price-farmgate-avg [ set potatoes-russet-organic-fresh_price-to-buy potato-organic-russet_price-farmgate-avg ]

    set potatoes-purple-conventional-fresh_price-to-buy precision ( random-normal potato-conventional-purple_price-shipper-receives-avg potato-conventional-purple_price-shipper-receives-stdev ) 2
    if potatoes-purple-conventional-fresh_price-to-buy < potato-conventional-purple_price-farmgate-avg [ set potatoes-purple-conventional-fresh_price-to-buy potato-conventional-purple_price-farmgate-avg ]

    set potatoes-purple-organic-fresh_price-to-buy precision ( random-normal potato-organic-purple_price-shipper-receives-avg potato-organic-purple_price-shipper-receives-stdev ) 2
    if potatoes-purple-organic-fresh_price-to-buy < potato-organic-purple_price-farmgate-avg [ set potatoes-purple-organic-fresh_price-to-buy potato-organic-purple_price-farmgate-avg ]


    if debug-mode = TRUE [
     print "processor conventional russet fresh price to buy"
     print potatoes-russet-conventional-fresh_price-to-buy ]

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
    set assets-initial assets

    set potatoes-russet-conventional-fresh_inventory-maximum 1000000000000
    set potatoes-russet-conventional-processed_inventory-maximum 1000000000000
    set potatoes-russet-organic-fresh_inventory-maximum 1000000000000
    set potatoes-purple-conventional-fresh_inventory-maximum 1000000000000
    set potatoes-purple-conventional-processed_inventory-maximum 1000000000000
    set potatoes-purple-organic-fresh_inventory-maximum 1000000000000
    set potatoes-purple-organic-processed_inventory-maximum 1000000000000
    set potatoes-russet-conventional-fresh-small_inventory-maximum 1000000000000

    set potatoes-russet-conventional-fresh_price-to-buy precision ( random-normal potato-conventional-russet_price-shipper-receives-avg potato-conventional-russet_price-shipper-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-russet-conventional-fresh_price-to-buy < potato-conventional-russet_price-farmgate-avg [ set potatoes-russet-conventional-fresh_price-to-buy potato-conventional-russet_price-farmgate-avg ]

    set potatoes-russet-organic-fresh_price-to-buy precision ( random-normal potato-organic-russet_price-shipper-receives-avg potato-organic-russet_price-shipper-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-russet-organic-fresh_price-to-buy < potato-organic-russet_price-farmgate-avg [ set potatoes-russet-organic-fresh_price-to-buy potato-organic-russet_price-farmgate-avg ] ;flagged: variable rename

    set potatoes-purple-conventional-fresh_price-to-buy precision ( random-normal potato-conventional-purple_price-shipper-receives-avg potato-conventional-purple_price-shipper-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-purple-conventional-fresh_price-to-buy < potato-conventional-purple_price-farmgate-avg [ set potatoes-purple-conventional-fresh_price-to-buy potato-conventional-purple_price-farmgate-avg ]

    set potatoes-purple-organic-fresh_price-to-buy precision ( random-normal potato-organic-purple_price-shipper-receives-avg potato-organic-purple_price-shipper-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-purple-organic-fresh_price-to-buy < potato-organic-purple_price-farmgate-avg [ set potatoes-purple-organic-fresh_price-to-buy potato-organic-purple_price-farmgate-avg ] ;flagged: variable rename

    set potatoes-russet-conventional-fresh-small_price-to-buy precision ( random-normal potato-conventional-russet-small_price-shipper-receives-avg potato-conventional-russet-small_price-shipper-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-russet-conventional-fresh-small_price-to-buy < potato-conventional-russet-small_price-farmgate-avg [ set potatoes-russet-conventional-fresh-small_price-to-buy potato-conventional-russet-small_price-farmgate-avg ] ;flagged: variable rename

    if potato-scenario = "specialty-product" [

    set potatoes-russet-conventional-processed_price-to-buy precision ( random-normal potato-conventional-russet-processed_price-processor-receives-avg potato-conventional-russet-processed_price-processor-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-russet-conventional-processed_price-to-buy < potato-conventional-russet_price-shipper-receives-avg [ set potatoes-russet-conventional-processed_price-to-buy potato-conventional-russet_price-shipper-receives-avg ]

    set potatoes-russet-organic-processed_price-to-buy precision ( random-normal potato-organic-russet-processed_price-processor-receives-avg potato-organic-russet-processed_price-processor-receives-stdev) 2 ;flagged: variable rename
    if potatoes-russet-organic-processed_price-to-buy < potato-organic-russet_price-shipper-receives-avg [ set potatoes-russet-organic-processed_price-to-buy potato-organic-russet_price-shipper-receives-avg ] ;flagged: variable rename

    set potatoes-purple-conventional-processed_price-to-buy precision ( random-normal potato-conventional-purple-processed_price-processor-receives-avg potato-conventional-purple-processed_price-processor-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-purple-conventional-processed_price-to-buy < potato-conventional-purple_price-shipper-receives-avg [ set potatoes-purple-conventional-processed_price-to-buy potato-conventional-purple_price-shipper-receives-avg ]

    set potatoes-purple-organic-processed_price-to-buy precision ( random-normal potato-organic-purple-processed_price-processor-receives-avg potato-organic-purple-processed_price-processor-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-purple-organic-processed_price-to-buy < potato-organic-purple_price-shipper-receives-avg [ set potatoes-purple-organic-processed_price-to-buy potato-organic-purple_price-shipper-receives-avg ] ;flagged: variable rename

    ]

    if debug-mode = TRUE [
      print "distributor conventional russet fresh price to buy"
      print potatoes-russet-conventional-fresh_price-to-buy ]

    if hide-turtles? = TRUE [ ht ]
   ]

end


to setup-dps_buyers

  set-default-shape dps_buyers "house"

  ;; create elementary schools
  create-dps_buyers 1
  [
;    set school-type "elementary"
    setxy random max-pxcor random max-pycor                        ;; in order for this to work correctly, the origin of the netlogo display must be set at the corner
    set size 2
;    set color red
    set id who
;    set agent-name word "school " id
    set assets 10000
    set assets-initial assets

    set potatoes-russet-conventional-fresh_inventory-maximum 10
    set potatoes-russet-conventional-processed_inventory-maximum 10
    set potatoes-russet-organic-fresh_inventory-maximum 10
    set potatoes-purple-conventional-fresh_inventory-maximum 10
    set potatoes-purple-conventional-processed_inventory-maximum 10
    set potatoes-purple-organic-fresh_inventory-maximum 10
    set potatoes-purple-organic-processed_inventory-maximum 10
    set potatoes-russet-conventional-fresh-small_inventory-maximum 10
    if debug-mode = TRUE [
      print "school conventional russet fresh price to buy"
      print potatoes-russet-conventional-fresh_price-to-buy ]

    if hide-turtles? = TRUE [ ht ]
  ]

;  ;; create middle schools
;  create-schools 33
;  [
;    set school-type "middle"
;    setxy random max-pxcor random max-pycor                        ;; in order for this to work correctly, the origin of the netlogo display must be set at the corner
;    set size 2
;;    set color red
;    set id who
;    set agent-name word "school " id
;    set assets 10000
;
;    set potatoes-russet-conventional-fresh_inventory-maximum 10
;    set potatoes-russet-conventional-processed_inventory-maximum 10
;    set potatoes-russet-organic-fresh_inventory-maximum 10
;    set potatoes-purple-conventional-fresh_inventory-maximum 10
;    set potatoes-purple-conventional-processed_inventory-maximum 10
;    set potatoes-purple-organic-fresh_inventory-maximum 10
;    set potatoes-purple-organic-processed_inventory-maximum 10
;    set potatoes-russet-conventional-fresh-small_inventory-maximum 10
;
;    if debug-mode = TRUE [
;      print "school conventional russet fresh price to buy"
;      print potatoes-russet-conventional-fresh_price-to-buy ]
;
;    if hide-turtles? = TRUE [ ht ]
;  ]
;
;  ;; create high schools
;  create-schools 57
;  [
;    set school-type "high"
;    setxy random max-pxcor random max-pycor                        ;; in order for this to work correctly, the origin of the netlogo display must be set at the corner
;    set size 2
;;    set color red
;    set id who
;    set agent-name word "school " id
;    set assets 10000
;
;    set potatoes-russet-conventional-fresh_inventory-maximum 10
;    set potatoes-russet-conventional-processed_inventory-maximum 10
;    set potatoes-russet-organic-fresh_inventory-maximum 10
;    set potatoes-purple-conventional-fresh_inventory-maximum 10
;    set potatoes-purple-conventional-processed_inventory-maximum 10
;    set potatoes-purple-organic-fresh_inventory-maximum 10
;    set potatoes-purple-organic-processed_inventory-maximum 10
;    set potatoes-russet-conventional-fresh-small_inventory-maximum 10
;
;     if debug-mode = TRUE [
;       print "school conventional russet fresh price to buy"
;       print potatoes-russet-conventional-fresh_price-to-buy ]
;
;    if hide-turtles? = TRUE [ ht ]
;  ]

  ask dps_buyers [
   set potatoes-russet-conventional-fresh_price-to-buy precision ( random-normal potato-conventional-russet_price-distributor-receives-avg potato-conventional-russet_price-distributor-receives-stdev ) 2 ;flagged: variable rename
   if potatoes-russet-conventional-fresh_price-to-buy < potato-conventional-russet_price-shipper-receives-avg [ set potatoes-russet-conventional-fresh_price-to-buy potato-conventional-russet_price-shipper-receives-avg ] ;flagged: variable rename

    set potatoes-russet-organic-fresh_price-to-buy precision ( random-normal potato-organic-russet_price-distributor-receives-avg potato-organic-russet_price-distributor-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-russet-organic-fresh_price-to-buy < potato-organic-russet_price-shipper-receives-avg [ set potatoes-russet-organic-fresh_price-to-buy potato-organic-russet_price-shipper-receives-avg ] ;flagged: variable rename

    set potatoes-purple-conventional-fresh_price-to-buy precision ( random-normal potato-conventional-purple_price-distributor-receives-avg potato-conventional-purple_price-distributor-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-purple-conventional-fresh_price-to-buy < potato-conventional-purple_price-shipper-receives-avg [ set potatoes-purple-conventional-fresh_price-to-buy potato-conventional-purple_price-shipper-receives-avg ]

    set potatoes-purple-organic-fresh_price-to-buy precision ( random-normal potato-organic-purple_price-distributor-receives-avg potato-organic-purple_price-distributor-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-purple-organic-fresh_price-to-buy < potato-organic-purple_price-shipper-receives-avg [ set potatoes-purple-organic-fresh_price-to-buy potato-organic-purple_price-shipper-receives-avg ] ;flagged: variable rename

    set potatoes-russet-conventional-fresh-small_price-to-buy precision ( random-normal potato-conventional-russet-small_price-distributor-receives-avg potato-conventional-russet-small_price-distributor-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-russet-conventional-fresh-small_price-to-buy < potato-conventional-russet-small_price-shipper-receives-avg [ set potatoes-russet-conventional-fresh-small_price-to-buy potato-conventional-russet-small_price-shipper-receives-avg ] ;flagged: variable rename

    if potato-scenario = "specialty-product" [

    set potatoes-russet-conventional-processed_price-to-buy precision ( random-normal potato-conventional-russet-processed_price-distributor-receives-avg potato-conventional-russet-processed_price-distributor-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-russet-conventional-processed_price-to-buy < potato-conventional-russet-processed_price-processor-receives-avg [ set potatoes-russet-conventional-processed_price-to-buy potato-conventional-russet-processed_price-processor-receives-avg ]

    set potatoes-russet-organic-processed_price-to-buy precision ( random-normal potato-organic-russet-processed_price-distributor-receives-avg potato-organic-russet-processed_price-distributor-receives-stdev) 2 ;flagged: variable rename
    if potatoes-russet-organic-processed_price-to-buy < potato-organic-russet-processed_price-processor-receives-avg [ set potatoes-russet-organic-processed_price-to-buy potato-organic-russet-processed_price-processor-receives-avg ] ;flagged: variable rename

    set potatoes-purple-conventional-processed_price-to-buy precision ( random-normal potato-conventional-purple-processed_price-distributor-receives-avg potato-conventional-purple-processed_price-distributor-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-purple-conventional-processed_price-to-buy < potato-conventional-purple-processed_price-processor-receives-avg [ set potatoes-purple-conventional-processed_price-to-buy potato-conventional-purple-processed_price-processor-receives-avg ]

    set potatoes-purple-organic-processed_price-to-buy precision ( random-normal potato-organic-purple-processed_price-distributor-receives-avg potato-organic-purple-processed_price-distributor-receives-stdev ) 2 ;flagged: variable rename
    if potatoes-purple-organic-processed_price-to-buy < potato-organic-purple-processed_price-processor-receives-avg [ set potatoes-purple-organic-processed_price-to-buy potato-organic-purple-processed_price-processor-receives-avg ] ;flagged: variable rename

    ]
  ]
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


to setup-potato-farm-crop-allocation

  ask potato_farmers
  [
    set russet-canela-allocation 0.8
    set purple-allocation 0.2
  ]

end


to setup-estimated-yields

;  kevin's code
;  ask potato_farmers [
;    set potato-farmers_yield-estimated_russet-conventional (2.20462 * (((sum [potato-canela-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
;      with [certified-organic = 0] with [remainder-patch = 0] * 100 * russet-canela-allocation)) + (sum [potato-canela-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
;      with [certified-organic = 0] with [remainder-patch = 1] * russet-canela-allocation * (hectares-farmed-potatoes - (100 * (patches-in-potatoes - 1))))))
;
;    set potato-farmers_yield-estimated_purple-conventional (2.20462 * (((sum [potato-purple-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
;      with [certified-organic = 0] with [remainder-patch = 0] * 100 * purple-allocation)) + (sum [potato-purple-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
;      with [certified-organic = 0] with [remainder-patch = 1] * purple-allocation * (hectares-farmed-potatoes - (100 * (patches-in-potatoes - 1))))))
;
;    set potato-farmers_yield-estimated_russet-organic (2.20462 * (((sum [potato-canela-org-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
;      with [certified-organic = 1] with [remainder-patch = 0] * 100 * russet-canela-allocation)) + (sum [potato-canela-org-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
;      with [certified-organic = 1] with [remainder-patch = 1] * russet-canela-allocation * (hectares-farmed-potatoes - (100 * (patches-in-potatoes - 1))))))
;
;    set potato-farmers_yield-estimated_purple-organic (2.20462 * (((sum [potato-purple-org-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
;      with [certified-organic = 1] with [remainder-patch = 0] * 100 * purple-allocation)) + (sum [potato-purple-org-mean-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
;      with [certified-organic = 1] with [remainder-patch = 1] * purple-allocation * (hectares-farmed-potatoes - (100 * (patches-in-potatoes - 1))))))
;  ]


;  randy's simplified code
  ask potato_farmers [
    let f-id  farm-id

    ; All conventional potatoes, creating p-set0 and p-set1 based on, ultimately, remainder-patch (i.e., 0 or 1)
    let p-set patches with [ farmer = f-id ]
    set p-set p-set with [ rotation = "potato" and certified-organic = 0 ]
    let p-set0 p-set with [ remainder-patch = 0 ]
    let p-set1 p-set with [ remainder-patch = 1 ]

    ; Russet conventional
    set potato-farmers_yield-estimated_russet-conventional  sum [ potato-canela-mean-yield ] of p-set0 * 100 * russet-canela-allocation
    set potato-farmers_yield-estimated_russet-conventional  potato-farmers_yield-estimated_russet-conventional + ( sum [ potato-canela-mean-yield ] of p-set1 * russet-canela-allocation * ( hectares-farmed-potatoes - ( 100 * ( patches-in-potatoes - 1 ) ) ) )
    set potato-farmers_yield-estimated_russet-conventional  2.20462 * potato-farmers_yield-estimated_russet-conventional
    let total_russet_yield potato-farmers_yield-estimated_russet-conventional
    set potato-farmers_yield-estimated_russet-conventional (.67 * total_russet_yield)

    ; Small russet conventional
    set potato-farmers_yield-estimated_russet-conventional-small (.33 * total_russet_yield)

    ; Purple conventional
    set potato-farmers_yield-estimated_purple-conventional  sum [ potato-purple-mean-yield ] of p-set0 * 100 * purple-allocation
    set potato-farmers_yield-estimated_purple-conventional  potato-farmers_yield-estimated_purple-conventional + ( sum [ potato-purple-mean-yield ] of p-set1 * purple-allocation * ( hectares-farmed-potatoes - ( 100 * ( patches-in-potatoes - 1 ) ) ) )
    set potato-farmers_yield-estimated_purple-conventional  2.20462 * potato-farmers_yield-estimated_purple-conventional

    ; All organic potatoes, creating p-set0 and p-set1 based on, ultimately, remainder-patch (i.e., 0 or 1)
    set p-set patches with [ farmer = f-id ]
    set p-set p-set with [ rotation = "potato" and certified-organic = 1 ]
    set p-set0 p-set with [ remainder-patch = 0 ]
    set p-set1 p-set with [ remainder-patch = 1 ]

      ; Russet organic
    set potato-farmers_yield-estimated_russet-organic  sum [ potato-canela-org-mean-yield ] of p-set0 * 100 * russet-canela-allocation
    set potato-farmers_yield-estimated_russet-organic  potato-farmers_yield-estimated_russet-organic + ( sum [ potato-canela-org-mean-yield ] of p-set1 * russet-canela-allocation * ( hectares-farmed-potatoes - ( 100 * ( patches-in-potatoes - 1 ) ) ) )
    set potato-farmers_yield-estimated_russet-organic  2.20462 * potato-farmers_yield-estimated_russet-organic

    ; Purple organic
    set potato-farmers_yield-estimated_purple-organic  sum [ potato-purple-org-mean-yield ] of p-set0 * 100 * purple-allocation
    set potato-farmers_yield-estimated_purple-organic  potato-farmers_yield-estimated_purple-organic + ( sum [ potato-purple-org-mean-yield ] of p-set1 * purple-allocation * ( hectares-farmed-potatoes - ( 100 * ( patches-in-potatoes - 1 ) ) ) )
    set potato-farmers_yield-estimated_purple-organic  2.20462 * potato-farmers_yield-estimated_purple-organic



  ]

end


to go

  if ticks > max-ticks [ stop ]
  manage-dates
  if ( week = 31 ) [ reset-storage ]
  if ( week = 31 ) and ( year != 1 ) [
    profitability-check
    transition-patches
    update-organic
    update-display ]
  if week = 31 [ setup-estimated-yields ]
  if ( week = 5 ) or ( week = 18 ) or ( week = 31 ) [
    reset-promised-amounts
    table:clear potato-table_russet-conventional
    table:clear potato-table_russet-organic
    table:clear potato-table_purple-conventional
    table:clear potato-table_purple-organic
    table:clear potato-table_russet-conventional-small
    table:clear potato-table_russet-conventional-processed                                                  ;; potato contracting tables
    table:clear potato-table_russet-organic-processed
    table:clear potato-table_purple-conventional-processed
    table:clear potato-table_purple-organic-processed
    set-contracts
;    if potato-scenario = "gfpp"
;      [ set-gfpp-contracts ]
;    if (potato-scenario = "fresh-CO") or (potato-scenario = "small-potatoes") or (potato-scenario = "baseline")
;      [ set-contracts_russet-conventional
;        set-contracts_russet-organic
;        set-contracts_purple-conventional
;        set-contracts_purple-organic ]
       ]
  if week = 36 [
    produce-potatoes
    output-print data-year ]    ; tracker for debugging
  if ( week = 6 ) or ( week = 19 ) or ( week = 37 ) [
  fulfill-contracts ; right now this sends all contracted potatoes at once, but we could go back and devide it into weekly shipments if wanted/needed
  process-potatoes
  fulfill-processor-contracts ]
  if potato-scenario = "baseline" [ ;baseline = TRUE [
    if ((week > 33) and (week < 47)) or ((week > 47) and (week < 52)) or ((week > 2) and (week < 13)) or ((week > 13) and (week < 22))
    [school-purchases-baseline-french-fries]
  ]
;  if week = 29 [spot-market-sales potato_farmers potato_repackers number-potato_repackers] ;double check that this is the correct week for this
  ;; --------------------------------------------------
  ;; somewhere here we need to resolve when potatoes get processed, and how we track processor/school inventory (it introduces all the differentiated products into our table setup)
  ;; --------------------------------------------------
  scuola-cucina-cibo
  eat-breakfast
  eat-lunch
  tally-hei
  if ticks = max-ticks [ calc-profit ]
  ;output-data ;--> not needed during normal model runs, only for outputting results to spreadsheet as needed
  tick

end

to calc-profit
  print "avg farmer profitability:"
  let mean-final-farmer mean [assets-final] of potato_farmers
  let mean-initial-farmer mean [assets-initial] of potato_farmers
  let profitability-average-potato-farmer (mean-final-farmer - mean-initial-farmer) / year
  print profitability-average-potato-farmer

  print "avg shipper profitability:"
  let mean-final-shipper mean [assets-final] of potato_shippers
  let mean-initial-shipper mean [assets-initial] of potato_shippers
  let profitability-average-potato-shipper (mean-final-shipper - mean-initial-shipper) / year
  print profitability-average-potato-shipper

  print "avg repacker profitability:"
  let mean-final-repacker mean [assets-final] of potato_repackers
  let mean-initial-repacker mean [assets-initial] of potato_repackers
  let profitability-average-potato-repacker (mean-final-repacker - mean-initial-repacker) / year
  print profitability-average-potato-repacker

  print "avg distributor profitability:"
  let mean-final-distributor mean [assets-final] of distributors
  let mean-initial-distributor mean [assets-initial] of distributors
  let profitability-average-distributor (mean-final-distributor - mean-initial-distributor) / year
  print profitability-average-distributor

  print "avg dps_buyer profitability:"
  let mean-final-dps mean [assets-final] of dps_buyers
  let mean-initial-dps mean [assets-initial] of dps_buyers
  let profitability-average-dps_buyer (mean-final-dps - mean-initial-dps) / year
  print profitability-average-dps_buyer


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


 ; maybe come back to this later and play with frequency of profitability check for small/medium farms
to profitability-check
ask potato_farmers [
    let predicted-org-profit 0
    let predicted-conv-profit 0

    if farm-transitioning = 1 [
      update-tls
      transition-patches
    ]

    if farm-transitioning = 0
    [
      ;basic-profitability-calculation
      let estimated-conv-yield 2.20462 * (mean [potato-canela-mean-yield] of patches with [farmer = [farm-id] of myself] * hectares-farmed-potatoes)
      ; 1 kg = 2.20462 lbs. so the above shows the yield in lbs.
      let conventional-revenue-for-conv-calc (estimated-conv-yield * potato-conventional-russet_price-farmgate-avg * organic-planning-horizon)
      let acres-farmed-potatoes (hectares-farmed-potatoes * 2.471)  ; 1 ha = 2.471 acres
      let conventional-costs (acres-farmed-potatoes * potato-conventional-russet_cost-input-per-acre * organic-planning-horizon)
       ; ^ running into same hectares vs. lbs for input price issue from other parts of the model
      set predicted-conv-profit (conventional-revenue-for-conv-calc - conventional-costs)

      ;organic-profitability-calculation
      let estimated-org-yield 2.20462 * (mean [potato-canela-org-mean-yield] of patches with [farmer = [farm-id] of myself] * hectares-farmed-potatoes)
      let conventional-revenue-for-org-calc (estimated-org-yield * potato-conventional-russet_price-farmgate-avg * 3)  ; get organic yields even though getting conventional price per lb.
      let organic-revenue (estimated-org-yield * potato-organic-russet_price-farmgate-avg * (organic-planning-horizon - 3))
      let organic-costs (acres-farmed-potatoes * potato-organic-russet_cost-input-per-acre * organic-planning-horizon)
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
;    print mean [transition-likelihood-score ] of potato_farmers
;    print count potato_farmers with [ transition-likelihood-score >= .5 ]
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
    let not-me other potato_farmers
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
    let not-me other potato_farmers
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

  ask potato_farmers [

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

  let my-farmer potato_farmers with [ farm-id = [farmer] of myself]
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

  if display-style = "potato vs barley rotation"
  [
    ask patches with [ rotation = "barley" ] [ set pcolor 125 ]
    ask patches with [ rotation = "potato" ] [ set pcolor 34 ]
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
    ask potato_farmers with ( [ fully-organic = 1 and ( farm-size = "small" or ( farm-size = "medium" and alternative-farmer = 1 ) ) ] )
    [
      let my-patches patches with [ farmer = [ farm-id ] of myself ]
      ask my-patches [set pcolor 45 ]
    ]
  ]

  if display-style = "bad vs good year"
  [
    ask patches with [ occupied = 1 ] [
      set pcolor 5
      if ( potato-russet-canela-current-yield > 1.2 * potato-canela-mean-yield ) [ set pcolor 125 ]
      if ( potato-russet-canela-current-yield <= 1.2 * potato-canela-mean-yield ) [ set pcolor 135 ]
      if ( potato-russet-canela-current-yield <= 1.1 * potato-canela-mean-yield ) [ set pcolor 63 ]
      if ( potato-russet-canela-current-yield <= 1 * potato-canela-mean-yield ) [ set pcolor 66 ]
      if ( potato-russet-canela-current-yield <= .9 * potato-canela-mean-yield ) [ set pcolor 45 ]
      if ( potato-russet-canela-current-yield <= .8 * potato-canela-mean-yield ) [ set pcolor 43 ]
      if ( potato-russet-canela-current-yield <= .7 * potato-canela-mean-yield ) [ set pcolor 27 ]
      if ( potato-russet-canela-current-yield <= .6 * potato-canela-mean-yield ) [ set pcolor 25 ]
      if ( potato-russet-canela-current-yield <= .5 * potato-canela-mean-yield ) [ set pcolor 23 ]
      if ( potato-russet-canela-current-yield <= .4 * potato-canela-mean-yield ) [ set pcolor 17 ]
      if ( potato-russet-canela-current-yield <= .3 * potato-canela-mean-yield ) [ set pcolor 15 ]
      if ( potato-russet-canela-current-yield <= .2 * potato-canela-mean-yield ) [ set pcolor 12 ]
    ]
  ]

  if display-style = "transition likelihood score"
  [
    ask potato_farmers
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
    ask potato_farmers
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


;EXPERIMENTING WITH NEW SCENARIO-BASED CONTRACTING PROCEDURE HERE (if successful, should be able to delete procedures below. but saving all for now.)

to set-contracts

  ;no matter the scenario, the farmer sells to shippers and repackers

  ;farmers to shippers
  setContracts_russetConventionalFresh  potato_farmers  potato_shippers  number-potato_shippers  TRUE
  setContracts_russetOrganicFresh  potato_farmers  potato_shippers  number-potato_shippers  TRUE
  setContracts_purpleConventionalFresh  potato_farmers  potato_shippers  number-potato_shippers  TRUE
  setContracts_purpleOrganicFresh  potato_farmers  potato_shippers  number-potato_shippers  TRUE
  setContracts_smallFresh  potato_farmers  potato_shippers  number-potato_shippers  TRUE

  ;farmers to repackers
  setContracts_russetConventionalFresh  potato_farmers  potato_repackers  number-potato_repackers  TRUE
  setContracts_russetOrganicFresh  potato_farmers  potato_repackers  number-potato_repackers  TRUE
  setContracts_purpleConventionalFresh  potato_farmers  potato_repackers  number-potato_repackers  TRUE
  setContracts_purpleOrganicFresh  potato_farmers  potato_repackers  number-potato_repackers  TRUE
  setContracts_smallFresh  potato_farmers  potato_repackers  number-potato_repackers  TRUE

  ;scenario 1: baseline
  if potato-scenario = "baseline"[

    ;shippers to distributors
    setContracts_russetConventionalFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_russetOrganicFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_purpleConventionalFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_purpleOrganicFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_smallFresh  potato_shippers  distributors  number-distributors  TRUE

    ;schools purchase baseline french fries from distributor THIS HAPPENS IN GO PROCEDURE RIGHT NOW.
    ;school-purchases-baseline-french-fries
  ]

  ;scenario 2: fresh-CO
  if potato-scenario = "fresh-CO"[

    ;shippers to distributors
    setContracts_russetConventionalFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_russetOrganicFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_purpleConventionalFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_purpleOrganicFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_smallFresh  potato_shippers  distributors  number-distributors  TRUE

    ;schools purchase fresh CO russets from distributors
    setContracts_russetConventionalFresh  distributors  dps_buyers  1  FALSE

  ]

  ;scenario 3: gfpp
  if potato-scenario = "gfpp"[

    ;schools purchase russet conventional fresh potatoes from shippers
    setContracts_russetConventionalFresh  potato_shippers  schools  school-count  FALSE

    ;then potatoes flow through system as normal
    setContracts_russetConventionalFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_russetOrganicFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_purpleConventionalFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_purpleOrganicFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_smallFresh  potato_shippers  distributors  number-distributors  TRUE
  ]

  ;scenario 4: small-potatoes
  if potato-scenario = "small-potatoes"[

    ;schools purchase small russet conventional fresh potatoes from shippers
    setContracts_smallFresh  potato_shippers  dps_buyers  1  FALSE

    ;then potatoes flow through system as normal
    setContracts_russetConventionalFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_russetOrganicFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_purpleConventionalFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_purpleOrganicFresh  potato_shippers  distributors  number-distributors  TRUE
    setContracts_smallFresh  potato_shippers  distributors  number-distributors  TRUE
  ]

  ;scenario 5: specialty-product
  if potato-scenario = "specialty-product"[
    ;shippers to processors
    setContracts_russetConventionalFresh  potato_shippers  potato_processors  number-potato_processors  TRUE
    setContracts_russetOrganicFresh  potato_shippers  potato_processors  number-potato_processors  TRUE
    setContracts_purpleConventionalFresh  potato_shippers  potato_processors  number-potato_processors  TRUE
    setContracts_purpleOrganicFresh  potato_shippers  potato_processors  number-potato_processors  TRUE
    setContracts_smallFresh  potato_shippers  potato_processors  number-potato_processors  TRUE

    ;processors to distributors
    setContracts_russetConventionalProcessed  potato_processors  distributors  number-distributors  TRUE
    setContracts_purpleConventionalProcessed  potato_processors  distributors  number-distributors  TRUE
    setContracts_purpleOrganicProcessed  potato_processors  distributors  number-distributors  TRUE

    ;schools purchase purple processed potatoes (could change this to be combo of products in final scenario)
    setContracts_purpleConventionalProcessed  distributors  dps_buyers  1  FALSE
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
    set out-of-state-french-fry_price-to-sell random-normal potato-conventional-russet-processed_price-distributor-receives-avg potato-conventional-russet-processed_price-distributor-receives-stdev
  ]

    ask dps_buyers [ if out-of-state-french-fry_inventory-current < out-of-state-french-fry_inventory-maximum
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


;to set-contracts_russet-conventional
;
;  ;; -------------------------------------------------------------------------------------------------------------------
;  ;; add something here to check week to decided if it's time to contract, and if so if it's prime/off season
;  ;; also add something here so that if it's off-season contract negotiation, all buy prices are increased by 10% (prices are higher in the off season)
;  ;; -------------------------------------------------------------------------------------------------------------------
;  ;; potato to standard french fry, processor needed
;
;  ;  farmers to shippers
;  setContracts_russetConventionalFresh  potato_farmers  potato_shippers  number-potato_shippers  TRUE
;
;  ;  farmers to repackers
;  setContracts_russetConventionalFresh  potato_farmers  potato_repackers  number-potato_repackers  TRUE
;
;  ;  shippers to processors
;  setContracts_russetConventionalFresh  potato_shippers  potato_processors  number-potato_processors  TRUE
;
;  ;  shippers to distributors
;  setContracts_russetConventionalFresh  potato_shippers  distributors  number-distributors  TRUE
;
;  ;  processors to distributors
;  setContracts_russetConventionalProcessed  potato_processors  distributors  number-distributors  TRUE
;
;  ;  distributors to school
;  if potato-scenario != "baseline" [
;  setContracts_russetConventionalFresh  distributors  schools  school-count  FALSE
;  setContracts_russetConventionalProcessed  distributors  schools  school-count  FALSE
;  ]
;
;end
;
;
;to set-contracts_russet-organic
;
;  ;; -------------------------------------------------------------------------------------------------------------------
;  ;; add something here to check week to decided if it's time to contract, and if so if it's prime/off season
;  ;; also add something here so that if it's off-season contract negotiation, all buy prices are increased by 10% (prices are higher in the off season)
;  ;; -------------------------------------------------------------------------------------------------------------------
;  ;; potato to baked potatoes, no processor needed
;
;  ;  farmers to shippers
;  setContracts_russetOrganicFresh  potato_farmers  potato_shippers  number-potato_shippers  TRUE
;
;  ;  farmers to repackers
;  setContracts_russetOrganicFresh  potato_farmers  potato_repackers  number-potato_repackers  TRUE
;
;  ;  shippers to distributors
;  setContracts_russetOrganicFresh  potato_shippers  distributors  number-distributors  TRUE
;
;  ;  distributors to school
;  if potato-scenario != "baseline" [
;  setContracts_russetOrganicFresh  distributors  schools  school-count  FALSE
;  ]
;
;end
;
;
;to set-contracts_purple-conventional
;
;  ;; -------------------------------------------------------------------------------------------------------------------
;  ;; add something here to check week to decided if it's time to contract, and if so if it's prime/off season
;  ;; also add something here so that if it's off-season contract negotiation, all buy prices are increased by 10% (prices are higher in the off season)
;  ;; -------------------------------------------------------------------------------------------------------------------
;  ;; potato to specialty potato chip, processor needed
;
;  ;  farmers to shippers
;  setContracts_purpleConventionalFresh  potato_farmers  potato_shippers  number-potato_shippers  TRUE
;
;  ;  farmers to repackers
;  setContracts_purpleConventionalFresh  potato_farmers  potato_repackers  number-potato_repackers  TRUE
;
;  ;  shippers to processors
;  setContracts_purpleConventionalFresh  potato_shippers  potato_processors  number-potato_processors  TRUE
;
;  ;  shippers to distributors
;  setContracts_purpleConventionalFresh  potato_shippers  distributors  number-distributors  TRUE
;
;  ;  processors to distributors
;  setContracts_purpleConventionalProcessed  potato_processors  distributors  number-distributors  TRUE
;
;  ;  distributors to school
;  if potato-scenario != "baseline" [
;  setContracts_purpleConventionalFresh  distributors  schools  school-count  FALSE
;  setContracts_purpleConventionalProcessed   distributors  schools  school-count  FALSE
;  ]
;
;end
;
;
;to set-contracts_purple-organic
;
;  ;; -------------------------------------------------------------------------------------------------------------------
;  ;; add something here to check week to decided if it's time to contract, and if so if it's prime/off season
;  ;; also add something here so that if it's off-season contract negotiation, all buy prices are increased by 10% (prices are higher in the off season)
;  ;; -------------------------------------------------------------------------------------------------------------------
;  ;; potato to organic specialty wedge, processor needed
;
;  ;  farmers to shippers
;  setContracts_purpleOrganicFresh  potato_farmers  potato_shippers  number-potato_shippers  TRUE
;
;  ;  farmers to repackers
;  setContracts_purpleOrganicFresh  potato_farmers  potato_repackers  number-potato_repackers  TRUE
;
;  ;  shippers to processors
;  setContracts_purpleOrganicFresh  potato_shippers  potato_processors  number-potato_processors  TRUE
;
;  ;  shippers to distributors
;  setContracts_purpleOrganicFresh  potato_shippers  distributors  number-distributors  TRUE
;
;  ;  processors to distributors
;  setContracts_purpleOrganicProcessed  potato_processors  distributors  number-distributors  TRUE
;
;  ;  distributors to school
;  if potato-scenario != "baseline" [
;  setContracts_purpleOrganicFresh  distributors  schools  school-count  FALSE
;  setContracts_purpleOrganicProcessed   distributors  schools  school-count  FALSE
;  ]
;
;end
;
;to set-contracts_small-potatoes
;
;  ;; -------------------------------------------------------------------------------------------------------------------
;  ;; add something here to check week to decided if it's time to contract, and if so if it's prime/off season
;  ;; also add something here so that if it's off-season contract negotiation, all buy prices are increased by 10% (prices are higher in the off season)
;  ;; -------------------------------------------------------------------------------------------------------------------
;
;  ;; assume small potatoes are only russet conventional
;
;  ;  farmers to shippers
;  setContracts_smallFresh  potato_farmers  potato_shippers  number-potato_shippers  TRUE
;
;  ;  shippers to school
;  setContracts_smallFresh  potato_shippers  schools  school-count  TRUE
;
;
;  ; IF SCHOOL IS PURCHASING DIRECTLY FROM SHIPPERS, NEED TO MAKE SURE PERCENTAGES SENT THROUGH EACH ROUTE OF SUPPLY CHAIN ARE WORKING AS INTENDED
;
;
;
;  ;  farmers to repackers
;  setContracts_smallFresh  potato_farmers  potato_repackers  number-potato_repackers  TRUE
;
;  ;  shippers to processors
;  setContracts_smallFresh  potato_shippers  potato_processors  number-potato_processors  TRUE
;
;  ;  shippers to distributors
;  setContracts_smallFresh  potato_shippers  distributors  number-distributors  TRUE
;
;  ;  processors to distributors
;  setContracts_smallFresh  potato_processors  distributors  number-distributors  TRUE
;
;  ;  distributors to school
;  if potato-scenario != "baseline" [
;  setContracts_smallFresh  distributors  schools  school-count  FALSE
;  setContracts_smallFresh   distributors  schools  school-count  FALSE
;  ]
;
;  ; MAKE SURE THE NUMBER DISTRIBUTORS INPUT VARIABLE IS CORRECT IN DISTRIBUTORS TO SCHOOL PORTION OF THIS CODE
;
;end
;
;to set-gfpp-contracts
;  ; we assume in the gfpp scenario that schools are only purchasing conventional russet potatoes, not any other potato types/varieties!
;  ; farmers will otherwise sell to shippers as they normally do
;
;  ; short supply chain for as many conventional russets as the schools want to buy
;  ;  farmers to shippers
;  setContracts_russetConventionalFresh  potato_farmers  potato_shippers  number-potato_shippers  FALSE
;
;  ;  shippers to school
;  setContracts_russetConventionalFresh  potato_shippers  schools  school-count  FALSE
;
;
;  ; normal contracts for farmers to sell the rest of their potatoes WILL THIS MESS UP % TO DIFFERENT AGENTS AT THE FARMGATE???
;
;end


;; -------------------------------------
;; right now this happens all at once, but it could be made weekly by having farmers harvest 1/7th (the harvest season is 7 weeks long) of their annual production each week of the harvest season
;; come back to this later is necessary
; --------------------------------------
to produce-potatoes

  set-potato-yield ; annual, planning stage
  set-potato-farm-crop-allocation ; annual, planning steage
  set-potato-barley-rotation ; annual, planning stage
  calculate-annual-production ; annual, harvest stage

end


to fulfill-contracts

  ;; --------------------------------------------------------------------------------
  ;; NEED TO MAKE SURE FARMERS GET PAID WHEN SHIPPER/WAREHOUSE CONTRACT ARE FULFILLED
  ;; --------------------------------------------------------------------------------


   ;no matter the scenario, the farmer sells to shippers and repackers

  ; FARMER TO SHIPPER CONTRACT FULFILLMENT
  fulfillContracts_russetConventionalFresh potato_farmers potato_shippers
  fulfillContracts_russetOrganicFresh potato_farmers potato_shippers
  fulfillContracts_purpleConventionalFresh potato_farmers potato_shippers
  fulfillContracts_purpleOrganicFresh potato_farmers potato_shippers
  fulfillContracts_smallFresh potato_farmers potato_shippers

  ; FARMER TO REPACKER CONTRACT FULFILLMENT
  fulfillContracts_russetConventionalFresh potato_farmers potato_repackers
  fulfillContracts_russetOrganicFresh potato_farmers potato_repackers
  fulfillContracts_purpleConventionalFresh potato_farmers potato_repackers
  fulfillContracts_purpleOrganicFresh potato_farmers potato_repackers
  fulfillContracts_smallFresh potato_farmers potato_repackers

  if potato-scenario = "baseline" [
    fulfillContracts_russetConventionalFresh potato_shippers distributors
    fulfillContracts_russetOrganicFresh potato_shippers distributors
    fulfillContracts_purpleConventionalFresh potato_shippers distributors
    fulfillContracts_purpleOrganicFresh potato_shippers distributors
    fulfillContracts_smallFresh potato_shippers distributors
  ]

  if potato-scenario = "fresh-CO" [
    fulfillContracts_russetConventionalFresh potato_shippers distributors
    fulfillContracts_russetOrganicFresh potato_shippers distributors
    fulfillContracts_purpleConventionalFresh potato_shippers distributors
    fulfillContracts_purpleOrganicFresh potato_shippers distributors
    fulfillContracts_smallFresh potato_shippers distributors

    fulfillContracts_russetConventionalFresh distributors dps_buyers
  ]

  if potato-scenario = "gfpp" [
    fulfillContracts_russetConventionalFresh potato_shippers dps_buyers

    fulfillContracts_russetConventionalFresh potato_shippers distributors
    fulfillContracts_russetOrganicFresh potato_shippers distributors
    fulfillContracts_purpleConventionalFresh potato_shippers distributors
    fulfillContracts_purpleOrganicFresh potato_shippers distributors
    fulfillContracts_smallFresh potato_shippers distributors
  ]

  if potato-scenario = "small-potatoes" [
    fulfillContracts_smallFresh potato_shippers dps_buyers

    fulfillContracts_russetConventionalFresh potato_shippers distributors
    fulfillContracts_russetOrganicFresh potato_shippers distributors
    fulfillContracts_purpleConventionalFresh potato_shippers distributors
    fulfillContracts_purpleOrganicFresh potato_shippers distributors
    fulfillContracts_smallFresh potato_shippers distributors
  ]

  if potato-scenario = "specialty-product" [
  fulfillContracts_russetConventionalFresh potato_shippers potato_processors
  fulfillContracts_purpleConventionalFresh potato_shippers potato_processors
  fulfillContracts_purpleOrganicFresh potato_shippers potato_processors
  fulfillContracts_smallFresh potato_shippers potato_processors
  ]

  ; ^ do this during fulfillment with amount-exchanged variable so don't accidentally double count if potatoes remain in repacker inventory between ticks for some reason?

;  ask potato_shippers [
;    if potatoes-russet-conventional-fresh_inventory-current < 0 [ set potatoes-russet-conventional-fresh_inventory-current 0 ] ] ; this line forces no negative inventory amounts

end


to fulfill-processor-contracts
  if potato-scenario = "specialty-product" [

    ; PROCESSOR TO DISTRIBUTOR CONTRACT FULFILLMENT
    fulfillContracts_russetConventionalProcessed potato_processors distributors
    fulfillContracts_purpleConventionalProcessed potato_processors distributors
    fulfillContracts_purpleOrganicProcessed potato_processors distributors

    ; DISTRIBUTOR TO SCHOOL CONTRACT FULFILLMENT
    fulfillContracts_purpleConventionalProcessed  distributors  dps_buyers
  ]

end


to spot-market-sales [ sellers buyers buyer_count]   ; only set up for farmers to repackers right now (if want to include other agents, will need to make space availabel variable for them.
  let amount-exchanged 0                             ; the way this process is set up, farmers get one chance to sell potatoes to a repacker and the rest go to waste
  let price-exchanged 0                              ; the farmer chooses the repacker based on price, not space available....maybe should change this.
  let price-tag 0                                    ; maybe it should be buyers with capacity = space for all potatoes

  ask buyers [
    set potatoes-russet-conventional-fresh_space-available ( potatoes-russet-conventional-fresh_inventory-maximum - potatoes-russet-conventional-fresh_inventory-current )
  ]

  ask sellers [
    if potatoes-russet-conventional-fresh_inventory-current > 0 [

    let buyers-with-capacity ( buyers with [ potatoes-russet-conventional-fresh_contract-space-available > 0 ] )
    let bidding_buyers 0
    if any? buyers-with-capacity [
      ifelse ( count buyers-with-capacity ) >= ( round ( market-knowledge * buyer_count ) )
      [ set bidding_buyers n-of ( round ( market-knowledge * buyer_count ) ) buyers-with-capacity ]
      [ set bidding_buyers buyers-with-capacity ]

      let my-buyer n-of 1 ( bidding_buyers with-max [ potatoes-russet-conventional-fresh_price-to-buy ] )
      let space-avail item 0 ([potatoes-russet-conventional-fresh_contract-space-available] of my-buyer )
      ifelse potatoes-russet-conventional-fresh_inventory-current > space-avail
        [ set amount-exchanged space-avail ]
        [ set amount-exchanged potatoes-russet-conventional-fresh_inventory-current ]
     set price-exchanged item 0 ([potatoes-russet-conventional-fresh_price-to-buy] of my-buyer )
     set price-tag (amount-exchanged * price-exchanged)
     set potatoes-russet-conventional-fresh_inventory-current (potatoes-russet-conventional-fresh_inventory-current - amount-exchanged)
     set assets (assets + price-tag)
    ]
   ]
  ]
  ask buyers [
    set potatoes-russet-conventional-fresh_inventory-current (potatoes-russet-conventional-fresh_inventory-current + amount-exchanged)
    set assets (assets - price-tag)
  ]

  ask sellers [
    set potatoes-russet-conventional-fresh_inventory-current 0
  ]
end

to out-of-state-sales

end

to reset-promised-amounts

  ask potato_farmers [
    set potatoes-russet-conventional-fresh-promised 0
    set potatoes-russet-organic-fresh-promised 0
    set potatoes-purple-conventional-fresh-promised 0
    set potatoes-purple-organic-fresh-promised 0
    set potatoes-russet-conventional-fresh-small-promised 0 ]

  ask potato_shippers [
    set potatoes-russet-conventional-fresh_my-incoming-total 0
    set potatoes-russet-conventional-fresh-promised 0
    set potatoes-russet-organic-fresh_my-incoming-total 0
    set potatoes-russet-organic-fresh-promised 0
    set potatoes-purple-conventional-fresh_my-incoming-total 0
    set potatoes-purple-conventional-fresh-promised 0
    set potatoes-purple-organic-fresh_my-incoming-total 0
    set potatoes-purple-organic-fresh-promised 0
    set potatoes-russet-conventional-fresh-small_my-incoming-total 0
    set potatoes-russet-conventional-fresh-small-promised 0]

  ask potato_repackers [
    set potatoes-russet-conventional-fresh_my-incoming-total 0
    set potatoes-russet-conventional-fresh-promised 0
    set potatoes-russet-organic-fresh_my-incoming-total 0
    set potatoes-russet-organic-fresh-promised 0
    set potatoes-purple-conventional-fresh_my-incoming-total 0
    set potatoes-purple-conventional-fresh-promised 0
    set potatoes-purple-organic-fresh_my-incoming-total 0
    set potatoes-purple-organic-fresh-promised 0
    set potatoes-russet-conventional-fresh-small_my-incoming-total 0
    set potatoes-russet-conventional-fresh-small-promised 0 ]

  ask potato_processors [
    set potatoes-russet-conventional-fresh_my-incoming-total 0
    set potatoes-russet-conventional-processed-promised 0
    set potatoes-purple-conventional-fresh_my-incoming-total 0
    set potatoes-purple-conventional-processed-promised 0
    set potatoes-purple-organic-fresh_my-incoming-total 0
    set potatoes-purple-organic-processed-promised 0
    set potatoes-russet-conventional-fresh-small_my-incoming-total 0
    set potatoes-russet-conventional-fresh-small-promised 0 ]

  ask distributors [
    set potatoes-russet-conventional-fresh_my-incoming-total 0
    set potatoes-russet-conventional-fresh-promised 0
    set potatoes-russet-conventional-processed_my-incoming-total 0
    set potatoes-russet-conventional-processed-promised 0
    set potatoes-russet-organic-fresh_my-incoming-total 0
    set potatoes-russet-organic-fresh-promised 0
    set potatoes-purple-conventional-fresh_my-incoming-total 0
    set potatoes-purple-conventional-fresh-promised 0
    set potatoes-purple-conventional-processed_my-incoming-total 0
    set potatoes-purple-conventional-processed-promised 0
    set potatoes-purple-organic-fresh_my-incoming-total 0
    set potatoes-purple-organic-fresh-promised 0
    set potatoes-purple-organic-processed_my-incoming-total 0
    set potatoes-purple-organic-processed-promised 0
    set potatoes-russet-conventional-fresh-small_my-incoming-total 0
    set potatoes-russet-conventional-fresh-small-promised 0 ]

end

;*************************
;  SET POTATO YIELD DSSAT ; input 38 years of DSSAT yield data into patches
;*************************
to set-potato-yield ; set single-year random potato yield

;  set data-year 1998
  set data-year 1980 + random 39
;  set data-year 1981 --> for debugging (we know 1981 was a very bad production year)

  let file-name-canela (word data-year "_canela.asc")
  set canela-load gis:load-dataset file-name-canela
  gis:apply-raster canela-load potato-russet-canela-current-yield

  let file-name-canela-org (word data-year "_canela_org.asc")
  set canela-org-load gis:load-dataset file-name-canela-org
  gis:apply-raster canela-org-load potato-russet-canela-org-current-yield

  let file-name-purple (word data-year "_purple.asc")
  set purple-load gis:load-dataset file-name-purple
  gis:apply-raster purple-load potato-purple-current-yield

  let file-name-purple-org (word data-year "_purple_org.asc")
  set purple-org-load gis:load-dataset file-name-purple-org
  gis:apply-raster purple-org-load potato-purple-org-current-yield

  ask patches
 [
    ifelse potato-russet-canela-current-yield >= 0; sets all non-producing patches to 0, otherwise they are NaN. Also see next set of commands re: NaN
    []
    [
      set potato-russet-canela-current-yield 0
      set potato-russet-canela-org-current-yield 0
      set potato-purple-current-yield 0
      set potato-purple-org-current-yield 0
    ]
  ]

  ask patches with [occupied = 1]; this fixes the situation where some years from DSSAT seem to produce NaN for a small number of patches. I think this is a DSSAT error
  [
    if potato-russet-canela-current-yield = 0
    [
      set potato-russet-canela-current-yield mean [potato-russet-canela-current-yield] of patches with [potato-yes-no = 1]
      set potato-russet-canela-org-current-yield mean [potato-russet-canela-org-current-yield] of patches with [potato-yes-no = 1]
      set potato-purple-current-yield mean [potato-purple-current-yield] of patches with [potato-yes-no = 1]
      set potato-purple-org-current-yield mean [potato-purple-org-current-yield] of patches with [potato-yes-no = 1]

      ; this is where we could set a bad-production-year variable for farmers. would need to link farmers to patches and reset to 0 at the beginning of every season
    ]
  ]

  update-bad-production-year

end

to update-bad-production-year

  ask potato_farmers [
    set last-year-mediocre-production-year this-year-mediocre-production-year
    set last-year-bad-production-year this-year-bad-production-year

    set this-year-mediocre-production-year 0
    set this-year-bad-production-year 0

    ; if production of any variety is below 60% of its mean yield, the year is considered a "bad" production year --> used in TLS update

    ; mediocre production year
    if (.7 * potato-canela-mean-yield < potato-russet-canela-current-yield) and (potato-russet-canela-current-yield < 1 * potato-canela-mean-yield)
        [set this-year-mediocre-production-year 1]
    if (.7 * potato-canela-org-mean-yield < potato-russet-canela-current-yield) and (potato-russet-canela-current-yield < 1 * potato-canela-org-mean-yield)
        [set this-year-mediocre-production-year 1]
    if (.7 * potato-purple-mean-yield < potato-russet-canela-current-yield) and (potato-russet-canela-current-yield < 1 * potato-purple-mean-yield)
        [set this-year-mediocre-production-year 1]
    if (.7 * potato-purple-org-mean-yield < potato-russet-canela-current-yield) and (potato-russet-canela-current-yield < 1 * potato-purple-org-mean-yield)
        [set this-year-mediocre-production-year 1]

    ; bad production year
    if potato-russet-canela-current-yield < .7 * potato-canela-mean-yield
        [set this-year-bad-production-year 1]
    if potato-russet-canela-org-current-yield < .7 * potato-canela-org-mean-yield
        [set this-year-bad-production-year 1]
    if potato-purple-current-yield < .7 * potato-purple-mean-yield
        [set this-year-bad-production-year 1]
    if potato-purple-org-current-yield < .7 * potato-purple-org-mean-yield
        [set this-year-bad-production-year 1]
    ]
  ask n-of 1 potato_farmers [
;    print year print data-year
  ]
  ask potato_farmers [
;    print bad-production-year
  ]
end
;************************************
;  SET POTATO FARM CROP ALLOCATION   ; this can become dynamic
;************************************
to set-potato-farm-crop-allocation

  ask potato_farmers
  [
    set russet-canela-allocation 0.8
    set purple-allocation 0.2
  ]

end


;**********************************
;  TO SET POTATO BARLEY ROTATION
;********************************
to set-potato-barley-rotation

  if rotation-year = 3; all producers on same schedule but don't need to be- just doesn't seem to be important to model different schedules
  [
    ask potato_farmers with [patches-in-rotation > 0]; those with patches that rotate, otherwise just grow within 1 or 2 patches
        [
          ask patches with [rotation = "barley"] with [farmer = [farm-id] of myself]
          [set rotation "transition"]
          ask n-of (patches-in-rotation) patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
          [set rotation "barley"]
          ask patches with [rotation = "transition"] with [farmer = [farm-id] of myself]
          [set rotation "potato"]
         ]
    set rotation-year 0
  ]

    set rotation-year rotation-year + 1

end


;**********************************
;  CALCULATE ANNUAL PRODUCTION
;********************************
to calculate-annual-production

  ask potato_farmers
   [
      set russet-canela-current-production (2.20462 *(((sum [potato-russet-canela-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
        with [certified-organic = 0] with [remainder-patch = 0] * 100 * russet-canela-allocation)) + (sum [potato-russet-canela-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
         with [certified-organic = 0] with [remainder-patch = 1] * russet-canela-allocation * (hectares-farmed-potatoes - (100 * (patches-in-potatoes - 1))))))

      set purple-current-production (2.20462 * (((sum [potato-purple-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
        with [certified-organic = 0] with [remainder-patch = 0] * 100 * purple-allocation)) + (sum [potato-purple-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
         with [certified-organic = 0] with [remainder-patch = 1] * purple-allocation * (hectares-farmed-potatoes - (100 * (patches-in-potatoes - 1))))))

      set russet-canela-org-current-production (2.20462 * (((sum [potato-russet-canela-org-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
        with [certified-organic = 1] with [remainder-patch = 0] * 100 * russet-canela-allocation)) + (sum [potato-russet-canela-org-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
         with [certified-organic = 1] with [remainder-patch = 1] * russet-canela-allocation * (hectares-farmed-potatoes - (100 * (patches-in-potatoes - 1))))))

      set purple-org-current-production (2.20462 * (((sum [potato-purple-org-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
        with [certified-organic = 1] with [remainder-patch = 0] * 100 * purple-allocation)) + (sum [potato-purple-org-current-yield] of patches with [farmer = [farm-id] of myself] with [rotation = "potato"]
         with [certified-organic = 1] with [remainder-patch = 1] * purple-allocation * (hectares-farmed-potatoes - (100 * (patches-in-potatoes - 1))))))
;  ]
;      **************************************************
;      NOTE FROM 10/5: double-check variable renaming in randy's code --> the output numbers don't match kevin's output, so something is mismatched
;      **************************************************
;      print "kevin's actual yield"
;      ask potato_farmer 2 [ print russet-canela-current-production print purple-current-production print russet-canela-org-current-production print purple-org-current-production ]
;      ask potato_farmer 25 [ print russet-canela-current-production print purple-current-production print russet-canela-org-current-production print purple-org-current-production ]
;      ask potato_farmer 50 [ print russet-canela-current-production print purple-current-production print russet-canela-org-current-production print purple-org-current-production ]
;      ask potato_farmer 66 [ print russet-canela-current-production print purple-current-production print russet-canela-org-current-production print purple-org-current-production ]
;
;  ask potato_farmers [
;
;    let f-id  farm-id
;
;    ; All conventional potatoes, creating p-set0 and p-set1 based on, ultimately, remainder-patch (i.e., 0 or 1)
;    let p-set patches with [ farmer = f-id ]
;    set p-set p-set with [ rotation = "potato" and certified-organic = 0 ]
;    let p-set0 p-set with [ remainder-patch = 0 ]
;    let p-set1 p-set with [ remainder-patch = 1 ]
;
;    ; Russet conventional
;    set russet-canela-current-production  sum [ potato-russet-canela-current-yield ] of p-set0 * 100 * russet-canela-allocation
;    set russet-canela-current-production  potato-farmers_yield-estimated_russet-conventional + ( sum [ potato-russet-canela-current-yield ] of p-set1 * russet-canela-allocation * ( hectares-farmed-potatoes - ( 100 * ( patches-in-potatoes - 1 ) ) ) )
;    set russet-canela-current-production  2.20462 * russet-canela-current-production
;
;    ; Purple conventional
;    set purple-current-production  sum [ potato-purple-current-yield ] of p-set0 * 100 * purple-allocation
;    set purple-current-production  potato-farmers_yield-estimated_purple-conventional + ( sum [ potato-purple-current-yield ] of p-set1 * purple-allocation * ( hectares-farmed-potatoes - ( 100 * ( patches-in-potatoes - 1 ) ) ) )
;    set purple-current-production  2.20462 * purple-current-production
;
;    ; All organic potatoes, creating p-set0 and p-set1 based on, ultimately, remainder-patch (i.e., 0 or 1)
;    set p-set patches with [ farmer = f-id ]
;    set p-set p-set with [ rotation = "potato" and certified-organic = 1 ]
;    set p-set0 p-set with [ remainder-patch = 0 ]
;    set p-set1 p-set with [ remainder-patch = 1 ]
;
;      ; Russet organic
;    set russet-canela-org-current-production  sum [ potato-russet-canela-org-current-yield ] of p-set0 * 100 * russet-canela-allocation
;    set russet-canela-org-current-production  potato-farmers_yield-estimated_russet-organic + ( sum [ potato-russet-canela-org-current-yield ] of p-set1 * russet-canela-allocation * ( hectares-farmed-potatoes - ( 100 * ( patches-in-potatoes - 1 ) ) ) )
;    set russet-canela-org-current-production  2.20462 * russet-canela-org-current-production
;
;    ; Purple organic
;    set purple-org-current-production  sum [ potato-purple-org-current-yield ] of p-set0 * 100 * purple-allocation
;    set purple-org-current-production  potato-farmers_yield-estimated_purple-organic + ( sum [ potato-purple-org-current-yield ] of p-set1 * purple-allocation * ( hectares-farmed-potatoes - ( 100 * ( patches-in-potatoes - 1 ) ) ) )
;    set purple-org-current-production  2.20462 * purple-org-current-production
;  ]
;
;    print "randy's actual yield"
;    ask potato_farmer 2 [ print russet-canela-current-production print purple-current-production print russet-canela-org-current-production print purple-org-current-production ]
;    ask potato_farmer 25 [ print russet-canela-current-production print purple-current-production print russet-canela-org-current-production print purple-org-current-production ]
;    ask potato_farmer 50 [ print russet-canela-current-production print purple-current-production print russet-canela-org-current-production print purple-org-current-production ]
;    ask potato_farmer 66 [ print russet-canela-current-production print purple-current-production print russet-canela-org-current-production print purple-org-current-production ]
;
;;     ------------------------------
;;     stef note (8/30/20):
;;     farmer input costs: farmers need to be paying organic input costs on both organic and in-transition patches, conventional input costs for everything else
;;     this means input costs are calculated on what is planted, not what is harvested, which seems more realistic
;;     NEED TO ADJUST UNITS HERE: LAND CALCULATION IS PER PATCH, COSTS ARE PER ACRE
;;     ------------------------------
;
;  ask potato_farmers [

      let my-potato-patches patches with [ farmer = [ id ] of myself and rotation = "potato"]
      let my-organic-patches count my-potato-patches with [ certified-organic = 1 or in-organic-transition = 1 ]
      let my-conventional-patches ( ( count my-potato-patches ) - my-organic-patches )

      ;REDO INPUT PRICES (WHERE IN THE CODE/WHEN WE SHOULD HAVE FARMERS PAY FOR INPUTS)
;      set assets ( assets - ( my-conventional-patches * (random-normal conv-input-price-per-lb conv-input-price-stdev) ) )
;      set assets ( assets - ( my-organic-patches * (random-normal org-input-price org-input-price-stdev) ) )

;      set assets ( assets - ( russet-canela-current-production * (random-normal conv-input-price-per-lb conv-input-price-stdev) )) ; Add input prices for all potato product types: CHECK UNITS: input prices are per acre
      ;-----------------------------------------------------
;     ;11/11 new input costs on a per acre basis
;
;      let potato-conventional-russet_acres-farmed ;CALCULATE THIS!
;      set assets (assets - (potato-conventional-russet_acres-farmed * potato-conventional-russet_cost-input-per-acre))
;
;      let potato-organic-russet_acres-farmed ;CALCULATE THIS!
;      set assets (assets - (potato-organic-russet_acres-farmed * potato-organic-russet_cost-input-per-acre))
;
;      let potato-conventional-purple_acres-farmed ;CALCULATE THIS!
;      set assets (assets - (potato-conventional-purple_acres-farmed * potato-conventional-purple_cost-input-per-acre))
;
;      let potato-organic-purple_acres-farmed ;CALCULATE THIS!
;      set assets (assets - (potato-organic-purple_acres-farmed * potato-organic-purple_cost-input-per-acre))

      ;-----------------------------------------------------
      ; 1 kg = 2.20462 lbs.
      ; convert when update farmer inventory

      ; UPDATE FARMER INVENTORY HERE
      set potatoes-russet-conventional-fresh_inventory-current (potatoes-russet-conventional-fresh_inventory-current + (.67 * russet-canela-current-production))
      set potatoes-russet-conventional-fresh-small_inventory-current (potatoes-russet-conventional-fresh-small_inventory-current + (.33 * russet-canela-current-production))
      set potatoes-russet-organic-fresh_inventory-current ( potatoes-russet-organic-fresh_inventory-current + russet-canela-org-current-production)
      set potatoes-purple-conventional-fresh_inventory-current (potatoes-purple-conventional-fresh_inventory-current + purple-current-production)
      set potatoes-purple-organic-fresh_inventory-current (potatoes-purple-organic-fresh_inventory-current + purple-org-current-production)

   ]

end


;**********************************
;  OUTPUT PRODUCTION AND SALES TO EXCEL
;********************************
to output-data

    if year >= (years-in-model-run - years-of-data-collection)  ; only gathers output data in the last 2 years of the model (lets patterns emerge before gathering data).
                 ; takes mean and sum of cash and inventory by agent type.
                 ; processed potatoes not included atm
  [
    set mean-potato-producer-inventory mean [ potatoes-russet-conventional-fresh_inventory-current ] of potato_farmers
    set sum-potato-producer-inventory sum [ potatoes-russet-conventional-fresh_inventory-current ] of potato_farmers
    set mean-potato-producer-cash  mean [ assets ] of potato_farmers
    set sum-potato-producer-cash sum [ assets ] of potato_farmers

    set mean-potato-shipper-inventory mean [ potatoes-russet-conventional-fresh_inventory-current ] of potato_shippers
    set sum-potato-shipper-inventory sum [ potatoes-russet-conventional-fresh_inventory-current ] of potato_shippers
    set mean-potato-shipper-cash mean [ assets ] of potato_shippers
    set sum-potato-shipper-cash sum [ assets ] of potato_shippers

    set mean-potato-repacker-inventory mean [ potatoes-russet-conventional-fresh_inventory-current ] of potato_repackers
    set sum-potato-repacker-inventory sum [ potatoes-russet-conventional-fresh_inventory-current ] of potato_repackers
    set mean-potato-repacker-cash mean [ assets ] of potato_repackers
    set sum-potato-repacker-cash sum [ assets ] of potato_repackers

    set mean-potato-processor-inventory mean [ potatoes-russet-conventional-fresh_inventory-current ] of potato_processors
    set sum-potato-processor-inventory sum [ potatoes-russet-conventional-fresh_inventory-current ] of potato_processors
    set mean-potato-processor-cash mean [ assets ] of potato_processors
    set sum-potato-processor-cash sum [ assets ] of potato_processors

    set mean-distributor-inventory mean [ potatoes-russet-conventional-fresh_inventory-current ] of distributors
    set sum-distributor-inventory sum [ potatoes-russet-conventional-fresh_inventory-current ] of distributors
    set mean-distributor-cash mean [ assets ] of distributors
    set sum-distributor-cash sum [ assets ] of distributors

    set mean-school-inventory mean [ potatoes-russet-conventional-fresh_inventory-current ] of schools
    set sum-school-inventory sum [ potatoes-russet-conventional-fresh_inventory-current ] of schools
    set mean-school-cash mean [ assets ] of schools
    set sum-school-cash sum [ assets ] of schools

  ]

end


;;*************************************
;; PROCESS POTATOES
;;*************************************
to process-potatoes

  ask potato_processors [
    ; combine small and regular sized potatoes into one inventory variable
    set potatoes-russet-conventional-fresh_inventory-current (potatoes-russet-conventional-fresh_inventory-current + potatoes-russet-conventional-fresh-small_inventory-current)
    set potatoes-russet-conventional-fresh-small_inventory-current 0

    if potatoes-russet-conventional-fresh_inventory-current > 1 [
      let conversion ( potatoes-russet-conventional-fresh_inventory-current ) ; * .8 ) ;; assumes 20% waste during fresh-to-processed conversion (stef's random value - needs to be made realistic)
      let processed-space-available ( potatoes-russet-conventional-processed_inventory-maximum - potatoes-russet-conventional-processed_inventory-current )
      ifelse processed-space-available >= conversion
      [ set potatoes-russet-conventional-processed_inventory-current ( potatoes-russet-conventional-processed_inventory-current + conversion )
        set potatoes-russet-conventional-fresh_inventory-current 0 ]
      [ set potatoes-russet-conventional-processed_inventory-current ( potatoes-russet-conventional-processed_inventory-current + processed-space-available )
        set potatoes-russet-conventional-fresh_inventory-current ( potatoes-russet-conventional-fresh_inventory-current - processed-space-available ) ] ;* 1.25 ) ]
    ]
  ]

end


;converts uncooked potatoes into individual serving sizes --> NOTE: MAKE SURE TO CHECK UNITS BETWEEN INVENTORY AND SERVINGS CONVERSION
to scuola-cucina-cibo

  ask schools
    [
    set potato-russet-conventional-processed_servings ( potato-russet-conventional-processed_servings + ( potatoes-russet-conventional-processed_inventory-current * 14 ) ) ;; 14 servings per unit of processed potatoes
    set potatoes-russet-conventional-processed_inventory-current 0
    set potato-russet-conventional-fresh_servings ( potato-russet-conventional-fresh_servings + (potatoes-russet-conventional-fresh_inventory-current * 8.9 ) ) ;; 8.9 servings per unit of fresh potatoes
    set potatoes-russet-conventional-fresh_inventory-current 0
    set potato-russet-organic-fresh_servings ( potato-russet-organic-fresh_servings + ( potatoes-russet-organic-fresh_inventory-current * 8.9 ) ) ;; 8.9 servings per unit of fresh potatoes
    set potatoes-russet-organic-fresh_inventory-current 0
    ]

end


to eat-breakfast

  if ( ( week >= 2 ) and ( week <= 12 ) ) or ( ( week >= 14 ) and ( week >= 21 ) ) or ( ( week >= 34 ) and ( week >= 46 ) ) or ( ( week >= 48 ) and ( week >= 52 ) ) ; these are the weeks that school is in session
  [
    ask households [
    let school-p-meals ( [ potato-russet-conventional-processed_servings ] of one-of schools with [ id = [ school-id ] of myself ] )           ;; check how many processed servings of potatoes my school has
    let school-c-meals ( [ potato-russet-conventional-fresh_servings ] of one-of schools with [ id = [ school-id ] of myself ] )               ;; check how many fresh conventional servings of potatoes my school has
    let school-o-meals ( [ potato-russet-organic-fresh_servings ] of one-of schools with [ id = [ school-id ] of myself ] )                    ;; check how many fresh organic servings of potatoes my school has
    ifelse school-p-meals >= breakfast_total-needed                                                                         ;; if my school has enough processed potatoes to feed my household, eat those potatoes, update household hei based on processed potato hei score, and adjust school porcessed potato inventory
    [
     set hei-updated ( hei-updated + ( breakfast_total-needed * potato-conventional-processed_hei ) )
     ask schools with [ id = [ school-id ] of myself ]
       [ set potato-russet-conventional-processed_servings ( potato-russet-conventional-processed_servings - [ breakfast_total-needed ] of myself )
         set assets ( assets + ( [ breakfast_total-needed ] of myself * 1.54 ) ) ]
    ]
    [ ifelse ( school-c-meals >= breakfast_total-needed )                                                                        ;; if my school doesn't have enough processed potatoes, students will try to eat fresh conventional potatoes (then adjusting hei and inventory), and finally to eat fresh organic potatoes (then adjusting hei and inventory)
      [
        set hei-updated ( hei-updated + ( breakfast_total-needed * potato-fresh_hei ) )
        ask schools with [id = [ school-id ] of myself ]
          [ set potato-russet-conventional-fresh_servings ( potato-russet-conventional-fresh_servings - [ breakfast_total-needed ] of myself )
            set assets ( assets + ( [ breakfast_total-needed ] of myself * 1.54 ) )]
      ]
      [ ifelse ( school-o-meals >= breakfast_total-needed )                                                                        ;; if my school doesn't have enough processed potatoes, students will try to eat fresh conventional potatoes (then adjusting hei and inventory), and finally to eat fresh organic potatoes (then adjusting hei and inventory)
        [
        set hei-updated ( hei-updated + ( breakfast_total-needed * potato-fresh_hei ) )
        ask schools with [id = [school-id] of myself]
          [ set potato-russet-organic-fresh_servings ( potato-russet-organic-fresh_servings - [ breakfast_total-needed ] of myself )
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
    let school-p-meals ( [ potato-russet-conventional-processed_servings ] of one-of schools with [ id = [ school-id ] of myself ] )             ;; check how many processed servings of potatoes my school has
    let school-c-meals ( [ potato-russet-conventional-fresh_servings ] of one-of schools with [ id = [ school-id ] of myself ] )               ;; check how many fresh conventional servings of potatoes my school has
    let school-o-meals ( [ potato-russet-organic-fresh_servings ] of one-of schools with [ id = [ school-id ] of myself ] )                    ;; check how many fresh organic servings of potatoes my school has
    ifelse school-p-meals > lunch_total-needed                                                                         ;; if my school has enough processed potatoes to feed my household, eat those potatoes, update household hei based on processed potato hei score, and adjust school porcessed potato inventory
    [
     set hei-updated ( hei-updated + ( lunch_total-needed * potato-conventional-processed_hei ) )
     ask schools with [ id = [ school-id ] of myself ]
       [ set potato-russet-conventional-processed_servings ( potato-russet-conventional-processed_servings - [ lunch_total-needed ] of myself )
         set assets ( assets + ( [ lunch_total-needed ] of myself * 3.01 ) ) ]
    ]
    [ ifelse ( school-c-meals > lunch_total-needed )                                                                        ;; if my school doesn't have enough processed potatoes, students will try to eat fresh conventional potatoes (then adjusting hei and inventory), and finally to eat fresh organic potatoes (then adjusting hei and inventory)
      [
        set hei-updated ( hei-updated + ( lunch_total-needed * potato-fresh_hei ) )
        ask schools with [ id = [ school-id ] of myself ]
          [ set potato-russet-conventional-fresh_servings ( potato-russet-conventional-fresh_servings - [ lunch_total-needed ] of myself )
            set assets ( assets + ( [ lunch_total-needed ] of myself * 3.01 ) ) ]
      ]
      [ ifelse ( school-o-meals > lunch_total-needed )                                                                        ;; if my school doesn't have enough processed potatoes, students will try to eat fresh conventional potatoes (then adjusting hei and inventory), and finally to eat fresh organic potatoes (then adjusting hei and inventory)
        [
        set hei-updated ( hei-updated + ( lunch_total-needed * potato-fresh_hei ) )
        ask schools with [ id = [ school-id ] of myself ]
          [ set potato-russet-organic-fresh_servings ( potato-russet-organic-fresh_servings - [ lunch_total-needed ] of myself )
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

  reset-storage_potatoes potato_farmers
  reset-storage_potatoes potato_repackers
  reset-storage_potatoes potato_shippers
  reset-storage_potatoes potato_processors
  reset-storage_potatoes distributors
  reset-storage_potatoes schools


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

MONITOR
12
100
62
145
NIL
year
17
1
11

PLOT
1873
87
2221
237
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
"default" 1.0 0 -16777216 true "" "plot mean [assets] of potato_farmers"
"pen-1" 1.0 0 -7500403 true "" "plot 0"

PLOT
1520
705
1866
855
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

MONITOR
65
100
115
145
NIL
week
17
1
11

PLOT
1168
700
1516
850
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
"conv-p" 1.0 0 -1069655 true "" "ask distributors with [ agent-name = \"distributor 106\" ]\n[ plot potatoes-russet-conventional-processed_inventory-current ]"
"conv-f" 1.0 0 -723837 true "" "ask distributors with [ agent-name = \"distributor 107\" ]\n[ plot potatoes-russet-conventional-processed_inventory-current ]"
"pen-2" 1.0 0 -5509967 true "" "ask distributors with [ agent-name = \"distributor 108\" ]\n[ plot potatoes-russet-conventional-processed_inventory-current ]"
"pen-3" 1.0 0 -8275240 true "" "ask distributors with [ agent-name = \"distributor 109\" ]\n[ plot potatoes-russet-conventional-processed_inventory-current ]"
"pen-4" 1.0 0 -5298144 true "" "ask distributors with [ agent-name = \"distributor 106\" ]\n[ plot potatoes-russet-conventional-fresh_inventory-current ]"
"pen-5" 1.0 0 -4079321 true "" "ask distributors with [ agent-name = \"distributor 107\" ]\n[ plot potatoes-russet-conventional-fresh_inventory-current ]"
"pen-6" 1.0 0 -14439633 true "" "ask distributors with [ agent-name = \"distributor 108\" ]\n[ plot potatoes-russet-conventional-fresh_inventory-current ]"
"pen-7" 1.0 0 -14070903 true "" "ask distributors with [ agent-name = \"distributor 109\" ]\n[ plot potatoes-russet-conventional-fresh_inventory-current ]"
"pen-8" 1.0 0 -7500403 true "" "plot 0"

PLOT
1165
18
1865
235
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
"r. conv-fresh" 1.0 0 -14439633 true "" "plot sum [potatoes-russet-conventional-fresh_inventory-current] of potato_farmers"
"r. org-fresh" 1.0 0 -5509967 true "" "plot sum [potatoes-russet-organic-fresh_inventory-current] of potato_farmers"
"p. conv-fresh" 1.0 0 -11783835 true "" "plot sum [potatoes-purple-conventional-fresh_inventory-current] of potato_farmers"
"p. org-fresh" 1.0 0 -6917194 true "" "plot sum [potatoes-purple-organic-fresh_inventory-current] of potato_farmers"
"r. conv-small" 1.0 0 -6759204 true "" "plot sum [potatoes-russet-conventional-fresh-small_inventory-current] of potato_farmers"

PLOT
1168
240
1514
390
shippers conventional inventory
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
"shipper 104" 1.0 0 -5298144 true "" "ask potato_shippers with [ agent-name = \"shipper 100\" ]\n[ plot potatoes-russet-conventional-fresh_inventory-current ]"
"shipper 105" 1.0 0 -4079321 true "" "ask potato_shippers with [ agent-name = \"shipper 101\" ]\n[ plot potatoes-russet-conventional-fresh_inventory-current ]"
"shipper 106" 1.0 0 -14439633 true "" "ask potato_shippers with [ agent-name = \"shipper 102\" ]\n[ plot potatoes-russet-conventional-fresh_inventory-current ]"
"shipper 107" 1.0 0 -14070903 true "" "ask potato_shippers with [ agent-name = \"shipper 103\" ]\n[ plot potatoes-russet-conventional-fresh_inventory-current ]"

PLOT
1520
240
1868
390
shipper assets
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
"pen-1" 1.0 0 -5298144 true "" "ask potato_shippers with [ agent-name = \"shipper 100\" ]\n[ plot assets ]"
"pen-2" 1.0 0 -4079321 true "" "ask potato_shippers with [ agent-name = \"shipper 101\" ]\n[ plot assets ]"
"pen-3" 1.0 0 -14439633 true "" "ask potato_shippers with [ agent-name = \"shipper 102\" ]\n[ plot assets ]"
"pen-4" 1.0 0 -14070903 true "" "ask potato_shippers with [ agent-name = \"shipper 103\" ]\n[ plot assets ]"
"pen-5" 1.0 0 -7500403 true "" "plot 0"

PLOT
1168
394
1514
544
repackers conventional inventory
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
"repacker 100" 1.0 0 -5298144 true "" "ask potato_repackers with [ agent-name = \"repacker 96\" ]\n[ plot potatoes-russet-conventional-fresh_inventory-current ]"
"repacker 101" 1.0 0 -4079321 true "" "ask potato_repackers with [ agent-name = \"repacker 97\" ]\n[ plot potatoes-russet-conventional-fresh_inventory-current ]"
"repacker 102" 1.0 0 -14439633 true "" "ask potato_repackers with [ agent-name = \"repacker 98\" ]\n[ plot potatoes-russet-conventional-fresh_inventory-current ]"
"repacker 103" 1.0 0 -14070903 true "" "ask potato_repackers with [ agent-name = \"repacker 99\" ]\n[ plot potatoes-russet-conventional-fresh_inventory-current ]"

PLOT
1520
394
1868
544
repacker assets
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
"pen-1" 1.0 0 -5298144 true "" "ask potato_repackers with [ agent-name = \"repacker 96\" ]\n[ plot assets ]"
"pen-2" 1.0 0 -4079321 true "" "ask potato_repackers with [ agent-name = \"repacker 97\" ]\n[ plot assets ]"
"pen-3" 1.0 0 -14439633 true "" "ask potato_repackers with [ agent-name = \"repacker 98\" ]\n[ plot assets ]"
"pen-4" 1.0 0 -14070903 true "" "ask potato_repackers with [ agent-name = \"repacker 99\" ]\n[ plot assets ]"
"pen-5" 1.0 0 -16777216 true "" "plot 0"

PLOT
1168
547
1516
697
processors conventional inventory
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
"processor 108" 1.0 0 -1069655 true "" "ask potato_processors with [ agent-name = \"processor 104\" ]\n[ plot potatoes-russet-conventional-processed_inventory-current ]"
"processor 109" 1.0 0 -8275240 true "" "ask potato_processors with [ agent-name = \"processor 105\" ]\n[ plot potatoes-russet-conventional-processed_inventory-current ]"
"pen-2" 1.0 0 -5298144 true "" "ask potato_processors with [ agent-name = \"processor 106\" ]\n[ plot potatoes-russet-conventional-fresh_inventory-current ]"
"pen-3" 1.0 0 -14070903 true "" "ask potato_processors with [ agent-name = \"processor 107\" ]\n[ plot potatoes-russet-conventional-fresh_inventory-current ]"

PLOT
1520
549
1868
699
processor assets
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
"pen-1" 1.0 0 -5298144 true "" "ask potato_processors with [ agent-name = \"processor 104\" ]\n[ plot assets ]"
"pen-2" 1.0 0 -14070903 true "" "ask potato_processors with [ agent-name = \"processor 105\" ]\n[ plot assets ]"
"pen-3" 1.0 0 -7500403 true "" "plot 0"

SLIDER
12
337
257
370
market-knowledge
market-knowledge
.25
1
0.5
.25
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
percent-shippers-to-distributors
0.5
1
0
Number

INPUTBOX
2453
669
2602
729
percent-shippers-to-processors
0.5
1
0
Number

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
118
100
178
145
data-year
data-year
17
1
11

MONITOR
13
377
262
422
NIL
potatoes-outside
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
473
262
626
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
630
262
783
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
425
262
470
total conventional patches
count patches with [ certified-organic = 0 ]
17
1
11

CHOOSER
12
147
259
192
display-style
display-style
"farm ownership" "potato vs barley rotation" "organic vs conventional" "bad vs good year" "transition likelihood score" "farm size/ideology"
4

MONITOR
2614
295
2771
340
total processed servings
sum [potato-russet-conventional-processed_servings] of schools
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
1168
855
1516
1005
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
"conv-p" 1.0 0 -2674135 true "" "plot sum [potato-russet-conventional-processed_servings] of schools"
"conv-f" 1.0 0 -10899396 true "" "plot sum [potato-russet-conventional-fresh_servings] of schools"

PLOT
1520
857
1868
1007
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
12
195
257
228
hide-turtles?
hide-turtles?
0
1
-1000

PLOT
1873
240
2225
390
shipper price to buy
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
"default" 1.0 0 -5298144 true "" "ask potato_shippers with [ agent-name = \"shipper 100\" ]\n[ plot potatoes-russet-conventional-fresh_price-to-buy ]"
"pen-1" 1.0 0 -4079321 true "" "ask potato_shippers with [ agent-name = \"shipper 101\" ]\n[ plot potatoes-russet-conventional-fresh_price-to-buy ]"
"pen-2" 1.0 0 -14439633 true "" "ask potato_shippers with [ agent-name = \"shipper 102\" ]\n[ plot potatoes-russet-conventional-fresh_price-to-buy ]"
"pen-3" 1.0 0 -14070903 true "" "ask potato_shippers with [ agent-name = \"shipper 103\" ]\n[ plot potatoes-russet-conventional-fresh_price-to-buy ]"

PLOT
1878
860
2232
1010
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
"default" 1.0 0 -14439633 true "" "plot mean [ potatoes-russet-conventional-fresh_price-to-buy ] of schools"
"pen-1" 1.0 0 -5298144 true "" "plot mean [ potatoes-russet-conventional-processed_price-to-buy ] of schools"

PLOT
1875
395
2228
545
repacker price to buy
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
"default" 1.0 0 -5298144 true "" "ask potato_repackers with [ agent-name = \"repacker 96\" ]\n[ plot potatoes-russet-conventional-fresh_price-to-buy ]"
"pen-1" 1.0 0 -4079321 true "" "ask potato_repackers with [ agent-name = \"repacker 97\" ]\n[ plot potatoes-russet-conventional-fresh_price-to-buy ]"
"pen-2" 1.0 0 -14439633 true "" "ask potato_repackers with [ agent-name = \"repacker 98\" ]\n[ plot potatoes-russet-conventional-fresh_price-to-buy ]"
"pen-3" 1.0 0 -14070903 true "" "ask potato_repackers with [ agent-name = \"repacker 99\" ]\n[ plot potatoes-russet-conventional-fresh_price-to-buy ]"

PLOT
1875
550
2229
700
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
1875
705
2230
855
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

SLIDER
12
266
259
299
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
12
301
259
334
years-of-data-collection
years-of-data-collection
0
years-in-model-run
3.0
1
1
years
HORIZONTAL

OUTPUT
13
786
263
1013
11

SLIDER
12
231
258
264
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
529
810
1156
1008
mean TLS by farm type
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"s-main" 1.0 0 -15040220 true "" "plot mean [ transition-likelihood-score ] of ( potato_farmers with [ farm-size  = \"small\" and alternative-farmer = 0 ] )"
"s-alt" 1.0 0 -8330359 true "" "plot mean [ transition-likelihood-score ] of ( potato_farmers with [ farm-size  = \"small\" and alternative-farmer = 1 ] )"
"m-main" 1.0 0 -14454117 true "" "plot mean [ transition-likelihood-score ] of ( potato_farmers with [ farm-size  = \"medium\" and alternative-farmer = 0 ] )"
"m-alt" 1.0 0 -8275240 true "" "plot mean [ transition-likelihood-score ] of ( potato_farmers with [ farm-size  = \"medium\" and alternative-farmer = 1 ] )"
"l-main" 1.0 0 -5298144 true "" "plot mean [ transition-likelihood-score ] of ( potato_farmers with [ farm-size  = \"large\" and alternative-farmer = 0 ] )"
"l-alt" 1.0 0 -1604481 true "" "plot mean [ transition-likelihood-score ] of ( potato_farmers with [ farm-size  = \"large\" and alternative-farmer = 1 ] )"
".5" 1.0 0 -16777216 true "" "plot .5"

PLOT
529
1014
1156
1206
proportion of organic transition by farm type
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"s-main" 1.0 2 -15040220 true "" "plot ( (count potato_farmers with [ farm-size  = \"small\" and alternative-farmer = 0 and farm-transitioning = 1 ] ) / (count potato_farmers with [ farm-size  = \"small\" and alternative-farmer = 0 ] ) )"
"s-alt" 1.0 0 -8330359 true "" "plot ( (count potato_farmers with [ farm-size  = \"small\" and alternative-farmer = 1 and farm-transitioning = 1 ] ) / (count potato_farmers with [ farm-size  = \"small\" and alternative-farmer = 1 ] ) )"
"m-main" 1.0 0 -14454117 true "" "plot ( (count potato_farmers with [ farm-size  = \"medium\" and alternative-farmer = 0 and farm-transitioning = 1 ] ) / (count potato_farmers with [ farm-size  = \"medium\" and alternative-farmer = 0 ] ) )"
"m-alt" 1.0 0 -8275240 true "" "plot ( (count potato_farmers with [ farm-size  = \"medium\" and alternative-farmer = 1 and farm-transitioning = 1 ] ) / (count potato_farmers with [ farm-size  = \"medium\" and alternative-farmer = 1 ] ) )"
"l-main" 1.0 0 -5298144 true "" "plot ( (count potato_farmers with [ farm-size  = \"large\" and alternative-farmer = 0 and farm-transitioning = 1 ] ) / (count potato_farmers with [ farm-size  = \"large\" and alternative-farmer = 0 ] ) )"
"l-alt" 1.0 0 -1604481 true "" "plot ( (count potato_farmers with [ farm-size  = \"large\" and alternative-farmer = 1 and farm-transitioning = 1 ] ) / (count potato_farmers with [ farm-size  = \"large\" and alternative-farmer = 1 ] ) )"

CHOOSER
12
51
171
96
potato-scenario
potato-scenario
"baseline" "fresh-CO" "gfpp" "small-potatoes" "specialty-product"
0

PLOT
1169
1018
1813
1214
school potato type served
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
"russet conventional" 1.0 0 -15040220 true "" "plot sum [potatoes-russet-conventional-fresh_inventory-current] of schools"
"small" 1.0 0 -8990512 true "" "plot sum [potatoes-russet-conventional-fresh-small_inventory-current] of schools"
"purple processed" 1.0 0 -8630108 true "" "plot sum [potatoes-purple-conventional-processed_inventory-current] of schools"
"russet processed" 1.0 0 -723837 true "" "plot sum [out-of-state-french-fry_inventory-current] of schools"

MONITOR
1042
85
1139
130
NIL
potatoes-dps
17
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

Set prices as outlined in code for each (copy here when finished). 

Scenario 1 (baseline): 
farmer -> shipper and repacker -> outside of system

distributor -> school for processed potatoes (all idaho potatoes)

Scenario 2 (fresh CO): 

Scenario 3 (gfpp): 

Scenario 4 (small potatoes):

Scenario 5 (specialty product): 


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
* going to update input costs to reflect wisconsin info because provides conventional and organic input prices in one place: https://www.cias.wisc.edu/organic-potatoes-they-can-be-grown-but-can-they-be-profitable/
(use norkotah for russet and norland for specialty/purple)
* potato repacker.distributor sales price: summary stats for 20-years of AMS potato data (Table 4 in Erin's thesis)
* potato distributor sales price for processed potato: $1.01 --> price DPS pays for processed curly fries
* input costs per acre ($2340/acre) from CSU Extension 2015 enterprise budget and 2015 Cost of Potato Production Study (Paul Patterson)

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

**scenario info**

;  baseline: scenario 1 french fry
;  farmgate price idaho $0.0905
;  price received by shipper/warehouse $0.358  (CO originated terminal mkt avg price russet conventional)
;  price received by processor $0.51 (ERS food dollar processor)
;  price received by distributor $1.01 (DPS data)
;
;  differentiated: scenario 2 fresh CO potato sold fresh to DPS through mainline distributor - *** NOTE: something funky going on with contracts during gfpp setup - like only doing one contract period ***
;  farmgate prices (AMS 1998-2019; CPAC report)
;  Russet conventional: $0.1291
;  Russet organic: $0.2546
;  Specialty conv.: $0.2350
;  Specialty organic: $0.46344
;  Repacker: $0.08105
;  Price received by shipper/warehouse
;  Russet conventional: $0.358
;  Russet organic: $0.705
;  Specialty conv.: $0.651
;  Specialty organic: $1.284
;  Repacker: $0.224
;  (177% premium over FG from Russet conv.)
;  Price received by distributor
;  $0.3605 (($0.35 DPS data + 3% change baseline to local through mainline dist.)
;
;  differentiated: scenario 3 fresh CO potato that is sold fresh to DPS directly from SLV shipper/short GFPP supply chain
;  price received by farmer
;  Russet conventional: $.222
;  Russet organic: $0.437
;  Specialty conv.: $0.404
;  Specialty organic: $0.796
;  Repacker: $0.139
;  (62% to farmer and 38% to shipper cost structure from AAEA pres.9)
;  price received by shipper/warehouse
;  Russet conventional: $0.358
;  Russet organic: $0.705
;  Specialty conv.: $0.651
;  Specialty organic: $1.284
;  Repacker: $0.224
;
;  differentiated: scenario 4 small potatoes
;  price received by farmer $0.0356
;  price received by shipper $0.0986
;
;  differentiated: scenario 5 specialty processed potato product
;  price received by farmer
;  Russet conventional: $.1291
;  Russet organic: $.2546
;  Specialty conventional: $.2350
;  Specialty organic: $.4634
;  price received by shipper
;  Russet conventional: $0.358
;  Russet organic: $0.705
;  Specialty conv.: $0.651
;  Specialty organic: $1.284
;  Repacker price: $0.224
;  price received by processor $0.51
;  price received by distributor $0.82 (Seasoned, diced potatoes DPS)
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
