//
//  UILogin.h
//  QQDemo
//
//  Created by xinglely on 15/1/30.
//  Copyright (c) 2015年 xinglely. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UILogin : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>
{
    float  _DropGroupHeight;
}

//有@property这样才能用self引用
@property (retain,nonatomic)IBOutlet UIButton* DropButton;
@property (retain,nonatomic)IBOutlet UIButton* LoginButton;
@property (retain,nonatomic)IBOutlet UIButton* ForgetButton;
@property (retain,nonatomic)IBOutlet UIButton* RegisterButton;
@property (retain,nonatomic)IBOutlet UITextField* NameInput;
@property (retain,nonatomic)IBOutlet UITextField* PasswdInput;
@property (retain,nonatomic)IBOutlet UIImageView* Head;
@property (retain,nonatomic)IBOutlet UIView* PasswdGroup;
@property (retain,nonatomic)IBOutlet UIView* DropGroup;
@property (retain,nonatomic)IBOutlet UIView* Bottom;
@property (retain,nonatomic)IBOutlet UIScrollView* Accounts;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwdGroup_top;


@end
