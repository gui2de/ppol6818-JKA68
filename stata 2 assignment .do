**Jasnoor Anand STATA Assignment 2 

*Q1)
clear`'

global wd "/Users/jasnooranand/Desktop/ppol6818profali/week_05/03_assignment/01_data/"
cd "$wd"
use "$wd/q1_psle_student_raw.dta", clear

describe
list in 1/20

split s, parse("</TD></TR>") gen(temp_var)

drop s temp_var1

gen id = _n

reshape long temp_var, i(id) j(var_num)

drop id var_num

drop if temp_var == ""

split temp_var, parse("</TD>") gen(col)

gen school_code = ""
replace school_code = regexs(1) if regexm(col1, "([A-Z0-9]+)-[0-9]+")

drop if school_code == ""

gen candidate_id = regexs(2) if regexm(col1, "([A-Z0-9]+)-([0-9]+)")
replace candidate_id = regexs(2) if regexm(col1, "([A-Z0-9]+)-([0-9]+)")

gen student_number = regexs(0) if regexm(col2, "[0-9]{10,12}")

gen gender = regexs(0) if regexm(col3, "(?<=>)(M|F|Male|Female)(?=<)")

gen full_name = regexs(0) if regexm(col4, "(?<=<P>)([^<]+)(?=</FONT>)")


gen subject_scores = regexs(0) if regexm(col5, "(?<=>K)(.*?)(?=</FONT>)")


replace subject_scores = trim(subject_scores)


split subject_scores, parse(", ") gen(subj)


gen obs_id = _n


reshape long subj, i(obs_id) j(subject_count)


split subj, parse("- ") gen(subj_clean)


gen subject_name = trim(subj_clean1)
gen subject_grade = trim(subj_clean2)

drop subj subj_clean1 subj_clean2 subject_count

drop if subject_name == "" | subject_name == "."

encode subject_name, gen(subject_code)
drop subject_name

reshape wide subject_grade, i(obs_id) j(subject_code)


rename subject_grade1 total_avg
rename subject_grade2 eng_score
rename subject_grade3 math_score
rename subject_grade4 kiswahili_score
rename subject_grade5 knowledge_score
rename subject_grade6 science_score
rename subject_grade7 civics_score

drop obs_id
drop school_code

order schoolcode candidate_id gender student_number full_name kiswahili_score eng_score knowledge_score math_score science_score civics_score total_avg

drop temp_var col1 col2 col3 col4 col5 subject_scores



*q2)
clear
global wd "/Users/jasnooranand/Desktop/ppol6818profali/week_05/03_assignment/01_data/"
global excel "$wd/q2_CIV_populationdensity.xlsx"  

import excel "$excel", firstrow clear  

save "q2_CIV_populationdensity.dta", replace  


// Retain only rows that include 'DEPARTEMENT' in the department column
keep if regexm(NOMCIRCONSCRIPTION, "DEPARTEMENT")

// Removing unnecessary columns
drop SUPERFICIEKM2 POPULATION

// Renaming variables for clarity
rename NOMCIRCONSCRIPTION dept_name
rename DENSITEAUKM pop_density

// Cleaning up department names by removing unnecessary text
replace dept_name = regexr(dept_name, "DEPARTEMENT DE|DEPARTEMENT DU|DEPARTEMENT D'", "")

list dept_name if dept_name != trim(dept_name)
list dept_name if dept_name != lower(dept_name)

replace dept_name = trim(dept_name)
replace dept_name = lower(dept_name)

replace dept_name = "arrah" if dept_name == "arrha"

tempfile cleaned_density
save `cleaned_density', replace

use "$wd/q2_CIV_Section_0", clear 

decode b06_departemen, gen(dept_name)

replace dept_name = trim(dept_name)
replace dept_name = lower(dept_name)


