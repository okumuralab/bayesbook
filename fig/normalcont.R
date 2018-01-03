args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

y = 1:10
n = length(y)
ybar = mean(y)
s2 = var(y)
f = function(x1, x2) {
  exp(-n*x2/2) * exp(-((n-1)*s2+n*(ybar-x1)^2) / (2*exp(x2)))
}
x1 = seq(3, 8, length.out=101)
x2 = seq(1, 3.5, length.out=101)
contour(x1, x2, outer(x1,x2,Vectorize(f)),
        xlab=expression(italic(x)[1]), ylab=expression(italic(x)[2]))

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
