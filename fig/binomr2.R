args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,2,2)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
x = rbeta(10000000, 2.5, 8.5)
z = (2/pi) * asin(sqrt(x))
hist(z, breaks=seq(0,1,0.01), freq=FALSE, main="", xlab=expression(italic(x)),
     col=gray(0.9), axes=FALSE)
t = (2/pi) * asin(sqrt((0:10)/10))
axis(1, at=t, labels=(0:10)/10)
axis(2)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
