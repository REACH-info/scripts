library(xlsformfill)
library(tidyverse)
library(lubridate)
library(readxl)
library(openxlsx)

#loading multiple packages
packages <- c("xlsformfill", "tidyverse","lubridate", "readxl","openxlsx")
sapply(packages,library,character.only = T, logical.return = T)

questions <- read_excel("./AGORA_Endline_2021_KI_V02.xlsx",sheet = 1)
choices <- read_excel("./AGORA_Endline_2021_KI_V02.xlsx",sheet = 2)

KI_random_generated_data <- xlsform_fill(questions,choices,50)

write.xlsx(KI_random_generated_data,paste0("KI_Random_generated_data_",today(),".xlsx"))
