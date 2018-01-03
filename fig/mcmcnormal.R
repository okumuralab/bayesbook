args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=8, height=3)
par(family="Palatino")
par(mgp=c(1.8,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

y = 1:3         # データ
n = length(y)
ybar = mean(y)
s2 = var(y)
logpost = function(x1, x2) {
  -0.5 * (n*x2 + ((n-1)*s2+n*(ybar-x1)^2) / exp(x2))
}
set.seed(12345678)
x1 = ybar      # 適当な初期値
x2 = log(s2)   # 適当な初期値
lp = logpost(x1, x2)  # 現在の事後分布の対数
N = 100000     # 繰返し数（とりあえず10万）
x1trace = x2trace = numeric(N)  # 事後分布のサンプルを格納する配列
for (i in 1:N) {
  y1 = rnorm(1, x1, 1)  # 次の候補
  y2 = rnorm(1, x2, 1)  # 次の候補
  lq = logpost(y1, y2)  # 次の候補の事後分布の対数
  if (lp - lq < rexp(1)) {  # メトロポリスの更新（対数版）
    x1 = y1
    x2 = y2
    lp = lq
  }
  x1trace[i] = x1  # 配列に格納
  x2trace[i] = x2  # 配列に格納
}

par(mfrow=c(1,2))

hist((x1trace-ybar)/sqrt(s2/n), col=gray(0.9), freq=FALSE, xlim=c(-5,5),
     breaks=seq(-100,100,0.2),
     xlab=expression((italic(mu) - bar(italic(y))) / sqrt(italic(s)^2 / italic(n))),
     ylab="", main="")
curve(dt(x,n-1), add=TRUE)

hist((n-1)*s2/exp(x2trace), col=gray(0.9), freq=FALSE, xlim=c(0,10), breaks=(0:500)/5,
     xlab=expression((italic(n)-1) * " " * italic(s)^2 / italic(sigma)^2),
     ylab="", main="")
curve(dchisq(x,n-1), add=TRUE)


dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
