//
//  ViewControllerTempNavi.m
//  CheckerPlus
//
//  Created by 前川 幸広 on 2014/04/26.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerTempNavi.h"

@interface ViewControllerTempNavi ()

@end

@implementation ViewControllerTempNavi

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tempData = [ViewControllerTempData sharedManager];
    _tempData.runMode = self.runMode;
    _tempData.listId  = 0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
    }
    [super viewWillDisappear:animated];
    
    if ([self.delegate respondsToSelector:@selector(testA:)]) {
        [self.delegate testA:_tempData.listId];
    }
}

@end
