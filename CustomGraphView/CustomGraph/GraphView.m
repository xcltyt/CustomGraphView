
//
//  GraphView.m
//  mworkingHaier
//
//  Created by Saborka on 26/12/2016.
//  https://github.com/Saborka/CustomGraphView
//

#import "GraphView.h"
#import "DashesLineView.h"
#import "GraphLine.h"
#import "GraphConstants.h"
#import "GraphBar.h"
#import "header.h"


@interface GraphView () <UIScrollViewDelegate, GraphCurrentSelectDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
/**
 *  目标 折线
 */
@property (strong, nonatomic) GraphLine *targetLine;

/**
 *  实际折线
 */
@property (strong, nonatomic) GraphLine *actualLine;

//X轴底部view
@property (strong, nonatomic) UIView *bottomView;


@end

@implementation GraphView

- (void)drawGraph
{
    self.width = [UIScreen mainScreen].bounds.size.width;
    self.height = GraphTotalHeight;
    [self addSubview:self.scrollView];
    [self drawGrid];
    [self drawLine];
    if (_needBar) {
        [self drawBar];
    }
}

/**
 *  先画格子
 */

- (void)drawGrid
{
    [self drawXAxis];
    [self drawYAxis];
}

/**
 *  画x坐标
 */

- (void)drawXAxis
{
    //底部
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - GraphXBottomHeight, MainScreenWidth, GraphXBottomHeight)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.5)];
    lineView.backgroundColor = HEXCOLOR(0xf5f5f5);
    [self.bottomView addSubview:lineView];
    
    [self.scrollView addSubview:self.bottomView];
    
    for (int i = 0; i < _xTitleArray.count; i++) {
        UILabel *axisLabel = [self createAxisLabelIsXaxis:YES];
        axisLabel.tag = BaseXAxisTag + i;
        axisLabel.text = [_xTitleArray objectAtIndex:i];
        axisLabel.left = _xScaleLength * i;
        [self.bottomView addSubview:axisLabel];
    }
}

/**
 *  画y坐标
 */

- (void)drawYAxis
{
    for (int i = 0; i < _yTitleArray.count; i++) {
        //水平辅助线
        DashesLineView *line = [[DashesLineView alloc] initWithFrame:CGRectMake(0, GraphTotalHeight / _yTitleArray.count * i, MainScreenWidth, 1)];
        [self addSubview:line];
        [self sendSubviewToBack:line];
        
        //字
        if (i > 0) {
            UILabel *numLabel = [self createAxisLabelIsXaxis:NO];
            numLabel.bottom = line.top;
            numLabel.text = [_yTitleArray objectAtIndex:i];
            [self addSubview:numLabel];
            [self sendSubviewToBack:numLabel];
        }
    }
}

- (UILabel *)createAxisLabelIsXaxis:(BOOL)xAxis
{
    
    CGFloat left = xAxis ? 0 : 50;
    CGFloat width = xAxis ? _xScaleLength : MainScreenWidth - 50 - 10;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, width, GraphXBottomHeight)];
    label.textColor = xAxis ? GraphXAxisFontColor : GraphYAxisFontColor;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:GraphFontSize];
    label.textAlignment = xAxis ? NSTextAlignmentCenter : NSTextAlignmentRight;
    return label;
}

- (void)reloadData
{
    
}

/**
 *  画折线
 */

- (void)drawLine
{
    self.targetLine = [self createLineIsTarget:YES];
    self.actualLine = [self createLineIsTarget:NO];
    [self.scrollView addSubview:self.targetLine];
    [self.scrollView addSubview:self.actualLine];
    [self.targetLine reloadDataWithAnimation:YES];
    [self.actualLine reloadDataWithAnimation:YES];
}

- (GraphLine *)createLineIsTarget:(BOOL)isTarget
{
    GraphLine *line = [[GraphLine alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height - GraphXBottomHeight)];
    line.delegate = self;
    line.xScaleLength = self.xScaleLength;
    line.lineWidth = 2;
    line.maxValue = self.yMaxValue;
    if (isTarget) {
        line.lineColor = LineBlueColor;
        line.lineAlphaColor = LineBlueAlphaColor;
        line.valueArray = self.targetValues;
    } else {
        line.lineColor = self.isDeal ? LinePurpleColor : LineOrangeColor;
        line.lineAlphaColor = self.isDeal ? LinePurpleAlphaColor : LineOrangeAlphaColor;
        line.valueArray = self.actualValues;
    }
    return line;
}

/**
 *  画柱状图
 */
- (void)drawBar
{
    CGFloat targetX = (self.xScaleLength - 3*GraphBarWidthAndGap) / 2;
    CGFloat actualX = targetX + GraphBarWidthAndGap * 2;
    for (int i = 0; i < self.targetBarValues.count; i++) {
        GraphBar *targetBar = [[GraphBar alloc] initWithFrame:CGRectMake(targetX + self.xScaleLength * i, 0, GraphBarWidthAndGap, self.height - GraphXBottomHeight-1)];
        targetBar.barColor = BarBlueColor;
        CGFloat targetValue = [[self.targetBarValues objectAtIndex:i] floatValue] / self.yMaxValue;
        targetBar.barValue = targetValue;
        [_scrollView addSubview:targetBar];
    }
    
    for (int i = 0; i < self.actualBarValues.count; i++) {
        GraphBar *actualBar = [[GraphBar alloc] initWithFrame:CGRectMake(actualX+ self.xScaleLength * i, 0, GraphBarWidthAndGap, self.height - GraphXBottomHeight-1)];
        actualBar.barColor = BarYellowColor;
        CGFloat actualValue = [[self.actualBarValues objectAtIndex:i] floatValue] / self.yMaxValue;
        actualBar.barValue = actualValue;
        [_scrollView addSubview:actualBar];
    }
}

//高亮当前的x轴
- (void)graphLineView:(GraphLine *)graphLine currentSelectIndex:(NSInteger)index
{
    
    for (int i = 0; i < self.xTitleArray.count; i++) {
        UILabel *label = (UILabel *)[self.bottomView viewWithTag:i + BaseXAxisTag];
        if (i == index) {
            [label setTextColor:GraphXAxisHighlightFontColor];
        } else {
            [label setTextColor:GraphXAxisFontColor];
        }
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.maximumZoomScale = 2;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(_xScaleLength * _xTitleArray.count, self.height);
    }
    return _scrollView;
}

@end
