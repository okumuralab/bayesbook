args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=4)
par(family="Palatino")
par(mgp=c(2,0.8,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
plot(NULL, xlim=c(2,12), ylim=c(0,0.54), xlab=expression(italic(mu)), ylab="", yaxs="i", axes=FALSE)
axis(1)
y1 = 1:10
y2 = 6:10
ybar1 = mean(y1); se1 = sqrt(var(y1)/10)
ybar2 = mean(y2); se2 = sqrt(var(y2)/5)
dt1 = function(mu) dt((mu-ybar1) / se1, 9) / se1
dt2 = function(mu) dt((mu-ybar2) / se2, 4) / se2
p = function(mu) dt1(mu) * dt2(mu)
area = integrate(p, -Inf, Inf)$value
dt12 = function(mu) p(mu) / area
curve(dt1, lty=2, lwd=2, add=TRUE)
curve(dt2, lty=2, lwd=2, add=TRUE)
curve(dt12, lwd=2, add=TRUE)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
