args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=5, height=2.5)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
pb = function(x) { log(x / (1-x)) }
qb = function(z) { 1 / (1 + exp(-z)) }
## plot(NULL, xlim=c(pb(0.01),pb(0.99)), ylim=c(0,1.05),
##      xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
## t = c(0.01, 0.1, 0.5, 0.9, 0.99)
## axis(1, at=pb(t), label=t)
## for (k in 1:5) {
##     curve(dbeta(qb(x),k+1,11-k)/dbeta(k/10,k+1,11-k), pb(0.01), pb(0.99), add=TRUE)
## }
plot(NULL, xlim=c(pb(0.0001),pb(0.99)), ylim=c(0,0.7),
     xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
t = c(0.0001, 0.001, 0.01, 0.1, 0.5, 0.9, 0.99)
u = c("0.0001", 0.001, 0.01, 0.1, 0.5, 0.9, 0.99)
axis(1, at=pb(t), label=u)
for (k in 1:5) {
    a = integrate(function(x) dbeta(qb(x),k+1,11-k), pb(0.0001), pb(0.99))$value
    curve(dbeta(qb(x),k+1,11-k)/a, pb(0.0001), pb(0.99), add=TRUE)
}
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
