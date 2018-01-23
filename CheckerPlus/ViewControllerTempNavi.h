//
//  ViewControllerTempNavi.h
//  CheckerPlus
//
//  Created by 前川 幸広 on 2014/04/26.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerTempData.h"

@protocol ViewControllerTempNaviDelegate <UINavigationControllerDelegate>
// デリゲートメソッドを宣言
// （宣言だけしておいて，実装はデリゲート先でしてもらう）
- (void) testA:(NSInteger)listId;
@end


@interface ViewControllerTempNavi : UINavigationController
{
    ViewControllerTempData * _tempData;
}
@property (nonatomic, assign) id<ViewControllerTempNaviDelegate> delegate;
@property (nonatomic) NSInteger runMode; //1:選択 2:編集

@end
