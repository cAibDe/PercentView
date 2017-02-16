# PercentView
一个圆形百分比View
现在很多的App都有这么一个小小的View。
可以用在显示你剩余流量占总流量的百分比，也可以显示你当前进度占总进度的百分比。
#参数，属性
```objc
//目标layer
@property (nonatomic, strong) CAShapeLayer *progressLayer;
//渐变夜色
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
//整个圆的颜色
@property (nonatomic, strong) UIColor *trackColor;
//目标长度的颜色，但是设置gradientLayer的颜色之后就失效了
@property (nonatomic, strong) UIColor *progressColor;
//线宽
@property (nonatomic, assign) CGFloat lineWidth;
//贝塞尔曲线
@property (nonatomic, strong) UIBezierPath *path;
//百分比，最大值为100
@property (nonatomic, assign) CGFloat percent;
//动画时间
@property (nonatomic, assign) CGFloat duration;
//定时器
@property (nonatomic, strong) NSTimer *timer;
//阴影
@property (nonatomic, strong) UIImageView *shadowImageView;
//宽度
@property (nonatomic, assign) CGFloat pathWidth;
//目标百分比显示
@property (nonatomic, strong) UILabel *progressLabel;
```
其中gradientLayer可以设置多个颜色，做成那种颜色渐变的效果

```objc
 _gradientLayer.colors = @[(id)[UIColor redColor].CGColor,
                           (id)[UIColor yellowColor].CGColor       
                          ];
 [_gradientLayer setStartPoint:CGPointMake(0.5, 1.0)];
 [_gradientLayer setEndPoint:CGPointMake(0.5, 0.0)];
 ```
#使用方法
 就是一般的初始化就可以了
 
 ```objc
 - (ZPPercentView *)percentView{
    if (!_percentView) {
         CGFloat width = 150;
        _percentView = [[ZPPercentView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - width)/2, 150, width, width)];
        [_percentView updateZPPercent:@(80.0).floatValue openAnimation:YES];
        [self.view addSubview:_percentView];
    }
    return _percentView;

}
```
#演示
因为我传进去的就是80% 所以才能演示到80%  
![百分比.gif](http://upload-images.jianshu.io/upload_images/2368708-f2b57c8b8a9f8b6d.gif?imageMogr2/auto-orient/strip)
