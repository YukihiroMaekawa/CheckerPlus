//
//  ViewControllerList2.m
//  test_20140416
//
//  Created by 前川 幸広 on 2014/04/20.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerList2.h"
#import "DBConnector.h"
#import "EntityDListDt.h"

@interface UIViewController ()

@end

@implementation ViewControllerList2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.navigationBarTitle;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // 編集時の複数選択指定
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //ツールバーを生成
    [self createToolBarItem];
    [self createTableData];
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
    
    _tableKey       = [[NSMutableArray alloc] init];
    _tableVal       = [[NSMutableArray alloc] init];
    _tableCheckMark = [[NSMutableArray alloc] init];

    [_db dbOpen];
    
    [_db executeQuery:[self getListDt ] ];
    
    while ([_db.results next]) {
        [_tableKey       addObject:[NSNumber numberWithInt:[_db.results intForColumn:@"list_id2"]]];
        [_tableVal       addObject:[_db.results stringForColumn:@"text_hd"]];
        [_tableCheckMark addObject:[_db.results stringForColumn:@"check_flg"]];
    }
    [_db dbClose];
}

- (NSString*)getListDt{
    NSString *sql;
    
    sql = [NSString stringWithFormat
           :@"SELECT list_id2"
           "        ,text_hd"
           "        ,check_flg"
           "  FROM d_list_dt"
           " WHERE list_id = %d"
           " ORDER BY sort_no"
           ,(int)self.keyListId
           ];
    
    return sql;
}

// キーボードを隠す処理
- (void)closeKeyboard {
    [self.view endEditing: YES];
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
        for (UITextField *textFiled in [cell.contentView subviews]) {
            textFiled.enabled = isEdit;
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
    
    UIFont *uiFont = [UIFont systemFontOfSize:15.0];
    
    NSString *valueData;
    valueData = [_tableVal objectAtIndex:indexPath.row];
    textCell1 = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, 200, 45)];
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
    
    if([[_tableCheckMark objectAtIndex:indexPath.row] isEqualToString:@"1"]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell selected");
    
    if(!self.tableView.isEditing){
        _keyListId2 = [NSString stringWithFormat:@"%@" ,[_tableKey objectAtIndex:indexPath.row]].intValue;
        [_db dbOpen];
        EntityDListDt * entityDListDt = [[EntityDListDt alloc] initWithSelect:_db :self.keyListId :_keyListId2];
        
        if([entityDListDt.pCheckFlg isEqualToString:@""]){
            entityDListDt.pCheckFlg = @"1";
        }else{
            entityDListDt.pCheckFlg = @"";
        }
        [entityDListDt doUpdate:_db];
        [_db dbClose];
        
        [self createTableData];
        [self.tableView reloadData];
    }
}

// テーブル編集モード時アクション
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {   //削除
            _keyListId2 = [NSString stringWithFormat:@"%@" ,[_tableKey objectAtIndex:indexPath.row]].intValue;
            [self doDeleteListHd :(int)self.keyListId :(int)_keyListId2];
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
    EntityDListDt * entityDListDt = [[EntityDListDt alloc] initWithSelect:_db :self.keyListId : sortKey];
    stSortNo = (int)entityDListDt.pSortNo;
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
        EntityDListDt * entityDListDt = [[EntityDListDt alloc] initWithSelect:_db :self.keyListId :listKey];
        entityDListDt.pSortNo = stSortNo;
        [entityDListDt doUpdate:_db];
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
    _keyListId2 = [NSString stringWithFormat:@"%@" ,[_tableKey objectAtIndex:textField.tag - 1]].intValue;
    [_db dbOpen];
    EntityDListDt * entityDListDt = [[EntityDListDt alloc] initWithSelect:_db :self.keyListId :_keyListId2];
    entityDListDt.pTextHd    =     textField.text;
    [entityDListDt doUpdate:_db];
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
    //as.title = @"選択してください。";
    if(self.tableView.isEditing){
    }else{
        if([self isLocaleJapanese]){
            [as addButtonWithTitle:@"メール"];
            [as addButtonWithTitle:@"キャンセル"];
        }else{
            [as addButtonWithTitle:@"Mail"];
            [as addButtonWithTitle:@"Cancel"];
        }

        as.cancelButtonIndex = 1;
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
    }else{
        switch (buttonIndex) {
            //メールを作成
            case 0:
                [self openMail];
                break;
                //キャンセルボタン
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
        [self doDeleteListHd:(int)self.keyListId : (int)listKey];
    }
}

//リスト削除
- (void) doDeleteListHd :(int) listId :(int) listId2{
    [_db dbOpen];
    EntityDListDt * entityDListDt = [[EntityDListDt alloc] init];
    entityDListDt.pKeyListId = listId;
    entityDListDt.pKeyListId2 = listId2;
    [entityDListDt doDelete:_db];
    [_db dbClose];
}

//追加ボタン
- (IBAction)btnAdd:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_tableVal.count inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath,nil];
    
    [_db dbOpen];
    EntityDListDt * entityDListDt = [[EntityDListDt alloc] init];
    entityDListDt.pKeyListId = self.keyListId;
    entityDListDt.pKeyListId2 = [entityDListDt getNextKey:_db :self.keyListId];
    entityDListDt.pSortNo     = [entityDListDt getNextSortNo:_db :self.keyListId];
    entityDListDt.pTextHd     = @"";
    entityDListDt.pTempFlg    = @"0";
    [entityDListDt doInsert:_db];
    [_db dbClose];
    
    [_tableKey       addObject:[NSNumber numberWithInt:(int)entityDListDt.pKeyListId2]];
    [_tableVal       addObject:[NSString stringWithFormat:@""]];
    [_tableCheckMark addObject:[NSString stringWithFormat:@""]];

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

