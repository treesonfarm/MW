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

* ------------------------------------------------------------ *
* --- DATA ON PRODUCTION - MODULE V - AGRICULTURAL MODULE  ---- *
* ------------------------------------------------------------ *
* Information collect in two visit(i.e. rainy and dry seasons)
* Information on permanent crops was collected during the second visit - dry visit


  *----------------------------
  *  RAINY SEASON- VISIT I - Transitory Crops (ONLY)
  *----------------------------
    
    *--- 1 - Open DataSet (Transitory Crops - Visit 1) 

      use "$path_data/MW/2010-11/Agriculture/AG_MOD_B.dta", clear
      
      gen season=1
      rename ag_b0c crop_id

      rename ag_b08 value_sold
      rename ag_b04a q_harvest
      rename ag_b07a q_sold

      replace ag_b12a=0 if ag_b12a==.
      replace ag_b13a=0 if ag_b13a==.
      gen q_gift=ag_b12a+ag_b13a
      rename ag_b13a q_animal
      rename ag_b16a q_lost
      gen q_selfcosumption=ag_b20a if ag_b22a==1
      gen q_stored=ag_b20a if ag_b22a!=1

      drop if crop_id==.

      gen d_crop=3

      keep case_id crop_id value_sold q_* season d_crop

    *--- 2 - Append the other data (Transitory Crops - Visit 2) 

      append using  "$path_data/MW/2010-11/Agriculture/AG_MOD_O.dta"

      replace season=2 if season==.

      replace crop_id=ag_o0b if season==2
      replace value_sold=ag_o03 if season==2
      replace q_harvest=ag_o02a if season==2
      replace ag_o12a=0 if ag_o12a==.
      replace ag_o21a=0 if ag_o21a==.
      replace q_sold=ag_o12a+ag_o21a if season==2
      replace q_gift=ag_o31a if season==2
      replace q_animal=ag_o33a if season==2
      replace q_lost=ag_o36a if season==2
      replace q_selfcosumption=ag_o40a if season==2 &  ag_o42a==1
      replace q_stored=ag_o40a if season==2 &  ag_o42a!=1
      

       keep case_id crop_id value_sold q_* season d_crop
       order case_id crop_id season value_sold q_*

       drop if crop_id==.
       
       replace d_crop=2 if  d_crop==.

    *--- 3 - Append the Data (Permanent Crops)
     append using  "$path_data/MW/2010-11/Agriculture/AG_MOD_Q.dta"
      replace season=0 if season==.
      replace value_sold=ag_q03 if season==0
      replace crop_id=ag_q0b if season==0
      replace q_harvest=ag_q02a if season==0
      replace ag_q12a=0 if ag_q12a==.
      replace ag_q21a=0 if ag_q21a==.
      replace q_sold=ag_q12a+ag_q21a if season==0
      replace q_gift=ag_q31a if season==0
      replace q_animal=ag_q33a if season==0
      replace q_lost=ag_q35a if season==0
      replace q_selfcosumption=ag_q39a if season==0 &  ag_q41a==1
      replace q_stored=ag_q39a if season==0 &  ag_q41a!=1

      keep case_id crop_id value_sold q_* season d_crop
       order case_id crop_id season value_sold q_*

        replace d_crop=1 if  d_crop==.


    *--- 4 - Fixing the data
      
       drop if crop_id==.

       foreach i in q_harvest q_sold value_sold q_animal q_lost q_gift q_selfcosumption q_stored {
        replace `i'=0 if `i'==.
       }

       gen total=q_sold+q_animal+q_lost+q_gift+q_selfcosumption+q_stored


        gen x=(total>q_harvest)
        drop if x==1
        gen q_other=q_harvest-total


    *--- 4. Collapsing information

       foreach i in _sold _selfcosumption _gift _lost _other {
            gen share_q`i'=q`i'/q_harvest
        }

    *--- 3. Include our Classification 
        include "$path_work/do-files/MW-CropClassification.do"


    *--- 4. Collapsing information 

      collapse (sum) value_sold (mean) share_q_* ,by(case_id tree_type)
      order case_id tree_type

      *** Total sells --> 
        preserve
        bys case_id: egen t_agri_value=sum(value_sold)
        gen sh_agr_inc=value_sold/t_agri_value
        keep case_id tree_type sh_agr_inc
        encode tree_type, gen(tree)
        drop tree_type
        reshape wide sh_agr_inc, i(case_id) j(tree)
        save "$path_work/MW/0_CropsSells_HHLevel.dta", replace
        restore



  *----------------------------
  *  MERGE DATA FROM HOUSEHOLD
  *----------------------------

  merge n:1 case_id using "$path_data/MW/2010-11/Household/HH_MOD_A_FILT.dta", keepusing(ea_id reside stratum hh_wgt hh_a01 hh_a02 hh_a02b) nogenerate


    *--- 5. Save Data

      save "$path_work/MW/0_CropsSells.dta", replace

