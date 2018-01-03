# 『Rで楽しむベイズ統計入門』コード

## 第1章 ベイズの定理と確率

### 1.1 検診と確率

### 1.2 偽陽性，偽陰性など

### 1.3 ベイズの定理

### 1.4 条件付き確率とベイズの定理

### 1.5 事前分布，事後分布，尤度

### 1.6 統計的仮説検定とベイズの定理

### 1.7 確率とは

## 第2章 選挙の予測（2項分布）

### 2.1 選挙の予測

### 2.2 2項分布

```
> dbinom(2, 10, 0.5)
[1] 0.04394531
```

```
> rbinom(50, 10, 0.5)
 [1] 5 7 2 1 8 7 6 7 5 6 5 7 4 5 4 5 4 5 7 5 6 7 5 5 4 5 3 7 7 5
[31] 5 6 5 5 5 2 5 3 6 2 4 4 2 7 4 5 6 3 5 4
```

```
> y = rbinom(1000000, 10, 0.5)
```

```
> mean(y)
[1] 5.001356
```

```
> var(y)
[1] 2.507123
```

### 2.3 無情報事前分布

```
curve(x^2*(1-x)^8)
```

```
curve(x^2*(1-x)^8, 0, 1)
```

```
install.packages("ggplot2") # もしggplot2をインストールしていないなら
library(ggplot2)
ggplot(data.frame(x=c(0,1)), aes(x)) +
  stat_function(fun=function(x) x^2*(1-x)^8)
```

```
> integrate(function(x) x^2*(1-x)^8, 0, 1)
0.002020202 with absolute error < 2.2e-17
```

```
> integrate(function(x) x^2*(1-x)^8, 0.5, 1)
6.609059e-05 with absolute error < 7.3e-19
```

```
> 6.609059e-05 / 0.002020202
[1] 0.03271484
```

```
> r = integrate(function(x) x^2*(1-x)^8, 0, 1)
> str(r)
List of 5
 $ value       : num 0.00202
 $ abs.error   : num 2.24e-17
 $ subdivisions: int 1
 $ message     : chr "OK"
 $ call        : language integrate(f = function(x)
                 x^2 * (1 - x)^8, lower = 0, upper = 1)
 - attr(*, "class")= chr "integrate"
```

```
> r$value
[1] 0.002020202
> r$abs.error
[1] 2.242875e-17
```

```
> integrate(function(x) x^2*(1-x)^8, 0, 1)$value
[1] 0.002020202
```

```
> stats:::print.integrate(r)
0.002020202 with absolute error < 2.2e-17
```

```
> print.default(r)
$value
[1] 0.002020202

$abs.error
[1] 2.242875e-17

$subdivisions
[1] 1

$message
[1] "OK"

$call
integrate(f = function(x) x^2 * (1 - x)^8, lower = 0, upper = 1)

attr(,"class")
[1] "integrate"
```

### 2.4 ベータ分布

### 2.5 ベータ分布を使った推定

```
> curve(dbeta(x, 3, 9), 0, 1)
```

```
> pbeta(0.5, 3, 9, lower.tail=FALSE)
[1] 0.03271484
```

```
> 1 - pbeta(0.5, 3, 9)
[1] 0.03271484
```

```
> x = rbeta(1000000, 3, 9)  # 100万個の乱数を生成
> mean(x > 0.5)             # x > 0.5 になる割合
[1] 0.032691
```

```
> qbeta(0.5, 3, 9)
[1] 0.2357855
```

### 2.6 従来の統計学との比較

### 2.7 無情報でない事前分布

```
popularvote = read.csv("popularvote.csv")
```

```
p = popularvote[popularvote[,2] %in% 1900:2012, 7] / 100
```

```
hist(p, breaks=(0:100)/100, col="gray")
```

```
> (1/mean((p-0.5)^2)-4)/8
[1] 34.93437
```

```
> pbeta(0.5, 37, 43, lower.tail=FALSE)
[1] 0.2499484
```

```
> (pbeta(0.62,3,9)-pbeta(0.5,3,9)) / (pbeta(0.62,3,9)-pbeta(0.38,3,9))
[1] 0.1999947
```

```
> pbeta(0.5, 471, 531, lower.tail=FALSE)
[1] 0.02892526
```

```
> pbeta(0.5, 505, 565, lower.tail=FALSE)
[1] 0.03321951
```

```
> (pbeta(0.62,471,531)-pbeta(0.5,471,531)) /
              (pbeta(0.62,471,531)-pbeta(0.38,471,531))
[1] 0.02892526
```

### 2.8 事前分布についてのいろいろな考え方

## 第3章 事前分布の再検討

### 3.1 目盛の付け方の問題

```
> integrate(function(x) 1/sqrt(x*(1-x)), 0, 1)
3.141593 with absolute error < 9.4e-06
```

### 3.2 分散安定化変換

```
> install.packages("microbenchmark") # もしインストールしていないなら
> library(microbenchmark)
> x = runif(10000)
> microbenchmark(pbeta(x,0.5,0.5), 2*asin(sqrt(x))/pi)
Unit: microseconds
                 expr      min        lq      mean    median       uq
   pbeta(x, 0.5, 0.5) 4830.743 4888.6415 5392.5963 5245.3480 5635.353
 2 * asin(sqrt(x))/pi  336.661  341.3915  392.6564  373.9415  404.075
      max neval
 8161.128   100
  659.751   100
```

```
eps = 1e-14
curve(pbeta(x,0.5,0.5), 0.5-eps, 0.5+eps)
curve(2*asin(sqrt(x))/pi, add=TRUE, col="red")
```

### 3.3 オッズとロジット

### 3.4 ジェフリーズの事前分布を使った事後分布

```
curve(dbeta((sin(pi*x/2))^2, 3, 9), 0, 1, xlab="z")
```

```
curve(dbeta((sin(pi*x/2))^2, 3, 9), 0, 1, xaxt="n")
axis(1, at=(2/pi)*asin(sqrt(0:5/5)), 0:5/5)
```

```
> pbeta(0.5, 2.5, 8.5, lower.tail=FALSE)
[1] 0.02603661
```

```
> pbeta(0.5, 3, 9, lower.tail=FALSE)
[1] 0.03271484
```

### 3.5 区間推定

```
> binom.test(2, 10, 0.5)

	Exact binomial test

data:  2 and 10
number of successes = 2, number of trials = 10, p-value = 0.1094
alternative hypothesis: true probability of success is not equal to 0.5
95 percent confidence interval:
 0.02521073 0.55609546
sample estimates:
probability of success
                   0.2
```

```
> qbeta(0.025, 2.5, 8.5)
[1] 0.04405941
```

```
> qbeta(0.975, 2.5, 8.5)
[1] 0.5027745
```

```
> qbeta(c(0.025,0.975), 2.5, 8.5)
[1] 0.04405941 0.50277450
```

