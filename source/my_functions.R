################################################################################
## my_functions_for_load_raw_data
################################################################################
my_read_csv_from_raw_data_folder <- function(csv_filename) {
  # 현재 작업 디렉토리 설정
  project_folder <<- getwd()
  raw_data_folder <<- file.path(project_folder, "raw_data")
  
  # 입력된 파일명에 해당하는 파일 경로 설정
  csv_path <- file.path(raw_data_folder, csv_filename)
  df <- read.csv(csv_path, header=T, dec=".")
  
  return(df)
}

################################################################################
## my_functions_deidentify_raw_data
################################################################################
## 데이터프레임형식 raw_data와 환자번호 컬럼명을 인자로 받아서 serial number를 부여하여 반환하는 함수 
my_deidentify_raw_data <- function(df, col_name) {
  # 열을 정렬하고 고유한 값들을 추출합니다.
  unique_values <- unique(df[[col_name]])
  sorted_values <- sort(unique_values)
  
  # 고유한 값들에 대해 순서를 부여합니다.
  value_to_index <- match(sorted_values, unique_values)
  
  # 해당 열을 고유한 값에 대응하는 숫자로 대체합니다.
  df[[col_name]] <- as.character(value_to_index[match(df[[col_name]], unique_values)])
  
  return(df)
}

