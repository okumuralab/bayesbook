args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(0.5,0.5,0.5,0.5)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
set.seed(12345678)
inc = function(x) { x %% 30 + 1 }
dec = function(x) { (x + 28) %% 30 + 1 }
s = matrix(sample(c(-1,1), 900, replace=TRUE), nrow=30, ncol=30)
kT = 3
for (g in 1:10000) {
  i = sample(1:30, 1)
  j = sample(1:30, 1)
  dE = 2 * s[i,j] * (s[i,dec(j)]+s[i,inc(j)]+s[dec(i),j]+s[inc(i),j])
  if (dE < 0) {
    s[i,j] = -s[i,j]
  } else {
    p = exp(-dE/kT)
    s[i,j] = s[i,j] * sample(c(-1,1), 1, prob=c(p,1-p))
  }
}
plot((0:899)%/%30, (0:899)%%30, cex=1.5, pch=s*7.5+8.5, axes=FALSE, xlab="", ylab="", asp=1)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
