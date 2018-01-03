args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=3)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(6,1,0,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

pb = function(x) (2/pi)*asin(sqrt(x))  # pbeta(x,0.5,0.5)
qb = function(z) (sin(pi*z/2))^2       # qbeta(z,0.5,0.5)
plot(NULL, xlim=c(-1.2,1.2), ylim=c(0,1), xlab="", ylab="", yaxs="i", axes=FALSE)
axis(1, at=(-5:5)/10, labels=(0:10)/10)  # c("0","","0.2","","0.4","","0.6","","0.8","","1"))
t = (pb((0:10)/10) - 0.5) * pi / 2
axis(1, line=2, at=t, labels=(0:10)/10)
x = c(0.01, (1:9)/10, 0.99)
t = log(x / (1-x)) / 4
axis(1, line=4, at=t, labels=x)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
