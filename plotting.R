df <- read.csv("Metadata.csv",nrows=77)
#met ,nrows=77 , geen lege rijen meer
# which variables?
str(df)

# Start plotting
library("ggplot2")

# Make first plot
ggplot(data = df, aes(x = Timepoint, y = temp, fill = Reactor.cycle))+
 geom_point(shape = 21, size = 4)

#R denkt default dat het een continue variabele is, als je het als factor zet, ziet 
#R het als discreet, d
df$Reactor.cycle <- factor(df$Reactor.cycle)

#je krijgt een warning over missing values door lege rijen

#als je NA wil verwijderen in legende: ofwel lege rijen verwijderen ofwel in legende iets doen

# Store ggplot object

p1 <- ggplot(data = df, aes(x = Timepoint, y = temp, fill = Reactor.phase))
p2 <- p1 + geom_point(shape = 21, size = 4, alpha = 0.5)
p2 <-p2 + theme_bw()+
#je kan de variabele overschrijven of theme_bw() toevoegen aan vorige lijn
 geom_line()
 
#Lets facet this
p3 <- p2 + facet_grid(~Reactor.cycle)
p3
#je moet de plot ook callen en niet enkel toeschrijven aan variabele

#How do I know what's inside reactor phase
df$Reactor.phase
# met unique() zie je enkel de verschillende levels

p4 <- p3 + facet_grid(Reactor.phase~Reactor.cycle)
p4
#om de kleur aan te passen, ofwel bovenaan in ggplot veranderen bij fill, alles selecteren tot p4 en runnen
#ofwel:
#de aes in global options in originele ggplot, gelden voor alle plots daarna die erop gebaseerd zijn
p4 + geom_line(aes(color = Reactor.phase))

#Challenge time
### Right side: Conductivity


