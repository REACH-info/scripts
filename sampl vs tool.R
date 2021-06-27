# Loading Libraries
library(tidyverse)
library(janitor)
library(readxl)
library(butteR)

# The %in% operator in R can be used to identify if an element (e.g., a number) belongs to a vector or dataframe 
# while negating %in% do the opposite of %in% 


'%noin%' <- Negate('%in%')

# Reading our sampling data
sample <- read_excel("Sampling_Frame_HH_Endline.xlsx")


# Reading tool choices sheet 
tool <- read_excel("AGORA_Endline_2021_HH_Final_Version.xlsx",sheet = 2) 


#User defined function using base R to check whether a village in sample belongs to same manteqa in tool 
# or to check a district in sample belongs to same province in tool or not
# Basically it takes 2 data frame (sample file, tool) as an arguments with respective column names to be checked

sample_tool <- function(sample,s1,s2,tool,t1,t2){
  
  #creating a unique id for first dataset sample 
  #tolower_rm_special comes from butteR package it removes all special symbols and white spaces
  #Paste function in R is used to concatenate Vectors by converting them into character
  sample$uuid <- tolower_rm_special(paste(sample[[s1]],sample[[s2]]))
  
  #selecting first and second columns of sample dataset with uuid
  sample <- sample[,c(s1,s2,"uuid")]
  
  #converting first and second column to lower case by removing special characters 
  sample[[s1]] <- tolower_rm_special(sample[[s1]])
  sample[[s2]] <- tolower_rm_special(sample[[s2]])
  
  # filtering second arguments passed with tool from list_name in order to get its name from name column in tool
  # And selecting first argument that has been passed with tool dataset (list_name == "village") select("name","manteqa")
  tool <- tool[tool$list_name == t2,c("name",t1)]
  
  #converting name column in tool to lower case and removing all special character
  tool[["name"]] <- tolower_rm_special(tool[["name"]])
  
  #converting first argument to lower case and removing all special character
  tool[[t1]] <- tolower_rm_special(tool[[t1]])
  
  #creating a unique id for tool dataset by concatenating first argument and name column 
  tool$uuid <- tolower_rm_special(paste(tool[[t1]],tool[["name"]]))
  
  #checking if uuid of sample dataset doesn't exist in uuid of tool retrive us the first and second argument of sample 
  # here selecting mantequa and Village_Name
  result <- sample[sample$uuid %noin% tool$uuid,c(s1,s2)]
  
}
#calling function and passing the columns we want
result <- sample_tool(sample,"Mantequa", "Village_Name",tool,"manteqa","village")



