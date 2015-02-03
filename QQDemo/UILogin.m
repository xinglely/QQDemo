//
//  UILogin.m
//  QQDemo
//
//  Created by xinglely on 15/1/30.
//  Copyright (c) 2015年 xinglely. All rights reserved.
//

#import "UILogin.h"
#define ANIMATION_DURATION 0.3f


@interface UILogin ()

@end

@implementation UILogin


@synthesize DropButton;
@synthesize LoginButton;
@synthesize NameInput;
@synthesize PasswdInput;
@synthesize Head;
@synthesize PasswdGroup;
@synthesize DropGroup,ForgetButton,RegisterButton,Bottom,Accounts;
@synthesize passwdGroup_top;
@synthesize socket;

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
    
    [DropGroup.layer setAnchorPoint:CGPointMake(0.5f, 0.0f)];
    _DropGroupHeight=DropGroup.frame.size.height-1;
    
    [self connected:@"127.0.0.1" port:8888];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"内存警告");
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

//点击背景关闭键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    //[self.AccountInput resignFirstResponder];
    //[self.PasswdInput resignFirstResponder];
    [self.view endEditing:YES];
}


//UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //NSLog(@"return");
    if(textField.returnKeyType==UIReturnKeyNext){
        [self.PasswdInput becomeFirstResponder];
    }else if([self.PasswdInput isFirstResponder]){
        [self Login];
    }
    return YES;
}

//登录按钮事件
-(IBAction)onLogin:(id)sender
{
    [self Login];
}

-(void)Login
{
    NSString *name=self.NameInput.text;
    NSString *passwd=self.PasswdInput.text;
    if(name.length<=0){
        UIAlertView *alter=[[UIAlertView alloc] initWithTitle:@"登录错误" message:@"用户名不能为空" delegate:nil cancelButtonTitle:@"确实" otherButtonTitles:nil, nil];
        [alter show];
    }else if(passwd.length<=0){
        UIAlertView *alter=[[UIAlertView alloc] initWithTitle:@"登录错误" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确实" otherButtonTitles:nil, nil];
        [alter show];
    }
}

-(IBAction)onDropDown:(id)sender
{
    [self ShowAccountBox:[sender isSelected]];
}


-(void)ShowAccountBox:(bool)isSelected{
    //[self.view endEditing:YES];
    
    [DropButton setSelected:!isSelected];
    [LoginButton setEnabled:isSelected];
    [NameInput setEnabled:isSelected];
    [PasswdInput setEnabled:isSelected];
    [ForgetButton setEnabled:isSelected];
    [RegisterButton setEnabled:isSelected];
    if(!isSelected)[Head setAlpha:0.5f];
    else [Head setAlpha:1.0f];
    //move
    CABasicAnimation *move=[CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint pos=CGPointMake(PasswdGroup.center.x, PasswdGroup.center.y);
    
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(pos.x, pos.y)]];
    if(!isSelected){//show
        pos.y+=_DropGroupHeight;
        [move setValue:[NSNumber numberWithBool:NO] forKey:@"hide"];
    }else{//hide
        pos.y-=_DropGroupHeight;
        [move setValue:[NSNumber numberWithBool:YES] forKey:@"hide"];
    }
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(pos.x, pos.y)]];
    [move setValue:[NSValue valueWithCGPoint:pos] forKey:@"position"];
    //move.removedOnCompletion=NO;
    //[move setFillMode:kCAFillModeForwards];
    [move setDelegate:self];
    [move setDuration:ANIMATION_DURATION];
    [PasswdGroup.layer addAnimation:move forKey:nil];
    
    //scale
    
    /*
     CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
     [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.2, 1.0)]];
     [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
     */
     
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    //下面两句是保持动画最终状态
    scale.removedOnCompletion=NO;
    [scale setFillMode:kCAFillModeForwards];
    
    [scale setDuration:ANIMATION_DURATION];
    
    if(!isSelected){
        scale.fromValue=[NSNumber numberWithFloat:0.0f];
        scale.toValue=[NSNumber numberWithFloat:1.0f];
        [DropGroup setHidden:NO];
    }else{
        scale.fromValue=[NSNumber numberWithFloat:1.0f];
        scale.toValue=[NSNumber numberWithFloat:0.0f];
    }
    [DropGroup.layer addAnimation:scale forKey:nil];
    //[DropGroup setAnimations:[NSArray arrayWithObjects:scale,move, nil]];
    

    NSArray *constrains=self.view.constraints;
    for(NSLayoutConstraint *constraint in constrains){
        if(constraint.firstAttribute==NSLayoutAttributeTop){
            //NSLog(@"%f",constraint.constant);
            //constraint.constant=constraint.constant;
        }
    }
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    BOOL hide=[[anim valueForKey:@"hide"] boolValue];
    [DropGroup setHidden:hide];
    
    NSValue *value=[anim valueForKey:@"position"];
    PasswdGroup.center=[value CGPointValue];
    
    if(hide){
        passwdGroup_top.constant+=_DropGroupHeight;
    }else{
        passwdGroup_top.constant-=_DropGroupHeight;
    }
    
}

-(int)connected:(NSString*)ip port:(int)port
{
    socket=[[AsyncSocket alloc] initWithDelegate:self];
    NSError *err=nil;
    if([socket connectToHost:ip onPort:port error:&err]==NO)
    {
        NSLog(@"连接失败%d %@",[err code],[err localizedDescription]);
        return -1;
    }else
    {
        NSLog(@"连接成功");
        return 0;
    }
    return 0;
}

-(void)Recv:(NSString*)msg
{
    NSLog(@"显示信息%@",msg);
}

#pragma mark socket delegate

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    [socket readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"Error");
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSString *msg = @"Sorry this connect is failure";
    [self Recv:msg];
    socket = nil;
}

- (void)onSocketDidSecure:(AsyncSocket *)sock{
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Hava received datas is :%@",aStr);
    [self Recv:aStr];
    [socket readDataWithTimeout:-1 tag:0];
}

@end