merge m:1 dept_name using `cleaned_density'

tab _merge

list dept_name pop_density if _merge == 2

drop if _merge == 2

tab _merge

drop _merge

save "$wd/CIV_Section_O_with_density.dta", replace



*q3)
clear
use "q3_gps_data.dta", clear

sort latitude longitude

gen enumerator = .

local num_enumerators = 19  // Total enumerators
local num_households = _N    // Total households
local group_size = 6         // Households per enumerator

forvalues i = 1/`num_enumerators' {
    quietly count if missing(enumerator)  // Count unassigned households
    if `r(N)' == 0 {  // Stop if all are assigned
        continue
    }
    
    // firstwe find unassigned household (northernmost)
    quietly sum latitude if missing(enumerator)
    local lat = r(min)

    quietly sum longitude if missing(enumerator) & latitude == `lat'
    local lon = r(min)

    // then now we will have to create temporary dataset for distance calculations
    gen dist = .
    
    geodist latitude longitude `lat' `lon', generate(temp_dist)
    
    replace dist = temp_dist if missing(enumerator)

    sort dist

    replace enumerator = `i' if missing(enumerator) & _n <= `group_size'
   
    drop dist temp_dist
}



*q4)
clear
global wd "/Users/jasnooranand/Desktop/ppol6818profali/week_05/03_assignment/01_data/"
global excel "$wd/q4_Tz_election_2010_raw.xls"
import excel "$excel", sheet("Sheet1") cellrange(A5:J7927) firstrow clear


foreach var in REGION DISTRICT COSTITUENCY WARD {
    replace `var' = `var'[_n-1] if missing(`var')
}


replace TTLVOTES = "0" if TTLVOTES == "UN OPPOSED"
destring TTLVOTES, replace force


tab POLITICALPARTY
levelsof POLITICALPARTY, local(parties) clean
display "`parties'"  


gen votes_afp = TTLVOTES if POLITICALPARTY == "AFP"
gen votes_appt = TTLVOTES if POLITICALPARTY == "APPT"
gen votes_ccm = TTLVOTES if POLITICALPARTY == "CCM"
gen votes_chadema = TTLVOTES if POLITICALPARTY == "CHADEMA"
gen votes_chausta = TTLVOTES if POLITICALPARTY == "CHAUSTA"
gen votes_cuf = TTLVOTES if POLITICALPARTY == "CUF"
gen votes_dp = TTLVOTES if POLITICALPARTY == "DP"
gen votes_jahazi_asilia = TTLVOTES if POLITICALPARTY == "JAHAZI ASILIA"
gen votes_makin = TTLVOTES if POLITICALPARTY == "MAKIN"
gen votes_nccr_mageuzi = TTLVOTES if POLITICALPARTY == "NCCR-MAGEUZI"
gen votes_nld = TTLVOTES if POLITICALPARTY == "NLD"
gen votes_nra = TTLVOTES if POLITICALPARTY == "NRA"
gen votes_sau = TTLVOTES if POLITICALPARTY == "SAU"
gen votes_tadea = TTLVOTES if POLITICALPARTY == "TADEA"
gen votes_tlp = TTLVOTES if POLITICALPARTY == "TLP"
gen votes_udp = TTLVOTES if POLITICALPARTY == "UDP"
gen votes_umd = TTLVOTES if POLITICALPARTY == "UMD"


replace votes_afp = 0 if missing(votes_afp)
replace votes_appt = 0 if missing(votes_appt)
replace votes_ccm = 0 if missing(votes_ccm)
replace votes_chadema = 0 if missing(votes_chadema)
replace votes_chausta = 0 if missing(votes_chausta)
replace votes_cuf = 0 if missing(votes_cuf)
replace votes_dp = 0 if missing(votes_dp)
replace votes_jahazi_asilia = 0 if missing(votes_jahazi_asilia)
replace votes_makin = 0 if missing(votes_makin)
replace votes_nccr_mageuzi = 0 if missing(votes_nccr_mageuzi)
replace votes_nld = 0 if missing(votes_nld)
replace votes_nra = 0 if missing(votes_nra)
replace votes_sau = 0 if missing(votes_sau)
replace votes_tadea = 0 if missing(votes_tadea)
replace votes_tlp = 0 if missing(votes_tlp)
replace votes_udp = 0 if missing(votes_udp)
replace votes_umd = 0 if missing(votes_umd)


bysort WARD: egen Total_Votes = sum(TTLVOTES)


drop CANDIDATENAME SEX G POLITICALPARTY ELECTEDCANDIDATE TTLVOTES


gen ward_id = _n


order REGION DISTRICT COSTITUENCY WARD ward_id Total_Votes votes_*

*q5)
clear
global wd "/Users/jasnooranand/Desktop/ppol6818profali/week_05/03_assignment/01_data/"
global school_data "$wd/q5_psle_2020_data.dta"
global school_loc "$wd/q5_school_location.dta"

