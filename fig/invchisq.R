args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,2,2)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

set.seed(12345678)
n = 3  # 自由度
r = 1 / rchisq(1000000, n)
hist(r, freq=FALSE, breaks=c(seq(0,3,0.05),10000), xlim=c(0,3), col=gray(0.9),
     main="", xlab="", ylab="")
curve(x^(-n/2-1) * exp(-1/(2*x)) / (gamma(n/2) * 2^(n/2)), add=TRUE)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
