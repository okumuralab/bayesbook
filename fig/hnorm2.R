args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=5, height=3)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

ydata = c(11, 13, 16)
s2data = c(1, 1, 4)
t2lik = function(t2) {
    t2s2 = t2 + s2data
    m = sum(ydata/t2s2) / sum(1/t2s2)
#   sqrt(sum(1/t2s2^2)) *
    prod(1/sqrt(2*pi*t2s2)) *
    sqrt(2*pi*(1/sum(1/t2s2))) *
    exp(-sum((ydata-m)^2/t2s2)/2)
}
vt2lik = Vectorize(t2lik)
f = function(t2) sqrt(sum(1/(t2+s2data)^2))
zt2 = function(t2) integrate(Vectorize(f), 0, t2)$value
t2seq = c(0, sapply(seq(0.1,10,0.1),
                    function(z) uniroot(function(t2) zt2(t2) - z, c(0,500))$root))
y = vt2lik(t2seq)
ymax = max(y)
plot(seq(0,10,0.1), y, type="l", lwd=2, ylim=c(0,ymax*1.01),
     xlab=expression(italic(tau)^2), ylab="", yaxs="i", axes=FALSE)
t = c(0,10,20,50,100,200,500)
axis(1, sapply(t,zt2), t)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
