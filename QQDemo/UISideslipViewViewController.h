//
//  UISideslipViewViewController.h
//  QQDemo
//
//  Created by admin on 15-2-4.
//  Copyright (c) 2015年 xinglely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISideslipViewViewController : UIViewController
{
    @private
    UIViewController *leftVC;
    UIViewController *mainVC;
    UIViewController *rightVC;
    CGFloat scale;
    CGFloat width;
    CGFloat leftSpace;
    CGFloat rightSpace;
}
/*
 assign： 简单赋值，不更改索引计数,为了解决原类型与环循引用问题
 copy： 建立一个索引计数为1的对象，然后释放旧对象
 retain：释放旧的对象，将旧对象的值赋予输入对象，再提高输入对象的索引计数为1
 
 Copy其实是建立了一个相同的对象，而retain不是：
 比如一个NSString对象，地址为0×1111，内容为@”STR”
 Copy到另外一个NSString之 后，地址为0×2222，内容相同，新的对象retain为1， 旧有对象没有变化
 retain到另外一个NSString之 后，地址相同（建立一个指针，指针拷贝），内容当然相同，这个对象的retain值+1
 retain是指针拷贝，copy是内容拷贝。在拷贝之前，都会释放旧的对象。
 *使用copy： 对NSString
 * 使用retain： 对其他NSObject和其子类
 
 readonly表示这个属性是只读的，就是只生成getter方法，不会生成setter方法
 readwrite，设置可供访问级别
 nonatomic，非原子性访问，不加同步，多线程并发访问会提高性能,默认是两个访问方法都为原子型事务访问
 
 （weak和strong）不同的是 当一个对象不再有strong类型的指针指向它的时候 它会被释放  ，即使还有weak型指针指向它。
 */

@property (assign,nonatomic) CGFloat scale;//缩放系数
@property (strong)UITapGestureRecognizer *tapGR;//轻按手势
@property (retain,nonatomic) UIViewController *leftVC;
@property (retain,nonatomic) UIViewController *mainVC;
@property (retain,nonatomic) UIViewController *rightVC;
-(void)initWithLeftView:(UIViewController*) left mainView:(UIViewController*) main rightView:(UIViewController*)right;

-(void)ShowMainView;
-(void)ShowLeftView;
-(void)ShowRight;

@end