//メール生成
- (void) openMail{
    // メールビュー生成
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    // メール件名
    [picker setSubject:self.navigationBarTitle];
    
    // 添付画像
    /*
    NSData *myData = [[NSData alloc] initWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"Pandora_744_1392.jpg"], 1)];
    [picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"image"];
    */
    
    // メール本文
    [picker setMessageBody:[self createMailData] isHTML:NO];
    
    // メールビュー表示
    [self presentViewController:picker animated:YES completion:nil];
}

// アプリ内メーラーのデリゲートメソッド
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *resultsStr;
    
    switch (result) {
        case MFMailComposeResultCancelled:
            // キャンセル
            if([self isLocaleJapanese]){resultsStr = @"キャンセル";}else{resultsStr = @"canceled";}
            break;
        case MFMailComposeResultSaved:
            // 保存 (ここでアラート表示するなど何らかの処理を行う)
            if([self isLocaleJapanese]){resultsStr = @"保存";}else{resultsStr = @"saved";}
            break;
        case MFMailComposeResultSent:
            // 送信成功 (ここでアラート表示するなど何らかの処理を行う)
            if([self isLocaleJapanese]){resultsStr = @"送信成功";}else{resultsStr = @"Successful transmission";}
            break;
        case MFMailComposeResultFailed:
            // 送信失敗 (ここでアラート表示するなど何らかの処理を行う)
            if([self isLocaleJapanese]){resultsStr = @"送信失敗";}else{resultsStr = @"Transmission failure";}
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 生成と同時に各種設定も完了させる例
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Mail"
                          message:resultsStr
                          delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK"
                          , nil];
    
    [alert show];
}

// メールデータ作成
- (NSString *) createMailData{
    [_db dbOpen];
    
    [_db executeQuery:[self getMailData] ];
    
    NSString *data1 = @"";
    NSString *data2 = @"";
    
    if([self isLocaleJapanese]){
        data1 = @"□チェックなし\n";
        data2 = @"□チェックあり\n";
    }else{
        data1 = @"□unchecked\n";
        data2 = @"□checked\n";
    }
    
    while ([_db.results next]) {
        if([[_db.results stringForColumn:@"check_flg"] isEqualToString:@""]){
            data1 = [NSString stringWithFormat:@"%@%@\n"
                     ,data1
                     ,[_db.results stringForColumn:@"text_hd"]];
        }else{
            data2 = [NSString stringWithFormat:@"%@%@\n"
                     ,data2
                     ,[_db.results stringForColumn:@"text_hd"]];
        }
    }
    [_db dbClose];
    
    return  [NSString stringWithFormat:@"%@\n%@" ,data1 ,data2];
}


- (NSString*)getMailData{
    NSString *sql;
    
    sql = [NSString stringWithFormat
           :@"SELECT list_id2"
           "        ,text_hd"
           "        ,check_flg"
           "  FROM d_list_dt"
           " WHERE list_id = %d"
           " ORDER BY check_flg"
           "         ,sort_no"
           ,(int)self.keyListId
           ];
    
    return sql;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"List2Segue"]) {
        ViewControllerList2 * viewNext = [[ViewControllerList2 alloc] init];
        viewNext = segue.destinationViewController;
        viewNext.keyListId = _keyListId;
        viewNext.navigationBarTitle = @"testaaa";
        //        viewNext.delegate =(id<ViewControllerExercisesDelegate>)self;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = self.navigationBarTitle;

    [self createTableData];
    [self.tableView reloadData];
    
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