```
> qbeta(c(0.025,0.5,0.975), 2.5, 8.5)
[1] 0.04405941 0.21037364 0.50277450
```

```
> f = function(p) qbeta(p+0.95,2.5,8.5)-qbeta(p,2.5,8.5)
> p = optimize(f, c(0,0.05), tol=1e-8)$minimum
> qbeta(c(p,p+0.95), 2.5, 8.5)
[1] 0.0234655 0.4618984
```

```
f = function(p) {
  asin(sqrt(qbeta(p+0.95,2.5,8.5))) - asin(sqrt(qbeta(p,2.5,8.5)))
}
p = optimize(f, c(0,0.05), tol=1e-8)$minimum
qbeta(c(p,p+0.95), 2.5, 8.5)
```

```
> qbeta(c(0.025, 0.975), 45.5, 55.5)
[1] 0.3550769 0.5477710
```

```
> pbeta(0.5, 45.5, 55.5, lower.tail=FALSE)
[1] 0.1586579
```

```
> quantile(x, pnorm(c(-1,1)))
```

### 3.6 信頼区間とベイズ信用区間の比較

```
binomHPD = function(n, y) {
  a = y + 0.5
  b = n - y + 0.5
  f = function(x) {
    asin(sqrt(qbeta(x+0.95,a,b))) - asin(sqrt(qbeta(x,a,b)))
  }
  x = optimize(f, c(0,0.05), tol=1e-8)$minimum
  qbeta(c(x,x+0.95), a, b)
}

HPD = sapply(0:10, function(y) binomHPD(10,y))
f = function(x) {
  p = dbinom(0:10, 10, x)
  sum(p * (HPD[1,] <= x & x <= HPD[2,]))
}
plot(Vectorize(f), n=1001)
```

### 3.7 シミュレーションによる方法

```
> x = rbeta(1e7, 2.5, 8.5)
```

```
> object.size(x)
80000040 bytes
```

```
> set.seed(12345678)       # 12345678を乱数の種に設定する
> x = rbeta(1e7, 2.5, 8.5)
```

```
> hist(x)
```

```
> hist(x, breaks=seq(0,1,0.01), freq=FALSE, col="gray")
```

```
> z = (2/pi) * asin(sqrt(x))
> hist(z, breaks=seq(0,1,0.01), freq=FALSE, col="gray", axes=FALSE)
> axis(1, at=(2/pi)*asin(sqrt((0:10)/10)), labels=(0:10)/10)
> axis(2)
```

```
> median(x)
[1] 0.2103064
```

```
> mean(x > 0.5)
[1] 0.0260141
```

### 3.8 シミュレーションによる信用区間の推定

```
> set.seed(12345678)
> x = rbeta(1e7, 2.5, 8.5)
```

```
> quantile(x, c(0.025,0.975))
      2.5%      97.5%
0.04403125 0.50270036
```

```
> quantile(x, c(0.025,0.5,0.975))
      2.5%        50%      97.5%
0.04403125 0.21030641 0.50270036
```

```
hpd = function(x) {
  x = sort(x)      # 整列。ローカル変数なので元のxは変わらない
  n = length(x)
  h = floor(n/20)  # 四捨五入なら floor((n+10)/20)
  x1 = x[1:(h+1)]
  x2 = x[(n-h):n]
  k = which.min(x2 - x1)
  c(x1[k], x2[k])
}
```

```
> hpd(x)
[1] 0.02315747 0.46148612
```

```
> install.packages("coda")
> library(coda)
> HPDinterval(as.mcmc(x))
          lower     upper
var1 0.02315747 0.4614866
attr(,"Probability")
[1] 0.95
```

```
> install.packages("HDInterval")
> library(HDInterval)
> hdi(x)
     lower      upper
0.02315747 0.46148658
attr(,"credMass")
[1] 0.95
```

```
> z = (2/pi) * asin(sqrt(x))
> (sin(pi*hpd(z)/2))^2
[1] 0.03913638 0.48809581
```

```
q = qnorm(0.975)
n = 1e4
f = function() {
  x = sort(rnorm(n))
  h = floor(n/20)
  x1 = x[1:(h+1)]
  x2 = x[(n-h):n]
  k = which.min(x2 - x1)
  c(mean(x)+q*sd(x), x[0.975*n], x2[k])
}
r = replicate(1e4, f())
boxplot(t(r), names=c("1.96sd", "central", "hpd"))
```

### 3.9 シミュレーションによる最頻値の推定

```
> install.packages("modeest")
> library(modeest)
> x = rbeta(1e7, 2.5, 8.5)
> mlv(x, method="hsm")
Mode (most likely value): 0.1635758
Bickel's modal skewness: 0.3095892
Call: mlv.default(x = x, method = "hsm")
```

```
> mlv(x, method="hsm")$M
[1] 0.1635758
```

```
> x = rbeta(1e7, 2.5, 8.5)
> plot(density(x))
```

```
plot(density(x, 0.01))
```

```
d = density(x)  # 必要があれば density(x, 0.01) のようにバンド幅も指定
d$x[which.max(d$y)]
```

```
> x = rbeta(1e7, 2.5, 8.5)
> d = density(x)
> d$x[which.max(d$y)]
[1] 0.1647099
```

```
library(modeest)
f = function() {
  x = rnorm(1e4)
  d = density(x)
  c(mean(x), median(x), mlv(x, method="hsm")$M, d$x[which.max(d$y)])
}
r = replicate(1e4, f())
boxplot(t(r), names=c("mean", "median", "hsm", "density"))
```

### 3.10 予測分布

```
> x = rbeta(1e5, 2.5, 8.5)
```

```
> yt = sapply(x, function(x) rbinom(1, 10, x))
```

```
> barplot(table(yt))
```

```
> ytilde = sapply(0:10, function(r) mean(dbinom(r, 10, x)))
```

### 3.11 オッズとオッズ比

```
> a = 12; b = 6; c = 5; d = 12
> exp(log((a/b)/(c/d)) + qnorm(c(0.025,0.975)) * sqrt(1/a+1/b+1/c+1/d))
[1]  1.147127 20.084959
```

```
odds = function(n, a, b) {
  x = rbeta(n, a+0.5, b+0.5)
  x/(1 - x)
}
```

```
oddsratio = odds(1e7, 12, 6) / odds(1e7, 5, 12)
```

```
> quantile(oddsratio, c(0.025,0.5,0.975))
     2.5%       50%     97.5%
 1.196924  4.713666 21.026667
```

```
> hist(oddsratio, breaks=1000, xlim=c(0,50), freq=FALSE, col="gray")
```

```
> hist(log(oddsratio), breaks=100, freq=FALSE, col="gray")
```

```
> exp(hpd(log(oddsratio)))
[1]  1.162032 20.352423
```

```
oddsratio = odds(1e7, 1, 9) / odds(1e7, 0, 10)
```

