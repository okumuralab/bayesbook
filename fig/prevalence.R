args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=2)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

f = function(x,a,b,m,n) {
    t = x * a + (1-x) * b
    t^m * (1-t)^n
}

f1 = function(x,a,m,n) integrate(function(b) f(x,a,b,m,n), 0, a)$value

vf1 = Vectorize(f1)
f2 = function(x,m,n) integrate(function(a) vf1(x,a,m,n), 0, 1)$value
vf2 = Vectorize(f2)
curve(vf2(x,496,372), 0, 1, n=201, lwd=2, ylim=c(0,1.55e-259),
      xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
axis(1)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
