//
//  ViewControllerTemp.h
//  test_20140416
//
//  Created by 前川 幸広 on 2014/04/17.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrMaster.h"
#import "DBConnector.h"
#import "ViewControllerTempData.h"

@interface ViewControllerTemp : UIViewController<UITableViewDelegate
,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate>
{
    
    TrMaster   *_trMaster;
    DBConnector *_db;
    ViewControllerTempData * _tempData;

    NSMutableArray *_tableKey;
    NSMutableArray *_tableVal;
    NSMutableArray *_tableLabelTag;
    
    NSInteger _keyListId;
    NSString  *_text_hd;
    
    CGRect _tableFrame;
    bool   _isTableFrameEdit;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
