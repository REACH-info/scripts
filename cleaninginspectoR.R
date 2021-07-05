

# Loading libraries -------------------------------------------------------

library(dplyr)
library(cleaninginspectoR)




# Test Data ---------------------------------------------------------------

# Here we create some fake data for illustration purposes. It is not important to understand this;
# we keep it in so you can run the example yourself if you like. The dataset contains:
#   
# variable a: random values and outliers
# variable uuid: values should be unique but are not
# variable water.source.other: all NA except for two
# variable GPS.lat just some numbers, but the column header indicates this is potentially sensitive

testdf <- data.frame(a= c(runif(98),7287,-100),
                     b=sample(letters,100,T),
                     uuid=c(1:98, 4,20),
                     water.source.other = c(rep(NA,98),"neighbour's well","neighbour's well"),
                     GPS.lat = runif(100)
)




# Finding duplicates in certain columns -----------------------------------

# There is a generic function to find duplicates in a certain specified column:
find_duplicates(testdf, duplicate.column.name = "uuid")
find_duplicates_uuid(testdf)



# Finding outliers --------------------------------------------------------

find_outliers(testdf)



# Checking for other responses outlier ------------------------------------

find_other_responses(testdf)
