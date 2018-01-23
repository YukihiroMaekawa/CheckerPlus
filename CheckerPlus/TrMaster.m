//
//  TrMaster.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "TrMaster.h"
#import "DBConnector.h"

@implementation TrMaster

// 初期化
- (id)init
{
    if (self = [super init])
    {
        //DB作成
        _db = [[DBConnector alloc]init];
    }
    return self;
}

- (void) resetAllData{
    //DB全削除→作成
    [self dbDrop];
    [self dbInit];
    
}

- (void) dbDrop{
    NSString *sql;
    
    [_db dbOpen];
    
    // テーブル削除
    sql = @"DROP TABLE IF EXISTS d_list_hd";    [_db executeUpdate:sql];
    sql = @"DROP TABLE IF EXISTS d_list_dt";    [_db executeUpdate:sql];

    [_db dbClose];

}

- (void) dbInit{
    NSString *sql;
    
    [_db dbOpen];
    
    // リストHd
    sql = @"CREATE TABLE IF NOT EXISTS d_list_hd"
    "("
    " list_id           INTEGER"
    ",sort_no           INTEGER"
    ",text_hd           TEXT"
    ",text_dt           TEXT"
    ",label_tag         TEXT"
    ",check_on          TEXT"
    ",check_off         TEXT"
    ",temp_flg          TEXT"
    ",PRIMARY KEY(list_id)"
    ")";
    [_db executeUpdate:sql];

    // リストDt
    sql = @"CREATE TABLE IF NOT EXISTS d_list_dt"
    "("
    " list_id           INTEGER"
    ",list_id2          INTEGER"
    ",sort_no           INTEGER"
    ",text_hd           TEXT"
    ",text_dt           TEXT"
    ",label_tag         TEXT"
    ",check_flg         TEXT"
    ",temp_flg          TEXT"
    ",PRIMARY KEY(list_id ,list_id2)"
    ")";
    [_db executeUpdate:sql];

    [_db dbClose];
}
@end
