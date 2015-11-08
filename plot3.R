## This program creates plot3.png containing the three submetering types data in an
## x-y plot.  
## First this is a program downloads data from a specificed URL.  This data is in
## a .zip file and is unzipped to the working direcory.  Then the data subset
## from 1/2/2007 to 2/2/2007 is read into a data table.  Column names are added
## and numeric data is converted from character to numeric.  The Date column is 
## converted to Date class.  Date and Time are concatenated and converted to POSIXct.
## The plot is created on the screen and dev.copy is used to save the screen
## as the .png file plot3.png

library(data.table)
library(utils)
library(lubridate)

## Download the data and unzip the file to the working directory
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(URL, "powerData.zip")

unzip("powerData.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = ".", unzip = "internal",
      setTimes = FALSE)

## read the data for the dates 1/2/2007 to 2/2/2007
data <- fread("household_power_consumption.txt", sep = ";", header = TRUE, skip = 66635, nrows = 2882)

## add the column names and convert to columns to character or numeric
colNamesVector <- c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
colnames(data) <- colNamesVector

## convert the Date column to class = Date
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
## concatenate the Date and Time columns into Date_Time and convert to POSIXct class
data[, "Date_Time"] <- ymd_hms(paste(data$Date, data$Time))

## create the X-Y plot of Date-Time versus Global Active Power on the screen device
par(cex = "0.75") ## set the font size to 75% of default
with(data, plot(Date_Time, Sub_metering_1,  type ="l", xlab = "", ylab = "Energy Sub metering"))
with(data, points(Date_Time, Sub_metering_2, type = "l", col = "red"))
with(data, points(Date_Time, Sub_metering_3, type = "l", col = "blue"))

## create a legend 
legend("topright", lty = "solid", col = c("black", "red", "blue"), legend = c("Sub_metering_1      ", "Sub_metering_2", "Sub_metering_3 "))

## copy the screen plot to the png file
dev.copy(png, file = "plot3.png")
dev.off()

