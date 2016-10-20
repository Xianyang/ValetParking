//
//  TopScroller.h
//  Guangyingji
//
//  Created by 罗 显扬 on 14/12/13.
//  Copyright (c) 2014年 罗 显扬. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopScroller;
@protocol TopScrollerDelegate <NSObject>

@required

// ask the delegate how many views he wants to present inside the top scroller
- (NSInteger)numberOfViewsForTopScroller:(TopScroller *)scroller;

// ask the delegate to return the  view that should appear at <index>
- (UIView *)topScroller:(TopScroller *)scroller viewAtIndex:(int)index;

// ask the delegate to return the first or the last view
- (UIView *)topScroller:(TopScroller *)scroller viewAtFirstOfLast:(BOOL)isFirst;

// inform the delegate what the view at <index> has been clicked
- (void)topScroller:(TopScroller *)scroller clickedViewAtIndex:(int)index;

@end

@interface TopScroller : UIView

@property (weak) id <TopScrollerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (void)setupScroller;
- (void)reload;

@end
