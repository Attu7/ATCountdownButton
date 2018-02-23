# ATCountdownButton
该Button提供一种转圈倒计时功能。会以0.1s的粒度返回当前倒计时的时间。倒计时结束，以回调形式通知开发者。
提供了一种倒计时的解决思路，能够实现较低的性能消耗。
同时并未使用CAAnimation做动画效果，故不存在APP进入background时，触发animationDidStop的方法。更利于开发者对进度的把控。