```
f = function(logOR, a, b, c, d) {
  OR = exp(logOR)
  g = function(x2) {
    x1 = x2 / (x2 + (1 - x2) / OR)
    x1^(a+0.5) * (1-x1)^(b+0.5) * x2^(c-0.5) * (1-x2)^(d-0.5)
  }
  integrate(g, 0, 1)$value
}
```

```
vf = Vectorize(f)
curve(vf(x,12,6,5,12), -2, 6)
```

```
optimize(function(x) f(x,12,6,5,12), c(0,3), maximum=TRUE)
```

```
hist(log(oddsratio), breaks=100, freq=FALSE, col="gray")
area = integrate(function(x) vf(x,12,6,5,12), -2, 6)$value
curve(vf(x,12,6,5,12) / area, add=TRUE)
```

### 3.12 相対危険度

```
rRR = function(n, a, b, c, d) {
  rbeta(n, a+0.5, b+0.5) / rbeta(n, c+0.5, d+0.5)
}
r = rRR(1e7, 12, 6, 5, 12)
hist(log(r), freq=FALSE, breaks=100, xlim=c(-1,3), col="gray")
```

```
f = function(logRR, a, b, c, d) {
    RR = exp(logRR)
    g = function(x2) {
        x1 = x2 * RR
        x1^(a+0.5) * (1-x1)^(b-0.5) * x2^(c-0.5) * (1-x2)^(d-0.5)
    }
    integrate(g, 0, min(1,1/RR))$value
}
```

```
vf = Vectorize(f)
curve(vf(x,12,6,5,12), -1, 3)
```

```
optimize(function(x) f(x,12,6,5,12), c(0,3), maximum=TRUE)
```

```
hist(log(r), freq=FALSE, breaks=100, xlim=c(-1,3), col="gray")
area = integrate(function(x) vf(x,12,6,5,12), -1, 3)$value
curve(vf(x,12,6,5,12) / area, add=TRUE)
```

### 3.13 対数オッズ代替としての分散安定化変換

```
a = 12; b = 6; c = 5; d = 12
x1 = rbeta(1e7, a+0.5, b+0.5)
x2 = rbeta(1e7, c+0.5, d+0.5)
z1 = asin(sqrt(x1))
z2 = asin(sqrt(x2))
z = z1 - z2
```

```
hist(z, breaks=100, freq=FALSE, col="gray") # 度数分布
curve(dnorm(x, mean(z), sd(z)), add=TRUE)   # 正規分布と比べる
```

```
> quantile(z, c(0.025,0.5,0.975))
      2.5%        50%      97.5%
0.04429102 0.37245302 0.68602739
```

```
varAS = function(n, x) {
  a = asin(sqrt((0:n)/n))  # 分散安定化変換
  d = dbinom(0:n, n, x)    # 2項分布
  m = sum(d * a)           # 平均
  sum(d * (a - m)^2)       # 分散
}
```

```
mv = function(a, b) {
  f = function(x) dbeta(x, a+0.5, b+0.5)
  m = integrate(function(x) asin(sqrt(x)) * f(x), 0, 1)$value
  v = integrate(function(x) (asin(sqrt(x)) - m)^2 * f(x), 0, 1)$value
  c(m, v)
}
```

```
n = 20
curve(Vectorize(varAS)(n, x), 0, 1, lwd=2)
v = sapply(0:n, function(i) mv(i, n-i)[2])
points(0:n/n, v, pch=16)
abline(h=1/(4*n))
```

```
m = integrate(function(x) log(x/(1-x)) * f(x), 0, 1)$value
v = integrate(function(x) (log(x/(1-x)) - m)^2 * f(x), 0, 1)$value
```

### 3.14 邪魔なパラメータ

```
f = function(x,a,b,m,n) {
  t = x * a + (1-x) * b
  t^m * (1-t)^n
}
```

```
f1 = function(x,a,m,n) integrate(function(b) f(x,a,b,m,n), 0, a)$value
```

```
vf1 = Vectorize(f1)
f2 = function(x,m,n) integrate(function(a) vf1(x,a,m,n), 0, 1)$value
```

```
optimize(function(x) f2(x,496,372), c(0,1), maximum=TRUE)
```

```
curve(Vectorize(f2)(x,496,372), ylim=c(0,1.55e-259), yaxs="i")
```

```
install.packages("cubature")
library(cubature)
f2 = function(x,m,n) {
  adaptIntegrate(function(t) f(x,t[1],t[2],m,n),
                 c(0,0), c(1,1))$integral
}
```

### 3.15 止め方の問題・尤度原理・多重検定

## 第4章 個数の推定（ポアソン分布）

### 4.1 ポアソン分布とガンマ分布

```
x = 5
y = 0:20
barplot(x^y * exp(-x) / factorial(y), names.arg=y)
```

```
x = 5
y = 0:20
barplot(dpois(y,x), names.arg=y)
```

```
curve(dpois(5, x), 0, 20)
```

### 4.2 ポアソン分布の無情報事前分布

### 4.3 ポアソン分布のパラメータ推定

### 4.4 ポアソン分布のパラメータの信用区間

```
> qgamma(c(0.025,0.975), 5+0.5)
[1]  1.907874 10.960025
```

```
> qgamma(c(0.025,0.975), 0+0.5)
[1] 0.0004910346 2.5119430937
```

```
> qgamma(c(0,0.95), 0+0.5)
[1] 0.000000 1.920729
```

```
> y = 5
> f = function(p) qgamma(p+0.95,y+0.5)-qgamma(p,y+0.5)
> p = optimize(f, c(0,0.05), tol=1e-8)$minimum
> qgamma(c(p,p+0.95), y+0.5)
[1]  1.476607 10.152473
```

```
> y = 5
> f = function(p) sqrt(qgamma(p+0.95,y+0.5))-sqrt(qgamma(p,y+0.5))
> p = optimize(f, c(0,0.05), tol=1e-8)$minimum
> qgamma(c(p,p+0.95), y+0.5)
[1]  1.810949 10.686687
```

```
> pgamma(3, 0.5, lower.tail=FALSE)
[1] 0.01430588
```

```
> qgamma(pgamma(3, 0.5, lower.tail=FALSE) * 0.05, 0.5, lower.tail=FALSE)
[1] 5.72454
```

```
CI = sapply(0:30, function(y) poisson.test(y)$conf.int)
f = function(x) {
  p = dpois(0:30, x)
  sum(p * (CI[1,] <= x & x <= CI[2,]))
}
curve(Vectorize(f)(x), 0, 20)
```

### 4.5 2項分布との関係

```
x1 = rgamma(1e7, 2.5)
x2 = rgamma(1e7, 8.5)
x = x1 / (x1 + x2)
hist(x, breaks=(0:100)/100, freq=FALSE, col="gray")
curve(dbeta(x, 2.5, 8.5), add=TRUE)
```

### 4.6 多項分布

