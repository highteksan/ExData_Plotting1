## This program creates plot4.png containing four plots in 2x2 layout
## First this is a program downloads data from a specificed URL.  This data is in
## a .zip file and is unzipped to the working direcory.  Then the data subset
## from 1/2/2007 to 2/2/2007 is read into a data table.  Column names are added
## and numeric data is converted from character to numeric.  The Date column is 
## converted to Date class.  Date and Time are concatenated and converted to POSIXct.
## The plots are created on the screen and dev.copy is used to save the screen
## as the .png file plot4.png

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

## Create the plots

## set global parameters
par(mfrow = c(2, 2)) ## set up the plot device for 2 rows and 2 columns of plots
par(cex = "0.5") ## set the font size to 5% of default

## add the first plot - Global active power versus time
plot(data$Date_Time, data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
## create the X-Y plot of Date-Time versus Global Active Power on the screen device

## add the second plot - Voltage versus time
plot(data$Date_Time, data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

## add the third plot - Energy sub metering type versus time
with(data, plot(Date_Time, Sub_metering_1,  type ="l", xlab = "", ylab = "Energy Sub metering"))
with(data, points(Date_Time, Sub_metering_2, type = "l", col = "red"))
with(data, points(Date_Time, Sub_metering_3, type = "l", col = "blue"))
## create a legend, but this time with no boarder line
legend("topright", bty = "n", lty = "solid", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3 "))

## add the fourth plot - Global reactive power versus time
plot(data$Date_Time, data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")


## copy the screen plot to the png file
dev.copy(png, file = "plot4.png")
dev.off()

