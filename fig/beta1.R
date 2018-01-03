args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=5, height=2.5)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
# par(mar=c(3,3,2,2)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
plot(NULL, xlim=c(0,1), ylim=c(0,0.2^2*0.8^8*1.02),
     xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
axis(1)
x = seq(0.5,1,0.01)
y = sapply(x, function(x)x^2*(1-x)^8)
polygon(c(x,x[length(x)],x[1]), c(y,0,0), col=gray(0.9))
segments(0.2, 0, 0.2, 0.2^2*(1-0.2)^8, lty=2)
curve(x^2*(1-x)^8, 0, 1, add=TRUE)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
