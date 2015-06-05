/*****************************************************************************
* Stataload_NIS_2010_DX_PR_GRPS.Do
* This program will load the 2010 NIS ASCII DX_PR_GRPS File into Stata.
* Because Stata loads the entire file into memory, it may not be possible
* to load every data element for large files.  If necessary, edit this
* program to change the memory size or to load only selected data elements.
*****************************************************************************/

*** Set available memory size ***
set mem 500m

*** Read data elements from the ASCII file ***
infix long   HOSP_NIS                    1-  5   ///
      double KEY_NIS                     6- 15   ///
      int    CHRON1                     16- 18   ///
      int    CHRON2                     19- 21   ///
      int    CHRON3                     22- 24   ///
      int    CHRON4                     25- 27   ///
      int    CHRON5                     28- 30   ///
      int    CHRON6                     31- 33   ///
      int    CHRON7                     34- 36   ///
      int    CHRON8                     37- 39   ///
      int    CHRON9                     40- 42   ///
      int    CHRON10                    43- 45   ///
      int    CHRON11                    46- 48   ///
      int    CHRON12                    49- 51   ///
      int    CHRON13                    52- 54   ///
      int    CHRON14                    55- 57   ///
      int    CHRON15                    58- 60   ///
      int    CHRON16                    61- 63   ///
      int    CHRON17                    64- 66   ///
      int    CHRON18                    67- 69   ///
      int    CHRON19                    70- 72   ///
      int    CHRON20                    73- 75   ///
      int    CHRON21                    76- 78   ///
      int    CHRON22                    79- 81   ///
      int    CHRON23                    82- 84   ///
      int    CHRON24                    85- 87   ///
      int    CHRON25                    88- 90   ///
      int    CHRONB1                    91- 93   ///
      int    CHRONB2                    94- 96   ///
      int    CHRONB3                    97- 99   ///
      int    CHRONB4                   100-102   ///
      int    CHRONB5                   103-105   ///
      int    CHRONB6                   106-108   ///
      int    CHRONB7                   109-111   ///
      int    CHRONB8                   112-114   ///
      int    CHRONB9                   115-117   ///
      int    CHRONB10                  118-120   ///
      int    CHRONB11                  121-123   ///
      int    CHRONB12                  124-126   ///
      int    CHRONB13                  127-129   ///
      int    CHRONB14                  130-132   ///
      int    CHRONB15                  133-135   ///
      int    CHRONB16                  136-138   ///
      int    CHRONB17                  139-141   ///
      int    CHRONB18                  142-144   ///
      int    CHRONB19                  145-147   ///
      int    CHRONB20                  148-150   ///
      int    CHRONB21                  151-153   ///
      int    CHRONB22                  154-156   ///
      int    CHRONB23                  157-159   ///
      int    CHRONB24                  160-162   ///
      int    CHRONB25                  163-165   ///
      str    DXMCCS1                   166-176   ///
      str    E_MCCS1                   177-187   ///
      int    PCLASS1                   188-190   ///
      int    PCLASS2                   191-193   ///
      int    PCLASS3                   194-196   ///
      int    PCLASS4                   197-199   ///
      int    PCLASS5                   200-202   ///
      int    PCLASS6                   203-205   ///
      int    PCLASS7                   206-208   ///
      int    PCLASS8                   209-211   ///
      int    PCLASS9                   212-214   ///
      int    PCLASS10                  215-217   ///
      int    PCLASS11                  218-220   ///
      int    PCLASS12                  221-223   ///
      int    PCLASS13                  224-226   ///
      int    PCLASS14                  227-229   ///
      int    PCLASS15                  230-232   ///
      str    PRMCCS1                   233-240   ///
      using  "/volumes/projects-group$/LIU ADMINISTRATIVE/DATA Files/NIS_2010_DX_PR_GRPS.ASC"

