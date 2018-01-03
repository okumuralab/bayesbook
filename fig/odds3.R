args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=4)
# par(family="Latin Modern Mono 10 Regular")
# par(family="HiraKakuProN-W3")
par(family="Palatino")
par(mgp=c(1.7,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,2,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

set.seed(12345678) # 乱数の初期化
a = 12; b = 6; c = 5; d = 12
x1 = rbeta(1e7, a+0.5, b+0.5)
x2 = rbeta(1e7, c+0.5, d+0.5)
z1 = asin(sqrt(x1))
z2 = asin(sqrt(x2))
z = z1 - z2
hist(z, breaks=100, freq=FALSE, col=gray(0.9),
     main="", xlab=expression("difference of arcsin" * sqrt(italic(x))), ylab="")
curve(dnorm(x, mean(z), sd(z)), add=TRUE)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
