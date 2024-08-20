library(openxlsx)
library(dplyr)

source("source/my_functions.R")

file_name<- "han20230213.csv"
raw_data <- my_read_csv_from_raw_data_folder(file_name)

temp <- raw_data

################################################################################
## 날짜형식으로 변환
################################################################################
temp$DOB <- as.Date(temp$DOB, origin = "1899-12-30")
temp$D_1st_HR <- as.Date(temp$D_1st_HR, format = "%Y.%m.%d")
temp$D_1st_HR.1 <- as.Date(temp$D_1st_HR.1, origin = "1899-12-30")
temp$D_PTR <- as.Date(temp$D_PTR, origin = "1899-12-30")
temp$D_DEATH <- as.Date(temp$D_DEATH, format = "%Y.%m.%d")
temp$D_RECUR <- as.Date(temp$D_RECUR, format = "%Y.%m.%d")
temp$D_1st_HR.2 <- as.Date(temp$D_1st_HR.2, format = "%Y.%m.%d")
################################################################################
## AGE와 DOB validation
################################################################################
temp$PAGE <- ceiling(as.numeric(difftime(temp$D_1st_HR, temp$DOB, units = "days")) / 365.25)
temp$validation_AGE <- temp$AGE -temp$PAGE
################################################################################
## FU_DFS와 D_RECUR - D_1st_HR validation
################################################################################
temp$PDFS <- ceiling(as.numeric(difftime(temp$D_RECUR, temp$D_1st_HR, units = "days")) / 30)
temp$validation_DFS <- temp$PDFS -temp$FU_DFS
################################################################################
## FU_OS와 D_DEATH - D_1st_HR validation
################################################################################
temp$POS <- ceiling(as.numeric(difftime(temp$D_DEATH, temp$D_1st_HR, units = "days")) / 30)
temp$validation_POS <- temp$POS -temp$FU_OS

raw_data <- select(raw_data, -DOB, -D_1st_HR, -D_1st_HR.1, -D_PTR, -D_1st_HR.2, -D_RECUR, -D_DEATH)

# PatientID에 해당하는 열을 일련번호로 대체
raw_data<-my_deidentify_raw_data(raw_data, "MRN")
# PatientName에 해당하는 열을 삭제
deidentified_raw_data <- select(raw_data, -NAME)

file_name <- sub("\\.csv$", ".xlsx", file_name)
deidentified_file_name<-paste0("deidentified_", file_name)
deidentified_file_path <- file.path(raw_data_folder, deidentified_file_name)
write.xlsx(deidentified_raw_data, file=deidentified_file_path, rowNames=FALSE)
file_name <- sub("\\.xlsx$", ".csv", file_name)
deidentified_file_name<-paste0("deidentified_", file_name)
deidentified_file_path <- file.path(raw_data_folder, deidentified_file_name)
write.csv(deidentified_raw_data, file=deidentified_file_path, row.names=FALSE)
