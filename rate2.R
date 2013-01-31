# you need a couple of packages for this script; use
# install.packages("ggplot2")
# install.packages("reshape")

library(reshape)
library(ggplot2)

pre.data <- read.csv(file="webcontest.csv", header=TRUE, sep=",")
data <- melt(cbind(rate=0:30, rbind(0, pre.data)),
             id="rate", variable_name="server")
data$value <- data$value / 1000
png(filename="connections2.png", height=600, width=600, res=85, bg="white")
p <- qplot(rate, value, data=data, color=server, geom=c("line", "point"),
           main="Cowboy/Warp/Ocsigen/NodeJS/Vibe/GoHttp/Http-Kit",
           xlab="socket connections (K)",
           ylab="requests/sec (K)")
print(p)
dev.off()
