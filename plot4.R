## Plot addresses the following question:
## Across the United States, how have emissions from coal 
## combustion-related sources changed from 1999–2008?

## Read in the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)

## Filter coal related sources
SCC.filter<- SCC %>%
    select(SCC,Short.Name) %>%
    filter(grepl("coal", SCC$EI.Sector,ignore.case=TRUE))

## Merge and filter NEI for coal related sources
NEI.filter<-merge(NEI,SCC.filter,by.x="SCC",by.y="SCC")

## Perform group by year, then summarize according to coal related Emissions
## Lastly, divide the results by 10^3 to so that the plot would be easier to read
NEI.output<- NEI.filter %>% 
    group_by(year) %>% 
    summarize(emit.sum=sum(Emissions)) %>% 
    mutate(emit.sum=emit.sum/10^3)

## Create png image to plot on
png("plot4.png")

## Plot the output using the base plotting system with line width of 3
## and line histogram type
plot(NEI.output$year,NEI.output$emit.sum,lwd=3,type="h",
     xlab="Year",
     ylab="PM2.5 Emissions (Kilotons)",
     main="PM2.5 Emissions from Coal-Combustion Sources Across US"
)

## Add a line plot across the existing plot to better reveal the 
## relationship between each year
lines(NEI.output$year,NEI.output$emit.sum)

## Output plot to png file
dev.off()

## Perform clean up
rm(NEI.output)
rm(NEI.filter)
rm(SCC.filter)