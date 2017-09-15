#### load required libraries ####
library(ggplot2)
library(dplyr)

#### load data ####
df <- read.csv("Metadata.csv",nrows=77)

#of na.exclude(df) verwijderd elke rij met een NA 
# rowSums(if.na(df)) == ncol(df)
#na.omit() rijen die NA bevatten, worden weggefilterd maar regressiefunctie weet nog dat je die gefilterd hebt
# blank.lines.skip = TRUE als argument bij read.csv .. werkt soms, hangt er van af (stringsAsFactors...)

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
  mutate(condratio = Conductivity/temp) %>% 
  summarise(sd.d2 = sd(Diversity...D2),
            avelog10.celldens = mean(log10(Cell.density..cells.mL.)),
            mean.condrat = mean(condratio))

df$Reactor.cycle <- as.integer(df$Reactor.cycle)

#### join data sets ####
physicochem <- df %>%  
  select(sample_title,temp,ph,Conductivity)
diversity <- df %>% 
  select(sample_title,contains("Diversity"))

meanph <- df %>%
  filter(Reactor.cycle == 2) %>% 
  group_by(Reactor.phase) %>%
  mutate(condratio=Conductivity/temp) %>% 
  summarise(mean.ph = mean(ph),
            mean.d2 = mean(Diversity...D2),
            sd.ph = sd(ph),
            sd.d2 = sd(Diversity...D2),
            avelog10.celldens = mean(log10(Cell.density..cells.mL.)),
            mean.condrat = mean(condratio))

physicodiversity <- dplyr::full_join(physicochem,diversity,by = "sample_title")
physicodiversity

#### combining dplyr and ggplot2 ####

p1 <- ggplot(data = df, aes(x = Timepoint,y = Cell.density..cells.mL., fill = Cell.density..cells.mL.)) +
  geom_point(shape = 21, size = 4)

df.2 <- df %>% filter(Reactor.cycle==2)

p2 <- df %>% filter(Reactor.cycle==2) %>% 
  ggplot(aes(x = Timepoint,y = Cell.density..cells.mL., fill = Cell.density..cells.mL.)) +geom_point(shape = 21, size = 4)

p2 + scale_y_log10()
  