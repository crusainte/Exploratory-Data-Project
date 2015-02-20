## Plot addresses the following question:
## How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

## Read in the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)

## Filter motor vehicle related sources
SCC.filter<- SCC %>%
    select(SCC,Short.Name) %>%
    filter(grepl("vehicle", SCC$EI.Sector,ignore.case=TRUE))

## Filter Baltimore city from NEI
NEI.Baltimore<-filter(NEI,fips=="24510")

## Merge and filter NEI.Baltimore for motor vehicle related sources
NEI.filter<-merge(NEI.Baltimore,SCC.filter,by.x="SCC",by.y="SCC")

## Perform group by year, then summarize according to motor vehicle related Emissions
NEI.output<- NEI.filter %>% 
    group_by(year) %>% 
    summarize(emit.sum=sum(Emissions))

## Create png image to plot on
png("plot5.png")

## Plot the output using the base plotting system with line width of 3
## and line histogram type
plot(NEI.output$year,NEI.output$emit.sum,lwd=3,type="h",
     xlab="Year",
     ylab="PM2.5 Emissions (Tons)",
     main="PM2.5 Emissions from Motor Vehicle Sources in Baltimore City"
)

## Add a line plot across the existing plot to better reveal the 
## relationship between each year
lines(NEI.output$year,NEI.output$emit.sum)

## Output plot to png file
dev.off()

## Perform clean up
rm(NEI.output)
rm(NEI.filter)
rm(NEI.Baltimore)
rm(SCC.filter)