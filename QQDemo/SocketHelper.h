//
//  SocketHelper.h
//  QQDemo
//
//  Created by admin on 15-2-3.
//  Copyright (c) 2015年 xinglely. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AsyncSocket;

@interface SocketHelper : NSObject
{
    
    AsyncSocket *socket;
}
+(SocketHelper*)Instance;
-(int)connect:(NSString*)ip port:(int)port;
-(void)Recv:(NSString*)msg;
@property (retain,nonatomic)IBOutlet AsyncSocket *socket;

@end
