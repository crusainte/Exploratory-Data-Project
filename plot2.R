## Plot addresses the following question:
## Have total emissions from PM2.5 decreased in the Baltimore City, 
## Maryland (fips == "24510") from 1999 to 2008? 
## Use the base plotting system to make a plot answering this question

## Read in the files
NEI <- readRDS("summarySCC_PM25.rds")
## SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)

## Perform filter on fips 24510, group by year, then summarize according to Emissions
## Lastly, divide the results by 10^3 to so that the plot would be easier to read
NEI.output<- NEI %>% 
    filter(fips=="24510") %>%
    group_by(year) %>% 
    summarize(emit.sum=sum(Emissions)) %>% 
    mutate(emit.sum=emit.sum/10^3
    )

## Create png image to plot on
png("plot2.png")

## Plot the output using the base plotting system with line width of 3
## and line histogram type
plot(NEI.output$year,NEI.output$emit.sum,lwd=3,type="h",
     xlab="Year",
     ylab="PM2.5 Emissions (Kilotons)",
     main="Total PM2.5 emissions from Baltimore City, Maryland"
)

## Add a line plot across the existing plot to better reveal the relationship
## between each year
lines(NEI.output$year,NEI.output$emit.sum)

## Output plot to png file
dev.off()

## Perform clean up
rm(NEI.output)