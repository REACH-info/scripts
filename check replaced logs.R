library(openxlsx)
library(dplyr)

# We are defining a function below to check if cleaning log is applied to raw data correctly.

check_log <- function(rawDF, cleanedDF, uuid_){
  # Create empty vectors
  question <- vector()
  old_value <- vector()
  new_value <- vector()
  uuid <- vector()
  
  for (j in 1:length(rawDF)) {
    
    for (rowi in 1:nrow(rawDF)){
      value_raw <- rawDF[rowi, j]
      value_clean <- cleanedDF[rowi, j]
      
      # create logical check temp var
      # temp <- is.na(value_clean) & !is.na(value_raw)
      temp <- as.character(value_raw) %in% as.character(value_clean)
      # condition
      if (!isTRUE(temp)){
        value_raw <- rawDF[rowi, j]
        value_clean <- cleanedDF[rowi, j]
        
        # append values to vectors
        question <- c(question,names(rawDF[j]))
        old_value <- c(old_value, as.character(value_raw))
        new_value <- c(new_value, as.character(value_clean))
        uuid <- c(uuid, as.character(rawDF[rowi,uuid_]))
      }
      
    }
    # progress
    cat("\014")
    print(paste("Checking Column", j, "of", length(rawDF)))
  }
  
  checks <- data.frame(question, old_value, new_value, uuid)
  return(checks)
}




#reading raw data
raw_df <- read.xlsx("raw_data.xlsx")

#reading our clean data
cleaned_df <- read.xlsx("clean_data.xlsx")

#reading our cleaning log
cleaning_logs <- read.xlsx("cleaning log.xlsx")

#filtering to get only those logs that values are changed
cleaning_logs <- cleaning_logs[cleaning_logs$changed == "yes",]


#creating unique_id in cleaning log in order to compare wiht unique id of replaced _log file
cleaning_logs$unique_id <- paste0(cleaning_logs$uuid,cleaning_logs$question.name,cleaning_logs$new.value)

# Calling  check_log function to check whether cleaning log is applied correctly to raw_data 
# which gives us logs that are replaced
replaced_logs <- check_log(raw_df, cleaned_df, "_uuid")

#creating unique id for logs that are replaced
replaced_logs<- replaced_logs %>% mutate(unique_id = paste0(uuid,question,new_value))

#comparing repalced_logs data frame with cleaning log to find those logs which are not applied
missing_logs <- cleaning_logs[!cleaning_logs$unique_id %in% replaced_logs$unique_id,]

#To find logs that are replaced but are not in cleaning log
not_logged_logs <- replaced_logs[!replaced_logs$unique_id %in% cleaning_logs$unique_id,]

# To find logs which are not in raw_data
logs_nin_df <- cleaning_logs[!cleaning_logs$uuid %in% raw_df$`_uuid` | !cleaning_logs$question.name %in% names(raw_df),]

# finding duplicated logs
duplicate_logs <- cleaning_logs[duplicated(paste0(cleaning_logs$question.name,cleaning_logs$uuid)) | duplicated(paste0(cleaning_logs$question.name,cleaning_logs$uuid), fromLast = T),]

write.xlsx(replaced_logs,"output/replaced_log_result.xlsx")
write.xlsx(missing_logs,"output/missing_logs.xlsx")
write.xlsx(not_logged_logs,"output/not_logged_logs.xlsx")
write.xlsx(duplicate_logs,"output/duplicate_logs.xlsx")
