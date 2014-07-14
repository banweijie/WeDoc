//
//  WeViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-27.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeViewController.h"

@interface WeViewController () {
    NSIndexPath * indexPath_needToBeSeen;
}

@end

@implementation WeViewController

@synthesize sys_tableView;
@synthesize sys_tableView_originHeight;

- (void)keyboardWillShow:(NSNotification*)notification {
    NSValue * keyboardBoundsValue = notification.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGFloat KeyboardAnimationDurationUserInfoKey = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect keyboardBounds = [keyboardBoundsValue CGRectValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:KeyboardAnimationDurationUserInfoKey];
    
    [self moveContentWithKeyboardHeight:keyboardBounds.size.height duration:KeyboardAnimationDurationUserInfoKey];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    CGFloat KeyboardAnimationDurationUserInfoKey = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [self moveContentWithKeyboardHeight:0 duration:KeyboardAnimationDurationUserInfoKey];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isKindOfClass:[WeInfoedTextField class]]) {
        WeInfoedTextField * infoedTextField = (WeInfoedTextField *)textField;
        if ([infoedTextField.userData isKindOfClass:[NSIndexPath class]]) {
            indexPath_needToBeSeen = (NSIndexPath *)infoedTextField.userData;
        }
    }
}

-(void)moveContentWithKeyboardHeight:(CGFloat)kbdHeight duration:(CGFloat)duration
{
    CGRect rect = sys_tableView.frame;
    
    rect.size.height = MIN(self.view.frame.size.height - kbdHeight - rect.origin.y, self.sys_tableView_originHeight);
    
    sys_tableView.frame = rect;
    
    [sys_tableView scrollToRowAtIndexPath:indexPath_needToBeSeen atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