***  Assign labels to the data elements ***
label var HOSP_NIS                 "NIS hospital number"
label var KEY_NIS                  "NIS record number"
label var CHRON1                   "Chronic condition indicator 1"
label var CHRON2                   "Chronic condition indicator 2"
label var CHRON3                   "Chronic condition indicator 3"
label var CHRON4                   "Chronic condition indicator 4"
label var CHRON5                   "Chronic condition indicator 5"
label var CHRON6                   "Chronic condition indicator 6"
label var CHRON7                   "Chronic condition indicator 7"
label var CHRON8                   "Chronic condition indicator 8"
label var CHRON9                   "Chronic condition indicator 9"
label var CHRON10                  "Chronic condition indicator 10"
label var CHRON11                  "Chronic condition indicator 11"
label var CHRON12                  "Chronic condition indicator 12"
label var CHRON13                  "Chronic condition indicator 13"
label var CHRON14                  "Chronic condition indicator 14"
label var CHRON15                  "Chronic condition indicator 15"
label var CHRON16                  "Chronic condition indicator 16"
label var CHRON17                  "Chronic condition indicator 17"
label var CHRON18                  "Chronic condition indicator 18"
label var CHRON19                  "Chronic condition indicator 19"
label var CHRON20                  "Chronic condition indicator 20"
label var CHRON21                  "Chronic condition indicator 21"
label var CHRON22                  "Chronic condition indicator 22"
label var CHRON23                  "Chronic condition indicator 23"
label var CHRON24                  "Chronic condition indicator 24"
label var CHRON25                  "Chronic condition indicator 25"
label var CHRONB1                  "Chronic condition body system 1"
label var CHRONB2                  "Chronic condition body system 2"
label var CHRONB3                  "Chronic condition body system 3"
label var CHRONB4                  "Chronic condition body system 4"
label var CHRONB5                  "Chronic condition body system 5"
label var CHRONB6                  "Chronic condition body system 6"
label var CHRONB7                  "Chronic condition body system 7"
label var CHRONB8                  "Chronic condition body system 8"
label var CHRONB9                  "Chronic condition body system 9"
label var CHRONB10                 "Chronic condition body system 10"
label var CHRONB11                 "Chronic condition body system 11"
label var CHRONB12                 "Chronic condition body system 12"
label var CHRONB13                 "Chronic condition body system 13"
label var CHRONB14                 "Chronic condition body system 14"
label var CHRONB15                 "Chronic condition body system 15"
label var CHRONB16                 "Chronic condition body system 16"
label var CHRONB17                 "Chronic condition body system 17"
label var CHRONB18                 "Chronic condition body system 18"
label var CHRONB19                 "Chronic condition body system 19"
label var CHRONB20                 "Chronic condition body system 20"
label var CHRONB21                 "Chronic condition body system 21"
label var CHRONB22                 "Chronic condition body system 22"
label var CHRONB23                 "Chronic condition body system 23"
label var CHRONB24                 "Chronic condition body system 24"
label var CHRONB25                 "Chronic condition body system 25"
label var DXMCCS1                  "Multi-Level CCS:  Diagnosis 1"
label var E_MCCS1                  "Multi-Level CCS:  E Code 1"
label var PCLASS1                  "Procedure class 1"
label var PCLASS2                  "Procedure class 2"
label var PCLASS3                  "Procedure class 3"
label var PCLASS4                  "Procedure class 4"
label var PCLASS5                  "Procedure class 5"
label var PCLASS6                  "Procedure class 6"
label var PCLASS7                  "Procedure class 7"
label var PCLASS8                  "Procedure class 8"
label var PCLASS9                  "Procedure class 9"
label var PCLASS10                 "Procedure class 10"
label var PCLASS11                 "Procedure class 11"
label var PCLASS12                 "Procedure class 12"
label var PCLASS13                 "Procedure class 13"
label var PCLASS14                 "Procedure class 14"
label var PCLASS15                 "Procedure class 15"
label var PRMCCS1                  "Multi-Level CCS:  Procedure 1"

