//
//  UISideslipViewViewController.m
//  QQDemo
//
//  Created by admin on 15-2-4.
//  Copyright (c) 2015年 xinglely. All rights reserved.
//

#import "UISideslipViewViewController.h"
#define  SCALE 0.8

@interface UISideslipViewViewController ()

@end

@implementation UISideslipViewViewController
@synthesize scale,tapGR,leftVC,mainVC,rightVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self initWithLeftView:[sb instantiateViewControllerWithIdentifier:@"leftVC"]
                  mainView:[sb instantiateViewControllerWithIdentifier:@"mainNav"]
                 rightView:[sb instantiateViewControllerWithIdentifier:@"rightVC"]];
    
    /*
    UIViewController *vc=[[UIViewController alloc] init];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    * /
    UIViewController* nav=[sb instantiateViewControllerWithIdentifier:@"mainNav"];
    CGRect frame = self.view.bounds;
    frame.origin.x = 100;
    nav.view.frame = frame;
    
    [self.view addSubview:nav.view];
    */
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)initWithLeftView:(UIViewController*) left mainView:(UINavigationController*) main rightView:(UIViewController*)right
{
    leftSpace=200;
    rightSpace=80;
    self.scale = 0.0f;
    self.leftVC=left;
    self.mainVC=main;
    self.rightVC=right;
    width=[[UIScreen mainScreen] bounds].size.width;
    
    //滑动手势添加到mainVC
    UIPanGestureRecognizer *panGR=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onHandlePan:)];
    [self.mainVC.view addGestureRecognizer:panGR];
    
    //轻按手势添加到mainVC
    self.tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHandleTap:)];
    [self.tapGR setNumberOfTapsRequired:1];
    [self.mainVC.view addGestureRecognizer:tapGR];
    
    left.view.hidden = YES;
    right.view.hidden = YES;
    [self.view addSubview:left.view];
    [self.view addSubview:right.view];
    [self.view addSubview:main.view];
    [self addChildViewController:mainVC];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:nil];
}

#pragma mark -
#pragma mark 滑动手势回调
-(void) onHandlePan:(UIPanGestureRecognizer*)pan
{
    
    CGPoint point = [pan translationInView:self.view];//获取平移手势对象在self.view的位置点
    
    CGPoint pos=pan.view.center;
    pos.x += point.x;
    if(pos.x > leftSpace+width/2)
    {
        pos.x = leftSpace+width/2;
    }else if(pos.x < width/2-rightSpace)
    {
        pos.x = width/2-rightSpace;
    }
    pan.view.center = pos;
    
    BOOL isToLeft=false;
    /*
     frame指的是：该view在父view坐标系统中的位置和大小。（参照点是父亲的坐标系统）
     bounds指的是：该view在本身坐标系统中 的位置和大小。（参照点是本身坐标系统）
     */
    if(pan.view.frame.origin.x>=0)//向右划
    {
        isToLeft=false;
        scale = 1-(pan.view.frame.origin.x/leftSpace)*(1-SCALE);
        pan.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);//实现的是放大和缩小
    }else if(pan.view.frame.origin.x > -rightSpace)//向左划
    {
        isToLeft=true;
        scale = 1-(pan.view.frame.origin.x/-rightSpace)*(1-SCALE);
        pan.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);//实现的是放大和缩小
    }
    
    self.leftVC.view.hidden=isToLeft;
    self.rightVC.view.hidden=!isToLeft;
    
    //NSLog(@"获取到的触摸点的位置为:%@",NSStringFromCGPoint(point));
    //清空,重置手势
    [pan setTranslation:CGPointZero inView:self.view];//移动以后的坐标
    //修正手势结束后位置
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        if(pos.x>=width/2+150)
        {
            [self ShowLeftView];
        }else if(pos.x< width/2-rightSpace/2)
        {
            [self ShowRight];
        }else
        {
            [self ShowMainView];
        }
    }
}

#pragma mark -
#pragma mark 滑动手势回调
-(void) onHandleTap:(UITapGestureRecognizer*)tap
{
    if(tap.state == UIGestureRecognizerStateEnded)
    {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        CGSize size=[[UIScreen mainScreen] bounds].size;
        tap.view.center = CGPointMake(size.width/2, size.height/2);
        [UIView commitAnimations];
    }
}


-(void)ShowMainView
{
    [UIView beginAnimations:nil context:nil];
    
    mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    mainVC.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(AnimationFinish)];
    [UIView commitAnimations];
}
-(void)ShowLeftView
{
    scale = 1-(mainVC.view.frame.origin.x/leftSpace)*(1-SCALE);
    
    [UIView beginAnimations:nil context:nil];
    mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,scale,scale);
    mainVC.view.center = CGPointMake(width/2+leftSpace,[UIScreen mainScreen].bounds.size.height/2);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(AnimationFinish)];
    [UIView commitAnimations];
}
-(void)ShowRight
{
    scale = 1-(mainVC.view.frame.origin.x/-rightSpace)*(1-SCALE);
    
    [UIView beginAnimations:nil context:nil];
    mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,scale,scale);
    mainVC.view.center = CGPointMake(width/2-rightSpace,[UIScreen mainScreen].bounds.size.height/2);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(AnimationFinish)];
    [UIView commitAnimations];
}

-(void)AnimationFinish
{
    NSLog(@"finish");
    if(mainVC.view.center.x>=width)
    {
        self.leftVC.view.hidden = NO;
        self.rightVC.view.hidden = YES;
    }else if(mainVC.view.center.x< width/2-rightSpace/2)
    {
        self.leftVC.view.hidden = YES;
        self.rightVC.view.hidden = NO;
    }else
    {
        self.leftVC.view.hidden = YES;
        self.rightVC.view.hidden = YES;
    }
    

}
@end
