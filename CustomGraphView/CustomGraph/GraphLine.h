//
//  GraphLine.h
//  mworkingHaier
//
//  Created by Saborka on 26/12/2016.
//  https://github.com/Saborka/CustomGraphView
//

#import <UIKit/UIKit.h>
#import "GraphPopView.h"
#import "GraphDot.h"

@class GraphLine;

@protocol GraphCurrentSelectDelegate <NSObject>

@optional

//当前高亮
- (void)graphLineView:(GraphLine *)graphLine currentSelectIndex:(NSInteger)index;

@end

@interface GraphLine : UIView

@property (weak, nonatomic) id <GraphCurrentSelectDelegate> delegate;
@property (strong, nonatomic) GraphDot *dot;
@property (strong, nonatomic) GraphPopView *pop;
@property (strong, nonatomic) UIColor *lineColor;
@property (strong, nonatomic) UIColor *lineAlphaColor;
@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) NSArray *valueArray;
@property (assign, nonatomic) CGFloat xScaleLength;
@property (assign, nonatomic) CGFloat maxValue;

- (void)reloadDataWithAnimation:(BOOL)animation;

@end