```
> x1 = rgamma(1e7, 29.5)  # 賛成
> x2 = rgamma(1e7, 45.5)  # 反対
> x3 = rgamma(1e7, 26.5)  # どちらでもない
> p1 = x1 / (x1 + x2 + x3)
> p2 = x2 / (x1 + x2 + x3)
> mean(p1 < p2)
[1] 0.9688644
```

```
rdirichlet = function(a) {
  r = rgamma(length(a), a)
  return(r / sum(r))
}
```

### 4.7 地震の起こる年

```
> (y = diff(c(1498, 1605, 1707, 1854)))
[1] 107 102 147
```

```
f = function(t,m,a2) (log(m/(a2*t^3)) - (t-m)^2/(a2*m*t)) / 2
```

```
llik = function(m,a2) f(y[1],m,a2) + f(y[2],m,a2) + f(y[3],m,a2)
```

```
x1 = seq(80, 180, length.out=100)
x2 = seq(0.01, 0.4, length.out=100)
contour(x1, x2, outer(x1,x2,llik), nlevels=50)
```

```
x1 = seq(80, 180, length.out=100)
x2 = seq(-5, -1, length.out=100)
contour(x1, x2, outer(x1, x2, function(u,v) llik(u,exp(v))), nlevels=50)
```

```
> nlm(function(v) -llik(v[1],v[2]), c(120,0.02))
...
$estimate
[1] 118.66650393   0.02656268
...
```

```
ma2 = function(a2) {
    integrate(function(m) exp(llik(m,a2)), 0, 200)$value +
    integrate(function(m) exp(llik(m,a2)), 200, 1000)$value
}
curve(Vectorize(ma2)(x), 0.005, 1, log="x")
```

```
mm = function(m) {
    integrate(function(x) exp(llik(m,exp(x))), -Inf, -5)$value +
    integrate(function(x) exp(llik(m,exp(x))), -5, 0)$value
}
curve(Vectorize(mm)(x), 0, 200)
```

```
library(cubature)
ff = function(t,m,v) exp(f(t,m,exp(v)) + llik(m,exp(v)))
ytilde = function(t) {
    adaptIntegrate(function(x) ff(t,x[1],x[2]), c(0,-10), c(1000,1))$integral
}
curve(Vectorize(ytilde)(x), 1, 200)
```

```
> p1 = integrate(Vectorize(ytilde), 157, 187)$value
> p2 = integrate(Vectorize(ytilde), 187, 1000)$value
> p1 / (p1 + p2)
```

### 4.8 無情報でない事前分布：エディントンのバイアス

## 第5章 連続量の推定（正規分布）

### 5.1 既知の誤差をもつ測定器の問題

```
> pnorm(10, 9.8, 0.1, lower.tail=FALSE)
[1] 0.02275013
```

```
curve(dnorm(x,-0.5,1), 0, 3)
```

```
> t = pnorm(0, -0.5, 1, lower.tail=FALSE)  # 全面積
> qnorm(0.05*t, -0.5, 1, lower.tail=FALSE)
[1] 1.658954
```

```
y134 = 0.00470; s134 = 0.000803
y137 = 0.0469;  s137 = 0.00144
d = as.numeric(difftime(as.POSIXct("2017-08-21"),
                        as.POSIXct("2011-03-11")), units="days")
c = 2^((1/30.08 - 1/2.0652) * d / 365.2422)
x137 = rnorm(1000000, y137, s137)
x134 = rnorm(1000000, y134, s134)
r = x134 / (c * x137)
r = ifelse(r <= 1, r, NA)
```

```
hist(r, breaks=seq(0,1,0.02), col="gray")
```

```
> hpd(r)
[1] 0.5219617 0.9814742
```

### 5.2 測定の連鎖

```
> (100/1^2+102/1^2) / (1/1^2+1/1^2)
[1] 101
> sqrt(1/(1/1^2 + 1/1^2))
[1] 0.7071068
```

### 5.3 誤差の事後分布

```
> curve(1/sqrt(2*pi*x^2)*exp(-1/(2*x^2)), 0, 10)
```

```
> curve(1/sqrt(2*pi*x)*exp(-1/(2*x)), 0, 10)
```

```
> curve(1/sqrt(2*pi*exp(x))*exp(-1/(2*exp(x))), -5, 10)
```

### 5.4 平均と分散の同時推定

```
y = 1:10  # データ
n = length(y)
ybar = mean(y)
s2 = var(y)
f = function(x1, x2) {  # 事後分布
  exp(-n*x2/2) * exp(-((n-1)*s2+n*(ybar-x1)^2) / (2*exp(x2)))
}
x1 = seq(3, 8, length.out=101)    # 等高線を描くためのメッシュ
x2 = seq(1, 3.5, length.out=101)
contour(x1, x2, outer(x1,x2,Vectorize(f)))  # 等高線を描く
```

### 5.5 分散の分布

```
y = 1:10       # データ
n = length(y)
ybar = mean(y)
s2 = var(y)
x1 = 5.5
x2 = log(((n-1)*s2+n*(ybar-x1)^2) / rchisq(1000000,n))
hist(x2, freq=FALSE, col="gray", breaks=50)
```

### 5.6 平均値の分布

```
> y = -2:6
> t.test(y)

	One Sample t-test

data:  y
t = 2.1909, df = 8, p-value = 0.05984
alternative hypothesis: true mean is not equal to 0
95 percent confidence interval:
 -0.1050841  4.1050841
sample estimates:
mean of x
        2
```

```
> y = -2:6
> n = length(y)
> qt(c(0.025,0.975), n-1) * sqrt(var(y) / n) + mean(y)
[1] -0.1050841  4.1050841
```

```
> 2 * pt(-abs(mean(y)) / sqrt(var(y) / n), n-1)
[1] 0.05983788
```

```
y1 = 1:10
y2 = 6:10
n1 = length(y1)
n2 = length(y2)
mu1 = rt(1e7, n1-1) * sqrt(var(y1) / n1) + mean(y1)
mu2 = rt(1e7, n2-1) * sqrt(var(y2) / n2) + mean(y2)
```

```
> quantile(mu2 - mu1, c(0.025, 0.975))
      2.5%      97.5%
-0.4116891  5.4108151
```

```
> mean(mu1 < mu2)
[1] 0.9582333
```

```
y1 = 1:10
y2 = 6:10
n1 = length(y1)
n2 = length(y2)
m1 = mean(y1)
m2 = mean(y2)
s1 = sqrt(var(y1) / n1)
s2 = sqrt(var(y2) / n2)
f = function(x) pt((x-m1)/s1, n1-1) * dt((x-m2)/s2, n2-1) / s2
integrate(f, -Inf, Inf)
```

```
0.958215 with absolute error < 1.1e-05
```

```
> sd(mu2 - mu1)
[1] 1.475804
```

