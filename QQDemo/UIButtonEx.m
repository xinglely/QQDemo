//
//  UIButtonEx.m
//  QQDemo
//
//  Created by xinglely on 15/1/30.
//  Copyright (c) 2015年 xinglely. All rights reserved.
//

#import "UIButtonEx.h"
#import "ShareFunc.h"

@implementation UIButtonEx

//我们如果用Interface Builder 方式创建了UIView对象。（也就是，用拖控件的方式）那么，initWithFrame方法方法是不会被调用的

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


//initWithCoder是一个类在IB中创建但在xocdde中被实例化时被调用的
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setRound:YES];
        //UIImage* img=[[ShareFunc Instance] createImageWithColor:[UIColor blueColor]];
        UIImage* img=[[ShareFunc Instance] createImageWithColor:[UIColor colorWithRed:0 green:0 blue:0.5 alpha:0.5]];
        [self setBackgroundImage:img forState:UIControlStateHighlighted];
    }
    return self;
}

-(void)setRound:(bool)enable{
    if(!enable){
        self.layer.masksToBounds=NO;
    }else{
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=5;
        self.layer.borderColor=[UIColor colorWithRed:0 green:252 blue:252 alpha:1].CGColor;
        self.layer.borderWidth=1.5f;
    }
}
@end
