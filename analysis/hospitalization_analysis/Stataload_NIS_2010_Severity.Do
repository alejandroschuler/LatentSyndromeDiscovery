/*****************************************************************************
* Stataload_NIS_2010_Severity.Do
* This program will load the 2011 NIS ASCII Severity File into Stata.
* Because Stata loads the entire file into memory, it may not be possible
* to load every data element for large files.  If necessary, edit this
* program to change the memory size or to load only selected data elements.
*****************************************************************************/

*** Set available memory size ***
set mem 500m

*** Read data elements from the ASCII file ***
infix long   HOSPID                      1-  5   ///
      double KEY                         6- 20   ///
      int    APRDRG                     21- 24   ///
      byte   APRDRG_Risk_Mortality      25- 26   ///
      byte   APRDRG_Severity            27- 28   ///
      byte   CM_AIDS                    29- 30   ///
      byte   CM_ALCOHOL                 31- 32   ///
      byte   CM_ANEMDEF                 33- 34   ///
      byte   CM_ARTH                    35- 36   ///
      byte   CM_BLDLOSS                 37- 38   ///
      byte   CM_CHF                     39- 40   ///
      byte   CM_CHRNLUNG                41- 42   ///
      byte   CM_COAG                    43- 44   ///
      byte   CM_DEPRESS                 45- 46   ///
      byte   CM_DM                      47- 48   ///
      byte   CM_DMCX                    49- 50   ///
      byte   CM_DRUG                    51- 52   ///
      byte   CM_HTN_C                   53- 54   ///
      byte   CM_HYPOTHY                 55- 56   ///
      byte   CM_LIVER                   57- 58   ///
      byte   CM_LYMPH                   59- 60   ///
      byte   CM_LYTES                   61- 62   ///
      byte   CM_METS                    63- 64   ///
      byte   CM_NEURO                   65- 66   ///
      byte   CM_OBESE                   67- 68   ///
      byte   CM_PARA                    69- 70   ///
      byte   CM_PERIVASC                71- 72   ///
      byte   CM_PSYCH                   73- 74   ///
      byte   CM_PULMCIRC                75- 76   ///
      byte   CM_RENLFAIL                77- 78   ///
      byte   CM_TUMOR                   79- 80   ///
      byte   CM_ULCER                   81- 82   ///
      byte   CM_VALVE                   83- 84   ///
      byte   CM_WGHTLOSS                85- 86   ///
      using  "/volumes/projects-group$/LIU ADMINISTRATIVE/DATA Files/NIS_2010_Severity.ASC"

