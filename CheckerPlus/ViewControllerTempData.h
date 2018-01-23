//
//  ViewControllerTempData.h
//  CheckerPlus
//
//  Created by 前川 幸広 on 2014/04/26.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewControllerTempData : NSObject{}
+ (ViewControllerTempData *)sharedManager;
@property (nonatomic) NSInteger runMode; //1:選択 2:編集
@property (nonatomic) NSInteger listId;
@end
