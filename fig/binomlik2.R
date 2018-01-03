args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=2.5)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

pb = function(x) (2/pi)*asin(sqrt(x))  # pbeta(x,0.5,0.5)
qb = function(z) (sin(pi*z/2))^2       # qbeta(z,0.5,0.5)
## plot(NULL, xlim=c(0,1), ylim=c(0,1.05),
##      xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
plot(NULL, xlim=c(0,1), ylim=c(0,4.5),
     xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
axis(1, at=pb((0:5)/5), labels=(0:5)/5)
## for (k in 1:5) {
##     curve(dbeta(qb(x),k+1,11-k)/dbeta(k/10,k+1,11-k), 0, 1, add=TRUE)
## }
for (k in 1:5) {
    a = integrate(function(x) dbeta(qb(x),k+1,11-k), 0, 1)$value
    curve(dbeta(qb(x),k+1,11-k)/a, 0, 1, add=TRUE)
}

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
