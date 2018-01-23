//
//  DBConnector.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "DBConnector.h"
#import "FMDatabase.h"

@implementation DBConnector
static NSString *const DBNAME = @"app.db";

// 初期化
- (id)init
{
    if (self = [super init])
    {
        //DB情報取得
        _docPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
        _docDir   = [_docPaths objectAtIndex:0];
        //パスの最後にファイル名をアペンドし、DBファイルへのフルパスを生成。
        _docDir = [_docDir stringByAppendingPathComponent:DBNAME];
        
        //DBファイルがDocument配下に存在するか判定
        self.db = [FMDatabase databaseWithPath:_docDir];

        //DB作成・参照実行
        [self.db open];
        [self.db close];
    }
    
    return self;
}

- (void) dbOpen{
    [self.db open];
}

- (void) dbClose{
    [self.db close];
}

- (void) executeUpdate:(NSString *) sql{
    [_db executeUpdate:sql];
}

- (void) executeQuery:(NSString *) sql{
    self.results = [_db executeQuery:sql];
}

- (void) resultsClose{
    [self.results close];
}

@end
