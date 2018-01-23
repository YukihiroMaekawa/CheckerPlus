//
//  ViewControllerList2.h
//  test_20140416
//
//  Created by 前川 幸広 on 2014/04/20.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBConnector.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface ViewControllerList2 : UIViewController<UITableViewDelegate
,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>

{
    DBConnector *_db;
    CGPoint _tableViewOffSet;

    NSMutableArray *_tableKey;
    NSMutableArray *_tableVal;
    NSMutableArray *_tableCheckMark;

    NSInteger _keyListId2;
    
    CGRect _tableFrame;
    bool   _isTableFrameEdit;

}

@property (nonatomic) NSString *navigationBarTitle;
@property (nonatomic) NSInteger keyListId;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
