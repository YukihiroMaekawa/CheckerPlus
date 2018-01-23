//
//  EntityDListDt.h
//  test_20140416
//
//  Created by 前川 幸広 on 2014/04/20.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnector.h"

@interface EntityDListDt : NSObject
@property (nonatomic)           NSInteger pKeyListId;
@property (nonatomic)           NSInteger pKeyListId2;
@property (nonatomic)           NSInteger pSortNo;
@property (nonatomic)           NSString *pTextHd;
@property (nonatomic)           NSString *pTextDt;
@property (nonatomic)           NSString *pLabelTag;
@property (nonatomic)           NSString *pCheckFlg;
@property (nonatomic)           NSString *pTempFlg;

- (id)initWithSelect :(DBConnector *)db :(NSInteger)listId :(NSInteger)listId2;
-(NSInteger) getNextKey:(DBConnector *)db :(NSInteger)listId;
-(NSInteger) getNextSortNo:(DBConnector *)db :(NSInteger)listId;
-(void) doInsert :(DBConnector *)db;
-(void) doUpdate :(DBConnector *)db;
-(void) doDelete :(DBConnector *)db;
@end
