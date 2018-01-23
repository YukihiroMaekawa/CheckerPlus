//
//  ViewControllerList.m
//  test_20140416
//
//  Created by 前川 幸広 on 2014/04/16.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerList.h"
#import "ViewControllerList2.h"

#import "ViewControllerTempNavi.h"
#import "ViewControllerTemp.h"
#import "DBConnector.h"
#import "TrMaster.h"
#import "EntityDListHd.h"
#import "EntityDListDt.h"

@interface UIViewController ()

@end

@implementation ViewControllerList

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:1.0 green:0.2 blue:0 alpha:1.000];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [self setNavigationItemTitle];

    //DB作成
    _trMaster = [[TrMaster alloc]init];
    [_trMaster dbInit];
    
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // 編集時の複数選択指定
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //ツールバーを生成
    [self createToolBarItem];
    [self createTableData];
}

- (void) setNavigationItemTitle{
    NSString *titleStr;
    if([self isLocaleJapanese]){titleStr = @"チェックリスト";}else{titleStr = @"Check List";}
    self.navigationItem.title = titleStr;
}

// toolBar設定(通常)
- (void) createToolBarItem{
    self.navigationController.toolbarHidden = NO;
    self.toolbarItems = nil;

    //左のボタン
    UIBarButtonItem * barButtonLeft = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:(UIBarButtonSystemItemAction)
                                       target:self action:@selector(btnAction:)
                                       ];

    self.toolbarItems = @[barButtonLeft];
}

// toolBar設定(Edit)
- (void) createToolBarItemEdit{
    NSString *btnStr;
    
    self.navigationController.toolbarHidden = NO;
    self.toolbarItems = nil;
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                     target:nil
                                     action:nil];
    
    //左のボタン
    if([self isLocaleJapanese]){btnStr = @"すべて選択";}else{btnStr = @"Mark All";}
    UIBarButtonItem * barButtonLeft = [[UIBarButtonItem alloc]
                                       initWithTitle:btnStr
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(btnMarkAll:)
                                       ];

    //中のボタン
    UIBarButtonItem * barButtonCenter = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd)
                                         target:self action:@selector(btnAdd:)
                                         ];
    
    //右のボタン
    if([self isLocaleJapanese]){btnStr = @"ゴミ箱";}else{btnStr = @"Trash";}
    UIBarButtonItem * barButtonRight = [[UIBarButtonItem alloc]
                                        initWithTitle:btnStr
                                        style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(btnTrash:)
                                        ];
    
    self.toolbarItems = @[barButtonLeft ,flexibleItem ,barButtonCenter,flexibleItem ,barButtonRight];
    
}

// テーブルデータ作成
- (void) createTableData{
    _db = [[DBConnector alloc]init];
    
    _tableKey      = [[NSMutableArray alloc] init];
    _tableVal      = [[NSMutableArray alloc] init];
    _tableLabelTag = [[NSMutableArray alloc] init];

    [_db dbOpen];
    
    [_db executeQuery:[self getListHd] ];
    
    while ([_db.results next]) {
        [_tableKey addObject:[NSNumber numberWithInt:[_db.results intForColumn:@"list_id"]]];
        [_tableVal addObject:[_db.results stringForColumn:@"text_hd"]];
        [_tableLabelTag addObject:[_db.results stringForColumn:@"label_tag"]];
    }
    [_db dbClose];
}

- (NSString*)getListHd{
    NSString *sql;
    
    sql = [NSString stringWithFormat
           :@"SELECT list_id"
           "        ,text_hd"
           "        ,label_tag"
           "  FROM d_list_hd"
           " WHERE temp_flg = '0'"
           " ORDER BY sort_no"
           ];
    
    return sql;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    // 編集モード時のみ複数選択可能とする
    self.tableView.allowsMultipleSelectionDuringEditing = editing;
    [self.tableView setEditing:editing animated:animated];
    
    if(editing){
        // ツールバーのボタンを変更
        [self createToolBarItemEdit];
        
        // 編集時の複数選択指定
        self.editButtonItem.title = @"Done";
    }else{
        // ツールバーのボタンを変更
        [self createToolBarItem];

        self.editButtonItem.title = @"Edit";
    }
    
    //テーブルテキスト編集モード
    [self cellEditMode :editing];
}

