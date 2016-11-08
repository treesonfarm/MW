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


cap gen tree_type=""

* Permanents Crops
replace tree_type="Fruit Tree" if crop_id==6 & d_crop==1
replace tree_type="Fruit Tree" if crop_id==5 & d_crop==1
replace tree_type="Fruit Tree" if crop_id==15 & d_crop==1
replace tree_type="Fruit Tree" if crop_id==4 & d_crop==1
replace tree_type="Fruit Tree" if crop_id==11 & d_crop==1
replace tree_type="Fruit Tree" if crop_id==9 & d_crop==1
replace tree_type="Fruit Tree" if crop_id==8 & d_crop==1
replace tree_type="Fruit Tree" if crop_id==13 & d_crop==1
replace tree_type="Fruit Tree" if crop_id==14 & d_crop==1
replace tree_type="Fruit Tree" if crop_id==12 & d_crop==1
replace tree_type="Fruit Tree" if crop_id==10 & d_crop==1
replace tree_type="NA" if crop_id==48 & d_crop==1
replace tree_type="NA" if crop_id==18 & d_crop==1
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==16 & d_crop==1
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==1 & d_crop==1
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==7 & d_crop==1
replace tree_type="Tree Cash Crops" if crop_id==2 & d_crop==1
replace tree_type="Tree Cash Crops" if crop_id==17 & d_crop==1
replace tree_type="Tree Cash Crops" if crop_id==3 & d_crop==1


*Transitory Permanents Crops

replace tree_type="Fruit Tree" if crop_id==14 & (d_crop==2|d_crop==3)
replace tree_type="NA" if crop_id==41 & (d_crop==2|d_crop==3)
replace tree_type="NA" if crop_id==42 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==43 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==46 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==27 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==47 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==30 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==44 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==5  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==6  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==7  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==8  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==9  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==10 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==28 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==38 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==39 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==35 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==32 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==17  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==18  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==19  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==20  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==21  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==22  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==23  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==24  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==25  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==26 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==36 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==45 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==33 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==1  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==2  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==3  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==4 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==29 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==11  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==12  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==13  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==14  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==15  & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==16 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==31 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==37 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==40 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==34 & (d_crop==2|d_crop==3)
replace tree_type="Plant/Herb/Grass/Roots" if crop_id==48 & (d_crop==2|d_crop==3)


