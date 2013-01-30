autos_data <- read.csv(file="webcontest.csv", header=TRUE, sep=",")
max_y <- 30 # max(autos_data)

plot_colors <- c("blue","red","forestgreen","black","orange","green","darkblue","darkgreen")

png(filename="connections.png", height=600, width=600, bg="white")

plot(autos_data$nginx,    type="o", col=plot_colors[1], ylim=c(0,30000), axes=F, ann=F)
plot(autos_data$cowboy,   type="o", col=plot_colors[2], ylim=c(0,30000), axes=F, ann=F)
plot(autos_data$warp,     type="o", col=plot_colors[3], ylim=c(0,30000), axes=F, ann=F)
plot(autos_data$ocsigen,  type="o", col=plot_colors[4], ylim=c(0,30000), axes=F, ann=F)
plot(autos_data$nodejs,   type="o", col=plot_colors[5], ylim=c(0,30000), axes=F, ann=F)
plot(autos_data$vibe,     type="o", col=plot_colors[6], ylim=c(0,30000), axes=F, ann=F)
plot(autos_data$gohttp,   type="o", col=plot_colors[7], ylim=c(0,30000), axes=F, ann=F)
plot(autos_data$httpkit, type="o", col=plot_colors[8], ylim=c(0,30000), axes=F, ann=F)

title(main="Cowboy/Warp/Ocsigen/NodeJS/Vibe/GoHttp/Http-Kit", col.main="red", font.main=1)
title(xlab= "Socket Connections", col.lab=rgb(0,0.5,0))
title(ylab= "Requests/Sec", col.lab=rgb(0,0.5,0))

axis(1, at=1:30, lab=c("1K",  "2K",  "3K",  "4K",  "5K",  "6K",  "7K",  "8K",  "9K",  "1K0",
                       "11K", "12K", "13K", "14K", "15K", "16K", "17K", "18K", "19K", "2K0",
                       "21K", "22K", "23K", "24K", "25K", "26K", "27K", "28K", "29K", "3K0"))

axis(2, las=1, cex.axis=1000)

lines(autos_data$nginx,    type="o", pch=21, lty=1, col=plot_colors[1])
lines(autos_data$cowboy,   type="o", pch=25, lty=6, col=plot_colors[2])
lines(autos_data$warp,     type="o", pch=22, lty=3, col=plot_colors[3])
lines(autos_data$ocsigen,  type="o", pch=23, lty=4, col=plot_colors[4])
lines(autos_data$nodejs,   type="o", pch=24, lty=5, col=plot_colors[5])
lines(autos_data$vibe,     type="o", pch=21, lty=6, col=plot_colors[6])
lines(autos_data$gohttp,   type="o", pch=21, lty=7, col=plot_colors[7])
lines(autos_data$httpkit, type="o", pch=22, lty=8, col=plot_colors[8])

legend("topleft", c("ngnix","cowboy","warp","ocsigen","nodejs","vibe","gohttp","http-kit"), cex=1, col=plot_colors, pch=20:25, lty=1:7);

dev.off()
