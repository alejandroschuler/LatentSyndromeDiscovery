# To format the HCUP data, using the CCS diagnoses and procedures:
python format_hcup.py --input /home/aschuler/LatentSyndromes/data/NIS2010Core.csv \
    --output /home/aschuler/LatentSyndromes/data/codes_NIS2010_formatted_CCS.csv.gz \
    --keep_cols KEY$ \
    --idlist_cols DXCCS PRCCS \
    --min_records 0 \
    --true 1 --false 0 \
    --present 1 --absent 0 \
    --gzip

# We will also need to format the severity data (containing comorbidity codes):
python format_hcup.py --input /home/aschuler/LatentSyndromes/data/NIS_Severity.csv \
    --output  /home/aschuler/LatentSyndromes/data/codes_NIS_Severity_formatted.csv.gz \
    --keep_cols KEY$ \
    --bool_cols CM_ \
    --true 1 --false 0 \
    --present 1 --absent 0 \
    --gzip

# Now join the databases:
python combine_hcup.py --inputs /home/aschuler/LatentSyndromes/data/codes_NIS_Severity_formatted.csv.gz \
        /home/aschuler/LatentSyndromes/data/codes_NIS2010_formatted_CCS.csv.gz \
    --keys KEY \
    --output /home/aschuler/LatentSyndromes/data/codes_NIS_merged_CCS.csv.gz \
    --gzip