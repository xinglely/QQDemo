//
//  ShareFunc.m
//  QQDemo
//
//  Created by xinglely on 15/1/30.
//  Copyright (c) 2015年 xinglely. All rights reserved.
//

#import "ShareFunc.h"
#include <mach/mach.h>


@implementation ShareFunc

static ShareFunc* g_shareFunc=nil;

+(ShareFunc*)Instance{
    @synchronized(self){
        if(g_shareFunc==nil){
            g_shareFunc=[[self alloc] init];
        }
    }
    return g_shareFunc;
}


-(void)DumpInfo
{
    NSMutableString *info=[[NSMutableString alloc]init];
    [info setString:@"\n*******************************\n"];
    NSString *devName=[[UIDevice currentDevice] systemName];
    [info appendFormat:@"设备：%@\n",devName];
    
    NSString *usrName=[[UIDevice currentDevice] name];
    [info appendFormat:@"用户名：%@\n",usrName];
    
    NSString *model=[[UIDevice currentDevice] model];
    [info appendFormat:@"手机型号：%@\n",model];
    
    NSString *version=[[UIDevice currentDevice] systemVersion];
    [info appendFormat:@"系统版本ios%@\n",version];
    
    NSString *id=[[UIDevice currentDevice] identifierForVendor].UUIDString;
    [info appendFormat:@"设备标识符：%@\n",id];
    
    CGRect bounds=[[UIScreen mainScreen] bounds];
    [info appendFormat:@"屏幕大小：%.0fx%.0f\n",bounds.size.width,bounds.size.height];
    [info appendString:@"*******************************"];
    NSLog(@"%@",info);
    [self logMemoryInfo];
}

BOOL memoryInfo(vm_statistics_data_t *vmStats) {
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)vmStats, &infoCount);
    
    return kernReturn == KERN_SUCCESS;
}

- (void) logMemoryInfo {
    vm_statistics_data_t vmStats;
    
    if (memoryInfo(&vmStats)) {
        NSLog(@"free: %u\nactive: %u\ninactive: %u\nwire: %u\nzero fill: %u\nreactivations: %u\npageins: %u\npageouts: %u\nfaults: %u\ncow_faults: %u\nlookups: %u\nhits: %u",
              vmStats.free_count * vm_page_size,
              vmStats.active_count * vm_page_size,
              vmStats.inactive_count * vm_page_size,
              vmStats.wire_count * vm_page_size,
              vmStats.zero_fill_count * vm_page_size,
              vmStats.reactivations * vm_page_size,
              vmStats.pageins * vm_page_size,
              vmStats.pageouts * vm_page_size,
              vmStats.faults,
              vmStats.cow_faults,
              vmStats.lookups,
              vmStats.hits
              );
    }
}

/*
UIImage转UIColor
[UIColor colorWithPatternImage:[UIImageimageNamed:@"EmailBackground.png"]]
*/
-(UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
