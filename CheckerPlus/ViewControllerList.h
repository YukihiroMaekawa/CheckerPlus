//
//  ViewControllerList.h
//  test_20140416
//
//  Created by 前川 幸広 on 2014/04/16.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrMaster.h"
#import "DBConnector.h"

@interface ViewControllerList : UIViewController<UITableViewDelegate
,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate>

{
    TrMaster   *_trMaster;
    DBConnector *_db;
    NSMutableArray *_tableKey;
    NSMutableArray *_tableVal;
    NSMutableArray *_tableLabelTag;

    NSInteger _keyListId;
    NSString  *_text_hd;
    
    CGRect _tableFrame;
    bool   _isTableFrameEdit;
    NSInteger _runMode; //1:選択 2:編集
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
