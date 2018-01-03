args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=8, height=3)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,2,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

par(mfrow=c(1,2))

set.seed(12345678)
N = 50
a = numeric(N)          # 値を保存するための配列
x = 0                   # 初期値
p = 1 / (1 + x^2)       # 確率
b = rep(NA, N)
for (i in 1:N) {
  y = rnorm(1, x, 1)    # 候補（選び方は対称なら何でもよい）
  q = 1 / (1 + y^2)     # 確率
  if (runif(1) < q/p) { # 更新
    x = y
    p = q
  } else {
    b[i] = y
  }  
  a[i] = x
}
plot(0:N, c(0,a), pch=16, type="o", ylim=range(c(a,b),na.rm=TRUE), xlab="", ylab="")
points(1:N, b, pch=1)
segments(0:(N-1), a, 1:N, b)

set.seed(12345678)
N = 1000000             # 繰返し回数
a = numeric(N)          # 値を保存するための配列
x = 0                   # 初期値
p = 1 / (1 + x^2)       # 確率
accept = 0              # 採択を数えるカウンタ
for (i in 1:N) {
  y = rnorm(1, x, 1)    # 候補（選び方は対称なら何でもよい）
  q = 1 / (1 + y^2)     # 確率
  if (runif(1) < q/p) { # 更新
    x = y
    p = q
    accept = accept + 1
  }
  a[i] = x
}
hist(a, freq=FALSE, breaks=seq(-100,100,0.2), xlim=c(-5,5),
     col=gray(0.9), xlab=expression(italic(x)), ylab="", main="")
curve(dcauchy(x), add=TRUE)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
