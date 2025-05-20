# install.packages(c('xgboost', 'Matrix', 'caret', 'readxl', 'pROC'))


suppressMessages(library(xgboost))
suppressMessages(library(Matrix))
suppressMessages(library(caret))
suppressMessages(library(readxl))
suppressMessages(library(pROC))
args=commandArgs(T)




patient_data <- read_excel(paste0(  "./",args[1]))
patient_data <- patient_data[complete.cases(patient_data), ]
patient_data$delta_NIHSS<-patient_data$NIHSS_D-patient_data$NIHSS_A
patient_data$delta_NIH1A<-patient_data$NIH1A_D-patient_data$NIH1A_A
patient_data$delta_NIH1B<-patient_data$NIH1B_D-patient_data$NIH1B_A
patient_data$delta_NIH1C<-patient_data$NIH1C_D-patient_data$NIH1C_A
patient_data$delta_NIH2<-patient_data$NIH2_D-patient_data$NIH2_A
patient_data$delta_NIH3<-patient_data$NIH3_D-patient_data$NIH3_A
patient_data$delta_NIH4<-patient_data$NIH4_D-patient_data$NIH4_A

patient_data$delta_NIH5A<-patient_data$NIH5A_D-patient_data$NIH5A_A
patient_data$delta_NIH5B<-patient_data$NIH5B_D-patient_data$NIH5B_A
patient_data$delta_NIH6A<-patient_data$NIH6A_D-patient_data$NIH6A_A
patient_data$delta_NIH6B<-patient_data$NIH6B_D-patient_data$NIH6B_A
patient_data$delta_NIH7<-patient_data$NIH7_D-patient_data$NIH7_A
patient_data$delta_NIH8<-patient_data$NIH8_D-patient_data$NIH8_A
patient_data$delta_NIH9<-patient_data$NIH9_D-patient_data$NIH9_A
patient_data$delta_NIH10<-patient_data$NIH10_D-patient_data$NIH10_A
patient_data$delta_NIH11<-patient_data$NIH11_D-patient_data$NIH11_A

patient_data$TOAST1<-ifelse(patient_data$TOAST==1,1,0)
patient_data$TOAST2<-ifelse(patient_data$TOAST==2,1,0)
patient_data$TOAST3<-ifelse(patient_data$TOAST==3,1,0)
patient_data$TOAST4<-ifelse(patient_data$TOAST==4,1,0)
patient_data$TOAST5<-ifelse(patient_data$TOAST==5,1,0)
patient_data$D_MRS<-patient_data$MRS_D

all_outresult<-c()

k<-1

for(outcome in c("stroke","death","mRS_36")  ){
  for(time_point in c("m3","y1")) {
#   load(file = sprintf("./Models/TheSimplifiedModelsinScenario1/ROC_curve_%s.Rdata", dsLabel2[i]))
outcomename<-paste0(time_point,"_",outcome)
#m3_stroke_model_1_sensitivity_0_xgboost_model.xgb
mod_best_final<-xgb.load(paste0("./mod/",time_point,"_",outcome,"_model_1_sensitivity_0_xgboost_model.xgb"))


threhold1<-c("m3_stroke","y1_stroke","m3_death","y1_death","m3_mRS_36","y1_mRS_36")
threhold2<-c(0.154366135,0.11707978,0.0564446393,0.046315172687,0.150881908833,0.150881908833)
threhold<-data.frame(threhold1,threhold2)


mainmodel_noregion_xcols0<-c('AGE','GENDER', 'D_MRS' ,'H_TIA','TOAST1' ,'TOAST2','TOAST3','TOAST4','TOAST5','H_DIABO1','H_STROKEO1','delta_NIHSS',
                             'delta_NIH1A',
                             'delta_NIH1B','delta_NIH1C','delta_NIH2','delta_NIH3','delta_NIH4','delta_NIH5A','delta_NIH5B',
                             'delta_NIH6A','delta_NIH6B','delta_NIH7','delta_NIH8','delta_NIH9','delta_NIH10','delta_NIH11')
patient_data1<-patient_data[,c(mainmodel_noregion_xcols0)]

xgboost_matrix<-xgb.DMatrix(data=as.matrix(patient_data[,mainmodel_noregion_xcols0]),label=patient_data[[outcomename]])

pre_test_xgb<-predict(mod_best_final, xgboost_matrix)



performance<-data.frame(patient_data[[outcomename]],as.numeric(pre_test_xgb))
colnames(performance)<-c("true","predict")
xgboost_roc_out<-roc(performance$true,as.numeric(performance$predict))
ci_auc <- ci.auc(xgboost_roc_out, method = "bootstrap", boot.n = 1000)
ci_auc_result<-data.frame(ci_auc)
str(ci_auc_result)
ci_auc_1<-paste0(round(ci_auc_result$ci_auc[2],3),"(",round(ci_auc_result$ci_auc[1],3),"~",round(ci_auc_result$ci_auc[3],3),")")


predicted <- ifelse( performance$predict > threhold$threhold2[threhold$threhold1==outcomename], 1, 0)
cm <- confusionMatrix(as.factor( predicted), as.factor( performance$true))
outresult<-data.frame(t(data.frame(cm$byClas)))
cm1<-data.frame(cm$table)
outresult$cm_pre0_true0<-cm1$Freq[cm1$Prediction==0 & cm1$Reference==0]
outresult$cm_pre1_true0<-cm1$Freq[cm1$Prediction==1 & cm1$Reference==0]
outresult$cm_pre0_true1<-cm1$Freq[cm1$Prediction==0 & cm1$Reference==1]
outresult$cm_pre1_true1<-cm1$Freq[cm1$Prediction==1 & cm1$Reference==1]
outresult$auc<-xgboost_roc_out$auc[1]
outresult$auc_ci<-ci_auc_1
colnames(outresult)<-paste0("out_",colnames(outresult))

formatted_time <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
outresult$time<-formatted_time
outresult$outcomename<-outcomename
all_outresult<-rbind(all_outresult,outresult)


  }
  
}


formatted_time1 <- format(Sys.time(), "%Y-%m-%d_%H:%M:%S")

write.table(all_outresult,file = paste0("./DISCO_model_external_validation_result",formatted_time1,".csv"),quote = F,sep = ',',append=T,col.names=T,row.names = F)