use "$school_loc", clear

duplicates tag NECTACentreNo, gen(dup)
tab dup  

drop if NECTACentreNo == "n/a" | dup > 0  

tempfile clean_school_loc
save `clean_school_loc'

use "$school_data", clear

replace schoolname = subinstr(schoolname, "PRIMARY", "", .)
replace schoolname = subinstr(schoolname, "ACADEMY", "", .)
replace schoolname = trim(schoolname)

gen school_code = regexs(1) if regexm(schoolname, "([0-9]+)")
replace school_code = trim(school_code)

merge 1:1 school_code using `clean_school_loc'
drop if _merge == 2  
drop _merge


clear
global wd "/Users/jasnooranand/Desktop/ppol6818profali/week_05/03_assignment/01_data/"

* Load School Location Data
use "$wd/q5_school_location.dta", clear

* Drop duplicate school codes (NECTACentreNo)
duplicates tag NECTACentreNo, gen(dup)
drop if NECTACentreNo == "n/a" | dup > 0
drop dup

* Save clean school location dataset
tempfile clean_school_loc
save `clean_school_loc'

* Load PSLE School Data
use "$wd/q5_psle_2020_data.dta", clear

* Standardize school names (remove "PRIMARY", "ACADEMY", etc.)
replace schoolname = subinstr(schoolname, "PRIMARY", "", .)
replace schoolname = subinstr(schoolname, "ACADEMY", "", .)
replace schoolname = trim(schoolname)

* Extract school code if available
gen school_code = regexs(0) if regexm(schoolname, "([0-9]+)")
replace school_code = trim(school_code)
list schoolname school_code if missing(school_code)  // See if some schools have missing codes

ds

* Merge using School Code (Exact Match)
merge 1:1 schoolname using `clean_school_loc'

keep if _merge == 3  // Keep only matched records
drop _merge

* Save Final Cleaned Dataset
save "$wd/q5_psle_2020_matched.dta", replace



clear
global wd "/Users/jasnooranand/Desktop/ppol6818profali/week_05/03_assignment/01_data/"
global school_data "$wd/q5_psle_2020_data.dta"
global location_data "$wd/q5_school_location.dta"

* Step 1: Load the School Dataset
use "$school_data", clear

* Step 2: Remove unnecessary words from school names
replace schoolname = subinstr(schoolname, "PRIMARY", "", .)
replace schoolname = subinstr(schoolname, "ACADEMY", "", .)
replace schoolname = subinstr(schoolname, "NURSERY", "", .)
replace schoolname = trim(schoolname)

* Step 3: Extract School Code (Similar to NECTACentreNo)
gen school_code = regexs(0) if regexm(schoolname, "([0-9]+)")  // Extract numeric part
replace school_code = trim(school_code)

* Step 4: Save Cleaned School Data
tempfile school_temp
save `school_temp'

* Step 5: Load the School Location Dataset
use "$location_data", clear

* Step 6: Remove duplicates based on school_code (if available)
duplicates drop school_code, force
tempfile clean_school_loc
save `clean_school_loc'

* Step 7: Merge Using School Code
use `school_temp', clear
merge 1:1 school_code using `clean_school_loc'

* Step 8: Keep Only Matched Observations
keep if _merge == 3
drop _merge

save "$wd/q5_psle_merged.dta", replace



clear
global wd "/Users/jasnooranand/Desktop/ppol6818profali/week_05/03_assignment/01_data/"


use "$wd/q5_school_location.dta", clear


duplicates tag NECTACentreNo, gen(dup)
drop if NECTACentreNo == "n/a" | dup > 0
drop dup

replace School = lower(School)
replace School = trim(School)


tempfile clean_school_loc
save `clean_school_loc'

use "$wd/q5_psle_2020_data.dta", clear

rename schoolname School

* Convert School Name to Lowercase
replace School = lower(School)
replace School = regexr(School, "[0-9]+", "")

replace School = subinstr(School, "primary school - ps", "", .)
replace School = subinstr(School, "primary school", "", .)
replace School = subinstr(School, "- ps", "", .)

replace School = trim(School)

tempfile clean_psle
save `clean_psle'

use `clean_psle', clear
merge 1:1 School using `clean_school_loc'








