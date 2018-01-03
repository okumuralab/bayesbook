args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=2.5)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
b = 3
plot(NULL, xlim=c(0,1), ylim=c(0,dbeta(0,1,b)+0.1),
     xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
axis(1)
q = qbeta(c(0.025,0.975), 1, b)
x = seq(q[1], q[2], length.out=100)
y = sapply(x, function(x) dbeta(x,1,b))
polygon(c(x,x[length(x)],x[1]), c(y,0,0), col=gray(0.9))
curve(dbeta(x,1,b), 0, 1, add=TRUE)
segments(0, 0, 0, dbeta(0,1,b))
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
