##### download and unzip data file if it doesn't exist
# check whether the unzipped data file exist
if(!file.exists("household_power_consumption.txt")) {
  # check whether the zipped data file exist
  if(!file.exists("household_power_consumption.zip")) {
    # if not, download data file from web
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip"
    download.file(fileUrl, destfile = "./household_power_consumption.zip", method = "curl")
  }
  # unzip the downloaded file
  unzip("household_power_consumption.zip")
}


##### read in data as data frame
#  Ref1: http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html
library(dplyr) 
myAllData <- tbl_df(read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?"))

# filter data for 2007-02-01 and 2007-02-02 only
myData <- filter(myAllData, Date == "1/2/2007" | Date == "2/2/2007")

# convert Date, Time to strptime class
dt <- strptime(paste(myData$Date, myData$Time), "%d/%m/%Y %H:%M:%S")
xr <- as.POSIXct(round(range(dt), "days"))


##### plot the Sub_meterings vs time
png("plot3.png") # PNG graph device - default 480x480 pxs

# plot Sub_metering_1 vs time without X axis
plot(dt, myData$Sub_metering_1, xaxt="n", type="l",
     xlab="", ylab="Energy sub metering")
# add line plot Sub_metering_2 vs time
lines(dt, myData$Sub_metering_2, col="red")
# add line plot Sub_metering_3 vs time
lines(dt, myData$Sub_metering_3, col="blue")
# add X axis by day
axis.POSIXct(1, at=seq(xr[1], xr[2], by="day"), format="%a")
# add legend
legend('topright', c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), 
       lty=c(1,1,1),
       lwd=c(2,2,2),col=c("black","red","blue"))

# close graphing device
dev.off()
