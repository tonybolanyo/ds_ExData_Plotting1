################################################################################
#
#   Coursera Exploratory Data Analysis Course Project 1 - Plot 4
#   Tony G. Bolaño
#   April 2015
#
#   This assignment uses data from the UC Irvine Machine Learning Repository,
#   a popular repository for machine learning datasets. In particular, we will 
#   be using the "Individual household electric power consumption Data Set" 
#   which is available on the course web site:
#
#   Dataset URL:
#   https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
#
#   Dataset description:
#   Measurements of electric power consumption in one household with a 
#   one-minute sampling rate over a period of almost 4 years. Different 
#   electrical quantities and some sub-metering values are available.
#
#   1. Test if data file exists, if not exists try to download and unzip
#   2. Load data into dataframe
#   3. Subset data to 1/2/2007 and 2/2/2007
#   4. Create a DateTime column from character columns Date and Time
#   5. Create plot in a png file for Global Active Power by date
#      
#
################################################################################

# First we cleanup workspace
# ref. https://support.rstudio.com/hc/en-us/articles/200711843-Working-Directories-and-Workspaces

rm(list = ls())

# Defining file names
file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip_filename <- "exdata-data-household_power_consumption.zip"
data_filename <- "household_power_consumption.txt"

# If data file not exists then try to download and unzip
if (!file.exists(data_filename)) {
  
  tryCatch({
    message("Downloading zip data file...")
    download.file(url = file_url, destfile = zip_filename, method = "curl")
    message("Extracting text data file...")
    unzip(zip_filename)
  }, warning = function(war) {
    stop("Error downloading and extracting file.")
  }, error = function(err) {
    stop("Error downloading and extracting file.")
  })
    
  message("File downloaded and extracted!")
  
} else {
  message("Using previously text data file found on working directory")
}

# read raw data from original text file into a data frame
data <- read.csv(file = data_filename, header = T, sep = ";", na.strings = "?", 
                 colClasses = c(rep("character",2), rep("numeric",7)))

# subset data to 1/2/2007 and 2/2/2007
data <- data[data$Date == "1/2/2007" | data$Date == "2/2/2007",]

# create a DateTime column from character columns Date and Time
data$DateTime <- strptime(paste(data$Date,data$Time), format="%d/%m/%Y %H:%M:%S")

# setting labels and colors
ylabel1 <- "Global Active Power"
ylabel2 <- "Voltage"
ylabel3 <- "Energy sub metering"
ylabel4 <- "Global_reactive_power"
xlabel <- "datetime"
color1 <- "black"
color2 <- "red"
color3 <- "blue"

# open PNG file
png(filename="plot4.png", width = 480, height = 480, units = "px")

# Setting params (2 rows, 2 cols)
par(mfrow = c(2,2))

with(data, {
  # draw plot 1 (row = 1, col = 1)
  plot(DateTime, Global_active_power, type = "l", xlab = "", ylab = ylabel1)
  
  # draw plot 2 (row = 1, col = 2)
  plot(DateTime, Voltage, type = "l", xlab = xlabel, ylab = ylabel2)
  
  # draw plot 3 (row = 2, col = 1)
  plot(data$DateTime, data$Sub_metering_1, type = "l", xlab = "", ylab = ylabel3, col = color1)
  lines(data$DateTime, data$Sub_metering_2, type = "l", col=color2)
  lines(data$DateTime, data$Sub_metering_3, type = "l", col=color3)
  legend("topright", lty="solid", bty = "n",
         legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
         col = c(color1, color2, color3)
         )
  
  # draw plot 4 (row = 2, col = 2)
  plot(DateTime, Global_reactive_power, type = "l", xlab = xlabel, ylab = ylabel4)
})

# close file
dev.off()