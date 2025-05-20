# **DISCO model external validation tool**
This is a simple script for external validation of the DISCO stroke AI model (developed by liulab). The following packages are required: xgboost, Matrix, caret, readxl, pROC.




## Download File

```
git clone https://github.com/liusylab/Disco_model_external_validation.git
cd Disco_model_external_validation
```





## 1. Testing the script using sample data(example_patient_data.xlsx)
```
Rscript external_valiadation.R example_patient_data.xlsx
```
If the script runs successfully, you will find a new file in the directory: DISCO_model_external_validation_result{time}.csv


## 2. Create your own data table based on the sample data: You can directly copy the corresponding data into the Excel table
We have given the fields description of the data table in the file "patient_data_table_Field_description.xlsx"

<img width="807" alt="image" src="https://github.com/user-attachments/assets/944fe0b6-ff75-461d-b3b2-034ad0476124" />



**NOTE: All the contents filled in the patient_data_table must be in numerical form!!**


## 3. External validation of models using own patient data
```
Rscript external_valiadation.R your_filename.xlsx
```


