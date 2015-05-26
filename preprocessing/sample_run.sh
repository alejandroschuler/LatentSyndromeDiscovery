# To format the HCUP data, using the CCS diagnoses and procedures:
python format_hcup.py --input 2010/NIS2010Core.short.csv \
    --output 2010/processed/NIS2010_formatted_CCS.csv \
    --keep_cols KEY$ AGE$ TOTCHG$ LOS$ AMONTH$ ZIPINC_QRTL$ PL_NCHS2006$ \
    --bool_cols FEMALE$ AWEEKEND$ ELECTIVE$ DIED$ \
    --cat_cols RACE$ PAY1$ ASOURCE$ DISPUNIFORM$ \
    --idlist_cols DXCCS PRCCS \
    --min_records 0

# We will also need to format the severity data (containing comorbidity codes):
python format_hcup.py --input 2010/NIS_Severity.short.csv \
    --output 2010/processed/NIS_Severity_formatted.csv \
    --keep_cols KEY$ \
    --bool_cols CM_

# Now join the databases:
python combine_hcup.py --inputs 2010/processed/NIS_Severity_formatted.csv \
        2010/processed/NIS2010_formatted_CCS.csv \
    --keys KEY \
    --output 2010/processed/NIS_merged_CCS.csv

# This commented-out section is the analysis outputting a zipped file:

# # To format the HCUP data, using the CCS diagnoses and procedures:
# python format_hcup.py --input 2010/NIS2010Core.short.csv \
#     --output 2010/processed/NIS2010_formatted_CCS.csv.gz \
#     --keep_cols KEY$ AGE$ TOTCHG$ LOS$ AMONTH$ ZIPINC_QRTL$ PL_NCHS2006$ \
#     --bool_cols FEMALE$ AWEEKEND$ ELECTIVE$ DIED$ \
#     --cat_cols RACE$ PAY1$ ASOURCE$ DISPUNIFORM$ \
#     --idlist_cols DXCCS PRCCS \
#     --min_records 0 \
#     --gzip

# # We will also need to format the severity data (containing comorbidity codes):
# python format_hcup.py --input 2010/NIS_Severity.short.csv \
#     --output 2010/processed/NIS_Severity_formatted.csv.gz \
#     --keep_cols KEY$ \
#     --bool_cols CM_ \
#     --gzip

# # Now join the databases:
# python combine_hcup.py --inputs 2010/processed/NIS_Severity_formatted.csv.gz \
#         2010/processed/NIS2010_formatted_CCS.csv.gz \
#     --keys KEY --gzip \
#     --output 2010/processed/NIS_merged_CCS.csv