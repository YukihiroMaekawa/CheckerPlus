//
//  EntityDTrHd.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/30.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnector.h"

@interface EntityDListHd : NSObject

@property (nonatomic)           NSInteger pKeyListId;
@property (nonatomic)           NSInteger pSortNo;
@property (nonatomic)           NSString *pTextHd;
@property (nonatomic)           NSString *pTextDt;
@property (nonatomic)           NSString *pLabelTag;
@property (nonatomic)           NSString *pCheckOn;
@property (nonatomic)           NSString *pCheckOff;
@property (nonatomic)           NSString *pTempFlg;

- (id)initWithSelect :(DBConnector *)db :(NSInteger)listId;
-(NSInteger) getNextKey:(DBConnector *)db;
-(NSInteger) getNextSortNo:(DBConnector *)db;
-(void) doInsert :(DBConnector *)db;
-(void) doUpdate :(DBConnector *)db;
-(void) doDelete :(DBConnector *)db;
@end
