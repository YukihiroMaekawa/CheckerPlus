//
//  EntityDListDt.m
//  test_20140416
//
//  Created by 前川 幸広 on 2014/04/20.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "EntityDListDt.h"
#import "DBConnector.h"

@implementation EntityDListDt
// 初期化
- (id)init
{
    if (self = [super init])
    {
        [self initProperty];
    }
    return self;
}

- (id)initWithSelect :(DBConnector *)db :(NSInteger)listId :(NSInteger)listId2
{
    if (self = [super init])
    {
        [self initProperty];
        self.pKeyListId  = listId;
        self.pKeyListId2 = listId2;
        
        //データ取得
        [self doSelect:db];
    }
    return self;
}

-(void) initProperty{
    self.pKeyListId   = 0;
    self.pKeyListId2  = 0;
    self.pSortNo      = 0;
    self.pTextHd      = @"";
    self.pTextDt      = @"";
    self.pLabelTag    = @"";
    self.pCheckFlg    = @"";
}

-(NSInteger) getNextKey:(DBConnector *)db :(NSInteger)listId
{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT IFNULL(MAX(list_id2) ,0) + 1 AS list_id2"
           "  FROM d_list_dt"
           "   WHERE list_id = %d"
           ,(int)listId
           ];
    
    [db executeQuery:sql];
    
    NSInteger keyValue = 0;
    
    while ([db.results next]) {
        keyValue = [db.results intForColumn:@"list_id2"];
    }
    
    return (int) keyValue;
}

-(NSInteger) getNextSortNo:(DBConnector *)db :(NSInteger)listId
{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT IFNULL(MAX(sort_no) ,0) + 1 AS sort_no"
           "  FROM d_list_dt"
           " WHERE list_id = %d"
           ,(int)listId
           ];
    
    [db executeQuery:sql];
    
    NSInteger keyValue = 0;
    
    while ([db.results next]) {
        keyValue = [db.results intForColumn:@"sort_no"];
    }
    
    return (int) keyValue;
}

-(void) doSelect:(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT "
           " list_id"
           ",list_id2"
           ",sort_no"
           ",text_hd"
           ",text_dt"
           ",label_tag"
           ",check_flg"
           ",temp_flg"
           "    FROM d_list_dt"
           "   WHERE list_id  = %d"
           "     AND list_id2 = %d"
           ,(int)self.pKeyListId
           ,(int)self.pKeyListId2
           ];
    
    [db executeQuery:sql];
    
    while ([db.results next]) {
        self.pSortNo      = [db.results intForColumn:@"sort_no"];
        self.pTextHd      = [db.results stringForColumn:@"text_hd"];
        self.pTextDt      = [db.results stringForColumn:@"text_dt"];
        self.pLabelTag    = [db.results stringForColumn:@"label_tag"];
        self.pCheckFlg    = [db.results stringForColumn:@"check_flg"];
        self.pTempFlg     = [db.results stringForColumn:@"temp_flg"];
    }
}

-(void) doInsert:(DBConnector *)db{
    NSString *sql;
    
    sql = [NSString stringWithFormat
           :@"INSERT INTO d_list_dt"
           "("
           " list_id"
           ",list_id2"
           ",sort_no"
           ",text_hd"
           ",text_dt"
           ",label_tag"
           ",check_flg"
           ",temp_flg"
           ")"
           " SELECT"
           "  %d"
           ", %d"
           ", %d"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ,(int)self.pKeyListId
           ,(int)self.pKeyListId2
           ,(int)self.pSortNo
           ,self.pTextHd
           ,self.pTextDt
           ,self.pLabelTag
           ,self.pCheckFlg
           ,self.pTempFlg
           ];
    [db executeUpdate:sql];
}

-(void) doUpdate :(DBConnector *)db{
    NSString *sql;
    
    sql = [NSString stringWithFormat
           :@"UPDATE d_list_dt"
           "     SET sort_no     = %d"
           "        ,text_hd     = '%@'"
           "        ,text_dt     = '%@'"
           "        ,label_tag   = '%@'"
           "        ,check_flg   = '%@'"
           "        ,temp_flg    = '%@'"
           "   WHERE list_id  = %d"
           "     AND list_id2 = %d"
           ,(int)self.pSortNo
           ,self.pTextHd
           ,self.pTextDt
           ,self.pLabelTag
           ,self.pCheckFlg
           ,self.pTempFlg
           ,(int)self.pKeyListId
           ,(int)self.pKeyListId2
           ];
    [db executeUpdate:sql];
}

-(void) doDelete :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"DELETE FROM d_list_dt"
           "   WHERE list_id  = %d"
           "     AND list_id2 = %d"
           ,(int)self.pKeyListId
           ,(int)self.pKeyListId2
           ];
    [db executeUpdate:sql];
}

@end
