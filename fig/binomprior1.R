args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=3)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(6,1,0,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
# par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

pb = function(x) (2/pi)*asin(sqrt(x))  # pbeta(x,0.5,0.5)
qb = function(z) (sin(pi*z/2))^2       # qbeta(z,0.5,0.5)
plot(NULL, xlim=c(0,1), ylim=c(0,3), xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
t = pb((0:10)/10)
axis(1, at=t, labels=(0:10)/10)
axis(1, line=3, at=(0:10)/10, labels=(0:10)/10)
mtext(expression(italic(z)), 1, 4.5)
polygon(c(0,1,1,0,0), c(0,0,1,1,0), col=gray(0.9))
segments(t, 0, t, 1)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
