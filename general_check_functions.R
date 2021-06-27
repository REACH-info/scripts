
# loading libraries -------------------------------------------------------

library(dplyr)



# Survey made before first day of data collection -------------------------
started_before <-function(df,df_date,start_date,var_list= c()){
  df %>% 
    filter(df_date < start_date) %>%
    select(var_list)
}



# Survey with short interview duration ------------------------------------
short_interview <- function(df,interview_duration,time_min, var_list = c()){
  df %>% 
    filter(interview_duration < time_min) %>% 
    select(var_list)
}



# Duplicated survey- UUID -------------------------------------------------
duplicate_surveys <- function(df, var_list=c()){
  
  df[duplicated(df$`_uuid`) | duplicated(df$`_uuid`, fromLast = T),] %>%
    select(var_list)
}



# Surveys made in the future  ---------------------------------------------
future_survey <- function(df,var_list=c()){
  df %>%
    filter(date > as.Date(`_submission_time`)) %>%
    select(var_list)
}



# Survey with different start and end date --------------------------------
survey_different_start_end <- function(df,var_list=c()){
  df %>% 
    filter(as.Date(end) != as.Date(start)) %>% 
    select (var_list)
}



# Surveys ending before they start ----------------------------------------
ending_before_start <- function(df,var_list=c()){
  
  df %>%
    filter(as.POSIXct(start) > as.POSIXct(end)) %>%
    select(var_list)
    
}


# Number of surverys submitted per day ------------------------------------

survey_status_per_day <- function(df,date){ 
  
  df %>%
  group_by(Date = date) %>%
  summarise(Accepted = sum(deleted_issue == "no reason", na.rm = T),
            Deleted = sum(deleted_issue != "no reason", na.rm = T ),
            Total_submissions = n()
  )
}





# Number of Survey submitted per day by enumerator ----------------------------------------------------
survey_per_day_enumerator <-function(df,date,enumerator_uuid) {
  df %>%
    group_by(Date = date, Enumerator = enumerator_uuid) %>%
    summarise(Accepted = sum(deleted_issue == "no reason", na.rm = T),
              Deleted = sum(deleted_issue != "no reason", na.rm = T ),
              Total_submissions = n(),
              Avergage_survey = round(mean(sum(Accepted, Deleted, na.rm = T), na.rm = T),0)
    )
  
}
# Number of worked day per enumerator  ------------------------------------

no_worked_per_day <- function(df,recent_data){ 
  for (i in df$Enumerator) {
    df[df$Enumerator == i, "worked_days"] <- nrow(unique(recent_data[recent_data$enumerator_uuid == i,"date"]))
  }
}



# Average interview duration by enumerator --------------------------------
avg_survey_length <-function(df,enumerator_uuid){ 
  df %>% 
    group_by(Enumerator = enumerator_uuid) %>%
    summarise(
      Average_duration = round(mean(interview_duration, na.rm = T),0),
      Total_submissions = n()
    )
}
