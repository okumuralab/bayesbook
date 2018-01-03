args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,2,2)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

set.seed(12345678)
y = 1:10
n = length(y)
ybar = mean(y)
s2 = var(y)
x1 = 5.5
x2 = log(((n-1)*s2+n*(ybar-x1)^2) / rchisq(1000000,n))
hist(x2, freq=FALSE, breaks=50,
     xlim=c(0,5), col=gray(0.9), main="", xlab=expression(italic(x)[2]), ylab="")

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
