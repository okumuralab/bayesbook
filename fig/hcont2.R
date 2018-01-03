args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

ydata = c(11, 12, 14)
s2data = c(1, 1, 4)
f = function(m,t2,y,s2) { -((y-m)^2/(2*(t2+s2)) + log(t2+s2))/2 }
loglik = function(m,t2) { sum(f(m, t2, ydata, s2data)) }
x1 = seq(10, 14, length.out=101)
x2 = seq(0, 5, length.out=101)
contour(x1, x2, outer(x1, x2, Vectorize(loglik)), nlevels=20,
        xlab=expression(italic(mu)), ylab=expression(italic(tau)^2))
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
