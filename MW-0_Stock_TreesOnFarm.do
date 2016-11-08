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
* ---  PART I : CROP AND TREE CLASSIFICATION   ---- *
* ------------------------------------------------------------ *
* Information collect in two visit(i.e. rainy and dry seasons)
* Information on permanent crops was collected during the second visit - dry visit

  *-- 0. Open  Data sets and appending data sets

    use "$path_data/MW/2010-11/Agriculture/AG_MOD_P.dta", clear

            rename ag_p0b plot_id 
            rename ag_p0d crop_id
            drop if crop_id==.
            rename ag_p03 t_n_trees
            rename ag_p02a t_area 
            * Convert areas in HA
            replace t_area=t_area*0.404686 if ag_p02b==1
            replace t_area=t_area*0.0001000000884 if ag_p02b==3


            keep case_id plot_id crop_id t_n_trees t_area  
            gen d_crop=1
           

      * Transitory Crops Rainy Season 
      append using "$path_data/MW/2010-11/Agriculture/AG_MOD_G.dta", keep(case_id ag_g0b ag_g0d)

      replace plot_id=ag_g0b if plot_id==""
      replace crop_id=ag_g0d if crop_id==.
      replace d_crop=2 if d_crop==.
        drop if crop_id==.

       keep case_id plot_id crop_id t_n_trees t_area  d_crop

      * Transitory Crops Rainy Season 
      append using "$path_data/MW/2010-11/Agriculture/AG_MOD_M.dta", keep(case_id ag_m0b ag_m0d)

      replace plot_id=ag_m0b if plot_id==""
      replace crop_id=ag_m0d if crop_id==.
      replace d_crop=3 if d_crop==.
      drop if crop_id==.

      keep case_id plot_id crop_id t_n_trees t_area  d_crop
        drop if crop_id==.

  *-- 1. Include our Classification         
        
        include "$path_work/do-files/MW-CropClassification.do"

      
  *--  2 - Collapse information
    gen x=1
    collapse (sum) n_parcels=x  t_n_trees t_area ,by( case_id plot_id d_crop tree_type)


 *---  5 - Information per season

      reshape long h, i(case_id plot_id d_crop tree_typ) j(season 1 2)
        drop h
        drop if d_crop==2 & season==2
        drop if d_crop==3 & season==1
        drop d_crop

      collapse (sum) n_parcels t_n_trees t_area, by(case_id plot_id season tree_type)

  *-- 6. We identify whether the Parcel has more than one crop (i.e. Inter-cropped)

            bys case_id plot_id season: gen n_crops_plot=_N
            gen inter_crop=(n_crops_plot>1 & n_crops_plot!=.)
            drop n_crops_plot

  *-- 7. Reshape the data for the new crops system
            drop if tree_type==""
            encode tree_type, gen(type_crop)
              *1 Fruit Tree
              *2 NA
              *3 Plant
            drop tree_type
            order case_id plot_id type_crop 
            reshape wide n_parcels t_n_trees t_area , i(case_id plot_id season) j(type_crop)

  *--- 8. rename Variables 
            global names "Tree_Fruit NA Plant Tree_Agri"
            local number "1 2 3 4"
            
            local i=1
            foreach y of global names {
                local name: word `i' of `number'
                foreach h in n_parcels t_n_trees t_area {
                rename `h'`name' `h'_`y'
                replace `h'_`y'=0 if `h'_`y'==.
                }
                local i=`i'+1
            }

  *--- 6. Save the data

          order case_id plot_id inter_crop 

          save "$path_work/MW/0_CropsClassification.dta", replace

          gen t_area=t_area_Tree_Fruit+t_area_NA+t_area_Plant+t_area_Tree_Agri

          collapse (sum) t_area_Tree_Fruit  t_area_Tree_Agri  t_area, by(case_id plot_id)

           save "$path_work/MW/0_CropsClassification_plot_level.dta", replace

