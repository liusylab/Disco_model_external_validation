# **DISCO model external validation tool**
This is a simple script for external validation of the DISCO stroke AI model (developed by liulab). The following R packages are required: xgboost, Matrix, caret, readxl, pROC.




## Download File

```
git clone https://github.com/liusylab/Disco_model_external_validation.git
cd ./Disco_model_external_validation
```


## Data explanation:
You will see randomly generated data for 99 patients in the file(**example_patient_data.xlsx**), with 46 columns and 100 rows (including the header).
<img width="1597" alt="image" src="https://github.com/user-attachments/assets/6e5fad2b-a2f0-4c35-a308-8dbc5de9c106" />


We have given the fields description of the data table in the file "**patient_data_table_Field_description.xlsx**"

<img width="807" alt="image" src="https://github.com/user-attachments/assets/944fe0b6-ff75-461d-b3b2-034ad0476124" />




## 1. Testing the script using sample data(example_patient_data.xlsx)
```
Rscript ./external_valiadation.R example_patient_data.xlsx
```
If the script runs successfully, you will find a new file in the directory: DISCO_model_external_validation_result{time}.csv


## 2. Create your own data table based on the sample data
You can directly copy the corresponding data into the Excel table(**example_patient_data.xlsx**),.
Moreover, our script calculates the prediction results of 3 outcomes at 2 time points by default, so a total of 6 results (m3_stroke, y1_stroke, m3_death, y1_death, m3_mRS_36 y1_mRS_36) will be calculated. If your data lacks a column of result data, please fill it with 0 directly.

**NOTE: All the contents filled in the patient_data_table must be in numerical form!!**


## 3. External validation of models using own patient data
```
Rscript ./external_valiadation.R your_filename.xlsx
```


