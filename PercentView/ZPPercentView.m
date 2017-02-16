//
//  ZPPercentView.m
//  PercentView
//
//  Created by 张鹏 on 16/7/5.
//  Copyright © 2016年 robu. All rights reserved.
//

#import "ZPPercentView.h"
#define kStrokeEnd           @"strokeEnd"
#define kStrokeEndAnimation  @"strokeEndAnimation"
@interface ZPPercentView ()
//整个圆的layer
//@property (nonatomic, strong) CAShapeLayer *trackLayer;
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
@end
@implementation ZPPercentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}
#pragma mark - UI
- (void)setUpUI{
    self.progressColor = [UIColor greenColor];
    self.duration = 3;
    self.pathWidth = self.bounds.size.width;
    [self shadowImageView];
    [self gradientLayer];
}
#pragma mark - Load
- (void)loadLayer:(CAShapeLayer *)layer withColor:(UIColor *)color{
    CGFloat layerWidth = self.pathWidth;
    CGFloat layerX = (self.bounds.size.width - layerWidth)/2;
    layer.frame = CGRectMake(layerX, layerX, layerWidth, layerWidth);
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineCap = kCALineCapButt;
    layer.lineWidth = self.lineWidth;
    layer.path = self.path.CGPath;
}
#pragma mark - Animation
- (void)updateZPPercent:(CGFloat)percent openAnimation:(BOOL)animation{
    self.percent = percent;
    [self.progressLayer removeAllAnimations];
    if (!animation) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [CATransaction setAnimationDuration:1];
        self.progressLayer.strokeEnd = self.percent/100.0;
        [CATransaction commit];
    }else{
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:kStrokeEnd];
        animation.fromValue = @(0.0);
        animation.toValue = @(self.percent/100.0);
        animation.duration = self.duration*self.percent/100;
        animation.removedOnCompletion = YES;
        animation.delegate = self;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        self.progressLayer.strokeEnd = self.percent/100;
        [self.progressLayer addAnimation:animation forKey:kStrokeEndAnimation];
    }
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
    self.timer = [NSTimer timerWithTimeInterval:1/60.f target:self selector:@selector(timerStartAction) userInfo:nil repeats:YES    ];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)timerStartAction{
    id strokeEnd = [[_progressLayer presentationLayer]valueForKey:kStrokeEnd];
    if (![strokeEnd isKindOfClass:[NSNumber class]]) {
        return;
    }
    CGFloat progress = [strokeEnd floatValue];
    self.progressLabel.text = [NSString stringWithFormat:@"%0.f%%",floorf(progress*100)];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [self invalidateTimer];
        self.progressLabel.text = [NSString stringWithFormat:@"%0.f%%",self.percent];
    }
}
- (void)invalidateTimer{
    if (!self.timer) {
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark - Lazy Load
- (UIImageView *)shadowImageView{
    if (!_shadowImageView) {
        _shadowImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _shadowImageView.image = [UIImage imageNamed:@"shadow"];
        [self addSubview:_shadowImageView];
    }
    return _shadowImageView;
}
- (CAShapeLayer *)progressLayer{
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        [self loadLayer:_progressLayer withColor:self.progressColor];
        [self.layer addSublayer:_progressLayer];
    }
    return _progressLayer;
}
- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(id)[UIColor redColor].CGColor,
                                  (id)[UIColor yellowColor].CGColor
                            
                                  ];
        [_gradientLayer setStartPoint:CGPointMake(0.5, 1.0)];
        [_gradientLayer setEndPoint:CGPointMake(0.5, 0.0)];
        
        [_gradientLayer setMask:self.progressLayer];
        [self.layer addSublayer:_gradientLayer];
    }
    return _gradientLayer;
}
- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _progressLabel.textColor = [UIColor colorWithRed:0.310 green:0.627 blue:0.984 alpha:1.000];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:38];
        
        [self addSubview:_progressLabel];
    }
    return _progressLabel;
}

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    _percent = _percent > 100 ? 100 : _percent;
    _percent = _percent < 0 ? 0 : _percent;
}

- (UIBezierPath *)path {
    if (!_path) {
        
        CGFloat halfWidth = self.pathWidth / 2;
        _path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(halfWidth, halfWidth)
                                               radius:(self.pathWidth - self.lineWidth)/2
                                           startAngle:-M_PI/2*3
                                             endAngle:M_PI/2
                                            clockwise:YES];
    }
    return _path;
}

- (CGFloat)lineWidth {
    if (_lineWidth == 0) {
        _lineWidth = 2.5;
    }
    return _lineWidth;
}
@end