clear
global wd "/Users/jasnooranand/Desktop/ppol6818profali/week_05/03_assignment/01_data/"

* Load and clean School Location Data
use "$wd/q5_school_location.dta", clear

duplicates tag NECTACentreNo, gen(dup)
drop if NECTACentreNo == "n/a" | dup > 0
drop dup

replace School = lower(School)
replace School = trim(School)

* Save cleaned school location dataset
tempfile clean_school_loc
save `clean_school_loc'

* Load and clean PSLE Data
use "$wd/q5_psle_2020_data.dta", clear

rename schoolname School

replace School = lower(School)
replace School = regexr(School, "[0-9]+", "")

replace School = subinstr(School, "primary school - ps", "", .)
replace School = subinstr(School, "primary school", "", .)
replace School = subinstr(School, "- ps", "", .)

replace School = trim(School)

* Save cleaned PSLE data
tempfile clean_psle
save `clean_psle'

* Merge cleaned datasets
use `clean_psle', clear
duplicates report School


use `clean_school_loc', clear
duplicates report School

use `clean_psle', clear
merge m:m School using `clean_school_loc'


/*
Step by step explanation

Defined a global variable ($wd) to store the file path where the datasets are located. This makes it easier to refer to file locations throughout the script.
Load and Clean School Location Data

Opened the q5_school_location.dta dataset.
Identified duplicate values in the NECTACentreNo variable.
Removed rows where NECTACentreNo is "n/a" or appears as a duplicate.
Converted the School variable to lowercase and removed extra spaces for consistency.
Saved the cleaned version as a temporary file (clean_school_loc).
Load and Clean PSLE Data

Opened the q5_psle_2020_data.dta dataset.
Renamed schoolname to School to match the variable name in the school location dataset.
Converted School to lowercase and removed any numbers from the name.
Removed specific words/phrases like "primary school - ps", "primary school", and "- ps" to make school names more comparable.
Trimmed spaces in School for consistency.
Saved the cleaned dataset as a temporary file (clean_psle).
Merge the Datasets on School

Used duplicates report to check for duplicate School names in both datasets.
Attempted to merge the two datasets using m:m School, which allows multiple matches in both datasets.

*/

/*
next i am giving instructions in words since my code is not working
My Step-by-Step Plan for Adding Fuzzy Matching
Now that I have merged the exact matches, I need to match the remaining unmatched schools using fuzzy matching. Here's how I will do it:

1. Identify Unmatched Observations
After merging, I will use the _merge variable to categorize observations:
_merge == 1 → Schools that appear only in clean_psle (PSLE dataset).
_merge == 2 → Schools that appear only in clean_school_loc (School location dataset).
_merge == 3 → Successfully matched records (I will keep these).
I will save the unmatched records from both datasets separately for fuzzy matching.
2. Prepare for Fuzzy Matching
I will load the unmatched records.
I need to ensure that School is still a string variable in both datasets (and convert if necessary).
If I haven't already installed matchit, I will do so now to perform fuzzy matching.
3. Perform Fuzzy Matching
I will use matchit to compare school names between the unmatched PSLE schools and the unmatched school location dataset.
This will generate a similarity score (match_score) that measures how close the school names are.
4. Review and Filter Matches
I will sort the results by match_score to identify the best possible matches.
To ensure accuracy, I will set a threshold (e.g., match_score > 0.7) to keep only high-confidence matches.
5. Merge Fuzzy Matches into the Main Dataset
I will append the best fuzzy matches to the previously merged exact matches.
Finally, I will ensure that my dataset includes both exact and fuzzy matches so that I have the most complete and accurate mapping possible.
*/

*this is the code i want to use but it shows error. i do not know how to fix this, i think tjis is wrong but i am still attaching.

preserve
    keep if _merge == 1  
    tempfile psle_unmatched
    save `psle_unmatched'
restore

preserve
    keep if _merge == 2  
    tempfile school_loc_unmatched
    save `school_loc_unmatched'
restore

use `psle_unmatched', clear
gen id = _n  
save `psle_unmatched', replace

use `school_loc_unmatched', clear
gen id = _n  
save `school_loc_unmatched', replace

use `psle_unmatched', clear
matchit School using `school_loc_unmatched', idusing(id) gen(match_score) threshold(0.7)

sort match_score
append using `clean_psle'



