# get PITCHf/x data using the pitchRx package
# see http://cpsievert.github.io/pitchRx/
install.packages("pitchRx")
install.packages("dplyr")

library(dplyr)
library(pitchRx)

# Load data from over HTTP, by scraping HTML using the pitchRX library
dat <- pitchRx::scrape(start = "2015-05-21", end = "2015-05-21")

# Massage the data using dplyr
locations <- dplyr::select(dat$pitch, pitch_type, start_speed, px, pz, des, num, gameday_link)
View(locations)

names <- dplyr::select(dat$atbat, pitcher, batter, pitcher_name, batter_name, num, gameday_link, event, stand)
View(names)

# Now filter for pitches by Jacob DeGrom  
data <- names %>% filter(pitcher_name == "Jacob DeGrom") %>% inner_join(locations, ., by = c("num", "gameday_link"))
View(data)

# subset the data, keeping all rows but only columns number 1 through 5 and 13
deGrom <- data[, c(1:5, 13)]
View(deGrom)

# filter for swinging strikes
deGrom_swing <- filter(deGrom, grepl("Swinging", des))
View(deGrom_swing)

# plot the pitches, coloring them by velocity
p <- ggplot(deGrom_swing, aes(px, pz, color = start_speed))

# add in customized axis and legend formatting and labels
p <- p + scale_x_continuous(limits = c(-3, 3)) + scale_y_continuous(limits = c(0, 5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = "Jacob deGrom: Swinging Strikes, 5/21/2015") + ylab("Horizontal Location (ft.)") + xlab("Vertical Location (ft): Catcher's View") + labs(color = "Velocity (mph)")

# format the points
p <- p + geom_point(size = 10, alpha = .65)

# finish formatting
p <- p + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 30, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))

# view the plot
p