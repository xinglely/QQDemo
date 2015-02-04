//
//  SocketHelper.m
//  QQDemo
//
//  Created by admin on 15-2-3.
//  Copyright (c) 2015年 xinglely. All rights reserved.
//

#import "SocketHelper.h"
#import "AsyncSocket.h"

@implementation SocketHelper
@synthesize socket;

static SocketHelper* g_socket=nil;
+(SocketHelper*)Instance{
    @synchronized(self){
        if(g_socket==nil){
            g_socket=[[self alloc] init];
        }
    }
    return g_socket;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        if(socket==nil)
        {
            [self connect:@"127.0.0.1" port:8888];
        }
    }
    return self;
}

-(int)connect:(NSString*)ip port:(int)port
{
    socket=[[AsyncSocket alloc] initWithDelegate:self];
    [socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
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

-(void)Send:(NSString*)msg
{
    NSData *data=[msg dataUsingEncoding:NSUTF8StringEncoding];
    [socket writeData:data withTimeout:-1 tag:0];
    //继续监听读取
    //[client readDataWithTimeout:-1 tag:0];
}

#pragma mark socket delegate

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"连接完成：%@ %d",host,port);
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

//是否加密
- (void)onSocketDidSecure:(AsyncSocket *)sock{
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Hava received datas is :%@",aStr);
    [self Recv:aStr];
    [socket readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"thread(%@),onSocket:%p didWriteDataWithTag:%ld",[[NSThread currentThread] name],
          socket,tag);
}


@end
