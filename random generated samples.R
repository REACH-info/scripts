library(xlsformfill)
library(tidyverse)
library(lubridate)
library(readxl)
library(openxlsx)

# We can load multiple package at once as well as below
packages <- c("xlsformfill", "tidyverse","lubridate", "readxl","openxlsx")
sapply(packages,library,character.only = T, logical.return = T)

# Reading survey sheet (questions) of the tool which is sheet one 
questions <- read_excel("./AGORA_Endline_2021_KI_V02.xlsx",sheet = 1)

# Reading choices of the tool which is sheet 2 
choices <- read_excel("./AGORA_Endline_2021_KI_V02.xlsx",sheet = 2)

# using xlsform_fill function to generate random data for our tool we pass questions and choices sheet with number random data to be generated in this case we want 50 interview
KI_random_generated_data <- xlsform_fill(questions,choices,50)

# Writing random generated data in xlsx format
write.xlsx(KI_random_generated_data,paste0("KI_Random_generated_data_",today(),".xlsx"))
