# To format the HCUP data, using the CCS diagnoses and procedures:
python format_hcup.py --input /home/aschuler/LatentSyndromes/data/NIS2010Core.csv \
    --output /home/aschuler/LatentSyndromes/data/NIS2010_formatted_CCS.csv.gz \
    --keep_cols KEY$ AGE$ TOTCHG$ LOS$ AMONTH$ ZIPINC_QRTL$ PL_NCHS2006$ \
    --bool_cols FEMALE$ AWEEKEND$ ELECTIVE$ DIED$ \
    --cat_cols RACE$ PAY1$ ASOURCE$ DISPUNIFORM$ \
    --idlist_cols DXCCS PRCCS \
    --min_records 0 \
    --true 1 --false -1 \
    --present 1 --absent -1 \
    --gzip

# We will also need to format the severity data (containing comorbidity codes):
python format_hcup.py --input /home/aschuler/LatentSyndromes/data/NIS_Severity.csv \
    --output  /home/aschuler/LatentSyndromes/data/NIS_Severity_formatted.csv.gz \
    --keep_cols KEY$ \
    --bool_cols CM_ \
    --true 1 --false -1 \
    --present 1 --absent -1 \
    --gzip

# Now join the databases:
python combine_hcup.py --inputs /home/aschuler/LatentSyndromes/data/NIS_Severity_formatted.csv.gz \
        /home/aschuler/LatentSyndromes/data/NIS2010_formatted_CCS.csv.gz \
    --keys KEY \
    --output /home/aschuler/LatentSyndromes/data/NIS_merged_CCS.csv.gz \
    --gzip