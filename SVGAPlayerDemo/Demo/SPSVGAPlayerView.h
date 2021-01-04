//
//  SPSVGAPlayerView.h
//  SmartPiano
//
//  Created by hx on 2020/12/30.
//  Copyright © 2020 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SPSVGAPlayerView;

//@protocol SPSVGAPlayerParserProtocol <NSObject>
//
//@optional
//- (void)spsvgaPlayerParserDidLoadParser:(SPSVGAPlayerView *)player;
//- (void)spsvgaPlayerParserLoadFailureParser:(SPSVGAPlayerView *)player error:(NSError *)error;
//
//@end


@protocol SPSVGAPlayerDeleagte <NSObject>

@optional
- (void)spsvgaPlayerDidFinishedAnimation:(SPSVGAPlayerView *)player;
- (void)spsvgaPlayerDidAnimatedToFrame:(NSInteger)frame;
- (void)spsvgaPlayerDidAnimatedToPercentage:(CGFloat)percentage;

@end


@interface SPSVGAPlayerView : UIView

//@property(nonatomic, weak) id <SPSVGAPlayerParserProtocol>parseDelegate;
@property(nonatomic, weak) id <SPSVGAPlayerDeleagte>delegate;

@property(nonatomic, assign) int loops; //0 无线循环 循环次数

//init 默认自动加载完毕开启动画
- (instancetype)initWithFrame:(CGRect)frame
               parseWithNamed:(NSString *)named
                        loops:(int)loops;

- (instancetype)initWithFrame:(CGRect)frame
                 parseWithURL:(NSString *)urlString
                        loops:(int)loops;

//Pulic
- (void)startAnimation;
- (void)startAnimationWithRange:(NSRange)range reverse:(BOOL)reverse;
- (void)pauseAnimation;
- (void)stopAnimation;
- (void)clear;
- (void)stepToFrame:(NSInteger)frame andPlay:(BOOL)andPlay;
- (void)stepToPercentage:(CGFloat)percentage andPlay:(BOOL)andPlay;
- (void)setAnimationNamed:(NSString *)named;

@end

NS_ASSUME_NONNULL_END
