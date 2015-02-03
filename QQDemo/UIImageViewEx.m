//
//  UIImageViewEx.m
//  QQDemo
//
//  Created by xinglely on 15/1/30.
//  Copyright (c) 2015年 xinglely. All rights reserved.
//

#import "UIImageViewEx.h"

@implementation UIImageViewEx

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


-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setRound:YES];
    }
    return self;
}
-(void)setRound:(bool)enable{
    if(!enable){
        self.layer.masksToBounds=NO;
    }else{
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=self.frame.size.height/2;
    }
}
@end
