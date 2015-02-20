## Plot addresses the following question:
## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
## Using the base plotting system, make a plot showing the total PM2.5 emission from 
## all sources for each of the years 1999, 2002, 2005, and 2008.

## Read in the files
NEI <- readRDS("summarySCC_PM25.rds")
## SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)

## Perform group by year, then summarize according to Emissions
## Lastly, divide the results by 10^6 to so that the plot would be easier to read
NEI.output<- NEI %>% 
    group_by(year) %>% 
    summarize(emit.sum=sum(Emissions)) %>% 
    mutate(emit.sum=emit.sum/10^6
    )
NEI.output<- NEI %>% 
    group_by(year) %>% 
    summarize(emit.sum=sum(Emissions)) %>% 
    mutate(emit.sum=emit.sum/10^6
    )

## Create png image to plot on
png("plot1.png")

## Plot the output using the base plotting system with line width of 3
## and line histogram type
plot(NEI.output$year,NEI.output$emit.sum,lwd=3,type="h",
     xlab="Year",
     ylab="PM2.5 Emissions (Megatons)",
     main="Total PM2.5 emissions from all US sources"
     )

## Add a line plot across the existing plot to better reveal the relationship
## between each year
lines(NEI.output$year,NEI.output$emit.sum)

## Output plot to png file
dev.off()

## Perform clean up
rm(NEI.output)