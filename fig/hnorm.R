args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=5, height=3)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

ydata = c(11, 13, 16)
s2data = c(1, 1, 4)
f = function(t2,m) {
    sqrt(sum(1/(t2+s2data)^2)) *
    prod((1/sqrt(t2+s2data))) *
    exp(-sum((ydata-m)^2/(t2+s2data))/2)
}
vf = Vectorize(f)
g = function(m) integrate(vf, 0, Inf, m)$value
vg = Vectorize(g)
gmax = optimize(vg, c(5,20), maximum=TRUE)$objective
curve(vg, xlim=c(5,20), ylim=c(0,gmax*1.01), lwd=2,
      xlab=expression(italic(mu)), ylab="", yaxs="i", axes=FALSE)
axis(1)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