*** Convert special values to missing values ***
recode HOSP_NIS                  (-9999 -8888 -6666=.)
recode KEY_NIS                   (-999999999 -888888888 -666666666=.)
recode CHRON1                    (-99 -88 -66=.)
recode CHRON2                    (-99 -88 -66=.)
recode CHRON3                    (-99 -88 -66=.)
recode CHRON4                    (-99 -88 -66=.)
recode CHRON5                    (-99 -88 -66=.)
recode CHRON6                    (-99 -88 -66=.)
recode CHRON7                    (-99 -88 -66=.)
recode CHRON8                    (-99 -88 -66=.)
recode CHRON9                    (-99 -88 -66=.)
recode CHRON10                   (-99 -88 -66=.)
recode CHRON11                   (-99 -88 -66=.)
recode CHRON12                   (-99 -88 -66=.)
recode CHRON13                   (-99 -88 -66=.)
recode CHRON14                   (-99 -88 -66=.)
recode CHRON15                   (-99 -88 -66=.)
recode CHRON16                   (-99 -88 -66=.)
recode CHRON17                   (-99 -88 -66=.)
recode CHRON18                   (-99 -88 -66=.)
recode CHRON19                   (-99 -88 -66=.)
recode CHRON20                   (-99 -88 -66=.)
recode CHRON21                   (-99 -88 -66=.)
recode CHRON22                   (-99 -88 -66=.)
recode CHRON23                   (-99 -88 -66=.)
recode CHRON24                   (-99 -88 -66=.)
recode CHRON25                   (-99 -88 -66=.)
recode CHRONB1                   (-99 -88 -66=.)
recode CHRONB2                   (-99 -88 -66=.)
recode CHRONB3                   (-99 -88 -66=.)
recode CHRONB4                   (-99 -88 -66=.)
recode CHRONB5                   (-99 -88 -66=.)
recode CHRONB6                   (-99 -88 -66=.)
recode CHRONB7                   (-99 -88 -66=.)
recode CHRONB8                   (-99 -88 -66=.)
recode CHRONB9                   (-99 -88 -66=.)
recode CHRONB10                  (-99 -88 -66=.)
recode CHRONB11                  (-99 -88 -66=.)
recode CHRONB12                  (-99 -88 -66=.)
recode CHRONB13                  (-99 -88 -66=.)
recode CHRONB14                  (-99 -88 -66=.)
recode CHRONB15                  (-99 -88 -66=.)
recode CHRONB16                  (-99 -88 -66=.)
recode CHRONB17                  (-99 -88 -66=.)
recode CHRONB18                  (-99 -88 -66=.)
recode CHRONB19                  (-99 -88 -66=.)
recode CHRONB20                  (-99 -88 -66=.)
recode CHRONB21                  (-99 -88 -66=.)
recode CHRONB22                  (-99 -88 -66=.)
recode CHRONB23                  (-99 -88 -66=.)
recode CHRONB24                  (-99 -88 -66=.)
recode CHRONB25                  (-99 -88 -66=.)
recode PCLASS1                   (-99 -88 -66=.)
recode PCLASS2                   (-99 -88 -66=.)
recode PCLASS3                   (-99 -88 -66=.)
recode PCLASS4                   (-99 -88 -66=.)
recode PCLASS5                   (-99 -88 -66=.)
recode PCLASS6                   (-99 -88 -66=.)
recode PCLASS7                   (-99 -88 -66=.)
recode PCLASS8                   (-99 -88 -66=.)
recode PCLASS9                   (-99 -88 -66=.)
recode PCLASS10                  (-99 -88 -66=.)
recode PCLASS11                  (-99 -88 -66=.)
recode PCLASS12                  (-99 -88 -66=.)
recode PCLASS13                  (-99 -88 -66=.)
recode PCLASS14                  (-99 -88 -66=.)
recode PCLASS15                  (-99 -88 -66=.)

save "/volumes/projects-group$/LIU ADMINISTRATIVE/DATA Files/NIS_2010_DX_PR_GRPS.dta", replace
