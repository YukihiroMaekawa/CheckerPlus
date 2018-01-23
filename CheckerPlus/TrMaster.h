//
//  TrMaster.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnector.h"

@interface TrMaster : NSObject
{
    DBConnector *_db;
}
- (void) resetAllData;
- (void) dbInit;
@end
