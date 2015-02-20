## Plot addresses the following question:
## Compare emissions from motor vehicle sources in Baltimore City with emissions from 
## motor vehicle sources in Los Angeles County, California (fips == "06037"). 
## Which city has seen greater changes over time in motor vehicle emissions?

## Read in the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)
library(ggplot2)

## Filter motor vehicle related sources
SCC.filter<- SCC %>%
    select(SCC,Short.Name) %>%
    filter(grepl("vehicle", SCC$EI.Sector,ignore.case=TRUE))

## Filter Baltimore and California city from NEI
NEI.Cities<-filter(NEI,fips=="24510"|fips=="06037")

## Merge and filter NEI.BA for motor vehicle related sources
NEI.filter<-merge(NEI.Cities,SCC.filter,by.x="SCC",by.y="SCC")

NEI.output<- NEI.filter %>% 
    group_by(fips,year) %>% 
    summarize(emit.sum=sum(Emissions)) %>% 
    mutate(city=ifelse(fips=="06037","California","Baltimore"))

## Create png image to plot on
png("plot6.png")

## Plot with ggplot with x-axis as year, y-axis as summation of 
## emission based on motor vehicle emission sources 
## then color code the points according to city.
## Next, a regression line is created between each points across
## each year to reveal the trend for Baltimore and California.
## Lastly, the legend is turned off to make the chart bigger.
plot6<-ggplot(NEI.output,aes(x=year,y=emit.sum,color=city)) +
    facet_grid(city ~ .,scales="free") +
    geom_point() + 
    geom_smooth(method="lm",se=FALSE) +
    theme(legend.position="none") +
    xlab("Year") +
    ylab("PM2.5 Emissions (Tons)") +
    labs(color="City") +
    ggtitle("Emissions from Motor Vehicle Sources in Baltimore & California"
    )

## Print plot to png file
print(plot6)

## Close png file
dev.off()

## Perform clean up
rm(NEI.output)
rm(NEI.filter)
rm(NEI.Cities)
rm(SCC.filter)
rm(plot6)