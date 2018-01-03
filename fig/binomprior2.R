args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=3)
# par(family="HiraKakuProN-W3")
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
# par(mar=c(6,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

plot(NULL, xlim=c(0,1), ylim=c(0,3), xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
t = (0:10)/10
axis(1, at=t, labels=t)
mtext(expression(italic(z)), 1, 4.5)
x = seq(0, 1, 0.01)
y = pmin(3, sapply(x, function(x) dbeta(x,0.5,0.5)))
polygon(c(x,x[length(x)],x[1]), c(y,0,0), col=gray(0.9))
segments(t, 0, t, c(3, dbeta((1:9)/10,0.5,0.5), 3))
curve(dbeta(x, 0.5, 0.5), add=TRUE)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