- (void) cellEditMode:(BOOL) isEdit{
    NSArray * visibleCells = [self.tableView visibleCells];
    
    for (UITableViewCell *cell in visibleCells){
        for (UIControl *object in [cell.contentView subviews]) {
            if([object isMemberOfClass:[UIButton class]]){
                object.hidden = isEdit;
            }else{
                object.enabled = isEdit;
            }
        }
    }
}

/**
 * テーブルのセルの数を返す
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableVal count];
}

/**
 * 指定されたインデックスパスのセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITextField *textCell1;
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *imgStr;
    if([[_tableLabelTag objectAtIndex:indexPath.row] isEqualToString:@"0"]){
        imgStr = @"iconCell0.png";
    }else{
        imgStr = @"iconCell1.png";
    }
    UIImage *image = [UIImage imageNamed:imgStr];

    UIButton *btnCheck = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCheck.frame = CGRectMake(1, 1, 42, 42);
    [btnCheck setBackgroundImage:image
                         forState:UIControlStateNormal];
    btnCheck.imageView.contentMode = UIViewContentModeCenter;
    
    [cell.contentView addSubview:btnCheck];

    [btnCheck addTarget:self
                        action:@selector(btnCheck:)
              forControlEvents:UIControlEventTouchUpInside];
    if(self.tableView.isEditing){
        btnCheck.hidden= true;
    }else{
        btnCheck.hidden = false;
    }
    
    UIFont *uiFont = [UIFont systemFontOfSize:15.0];
    NSString *valueData;
    valueData = [_tableVal objectAtIndex:indexPath.row];
    textCell1 = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, 200, 45)];
    textCell1.textAlignment   = NSTextAlignmentLeft;
    textCell1.backgroundColor = [UIColor clearColor];
    textCell1.textColor       = [UIColor blackColor];
    [textCell1 setFont:uiFont];
    textCell1.text            = valueData;
    if([textCell1.text isEqualToString:@""]){
        NSString *str;
        if([self isLocaleJapanese]){str = @"入力してください";}else{str = @"Please enter";}
        textCell1.placeholder = str;
    }
    textCell1.delegate        = self;
    textCell1.tag             = indexPath.row + 1;
    
    if(self.tableView.isEditing){
        textCell1.enabled = true;
    }else{
        textCell1.enabled = false;
    }
    [cell.contentView addSubview:textCell1];

    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _keyListId = [NSString stringWithFormat:@"%@" ,[_tableKey objectAtIndex:indexPath.row]].intValue;
    _text_hd   = [_tableVal objectAtIndex:indexPath.row];
    
    if(!self.tableView.isEditing){        
        [self performSegueWithIdentifier:@"List2Segue" sender:self];
    }
}

// テーブル編集モード時アクション
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {   //削除
        _keyListId = [NSString stringWithFormat:@"%@" ,[_tableKey objectAtIndex:indexPath.row]].intValue;
        [self doDeleteListHd :(int)_keyListId];
        self.tableView.editing = NO;
        [self createTableData];
        [self.tableView reloadData];
    }
}

//移動を可とする
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//移動時処理
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndex toIndexPath:(NSIndexPath *)toIndex
{
    NSLog(@"%d  %d" ,(int)fromIndex.row ,(int)toIndex.row) ;
    
    int stIndex;
    int edIndex;
    int stSortNo;
    int moveKb;

    if(fromIndex == toIndex){return;}
    
    if(fromIndex < toIndex){
        moveKb  = 1; //後ろに移動
        stIndex = (int)fromIndex.row;
        edIndex = (int)toIndex.row;
    }else{
        moveKb  = 2; //前に移動
        stIndex = (int)toIndex.row;
        edIndex = (int)fromIndex.row;
    }

    //ソート番号振り直し基準のインデックスの値を取得しそこからインクリメントしていく
    int sortKey = [NSString stringWithFormat:@"%@" ,[_tableKey objectAtIndex:stIndex]].intValue;
    [_db dbOpen];
    EntityDListHd * entityDListHd = [[EntityDListHd alloc] initWithSelect:_db :sortKey];
    stSortNo = (int)entityDListHd.pSortNo;
    [_db dbClose];

    //移動先から移動元のソート順を振り直す
    for(int i = stIndex; i <=edIndex; i++){
        int idx;
        
        //後ろに移動した場合(from 0 to 3)
        if(moveKb == 1){
            //最終行(移動開始データのインデックス)
            if(i == toIndex.row){
                idx = stIndex;
            }else{
                idx = i + 1;
            }
        //前に移動した場合(from 3 to 0)
        }else{
            //先頭行(移動開始データのインデックス)
            if(i == toIndex.row){
                idx = edIndex;
            }else{
                idx = i - 1;
            }
        }
        // keyを取得
        int listKey = [NSString stringWithFormat:@"%@" ,[_tableKey objectAtIndex:idx]].intValue;
        [_db dbOpen];
        //ソート順を再設定
        EntityDListHd * entityDListHd = [[EntityDListHd alloc] initWithSelect:_db :listKey];
        entityDListHd.pSortNo = stSortNo;
        [entityDListHd doUpdate:_db];
        [_db dbClose];
        stSortNo ++;
    }

    [self createTableData];
    [self.tableView reloadData];

}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField{
    // テーブルのフレームを記憶
    if(!_isTableFrameEdit){
        _isTableFrameEdit = YES;
        _tableFrame = self.tableView.frame;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField*)textField{
    _keyListId = [NSString stringWithFormat:@"%@" ,[_tableKey objectAtIndex:textField.tag - 1]].intValue;
    [_db dbOpen];
    EntityDListHd * entityDListHd = [[EntityDListHd alloc] initWithSelect:_db :_keyListId];
    entityDListHd.pTextHd    =     textField.text;
    [entityDListHd doUpdate:_db];
    [_db dbClose];
    
    [_tableVal setObject:textField.text atIndexedSubscript:textField.tag -1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAction:(id)sender {
    // アクションシート例文
    UIActionSheet *as = [[UIActionSheet alloc] init];
    as.delegate = self;
//    as.title = @"選択してください。";
    if(self.tableView.isEditing){
    }else{
        if([self isLocaleJapanese]){
            [as addButtonWithTitle:@"テンプレートから追加"];               //テンプレートから追加
            [as addButtonWithTitle:@"テンプレートの作成と編集"]; //テンプレートの作成と編集
            [as addButtonWithTitle:@"キャンセル"];

        }else{
            [as addButtonWithTitle:@"Add from Template"];               //テンプレートから追加
            [as addButtonWithTitle:@"Creation and edit of a template"]; //テンプレートの作成と編集
            [as addButtonWithTitle:@"Cancel"];
        }
        as.cancelButtonIndex = 2;
    }
    as.destructiveButtonIndex = 0;
    [as showInView:self.view];  // ※下記参照
}

/**
 * アクションシートのボタンが押されたとき
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.tableView.isEditing){
        switch (buttonIndex) {
            //選択したデータを削除
            case 0:
                [self doDeleteSelectedItems];
                [self createTableData];
                [self.tableView reloadData];
                break;
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            //テンプレートから追加
            case 0:
                _runMode = 1;
                [self performSegueWithIdentifier:@"tempSegue" sender:self];
                break;
            //テンプレートの作成と編集
            case 1:
                _runMode = 2;
                [self performSegueWithIdentifier:@"tempSegue" sender:self];
                break;
            default:
                break;
        }
    }
}

//選択してリスト削除
- (void) doDeleteSelectedItems{
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    for(NSIndexPath *indexPath in indexPaths){
        int listKey = [NSString stringWithFormat:@"%@" ,[_tableKey objectAtIndex:indexPath.row]].intValue;
        [self doDeleteListHd:(int)listKey];
    }
}

//リスト削除
- (void) doDeleteListHd :(int) listId{
    [_db dbOpen];
    EntityDListHd * entityDListHd = [[EntityDListHd alloc] init];
    entityDListHd.pKeyListId = listId;
    [entityDListHd doDelete:_db];
    [_db dbClose];
}

//追加ボタン
- (IBAction)btnAdd:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_tableVal.count inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath,nil];
    
    [_db dbOpen];
    EntityDListHd * entityDListHd = [[EntityDListHd alloc] init];
    entityDListHd.pKeyListId = [entityDListHd getNextKey:_db];
    entityDListHd.pSortNo    = [entityDListHd getNextSortNo:_db];
    entityDListHd.pTextHd    = @"";
    entityDListHd.pLabelTag  = @"0";
    entityDListHd.pTempFlg   = @"0";
    [entityDListHd doInsert:_db];
    [_db dbClose];
    
    [_tableKey addObject:[NSNumber numberWithInt:(int)entityDListHd.pKeyListId]];
    [_tableVal addObject:[NSString stringWithFormat:@""]];
    [_tableLabelTag addObject:@"0"];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
}

//MarkAllボタン
- (IBAction)btnMarkAll:(id)sender{
    for (int i = 0; i < [_tableKey count]; i++) {
        [self.tableView selectRowAtIndexPath:
         [NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

//Trashボタン
- (IBAction)btnTrash:(id)sender {
    //選択されたデータを削除
    [self doDeleteSelectedItems];
    //テーブル再作成
    [self createTableData];
    [self.tableView reloadData];
}

- (IBAction)btnCheck:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        _keyListId = [NSString stringWithFormat:@"%@" ,[_tableKey objectAtIndex:indexPath.row]].intValue;
        [_db dbOpen];
        EntityDListHd * entityDListHd = [[EntityDListHd alloc] initWithSelect:_db :_keyListId];
        if([entityDListHd.pLabelTag isEqualToString:@"0"]){
            entityDListHd.pLabelTag = @"1";
            [sender setBackgroundImage:[UIImage imageNamed:@"iconCell1.png"]
                                forState:UIControlStateNormal];
        }else{
            entityDListHd.pLabelTag = @"0";
            
            [sender setBackgroundImage:[UIImage imageNamed:@"iconCell0.png"]
                              forState:UIControlStateNormal];
        }
        [entityDListHd doUpdate:_db];
        [_db dbClose];
        
        [self createTableData];
        [self.tableView reloadData];

    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"List2Segue"]) {
        ViewControllerList2 * viewNext = [[ViewControllerList2 alloc] init];
        viewNext = segue.destinationViewController;
        viewNext.keyListId = _keyListId;
        viewNext.navigationBarTitle = _text_hd;
    }
    else if ([segue.identifier isEqualToString:@"tempSegue"]) {
        ViewControllerTempNavi * viewNext = [[ViewControllerTempNavi alloc] init];
        viewNext = segue.destinationViewController;
        viewNext.runMode = _runMode;
        viewNext.delegate =(id<ViewControllerTempNaviDelegate>)self;
    }
}

- (void) testA:(NSInteger) listId{
    if (listId == 0){ return;}
    //選択されたTemplateのリストIDからデータを作成
    [_db dbOpen];
    
    NSString *sql;
    EntityDListHd * entityDListHd = [[EntityDListHd alloc] init];
    NSInteger nextListId = [entityDListHd getNextKey:_db];
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
           " %d"
           ",%d"
           ",text_hd"
           ",text_dt"
           ",label_tag"
           ",check_on"
           ",check_off"
           ",'0'"
           " FROM d_list_hd"
           " WHERE list_id = %d"
           ,(int)nextListId
           ,(int)[entityDListHd getNextSortNo:_db]
           ,(int)listId
           ];
    [_db executeUpdate:sql];
    
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
           " %d"
           ",list_id2"
           ",sort_no"
           ",text_hd"
           ",text_dt"
           ",label_tag"
           ",check_flg"
           ",'0'"
           " FROM d_list_dt"
           " WHERE list_id = %d"
           ,(int)nextListId
           ,(int)listId
           ];
    [_db executeUpdate:sql];
    
    [_db dbClose];
    
    [self createTableData];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setNavigationItemTitle];
    
    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];
    // ハイライト解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    // Register notification when the keyboard will be show
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];

    // Register notification when the keyboard will be hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) keyboardWillShow:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    //CGRect frame = self.tableView.frame;
    CGRect frame = _tableFrame;
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    frame.size.height -= keyboardBounds.size.height;
    NSLog(@"%d",(int)keyboardBounds.size.height);
    
    self.tableView.frame = frame;
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    CGRect frame = self.tableView.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    frame.size.height += keyboardBounds.size.height;

    // Apply new size of table view
    self.tableView.frame = frame;
    
    _isTableFrameEdit = NO;
    [UIView commitAnimations];
}

// 日本語かどうか判定
-(BOOL)isLocaleJapanese{
    //まず言語のリストを取得します。
    NSArray *languages = [NSLocale preferredLanguages];
    // 取得したリストの0番目に、現在選択されている言語の言語コード(日本語なら”ja”)が格納されるので、NSStringに格納します。
    NSString *languageID = [languages objectAtIndex:0];
    
    // 日本語の場合はYESを返す
    if ([languageID isEqualToString:@"ja"]) {
        return YES;
    }
    
    // 日本語の以外はNO
    return NO;
}
@end
