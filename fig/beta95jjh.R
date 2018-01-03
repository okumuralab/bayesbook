args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

# f = function(x) asin(sqrt(qbeta(x,2.5,8.5)))
# g = function(x) f(x+0.95)-f(x)
# x = optimize(g, c(0,0.05), tol=1e-8)$minimum
# q = qbeta(c(x,x+0.95), 2.5, 8.5)
q = c(0.03927066, 0.48841011)
x = seq(0, 1, 0.005)
pb = function(x) (2/pi)*asin(sqrt(x))
# qb = function(z) (sin(pi*z/2))^2
fy = function(x) dbeta(x, 3, 9)
y = sapply(x, fy)
t = pb(x)
plot(NULL, xlim=c(0,1), ylim=c(0,max(y)+0.1),
     xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
axis(1, at=t[seq(1,201,20)], labels=(0:10)/10)
polygon(pb(c(q[1],q[1],x[9:98],q[2],q[2],q[1])),
        fy(c(0,q[1],x[9:98],q[2],0,0)), col=gray(0.9))
segments(pb(q[1]), fy(q[1]), pb(q[2]), fy(q[2]), lty=2)
segments(pb(0.2), 0, pb(0.2), fy(0.2), lty=2)
polygon(t, y)
# curve(fy(qb(x)), add=TRUE)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
