args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(2,2,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

pkg = "modeest"
if (!require(pkg, character.only=TRUE)) {
    install.packages(pkg)
    library(pkg, character.only=TRUE)
}

set.seed(12345678)
f = function() {
    x = rnorm(1e4)
    d = density(x)
    c(mean(x), median(x), mlv(x, method="hsm")$M, d$x[which.max(d$y)])
}
r = replicate(1e4, f())
boxplot(t(r), names=c("mean", "median", "hsm", "density"))

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
