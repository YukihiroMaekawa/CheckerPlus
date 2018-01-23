//
//  EntityDTrHd.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/30.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "EntityDListHd.h"
#import "DBConnector.h"

@implementation EntityDListHd
// 初期化
- (id)init
{
    if (self = [super init])
    {
        [self initProperty];
    }
    return self;
}

- (id)initWithSelect :(DBConnector *)db :(NSInteger)listId
{
    if (self = [super init])
    {
        [self initProperty];
        self.pKeyListId     = listId;
        
        //データ取得
        [self doSelect:db];
    }
    return self;
}

-(void) initProperty{
    self.pKeyListId   = 0;
    self.pSortNo      = 0;
    self.pTextHd      = @"";
    self.pTextDt      = @"";
    self.pLabelTag    = @"";
    self.pCheckOn     = @"";
    self.pCheckOff    = @"";
    self.pTempFlg     = @"";
}

-(NSInteger) getNextKey:(DBConnector *)db
{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT IFNULL(MAX(list_id) ,0) + 1 AS list_id"
           "  FROM d_list_hd"
           ];
    
    [db executeQuery:sql];
    
    NSInteger keyValue = 0;
    
    while ([db.results next]) {
        keyValue = [db.results intForColumn:@"list_id"];
    }

    return (int) keyValue;
}

-(NSInteger) getNextSortNo:(DBConnector *)db
{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT IFNULL(MAX(sort_no) ,0) + 1 AS sort_no"
           "  FROM d_list_hd"
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
           ",sort_no"
           ",text_hd"
           ",text_dt"
           ",label_tag"
           ",check_on"
           ",check_off"
           ",temp_flg"
           "    FROM d_list_hd"
           "   WHERE list_id = %d"
           ,(int)self.pKeyListId
        ];
    
    
    [db executeQuery:sql];
    
    while ([db.results next]) {
        self.pSortNo      = [db.results intForColumn:@"sort_no"];
        self.pTextHd      = [db.results stringForColumn:@"text_hd"];
        self.pTextDt      = [db.results stringForColumn:@"text_dt"];
        self.pLabelTag    = [db.results stringForColumn:@"label_tag"];
        self.pCheckOn     = [db.results stringForColumn:@"check_on"];
        self.pCheckOff    = [db.results stringForColumn:@"check_off"];
        self.pTempFlg     = [db.results stringForColumn:@"temp_flg"];

    }
}

-(void) doInsert:(DBConnector *)db{
    NSString *sql;
    
    sql = [NSString stringWithFormat
           :@"INSERT INTO d_list_hd"
           "("
           " list_id"
           ",sort_no"
           ",text_hd"
           ",text_dt"
           ",label_tag"
           ",check_on"
           ",check_off"
           ",temp_flg"
           ")"
           " SELECT"
           "  %d"
           ", %d"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ,(int)self.pKeyListId
           ,(int)self.pSortNo
           ,self.pTextHd
           ,self.pTextDt
           ,self.pLabelTag
           ,self.pCheckOn
           ,self.pCheckOff
           ,self.pTempFlg
           ];
    [db executeUpdate:sql];
}

-(void) doUpdate :(DBConnector *)db{
    NSString *sql;

    sql = [NSString stringWithFormat
           :@"UPDATE d_list_hd"
           "     SET sort_no     = %d"
           "        ,text_hd     = '%@'"
           "        ,text_dt     = '%@'"
           "        ,label_tag   = '%@'"
           "        ,check_on    = '%@'"
           "        ,check_off   = '%@'"
           "        ,temp_flg    = '%@'"
           "   WHERE list_id = %d"
           ,(int)self.pSortNo
           ,self.pTextHd
           ,self.pTextDt
           ,self.pLabelTag
           ,self.pCheckOn
           ,self.pCheckOff
           ,self.pTempFlg
           ,(int)self.pKeyListId
           ];
    [db executeUpdate:sql];
}

-(void) doDelete :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"DELETE FROM d_list_hd"
           "   WHERE list_id  = %d"
           ,(int)self.pKeyListId
           ];
    [db executeUpdate:sql];

    sql = [NSString stringWithFormat
           :@"DELETE FROM d_list_dt"
           "   WHERE list_id  = %d"
           ,(int)self.pKeyListId
           ];
    [db executeUpdate:sql];

}

@end
