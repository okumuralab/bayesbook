args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=2.5)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
plot(NULL, xlim=c(0,10), ylim=c(0,0.02),
     xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
axis(1)
q = qgamma(pgamma(3, 0.5, lower.tail=FALSE) * 0.05, 0.5, lower.tail=FALSE)
x = seq(3, q, length.out=20)
y = sapply(x, function(x) dgamma(x,0.5))
polygon(c(x,x[length(x)],x[1]), c(y,0,0), col=gray(0.9))
curve(dgamma(x,0.5), add=TRUE)
# segments(0, 0, 0, 0.5)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
