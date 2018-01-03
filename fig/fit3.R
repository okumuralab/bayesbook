args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=3)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(2,2,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

poissonci = function(y) {
    if (y == 0) {
        qgamma(c(0,0.95), 0.5)
    } else {
        qgamma(c(0.025,0.975), y+0.5)
    }
}

ydata = c(11,4,13,10,4,8,6,16,7,12,10,13,6,5,1,4,2,0,0,1)
ci = sapply(1:20, function(i) poissonci(ydata[i]))
plot(1:20, ydata, type="p", pch=16, xlab="", ylab="", ylim=range(ci))
arrows(1:20, ci[1,], 1:20, ci[2,], length=0.03, angle=90, code=3)
a = 7.376486
b = 8.372888
f = function(x) a * exp(-(x-10)^2/(2*3^2)) + b * exp(-x/10)
curve(f, add=TRUE)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
