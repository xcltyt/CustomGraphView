//
//  GraphLine.m
//  mworkingHaier
//
//  Created by Saborka on 26/12/2016.
//  Copyright © 2016 CaiGaoBaDou. All rights reserved.
//

#import "GraphLine.h"
#import "GraphDot.h"
#import "GraphConstants.h"
#import "UIView+mySize.h"

@interface GraphLine ()

/**
 *  存储折线上每个点,方便后续处理
 */
@property (strong, nonatomic) NSMutableArray *pointArray;
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (assign, nonatomic) NSInteger lastSelectIndex;

@end

@implementation GraphLine

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lastSelectIndex = -1;
    }
    return self;
}

- (void)reloadDataWithAnimation:(BOOL)animation
{
    [self clear];
    [self drawLine];
    [self drawGradient];
    [self createCovers];
}

/**
 *  画折线图
 */
- (void)drawLine
{
    self.pointArray = [NSMutableArray array];
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    for (int i = 0; i < self.valueArray.count; i++) {
        CGFloat pointX = self.xScaleLength * i;
        CGFloat value = [self.valueArray[i] floatValue];
        CGFloat percent = value / self.maxValue;
        CGFloat pointY = (1 - percent) * GraphTotalHeight;
        CGPoint point = CGPointMake(pointX, pointY);
        [self.pointArray addObject:[NSValue valueWithCGPoint:point]];
        
        if (i == 0) {
            [linePath moveToPoint:point];
        } else {
            [linePath addLineToPoint:point];
        }
    }
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.zPosition = 0.0f;
    _shapeLayer.strokeColor = _lineColor.CGColor;
    _shapeLayer.lineWidth = _lineWidth;
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.lineJoin = kCALineJoinRound;
    _shapeLayer.frame = self.frame;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.path = linePath.CGPath;
    [self.layer addSublayer:_shapeLayer];
    
}

- (void)drawGradient
{
    /**
     *  添加渐变色
     */
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(__bridge id)_lineAlphaColor.CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:0.1].CGColor];
    
    gradientLayer.locations= @[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0.0,0.0);
    gradientLayer.endPoint = CGPointMake(0.0,1);
    
    UIBezierPath *gradientPath = [[UIBezierPath alloc] init];
    //渐变面积的第一个点和最后一个点都是对应折线点最下面的点,中间的点与折线上的点相同
    [gradientPath moveToPoint:CGPointMake(0, GraphTotalHeight)];
    
    for (int i = 0; i < self.pointArray.count; i ++) {
        [gradientPath addLineToPoint:[self.pointArray[i] CGPointValue]];
    }
    
    CGPoint endPoint = [[self.pointArray lastObject] CGPointValue];
    endPoint = CGPointMake(endPoint.x, GraphTotalHeight);
    [gradientPath addLineToPoint:endPoint];
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = gradientPath.CGPath;
    gradientLayer.mask = arc;
    [self.layer addSublayer:gradientLayer];
}

/**
 *  分散一个个的可点击区域
 */
- (void)createCovers
{
    for (int i = 0; i < self.pointArray.count; i++) {
        UIView *cover = [[UIView alloc] init];
        cover.tag = BaseCoverTag + i;
        
        if (i == 0) {
            cover.frame = CGRectMake(0, 0, self.xScaleLength / 2, GraphTotalHeight);
            [self addSubview:cover];
        }
        else if (i == self.pointArray.count - 1) {
            CGPoint lastPoint = [[self.pointArray objectAtIndex:i] CGPointValue];
            cover.frame = CGRectMake(lastPoint.x - self.xScaleLength / 2, 0, self.xScaleLength / 2, GraphTotalHeight);
            [self addSubview:cover];
        }
        else {
            CGPoint point = [[self.pointArray objectAtIndex:i] CGPointValue];
            cover.frame = CGRectMake(point.x - self.xScaleLength / 2, 0, self.xScaleLength, GraphTotalHeight);
            [self addSubview:cover];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverTapped:)];
        [cover addGestureRecognizer:tap];
    }
}

- (void)coverTapped:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag - BaseCoverTag;
    CGPoint point = [[self.pointArray objectAtIndex:index] CGPointValue];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(graphLineView:currentSelectIndex:)]) {
        [self.delegate graphLineView:self currentSelectIndex:index];
    }
    
    /**
     *  圆环及浮层
     */
    
    if (self.lastSelectIndex != -1) {
        GraphDot *lastDot = (GraphDot *)[self viewWithTag:BaseDotTag + self.lastSelectIndex];
        [lastDot removeFromSuperview];
        
        GraphPopView *lastPop = (GraphPopView *)[self viewWithTag:BasePopTag + self.lastSelectIndex];
        [lastPop removeFromSuperview];
    }
    
    GraphDot *dot = [[GraphDot alloc] initWithCenter:point radius:DotRadius borderColor:self.lineColor];
    dot.tag = BaseDotTag + index;
    dot.dotBorderWidth = 1.5;
    [self addSubview:dot];
    
    GraphPopView *pop = [[GraphPopView alloc] initWithFrame:CGRectZero bgColor:self.lineColor string:[self.valueArray objectAtIndex:index]];
    pop.center = point;
    
    CGFloat popY = point.y + GapBetweenDotAndPop;
    if (popY + pop.height > GraphTotalHeight - GraphXBottomHeight) { //如果pop底端超过x坐标 就把popview放在dot上面
        popY = popY - 3 * GapBetweenDotAndPop;
    }
    pop.top = popY;
    pop.tag = index + BasePopTag;
    
    [self addSubview:pop];
    
    self.lastSelectIndex = index;
}

/**
 *  移除圆环,浮层
 */
- (void)clear
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    for (CALayer *subLayer in self.layer.sublayers) {
        [subLayer removeFromSuperlayer];
    }
}

@end
