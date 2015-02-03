//
//  ShareFunc.h
//  QQDemo
//
//  Created by xinglely on 15/1/30.
//  Copyright (c) 2015年 xinglely. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareFunc : NSObject

+(ShareFunc*)Instance;
-(void)DumpInfo;
-(UIImage *)createImageWithColor:(UIColor *)color;
@end