***  Assign labels to the data elements ***
label var HOSPID                   "HCUP hospital identification number"
label var KEY                      "HCUP record identifier"
label var APRDRG                   "All Patient Refined DRG"
label var APRDRG_Risk_Mortality    "All Patient Refined DRG: Risk of Mortality Subclass"
label var APRDRG_Severity          "All Patient Refined DRG: Severity of Illness Subclass"
label var CM_AIDS                  "AHRQ comorbidity measure: Acquired immune deficiency syndrome"
label var CM_ALCOHOL               "AHRQ comorbidity measure: Alcohol abuse"
label var CM_ANEMDEF               "AHRQ comorbidity measure: Deficiency anemias"
label var CM_ARTH                  "AHRQ comorbidity measure: Rheumatoid arthritis/collagen vascular diseases"
label var CM_BLDLOSS               "AHRQ comorbidity measure: Chronic blood loss anemia"
label var CM_CHF                   "AHRQ comorbidity measure: Congestive heart failure"
label var CM_CHRNLUNG              "AHRQ comorbidity measure: Chronic pulmonary disease"
label var CM_COAG                  "AHRQ comorbidity measure: Coagulopathy"
label var CM_DEPRESS               "AHRQ comorbidity measure: Depression"
label var CM_DM                    "AHRQ comorbidity measure: Diabetes, uncomplicated"
label var CM_DMCX                  "AHRQ comorbidity measure: Diabetes with chronic complications"
label var CM_DRUG                  "AHRQ comorbidity measure: Drug abuse"
label var CM_HTN_C                 "AHRQ comorbidity measure: Hypertension (combine uncomplicated and complicated)"
label var CM_HYPOTHY               "AHRQ comorbidity measure: Hypothyroidism"
label var CM_LIVER                 "AHRQ comorbidity measure: Liver disease"
label var CM_LYMPH                 "AHRQ comorbidity measure: Lymphoma"
label var CM_LYTES                 "AHRQ comorbidity measure: Fluid and electrolyte disorders"
label var CM_METS                  "AHRQ comorbidity measure: Metastatic cancer"
label var CM_NEURO                 "AHRQ comorbidity measure: Other neurological disorders"
label var CM_OBESE                 "AHRQ comorbidity measure: Obesity"
label var CM_PARA                  "AHRQ comorbidity measure: Paralysis"
label var CM_PERIVASC              "AHRQ comorbidity measure: Peripheral vascular disorders"
label var CM_PSYCH                 "AHRQ comorbidity measure: Psychoses"
label var CM_PULMCIRC              "AHRQ comorbidity measure: Pulmonary circulation disorders"
label var CM_RENLFAIL              "AHRQ comorbidity measure: Renal failure"
label var CM_TUMOR                 "AHRQ comorbidity measure: Solid tumor without metastasis"
label var CM_ULCER                 "AHRQ comorbidity measure: Peptic ulcer disease excluding bleeding"
label var CM_VALVE                 "AHRQ comorbidity measure: Valvular disease"
label var CM_WGHTLOSS              "AHRQ comorbidity measure: Weight loss"

*** Convert special values to missing values ***
recode APRDRG                    (-999 -888 -666=.)
recode APRDRG_Risk_Mortality     (-9 -8 -6 -5=.)
recode APRDRG_Severity           (-9 -8 -6 -5=.)
recode CM_AIDS                   (-9 -8 -6 -5=.)
recode CM_ALCOHOL                (-9 -8 -6 -5=.)
recode CM_ANEMDEF                (-9 -8 -6 -5=.)
recode CM_ARTH                   (-9 -8 -6 -5=.)
recode CM_BLDLOSS                (-9 -8 -6 -5=.)
recode CM_CHF                    (-9 -8 -6 -5=.)
recode CM_CHRNLUNG               (-9 -8 -6 -5=.)
recode CM_COAG                   (-9 -8 -6 -5=.)
recode CM_DEPRESS                (-9 -8 -6 -5=.)
recode CM_DM                     (-9 -8 -6 -5=.)
recode CM_DMCX                   (-9 -8 -6 -5=.)
recode CM_DRUG                   (-9 -8 -6 -5=.)
recode CM_HTN_C                  (-9 -8 -6 -5=.)
recode CM_HYPOTHY                (-9 -8 -6 -5=.)
recode CM_LIVER                  (-9 -8 -6 -5=.)
recode CM_LYMPH                  (-9 -8 -6 -5=.)
recode CM_LYTES                  (-9 -8 -6 -5=.)
recode CM_METS                   (-9 -8 -6 -5=.)
recode CM_NEURO                  (-9 -8 -6 -5=.)
recode CM_OBESE                  (-9 -8 -6 -5=.)
recode CM_PARA                   (-9 -8 -6 -5=.)
recode CM_PERIVASC               (-9 -8 -6 -5=.)
recode CM_PSYCH                  (-9 -8 -6 -5=.)
recode CM_PULMCIRC               (-9 -8 -6 -5=.)
recode CM_RENLFAIL               (-9 -8 -6 -5=.)
recode CM_TUMOR                  (-9 -8 -6 -5=.)
recode CM_ULCER                  (-9 -8 -6 -5=.)
recode CM_VALVE                  (-9 -8 -6 -5=.)
recode CM_WGHTLOSS               (-9 -8 -6 -5=.)

save "/volumes/projects-group$/LIU ADMINISTRATIVE/DATA Files/NIS_2010_Severity.dta", replace
