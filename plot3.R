## Plot addresses the following question:
## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
## which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
## Which have seen increases in emissions from 1999–2008? 
## Use the ggplot2 plotting system to make a plot answer this question.

## Read in the files
NEI <- readRDS("summarySCC_PM25.rds")
## SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)
library(ggplot2)

## Perform filter on fips 24510, group by emission type then year, 
## then summarize according to Emissions
NEI.output<- NEI %>% 
    filter(fips=="24510") %>%
    group_by(type,year) %>% 
    summarize(emit.sum=sum(Emissions))

## Create png image to plot on
png("plot3.png")

## Plot with ggplot with x-axis as year, y-axis as summation of 
## emission based on emission type then color code the points
## according to emission type.
## Next, smoothing line is created between each points across
## each year to make the plot easier to read.
plot3<-ggplot(NEI.output,aes(x=year,y=emit.sum,color=type)) +
    geom_point() + 
    geom_smooth(method="loess") + 
    xlab("Year") +
    ylab("PM2.5 Emissions (Tons)") +
    labs(color="Emission Type") +
    ggtitle("Total Emissions by Type in Baltimore City"
    )

## Print plot to png file
print(plot3)

## Close png file
dev.off()

## Perform clean up
rm(NEI.output)
rm(plot3)