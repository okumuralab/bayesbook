args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=6, height=3)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(2,2,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

popularvote = read.csv("popularvote.csv", as.is=TRUE)
p = popularvote[popularvote[,2] %in% 1900:2012, 7] / 100
hist(p, breaks=(0:100)/100, col=gray(0.9), las=1, xlab="",
     ylab="", main="", right=FALSE)
curve(dbeta(x,35,35)*length(p)/100, add=TRUE)
# title(xlab="アメリカ大統領当選得票率", family="HiraKakuProN-W3")

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
