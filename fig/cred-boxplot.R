args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(2,2,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

q = qnorm(0.975)
n = 1e4
f = function() {
  x = sort(rnorm(n))
  h = floor(n/20)  # 四捨五入なら floor((n+10)/20)
  x1 = x[1:(h+1)]
  x2 = x[(n-h):n]
  k = which.min(x2 - x1)
  c(mean(x)+q*sd(x), x[0.975*n], x2[k])
}
r = replicate(1e4, f())
boxplot(t(r), names=c("1.96sd", "central", "hpd"))

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