```
> sqrt((n1-1)/(n1-3)*var(y1)/n1 + (n2-1)/(n2-3)*var(y2)/n2)
[1] 1.475998
```

```
> y1 = 1:10
> y2 = 6:10
> t.test(y1, y2)

	Welch Two Sample t-test

data:  y1 and y2
t = -2.1004, df = 12.876, p-value = 0.05597
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -5.07386764  0.07386764
sample estimates:
mean of x mean of y
      5.5       8.0
```

```
n1 = 10
n2 = 30
fun = function() {
  y1 = rnorm(n1, mean=0, sd=1.5)
  y2 = rnorm(n2, mean=0, sd=1.0)
  m1 = mean(y1)
  m2 = mean(y2)
  s1 = sqrt(var(y1) / n1)
  s2 = sqrt(var(y2) / n2)
  f = function(x) pt((x-m1)/s1, n1-1) * dt((x-m2)/s2, n2-1) / s2
  integrate(f, -Inf, Inf)$value
}
p = replicate(1000000, fun())  # 非常に時間がかかる！
mean(p < 0.025 | p > 0.975)
```

```
ybar1 = mean(y1);  se1 = sqrt(var(y1)/10)
ybar2 = mean(y2);  se2 = sqrt(var(y2)/5)
dt1 = function(mu) dt((mu - ybar1) / se1, 9) / se1
dt2 = function(mu) dt((mu - ybar2) / se2, 4) / se2
p = function(mu) dt1(mu) * dt2(mu)
area = integrate(p, -Inf, Inf)$value
dt12 = function(mu) p(mu) / area
```

```
> optimize(dt12, c(4,10), maximum=TRUE)
$maximum
[1] 7.192227
...
```

```
> uniroot(function(x) integrate(dt12,-Inf,x)$value - 0.025, c(4,6))
$root
[1] 5.044364
...
> uniroot(function(x) integrate(dt12,-Inf,x)$value - 0.975, c(8,10))
$root
[1] 8.493379
...
```

```
> y1 = c(1,2,3,4,5)
> y2 = c(2,2,4,4,6)
> t.test(y2, y1, paired=TRUE)

	Paired t-test

data:  y2 and y1
t = 2.4495, df = 4, p-value = 0.07048
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.08008738  1.28008738
sample estimates:
mean of the differences
                    0.6
```

```
> y = y2 - y1
> n = length(y)
> mu = rt(1e7, n-1) * sqrt(var(y)/n) + mean(y)
> mean(mu < 0)
[1] 0.0352859
```

```
> quantile(mu, c(0.025,0.975))
       2.5%       97.5%
-0.08008344  1.28020401
```

### 5.7 不検出（ND）の扱い

```
> post = function(x) dnorm(20, x, 5) * pnorm(15, x, 5)
> area = integrate(post, 0, 35)$value
> optimize(post, c(0,35), maximum=TRUE)
$maximum
[1] 15.61259
...
> integrate(function(x) x * post(x) / area, 0, 35)
15.42042 with absolute error < 4.6e-09
```

### 5.8 多変量正規分布と相関係数

```
> x1 = rnorm(1000)
> x2 = rnorm(1000)
> plot(x1, x2)          # 散布図を描いてみる
> mean(x1^2)            # ほぼ1のはず
[1] 0.9644733
> mean(x2^2)            # ほぼ1のはず
[1] 0.9993695
> mean(x1 * x2)         # ほぼ0のはず
[1] 0.05303644
```

```
> r = 0.5
> a = sqrt((1+r)/2)
> b = sqrt((1-r)/2)
> y1 = a*x1 + b*x2
> y2 = a*x1 - b*x2
> plot(y1, y2)        # 散布図を描いてみる
> mean(y1 * y2)       # ほぼ0.5になるはず
[1] 0.4735126
```

```
> x = c(1, 2, 3, 4, 5, 6)
> y = c(1, 3, 2, 4, 3, 5)
> r = cor(x, y)
> r
[1] 0.8315218
> n = length(x)
> tanh(qnorm(c(0.025,0.975), atanh(r), 1/sqrt(n-3)))
[1] 0.06138518 0.98104417
```

```
library(gsl)
f = function(rho, r, n) {
  (1-rho^2)^((n-1)/2) * (1-r^2)^((n-4)/2) *
  (1-rho*r)^(3/2-n) * hyperg_2F1(0.5,0.5,n-0.5,(1+rho*r)/2)
}
```

## 第6章 階層モデル

### 6.1 階層のある問題

```
ydata = c(11, 13, 16)             # 測定値
s2data = c(1, 1, 4)               # 測定値の誤差分散
f = function(m,t2,y,s2) { -((y-m)^2/(t2+s2) + log(t2+s2))/2 }
loglik = function(m,t2) { sum(f(m, t2, ydata, s2data)) }  # 対数尤度
x1 = seq(11, 15, length.out=101)  # 横軸は11〜15
x2 = seq(0, 10, length.out=101)   # 縦軸は0〜10
contour(x1, x2, outer(x1, x2, Vectorize(loglik)), nlevels=100)
```

```
> nlm(function(par) -loglik(par[1],par[2]), c(12.5,1))
$minimum
[1] 3.330307

$estimate
[1] 12.6488577  0.8959622

$gradient
[1] -1.843224e-08  0.000000e+00

$code
[1] 1

$iterations
[1] 7
```

```
m = 12.5;  t2 = 1  # 適当な初期値
for (j in 1:10) {
    m = sum(ydata/(s2data+t2)) / sum(1/(s2data+t2))
    f = function(t2,y,s2) { u = t2 + s2; ((y - m)^2 - u) / u^2 }
    g = function(t2) { sum(f(t2,ydata,s2data)) }
    t2 = uniroot(g, c(0,10))$root
    cat(m, t2, "\n")
}
```

```
> 1 / sum(1 / (t2 + s2data))
[1] 0.794207
```

```
> install.packages("metafor")
> library(metafor)
> ydata = c(11, 13, 16)
> s2data = c(1, 1, 4)
> rma(yi=ydata, vi=s2data, method="ML")

Random-Effects Model (k = 3; tau^2 estimator: ML)

tau^2 (estimated amount of total heterogeneity): 0.8960 (SE = 1.8287)
tau (square root of estimated tau^2 value):      0.9466
I^2 (total heterogeneity / total variability):   37.40%
H^2 (total variability / sampling variability):  1.60

Test for Heterogeneity:
Q(df = 2) = 5.5556, p-val = 0.0622

Model Results:

estimate       se     zval     pval    ci.lb    ci.ub
 12.6489   0.8912  14.1933   <.0001  10.9022  14.3956      ***

---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

### 6.2 完全にベイズな方法

```
f = function(t2,m) {
    sqrt(sum(1/(t2+s2data)^2)) *
    prod((1/sqrt(t2+s2data))) *
    exp(-sum((ydata-m)^2/(t2+s2data))/2)
}
g = function(m) integrate(Vectorize(f), 0, Inf, m)$value
plot(Vectorize(g), xlim=c(5,20))
```

```
> optimize(g, range(ydata), maximum=TRUE)
$maximum
[1] 12.6939
```

```
t2lik = function(t2) {
  t2s2 = t2 + s2data
  mhat = sum(ydata/t2s2) / sum(1/t2s2)
  prod(1/sqrt(2*pi*t2s2)) * sqrt(2*pi/sum(1/t2s2)) *
    exp(-sum((ydata-mhat)^2/t2s2)/2)
}
```

```
vt2lik = Vectorize(t2lik)
f = function(t2) sqrt(sum(1/(t2+s2data)^2))
zt2 = function(t2) integrate(Vectorize(f), 0, t2)$value
t2seq = c(0, sapply(seq(0.1,10,0.1),
          function(z) uniroot(function(t2) zt2(t2) - z, c(0,500))$root))
