//
//  GraphConstants.h
//  mworkingHaier
//
//  Created by Saborka on 27/12/2016.
//  Chttps://github.com/Saborka/CustomGraphView
//

#ifndef GraphConstants_h
#define GraphConstants_h

/**
 *  图总共高度
 */
#define GraphTotalHeight        245

/**
 *  X轴 底部高度
 */
#define GraphXBottomHeight      38

/**
 *  各种颜色
 */

#define LineBlueColor               RGB(90,189, 252)
#define LinePurpleColor             RGB(235,115, 246)
#define LineOrangeColor             RGB(249,112, 82)
#define BarYellowColor              RGBA(253,186, 113, 0.8)
#define BarBlueColor                RGBA(51,206, 245, 0.8)

#define LineBlueAlphaColor          RGBA(90, 189, 252, 0.8)
#define LinePurpleAlphaColor        RGBA(235,115, 246, 0.8)
#define LineOrangeAlphaColor        RGBA(249,112, 82, 0.8)
#define BarYellowAlphaColor         RGBA(253,186, 113, 0.8)
#define BarBlueAlphaColor           RGBA(51,206, 245, 0.8)

/**
 *  柱状图宽度和柱状图之前间距
 */
#define GraphBarWidthAndGap     12

/**
 *  折线固定宽度
 */

#define GraphLineWidth          2

/**
 *  X,Y轴坐标字号
 */
#define GraphFontSize           12

/**
 *  Y轴标题以及水平线颜色
 */
#define GraphYAxisFontColor     HEXCOLOR(0xdbdbdb)

/**
 *  X轴标题颜色
 */
#define GraphXAxisFontColor             HEXCOLOR(0xb3b3b3)
#define GraphXAxisHighlightFontColor    RGB(33,33, 33)

#define BaseCoverTag            1000
#define BaseDotTag              10000
#define BasePopTag              500
#define BaseXAxisTag            200


/**
 *  圆环的半径,描边
 */
#define DotRadius               6
#define DotBorderWidth          1.5

/**
 *  圆环和浮层间距
 */
#define GapBetweenDotAndPop     20

#endif /* GraphConstants_h */
