## necessary packages
library(dplyr)
library(lubridate)

## read subsetted data into data1, with Columnnames from file
## start reading data after the row depicted with "31/1/2007;23:59:00"
## read 2880 rows (==> "Measurements of electric power consumption in one household with a one-minute sampling rate"
##                  ==> 2days * 24hours * 60minutes == 2880 measurements)
data1 <- read.table("household_power_consumption.txt", sep = ";", col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3") ,na.strings = "?", colClasses = c("character", "character", rep("numeric", 7)), skip = grep("31/1/2007;23:59:00", readLines("household_power_consumption.txt")),nrows=2880)

## formate Date column
data1$Date <- dmy(data1$Date)

## set a new column for Date/Time
data1 <- mutate(data1, datetime = paste(data1$Date, data1$Time, sep = " "))
## formate Date/Time column
data1$datetime <- ymd_hms(data1$datetime)

## Open png device; create 'plot3.png' in my working directory
png(filename = "plot3.png")

## create third plot
## Timezone and Language from Germany, 
## therefor:  Thursday = "Donnerstag" = "Do"
##            Friday = "Freitag" = "FR"
##            Saturday = "Sonnabend" = "Sa"

## First empty plot
with(data1, plot(data1$datetime, data1$Sub_metering_1, type = "n", main = NULL, xlab = "", ylab = "Energy sub metering"))
## Bring in Sub_metering_1
lines(data1$datetime, data1$Sub_metering_1, col="black")
## Bring in Sub_metering_2
lines(data1$datetime, data1$Sub_metering_2, col="red")
## Bring in Sub_metering_3
lines(data1$datetime, data1$Sub_metering_3, col="blue")
## Bring in legend
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1,1,1), lwd = c(2.5, 2.5, 2.5), col = c("black", "red", "blue"))

## Close the png file device
dev.off()