plot(seq(0,10,0.1), vt2lik(t2seq), type="l", ylim=c(0,0.0061), xaxt="n")
t = c(0,10,20,50,100,200,500)
axis(1, sapply(t,zt2), t)
```

```
> optimize(t2lik, c(0,var(ydata)), maximum=TRUE)
$maximum
[1] 3.06694
```

### 6.3 完全なベイズモデルによるシミュレーション

```
s2bar = 1 / mean(1/s2data) # 誤差分散の調和平均
upost = function(u) {      # uの（周辺）事後分布
  t2 = exp(u) - s2bar
  t2s2 = t2 + s2data
  mhat = sum(ydata/t2s2) / sum(1/t2s2)
  sqrt(sum(1/t2s2^2)) *
  prod(1/sqrt(2*pi*t2s2)) * sqrt(2*pi/sum(1/t2s2)) *
  exp(-sum((ydata-mhat)^2/t2s2)/2) * (t2 + s2bar)
}
```

```
u0 = log(s2bar)
u1 = log(var(ydata) + s2bar)
h = integrate(Vectorize(upost), u0, 2*u1-u0)$value / 1000
umesh = numeric()
u = u1
i = 1
repeat {
  up = upost(u)
  usav = u
  u = u + h/up
  if (u > 700) break
  umesh[i] = (usav + u) / 2
  i = i + 1
}
u = u1
repeat {
  up = upost(u)
  usav = u
  u = u - h/up
  if (u < u0) break
  umesh[i] = (usav + u) / 2
  i = i + 1
}
theta = function(i) {
  u = sample(umesh, 1)
  t2 = exp(u) - s2bar
  v = 1 / sum(1 / (t2 + s2data))
  mhat = sum(ydata / (t2 + s2data)) * v
  m = rnorm(1, mhat, sqrt(v))
  d = 1/t2+1/s2data[i]
  rnorm(1, (m/t2+ydata[i]/s2data[i])/d, sqrt(1/d))
}
```

```
> theta3 = replicate(1000000, theta(3))
> hist(theta3, breaks=100, col="gray", freq=FALSE)
> mean(theta3)
[1] 14.59479
> sd(theta3)
[1] 1.890495
> quantile(theta3, c(0.025,0.5,0.975))
    2.5%      50%    97.5%
11.35747 14.44458 18.59985
```

### 6.4 メタアナリシス

```
> library(metafor)
> dat.bcg
   trial           author year tpos  tneg cpos  cneg ablat      alloc
1      1          Aronson 1948    4   119   11   128    44     random
2      2 Ferguson & Simes 1949    6   300   29   274    55     random
3      3  Rosenthal et al 1960    3   228   11   209    42     random
...
13    13   Comstock et al 1976   27 16886   29 17825    33 systematic
```

```
> es = escalc(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg)
> es[c("yi","vi")]
        yi     vi
1  -0.9387 0.3571
2  -1.6662 0.2081
3  -1.3863 0.4334
...
```

```
> log((4/119)/(11/128))
[1] -0.9386941
> 1/4 + 1/119 + 1/11 + 1/128
[1] 0.357125
```

```
> sum(es$yi / es$vi) / sum(1 / es$vi)
[1] -0.4361391
```

```
> 1 / sum(1 / es$vi)
[1] 0.001786369
```

```
> rma(yi, vi, data=es, method="FE")
...
estimate       se     zval     pval    ci.lb    ci.ub
 -0.4361   0.0423 -10.3190   <.0001  -0.5190  -0.3533      ***
```

```
forest(rma(yi, vi, data=es, method="FE"))
```

```
> es = escalc(measure="AS", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg)
> es[c("yi","vi")]
        yi     vi
1  -0.1038 0.0038
2  -0.1740 0.0016
3  -0.1113 0.0022
...
```

```
> asin(sqrt(4/(119+4))) - asin(sqrt(11/(128+11)))
[1] -0.1038356
> 1/(4*(119+4)) + 1/(4*(128+11))
[1] 0.003831081
```

```
> rma(yi, vi, data=es, method="ML")
...
estimate       se     zval     pval    ci.lb    ci.ub
 -0.0575   0.0174  -3.3059   0.0009  -0.0916  -0.0234      ***
```

```
forest(rma(yi, vi, data=es, method="ML"))
```

### 6.5 bayesmetaパッケージ

```
> install.packages("bayesmeta")
> library(bayesmeta)
> r = bayesmeta(c(11,13,16), c(1,1,2), tau.prior="Jeffreys")
```

```
> r
 'bayesmeta' object.

3 estimates:
1, 2, 3

tau prior (improper):
Jeffreys prior

mu prior (improper):
uniform(min=-Inf, max=Inf)

ML and MAP estimates:
                   tau       mu
ML joint     0.9470004 12.64934
ML marginal  1.7512716 12.69390
MAP joint    1.0070604 12.66894
MAP marginal 1.3905519 12.69329

marginal posterior summary:
                  tau        mu
mode       1.39055194 12.693292
median     2.35487034 12.855986
mean       3.67647047 12.980341
sd                 NA  3.947427
95% lower  0.02912476  7.485701
95% upper 10.14895476 18.955488

(quoted intervals are shortest credible intervals.)
```

```
> r$theta
                   1          2         3
y         11.0000000 13.0000000 16.000000
sigma      1.0000000  1.0000000  2.000000
mode      11.4712359 12.9058835 13.962664
median    11.4313117 12.9298433 14.439061
mean      11.4133994 12.9395931 14.588030
sd         0.9927761  0.9349359  1.888808
95% lower  9.4594936 11.1165736 11.181006
95% upper 13.3319573 14.7865567 18.370448
```

```
> library(metafor)
> es = escalc(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg)
> r = bayesmeta(es, tau.prior="Jeffreys")
```

```
a = data.frame(y=c(14,12,11,23,8,14,6,1),
               n=c(41967,50761,17958,54928,16904,47505,25870,18326))
```

```
> chisq.test(a)

	Pearson's Chi-squared test

