//
//  DBConnector.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface DBConnector : NSObject
{
    NSArray*  _docPaths;
    NSString* _docDir;
}
@property (nonatomic) FMDatabase* db;
@property (nonatomic) FMResultSet* results;
- (void) dbOpen;
- (void) dbClose;
- (void) executeUpdate:(NSString *) sql;
- (void) executeQuery:(NSString *) sql;
- (void) resultsClose;

@end

