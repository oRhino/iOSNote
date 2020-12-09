//
//  MMCache.m
//  iOS
//
//  Created by cyzone on 2020/1/8.
//  Copyright © 2020 CYZone. All rights reserved.
//

#import "MMCache.h"



@implementation MMCache


static MMCache *_class = nil;

+ (instancetype)defaultSinglen{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _class = [[self alloc]init];
    });
    return _class;
}



@end
