*-------------------------------------------------------------*
*-------------------------------------------------------------*
*                     Trees on Farm:                          *
*    Prevalence, Economic Contribution, and                   *
*   Determinants of Trees on Farms across Sub-Saharan Africa  *
*                                                             *
*             https://treesonfarm.github.io                   *
*-------------------------------------------------------------*
*   Miller, D.; Muñoz-Mora, J.C. and Christiaense, L.         *
*                                                             *
*                     Nov 2016                                *
*                                                             *
*             World Bank and PROFOR                           *
*-------------------------------------------------------------*
*                   Replication Codes                         *
*-------------------------------------------------------------*
*-------------------------------------------------------------*


*----------------------------------------------------- *
* --- PLOT SIZE AND HH WITH PLOTS   ---- *
* ------------------------------------------------------------ *

  *----------------------------
  *  RAINY SEASON- VISIT I 
  *----------------------------

  *-- 1. Open and append the data

    *---- ROSTER PLOT MODULE - AG-MODULE C: PLOT ROSTER
    use "$path_data/MW/2010-11/Agriculture/AG_MOD_C.dta", clear


  *-- 2. Fix the Parcel Size
      drop if ag_c04b==0
    
    * Convert everything to accres 
      * Acres (ag_c04b=2) to HA
        replace ag_c04a=ag_c04a*0.404686 if ag_c04b==1
      * Square Meters (ag_c04b=3) to Ha
      replace ag_c04a=ag_c04a*0.0001 if ag_c04b==3

      * Parcel Size using the GPS information
    gen plot_size=ag_c04a
    replace plot_size=ag_c04c*0.404686 if plot_size==.

    rename ag_c00 plot_id

  *-- 3. Data about the main use

    *--- Rainy Season - Visit 1

      preserve
      use "$path_data/MW/2010-11/Agriculture/AG_MOD_D.dta", clear
      keep case_id ag_d00 ag_d14
      rename ag_d00 plot_id
      drop if plot_id==""
      rename ag_d14 plot_use_rainy
      *Some only case repeated
      duplicates drop  case_id plot_id, force
      save "$path_work/MW/0_PlotUse_Rainy.dta", replace
      restore 

  *-- 4. Clean and merge the data
    keep case_id plot_id plot_size 
     drop if plot_id==""
    merge 1:1  case_id plot_id using "$path_work/MW/0_PlotUse_Rainy.dta", nogenerate keep(matched)

  *-- 5. Save data

      gen season_rainy=1
      save "$path_work/MW/0_Plot_Rainy.dta", replace

  *----------------------------
  *  DRY SEASON- VISIT II
  *----------------------------

  *-- 1. Open and append the data
    *---- ROSTER PLOT MODULE - AG-MODULE C: PLOT ROSTER
    use "$path_data/MW/2010-11/Agriculture/AG_MOD_J.dta", clear

     rename ag_j00 plot_id
     drop if plot_id==""


  *-- 2. Fix the Parcel Size
    
    * Convert everything to accres 
      * Hectares (ag_c04b=2) to Acres
        replace ag_j05a=ag_j05a*0.404686 if ag_j05b==1
      * Square Meters (ag_c04b=3) to Acres
      replace ag_j05a=ag_j05a*0.0001 if ag_j05b==3

      * Parcel Size using the GPS information
    gen plot_size=ag_j05a
    replace plot_size=ag_j05c*0.404686 if plot_size==.

  *-- 3. Data about the main use

    *--- DRY Season - Visit 2

      preserve
      use "$path_data/MW/2010-11/Agriculture/AG_MOD_K.dta", clear
      keep case_id ag_k0a ag_k15
      rename ag_k0a plot_id
      drop if plot_id==""
      rename ag_k15 plot_use_dry
      *Some only case repeated
      duplicates drop  case_id plot_id, force
      save "$path_work/MW/0_PlotUse_Dry.dta", replace
      restore 

  *-- 4. Clean and merge the data
    keep case_id plot_id plot_size 
     drop if plot_id==""
    merge 1:1  case_id plot_id using "$path_work/MW/0_PlotUse_Dry.dta", nogenerate 

    rename plot_size plot_size_dry

  *-- 5. Save data

    gen season_dry=2
    save "$path_work/MW/0_Plot_Dry.dta", replace

  *----------------------------
  *  MERGING DATA FROM THE TWO VISITS
  *----------------------------

  use "$path_work/MW/0_Plot_Rainy.dta", clear
  merge 1:1 case_id plot_id using "$path_work/MW/0_Plot_Dry.dta"

    rename plot_use_rainy plot_use
    * Organize the data f
    replace plot_size=plot_size_dry if _merge==2
    replace plot_use=plot_use_dry if _merge==2

    drop plot_size_dry  plot_use_dry _merge

    drop season_rainy season_dry

    gen x_dry=0
    gen x_rainy=1

    reshape long x_, i(case_id plot_id) j(season "rainy" "dry")
    drop x_

    rename season season1
    gen  season=1 if season1=="rainy"
    replace season=2 if season1=="dry"
    drop season1

    * D - Only appears in the Dry Season
    drop if (plot_id=="D1"|plot_id=="D2"|plot_id=="D3") & season==1

    save "$path_work/MW/1_Plot-Crop_Information.dta", replace

  *----------------------------
  *  MERGE INFORMATION WITH CROPS
  *----------------------------
    merge 1:1 case_id plot_id season using "$path_work/MW/0_CropsClassification.dta"

    drop if plot_id=="10"

  * To clean the data we will delete those plots without information

  drop if (plot_id=="D1"|plot_id=="D2"|plot_id=="R1"|plot_id=="R2"|plot_id=="R3"|plot_id=="R4"|plot_id=="R5"|plot_id=="R6"|plot_id=="R7") & _merge==2

  drop _merge

  save "$path_work/MW/1_Plot-Crop_Information.dta", replace

  * Organizing the data


  foreach i in n_parcels_Tree_Fruit n_parcels_Tree_Agri n_parcels_NA n_parcels_Plant t_area_Tree_Agri t_area_Tree_Fruit t_area_NA t_area_Plant {
        replace `i'=(`i'>0 & `i'!=.)
      }

  *-- 5. Fixing information For Inter-cropping and 

      * Those non-cultivated plots with forest
      gen  n_parcels_Tree_wood=(plot_use==5) 

      foreach i in _Tree_Fruit _Tree_Agri  _NA _Plant {
        gen inter_n`i'=inter_crop*n_parcels`i'
      }

    gen t_area_pre_trees=plot_size if t_area_Tree_Fruit>0|t_area_Tree_Agri>0|n_parcels_Tree_wood>0
    replace t_area_pre_trees=0 if t_area_pre_trees==.

    foreach i in _Tree_Fruit _Tree_Agri  {
      gen t_area_pre`i'=plot_size if n_parcels`i'>0
      replace t_area_pre`i'=0 if t_area_pre`i'==.
    }

    gen t_area_pre_Tree_wood=plot_size if n_parcels_Tree_wood>0
    replace t_area_pre_Tree_wood=0 if t_area_pre_Tree_wood==.


  gen n_plots=1
                  preserve
                  collapse (sum) n_plots  n_parcels_* t_n_trees_* t_area_* farm_size=plot_size inter_n_* (max) inter_crop  , by(case_id plot_id)

                  save "$path_work/MW/1_Plot-Crop_Information_plot_level.dta", replace
                  restore

  collapse (sum) n_plots  n_parcels_* t_n_trees_* t_area_* farm_size=plot_size inter_n_* (max) inter_crop  , by(case_id season)

  *----------------------------
  *  MERGE DATA FROM HOUSEHOLD
  *----------------------------

  merge n:1 case_id using "$path_data/MW/2010-11/Household/HH_MOD_A_FILT.dta", keepusing(ea_id reside stratum hh_wgt hh_a01 hh_a02 hh_a02b) nogenerate


  save "$path_work/MW/1_Plot-Crop_Information.dta", replace

  drop if season==.
  drop if reside==1

  encode ea_id, gen(ea)
  * Replace 
  foreach i of varlist n_parcels_Tree_Fruit-  t_area_pre_Tree_wood {
    replace `i'=0 if `i'==.
    }

  * collapsing for the two season
  collapse (max) n_plots (sum) n_parcels_Tree_Fruit- t_area_pre_Tree_wood (max) inter_* farm_size ea hh_wgt hh_a01 , by(case_id)

    save "$path_work/MW/1_Plot-Crop_Information_HH_level.dta", replace




