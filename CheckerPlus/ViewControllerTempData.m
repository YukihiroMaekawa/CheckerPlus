//
//  ViewControllerTempData.m
//  CheckerPlus
//
//  Created by 前川 幸広 on 2014/04/26.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerTempData.h"

static ViewControllerTempData* sharedParth = nil;

@implementation ViewControllerTempData

+ (ViewControllerTempData *)sharedManager{
    if (!sharedParth) {
        sharedParth = [ViewControllerTempData new];
    }
    return sharedParth;
}

- (id)init
{
    self = [super init];
    if (self) {
        //Initialization
    }
    return self;
}
@end