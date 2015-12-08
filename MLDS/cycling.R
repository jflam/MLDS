# Read data from a .tcx file exported from Strava
install.packages("XML")
library(XML)
library(ggplot2)

doc <- xmlParse("Morning Ride.tcx")
data <- xmlToDataFrame(nodes <- getNodeSet(doc, "//ns:Trackpoint", "ns"))

# Inspect the data
str(data)

# Coerce columns that we care about into numeric
data$HeartRateBpm <- as.numeric(as.character(data$HeartRateBpm))
data$AltitudeMeters <- as.numeric(as.character(data$AltitudeMeters))

# Convert datetime to numeric seconds offset from start of ride
data$Time <- as.numeric(as.POSIXlt(as.character(data$Time), "%Y-%m-%dT%H:%M:%S", tz = "GMT"))
data$Time <- data$Time - data$Time[1]

# Look at histogram of HR
par(mfcol = c(1, 1))
hist(data$HeartRateBpm, main = 'HR histogram', xlab = 'bpm', ylab = 'Time (s)', breaks = 30)

# Look at plot of HR vs. Elevation
par(mfcol = c(2, 1))
plot(data$Time, data$HeartRateBpm, type = 'l', xlab = 'Time (s)', ylab = 'bpm')
plot(data$Time, data$AltitudeMeters, type = 'l', xlab = 'Time (s)', ylab = 'm')