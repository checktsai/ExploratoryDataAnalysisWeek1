currdir <- "./data"
if (!dir.exists("./data"))
  dir.create("./data")
if (!dir.exists("./figure"))
  dir.create("./figure")
setwd(currdir)

# get dataset from web
#Download data zip file
zipFileName <- "household_power_consumption.zip"
fileName <- "household_power_consumption.txt"

# No download is need if fileName exists
if (!file.exists(fileName)) {
  fileURL <-
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, zipFileName, method = "curl")
  print (paste (zipFileName," is downloaded"))
} else{
  print(paste(zipFileName ," exists.  NO need to download"))
}

# unzip
if (file.exists(zipFileName)) {
  if (!file.exists(fileName)) {
    print(paste("Unzip ",fileName))
    unzip(zipFileName)
  } else {
    print(fileName)
  }
} else {
  stop ("Please download data set first")
}

fullData <- read.csv(file = fileName, na.strings = "?", sep=";", header=TRUE)
# select data bewteen specified period
selectedData <<- subset(fullData, Date %in% c("1/2/2007","2/2/2007"))

selectedData$Date <- as.Date(selectedData$Date, format="%d/%m/%Y")
datetime <- paste(as.Date(selectedData$Date), selectedData$Time)
selectedData$datetime <- as.POSIXct(datetime)

# file device
png("../figure/plot3.png", width=480, height=480)
## Plot 3
with(selectedData, {
  plot(Sub_metering_1~datetime, type="l",
       ylab="Energy sub metering", xlab="")
  lines(Sub_metering_2~datetime,col='Red')
  lines(Sub_metering_3~datetime,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()
setwd("../")