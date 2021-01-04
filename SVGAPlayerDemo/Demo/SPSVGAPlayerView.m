//
//  SPSVGAPlayerView.m
//  SmartPiano
//
//  Created by hx on 2020/12/30.
//  Copyright © 2020 edz. All rights reserved.
//

#import "SPSVGAPlayerView.h"
#import <SVGAPlayer/SVGA.h>

@interface SPSVGAPlayerView()<SVGAPlayerDelegate>

@property(nonatomic, strong) SVGAPlayer *player;
@property(nonatomic, strong) SVGAParser *parser;

@end

@implementation SPSVGAPlayerView


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
               parseWithNamed:(NSString *)named
                        loops:(int)loops{
    if (self = [super initWithFrame:frame]) {
        _loops = loops;
        [self initDefault];
        [self configureParseNamed:named];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
                 parseWithURL:(NSString *)urlString
                        loops:(int)loops{
    if (self = [super initWithFrame:frame]) {
        _loops = loops;
        [self initDefault];
        [self configureParseUrl:urlString];
    }
    return self;
}

- (void)initDefault{
    
    _parser = [[SVGAParser alloc] init];
    _player = [[SVGAPlayer alloc]init];
    [self addSubview:_player];
    _player.delegate = self;
    _player.loops = _loops;
    _player.clearsAfterStop = YES;
}


- (void)configureParseNamed:(NSString *)named{

    [_parser parseWithNamed:named inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        if (videoItem != nil) {
            self.player.videoItem = videoItem;
            [self.player startAnimation];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)configureParseUrl:(NSString *)urlString{
    
    [_parser parseWithURL:[NSURL URLWithString:urlString] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        if (videoItem != nil) {
            self.player.videoItem = videoItem;
            [self.player startAnimation];
        }
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _player.frame = self.bounds;
}

- (void)dealloc{
    
}
#pragma mark - SVGAPlayerDelegate

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player{
    if (self.delegate && [self.delegate respondsToSelector:@selector(spsvgaPlayerDidFinishedAnimation:)]) {
        [self.delegate spsvgaPlayerDidFinishedAnimation:self];
    }
}

- (void)svgaPlayerDidAnimatedToFrame:(NSInteger)frame{
    if (self.delegate && [self.delegate respondsToSelector:@selector(spsvgaPlayerDidAnimatedToFrame:)]) {
        [self.delegate spsvgaPlayerDidAnimatedToFrame:frame];
    }
}

- (void)svgaPlayerDidAnimatedToPercentage:(CGFloat)percentage{
    if (self.delegate && [self.delegate respondsToSelector:@selector(spsvgaPlayerDidAnimatedToPercentage:)]) {
        [self.delegate spsvgaPlayerDidAnimatedToPercentage:percentage];
    }
}

#pragma mark - Public
- (void)startAnimation{
    [self.player startAnimation];
}

- (void)startAnimationWithRange:(NSRange)range reverse:(BOOL)reverse{
    [self.player startAnimationWithRange:range reverse:reverse];
}

- (void)pauseAnimation{
    [self.player pauseAnimation];
}

- (void)stopAnimation{
    [self.player stopAnimation];
}

- (void)clear{
    [self.player clear];
}

- (void)stepToFrame:(NSInteger)frame andPlay:(BOOL)andPlay{
    [self.player stepToFrame:frame andPlay:andPlay];
}

- (void)stepToPercentage:(CGFloat)percentage andPlay:(BOOL)andPlay{
    [self.player stepToPercentage:percentage andPlay:andPlay];
}

- (void)setAnimationNamed:(NSString *)named{
    if (named == nil) {
        //----资源为空
        return;
    }
    [_parser parseWithNamed:named inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        if (videoItem != nil) {
            self.player.videoItem = videoItem;
            [self.player startAnimation];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark - setter
- (void)setLoops:(int)loops{
    _loops = loops;
    self.player.loops = loops;
}

@end

