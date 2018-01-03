args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=4)
# par(family="HiraKakuProN-W3")
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
plot(NULL, xlim=c(0,10), ylim=c(0,2),
     xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
axis(1, at=0:10, labels=0:10)
x = seq(0, 10, 0.1)
y = pmin(3, sapply(x, function(x) 1/sqrt(x)))
polygon(c(x,x[length(x)],x[1]), c(y,0,0), col=gray(0.9))
segments(1:10, 0, 1:10, 1/sqrt(1:10))
curve(1/sqrt(x), add=TRUE)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
