#### load required libraries ####
library(ggplot2)
library(dplyr)

#### load data ####
df <- read.csv("Metadata.csv",nrows=77)

# the function of the last loaded library is used: eg. function filter from dplyr is used
# and not from stats
# if you want to use the original functions: two times :: ,eg. stats::filter

mean(df[df$Reactor.phase == "Control", "ph"])
#calc mean on dataframe df, subset : df[rows,columns] ,select all rows from column ph
# where reactor.phase is control

levels(df$Reactor.phase)

#### select ####
physicochem <- select(df,ph,temp,Conductivity)

# piping symbol short cut: ctrl shift m, now you can use type completion
physicochem <- df %>% select(ph,temp,Conductivity)

physicochem.control <- df %>% 
  filter(Reactor.phase == "Control") %>% 
  select(ph,temp,Conductivity)
physicochem.control

#challenge: select only the diversity parameter for reactor phase startup
diversity <- df %>%  
  filter(Reactor.phase == "Startup") %>% 
  select(Diversity...D0,Diversity...D1,Diversity...D2)

#korter:

diversity2 <- df %>%
  filter(Reactor.phase == "Startup") %>% 
  select(contains("Diversity"))

#### grouping by ####
meanph <- df %>% 
  group_by(Reactor.phase) %>% 
  summarise(mean.ph = mean(ph),
            mean.d2 = mean(Diversity...D2),
            sd.ph = sd(ph))
#challenge
#generate a summary for reactor cycle 2 and add standard deviation and 
#log10 transformed cell count
df$Reactor.cycle <- as.factor(df$Reactor.cycle)
d2 <- df %>% 
  filter(Reactor.cycle == "2") %>% 
  summarise(sd.d2 = sd(Diversity...D2),
            avelog10.celldens = mean(log10(Cell.density..cells.mL.)))