data:  a
X-squared = 13.393, df = 7, p-value = 0.06309
```

```
es = escalc("PAS", xi=a$y, mi=a$n)
```

```
> r = bayesmeta(es, tau.prior="Jeffreys")
> forestplot(r)
```

## 第7章 MCMC

### 7.1 MCMC創世記

```
inc = function(x) { x %% 30 + 1 }        # 周期的境界条件を考慮した x+1
dec = function(x) { (x + 28) %% 30 + 1 } # 周期的境界条件を考慮した x-1
s = matrix(sample(c(-1,1), 900, replace=TRUE), nrow=30, ncol=30)
kT = 3  # 温度。これを 2.269 以下にするとスピンがほぼどちらかに揃う
ssum = 0
N = 1e6
for (g in 1:N) {
  i = sample(1:30, 1)
  j = sample(1:30, 1)
  dE = 2 * s[i,j] * (s[i,dec(j)]+s[i,inc(j)]+s[dec(i),j]+s[inc(i),j])
  if (dE < 0) {
    s[i,j] = -s[i,j]
  } else {
    p = exp(-dE/kT)
    s[i,j] = s[i,j] * sample(c(-1,1), 1, prob=c(p,1-p))
  }
  ssum = ssum + s[i,j]
  if (g %% 10000 == 0) {
    plot((0:899)%/%30, (0:899)%%30, cex=2, pch=s*7.5+8.5,
         axes=FALSE, xlab="", ylab="", asp=1, main=g, sub=ssum/g)
  }
}
```

### 7.2 1次元の簡単なMCMC

```
N = 100000              # 繰返し回数
a = numeric(N)          # 値を保存するための長さNの配列
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
```

```
plot(0:N, c(0,a), pch=16, type="o", ylim=range(c(a,b),na.rm=TRUE))
points(1:N, b, pch=1)
segments(0:(N-1), a, 1:N, b)
```

```
> hist(a, freq=FALSE, breaks=seq(-100,100,0.1), xlim=c(-5,5), col="gray")
> curve(dcauchy(x), add=TRUE)
```

```
> accept / N
[1] 0.77033
```

### 7.3 正規分布の平均と分散のベイズ推定

```
> exp(-743)         # 2.085451e-323
[1] 1.976263e-323
> exp(-744)         # 7.671945e-324
[1] 9.881313e-324
> exp(-745)         # 2.822351e-324
[1] 4.940656e-324
> exp(-746)         # 1.038285e-324
[1] 0
```

```
> exp(709)          # 8.218407e+307
[1] 8.218407e+307
> exp(710)          # 2.233995e+308
[1] Inf
```

```
> library(Rmpfr)
> exp(mpfr(-745, 120))   # -745を120ビット精度で
1 'mpfr' number of precision  120   bits
[1] 2.8223507304719370763534400820597826207e-324
```

```
logpost = function(x1, x2) {
  -0.5 * (n*x2 + ((n-1)*s2+n*(ybar-x1)^2) / exp(x2))
}
```

```
y = 1:3         # データ
n = length(y)
ybar = mean(y)
s2 = var(y)
```

```
  if (runif(1) < q/p) { ...
```

```
y = 1:3         # データ
n = length(y)
ybar = mean(y)
s2 = var(y)
logpost = function(x1, x2) {
  -0.5 * (n*x2 + ((n-1)*s2+n*(ybar-x1)^2) / exp(x2))
}
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
```

```
hist((x1trace-ybar)/sqrt(s2/n), col="gray", freq=FALSE, xlim=c(-5,5),
     breaks=seq(-1000,1000,0.2))
curve(dt(x,n-1), add=TRUE)
```

```
t = (x1trace-ybar)/sqrt(s2/n)
t = ifelse(abs(t) > 6, 6, t)
hist(t, col="gray", freq=FALSE, breaks=seq(-6,6,0.2), xlim=c(-5,5))
```

```
hist((n-1)*s2/exp(x2trace), col="gray", freq=FALSE,
     xlim=c(0,10), breaks=(0:500)/5)
curve(dchisq(x,n-1), add=TRUE)
```

```
plot(x1trace, x2trace, type="l")
```

```
plot(x1trace, x2trace, type="l", col="#00000010")
```

```
logpost = function(x1, x2) {
  if (x2 > 6) return(-Inf)
  -0.5 * (n*x2 + ((n-1)*s2+n*(ybar-x1)^2) / exp(x2))
}
```

```
y = 1:3         # データ
n = length(y)
ybar = mean(y)
s2 = var(y)
x2 = log(s2)   # 適当な初期値
N = 100000     # 繰返し数（とりあえず10万）
x1trace = x2trace = numeric(N)  # 足跡を格納する配列
for (i in 1:N) {
  x1 = rnorm(1, ybar, sqrt(exp(x2)/n))
  x2 = log(((n-1)*s2 + n*(ybar-x1)^2) / rchisq(1,n))
  x1trace[i] = x1
  x2trace[i] = x2
}
```

### 7.4 階層モデル

```
ydata = c(11, 13, 16)
s2data = c(1, 1, 4)
```

```
n = length(ydata)             # データの個数
s2bar = 1 / mean(1/s2data)    # 平均の誤差分散
logpost = function(m, u) {    # 事後分布の対数
  t2 = exp(u) - s2bar
  if (t2 < 0) return(-Inf)
  (log(sum(1/(t2+s2data)^2)) - sum((ydata-m)^2/(t2+s2data))
                             - sum(log(t2+s2data))) / 2 + u
}
m = mean(ydata)               # 適当な初期値
u = log(var(ydata) + s2bar)   # 適当な初期値
msd = sqrt(var(ydata)/n)
usd = sqrt(2/n)
lp = logpost(m, u)            # 事後分布の対数
N = 1e6                       # 繰返し数
utrace = mtrace  = numeric(N) # 足跡を格納する配列
thtrace = matrix(nrow=N, ncol=length(ydata))
for (i in 1:N) {
  mnew = rnorm(1, m, msd)     # 次の候補
  unew = rnorm(1, u, usd)     # 次の候補
  lq = logpost(mnew, unew)    # 次の候補の事後分布
  if (lp - lq < rexp(1)) {    # メトロポリスの更新（対数版）
    m = mnew
    u = unew
    lp = lq
  }
  mtrace[i] = m               # 配列に格納
  utrace[i] = u               # 配列に格納
  t2 = exp(u) - s2bar
  d = 1/t2+1/s2data
  thtrace[i,] = rnorm(1) * sqrt(1/d) + (m/t2+ydata/s2data)/d
}
```

```
> hist(mtrace, freq=FALSE, col="gray")
```

```
> hist(sqrt(exp(utrace)-s2), freq=FALSE, col="gray")
```

```
> quantile(thtrace[,3], c(0.025,0.5,0.975))
    2.5%      50%    97.5%
11.35855 14.44918 18.59558
```

```
library(metafor)
es = escalc(measure="AS", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg)
```

```
ydata = as.numeric(es$yi)  # 念のため余分な情報を落として数値だけにする
s2data = es$vi             # こちらはもともと数値だけ
```

```
> quantile(mtrace, c(0.025,0.5,0.975))
       2.5%         50%       97.5%
-0.09916989 -0.05757895 -0.01972227
> quantile(sqrt(exp(utrace)-s2bar), c(0.025,0.5,0.975))
      2.5%        50%      97.5%
0.04116507 0.06331995 0.10633262
```

### 7.5 回帰分析

```
> xdata = c(1, 2, 3, 4, 5, 6)
> ydata = c(1, 3, 2, 4, 3, 5)
> summary(lm(ydata ~ xdata))

Call:
lm(formula = ydata ~ xdata)

Residuals:
      1       2       3       4       5       6
-0.4286  0.9429 -0.6857  0.6857 -0.9429  0.4286

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)   0.8000     0.8177   0.978   0.3833
xdata         0.6286     0.2100   2.994   0.0402 *
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.8783 on 4 degrees of freedom
Multiple R-squared:  0.6914,	Adjusted R-squared:  0.6143
F-statistic: 8.963 on 1 and 4 DF,  p-value: 0.04019
```

```
xdata = c(1, 2, 3, 4, 5, 6)
ydata = c(1, 3, 2, 4, 3, 5)
xdata = xdata - mean(xdata)
ydata = ydata - mean(ydata)
n = length(ydata)              # データの個数
logpost = function(a, b, t) {  # 事後分布の対数
  -0.5 * (n*t + sum((a*xdata+b-ydata)^2)/exp(t))
}
a = 0              # 適当な初期値
b = 0              # 適当な初期値
t = 0              # 適当な初期値
lp = logpost(a, b, t) # 現在の事後分布の対数
N = 1000000           # 繰返し数
atrace = btrace = ttrace = numeric(N)  # 足跡を格納する配列
for (i in 1:N) {
  anew = rnorm(1, a, 1) # 次の候補
  bnew = rnorm(1, b, 1) # 次の候補
  tnew = rnorm(1, t, 1) # 次の候補
  lq = logpost(anew, bnew, tnew)  # 次の候補の事後分布の対数
  if (lp - lq < rexp(1)) {        # メトロポリスの更新（対数版）
    a = anew
    b = bnew
    t = tnew
    lp = lq
  }
  atrace[i] = a    # 配列に格納
  btrace[i] = b    # 配列に格納
  ttrace[i] = t    # 配列に格納
}
```

```
> atrace = atrace[-(1:10000)]   # 最初の1万個を捨てる
> mean(atrace)
[1] 0.6292575
```

```
> quantile(atrace, c(0.025,0.5,0.975))
      2.5%        50%      97.5%
