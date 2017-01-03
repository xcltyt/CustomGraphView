//
//  RootViewController.m
//  CustomGraphView
//
//  Created by Saborka on 3/1/2017.
//  https://github.com/Saborka/CustomGraphView
//

#import "RootViewController.h"
#import "GraphView.h"

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet GraphView *myGraph;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    NSArray *xTitles = @[@"北京分公司",@"上海分公司",@"华东大区", @"临沂分公司",@"美国分公司",@"日本大区", @"尼古拉分公司",@"尼玛分公司",@"嘎嘎大区"];
    CGFloat xScaleLength = 90;
    NSArray *targetArray = @[@"1400",@"4200",@"1800",@"2000",@"3000",@"2800",@"4000",@"3400",@"1900"];
    NSArray *actualArray = @[@"1400",@"4200",@"2800",@"1000",@"3000",@"4800",@"2800",@"2000",@"1900"];

    NSArray *yTitles = @[@"5000",@"4000",@"3000",@"2000",@"1000"];
    NSArray *targetBarArray = @[@"1000",@"2000",@"3000",@"1200",@"3000",@"2800",@"700",@"3400",@"1900"];
    NSArray *actualBarArray = @[@"3400",@"1200",@"3800",@"2000",@"4500",@"3800",@"3000",@"1400",@"4900"];
    CGFloat maxValue = 5000;
    
    
    self.myGraph.xTitleArray = xTitles;
    self.myGraph.yTitleArray = yTitles;
    self.myGraph.xScaleLength = xScaleLength;
    self.myGraph.targetValues = targetArray;
    self.myGraph.actualValues = actualArray;
    self.myGraph.yMaxValue = maxValue;
    self.myGraph.actualBarValues = actualBarArray;
    self.myGraph.targetBarValues = targetBarArray;
    self.myGraph.needBar = YES;
    [self.myGraph drawGraph];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