0.04447045 0.62977936 1.21628649
```

```
hist(atrace, breaks=seq(-10,10,0.05),
     col="gray", xlim=c(-0.5,2), freq=FALSE)
```

```
curve(dt((x-0.6286)/0.2100,4) / 0.2100, add=TRUE)
```

### 7.6 ポアソンデータのピークフィット

```
idata = 1:20
ydata = c(11,4,13,10,4,8,6,16,7,12,10,13,6,5,1,4,2,0,0,1)
logpost = function(a, b) {
  x = a * exp(-(idata-10)^2/(2*3^2)) + b * exp(-idata/10)
  sum((ydata - 0.5) * log(x) - x)
}
a = 5; b = 10       # 適当な初期値
lp = logpost(a, b)  # 事後分布の対数
N = 1e6             # 繰返し数
atrace = btrace = numeric(N) # 事後分布のサンプルを格納する配列
for (i in 1:N) {
  a1 = rnorm(1, a, 1)  # 候補
  b1 = rnorm(1, b, 1)  # 候補
  lq = logpost(a1, b1) # 候補の事後分布の対数
  if (lp - lq < rexp(1)) {  # メトロポリスの更新（対数版）
    a = a1
    b = b1
    lp = lq
  }
  atrace[i] = a
  btrace[i] = b
}
```

```
> quantile(atrace, c(0.025,0.5,0.975))
     2.5%       50%     97.5%
 4.511797  7.376486 10.512113
> quantile(btrace, c(0.025,0.5,0.975))
     2.5%       50%     97.5%
 5.778023  8.372888 11.496212
```

### 7.7 打切りデータの回帰分析

```
xdata = c(1, 2, 3, 4, 5, 6)    # データ
ydata = c(NA, NA, 3, 5, 4, 6)  # データ
iy = is.na(ydata)              # NA
jy = !iy                       # NA以外
ny = sum(jy)                   # NA以外の個数
logpost = function(a, b, t) {  # 事後分布の対数
  if (any(a*xdata+b < 0)) return(-Inf)
  sum(pnorm(2, a*xdata[iy]+b, exp(t/2), log.p=TRUE)) -
  0.5 * (ny*t + sum((a*xdata[jy]+b-ydata[jy])^2)/exp(t))
}
a = 1             # 適当な初期値
b = t = 0         # 適当な初期値
lp = logpost(a, b, t) # 現在の事後分布の対数
N = 100000        # 繰返し数
atrace = btrace = ttrace = numeric(N)  # 足跡を格納する配列
for (i in 1:N) {
  anew = rnorm(1, a, 1) # 次の候補
  bnew = rnorm(1, b, 1) # 次の候補
  tnew = rnorm(1, t, 1) # 次の候補
  lq = logpost(anew, bnew, tnew)  # 次の候補の事後分布の対数
  if (lp - lq < rexp(1)) {  # メトロポリスの更新（対数版）
    a = anew
    b = bnew
    t = tnew
    lp = lq
  }
  atrace[i] = a    # 配列に格納
  btrace[i] = b    # 配列に格納
  ttrace[i] = t    # 配列に格納
}
```

### 7.8 HMC法

```
U = function(q) log1p(q^2)          # log(1+q^2) = -log f(q)
dU = function(q) 2 * q / (1 + q^2)  # dU/dq
N = 100000
accept = 0
eps = 0.1
L = 10
a = numeric(N)
q = 0  # 初期値
for (i in 1:N) {
  qold = q
  p = rnorm(1)             # 運動量
  Hold = p^2 / 2 + U(q)    # 旧ハミルトニアン
  p = p - eps * dU(q) / 2  # leapfrogここから
  q = q + eps * p
  for (j in 2:L) {
    p = p - eps * dU(q)
    q = q + eps * p
  }
  p = p - eps * dU(q) / 2  # leapfrogここまで
  Hnew = p^2 / 2 + U(q)    # 新ハミルトニアン
  if (Hnew - Hold < rexp(1))  # メトロポリス
    accept = accept + 1
  else
    q = qold
  a[i] = q
}
```

```
> accept / N
[1] 0.99956
```

