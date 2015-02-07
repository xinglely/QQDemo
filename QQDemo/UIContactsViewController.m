//
//  UIContactsViewController.m
//  QQDemo
//
//  Created by admin on 15-2-6.
//  Copyright (c) 2015年 xinglely. All rights reserved.
//

#import "UIContactsViewController.h"


@interface UIContactsViewController ()

@end

@implementation UIContactsViewController

@synthesize table;
@synthesize searchBar=_searchBar;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor darkGrayColor];//设置文本颜色
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = @"Settings";
    self.navigationItem.titleView = titleLabel;
    [self.navigationItem setTitle:@"联系人"];
    [self.navigationController setTitle:@"ff"];
    //add right button
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"回到首页"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(ShowRightView)];
    
    //rightButton.image=[UIImage imageNamed:@"right_button.png"];
    rightButton.tintColor=[UIColor whiteColor];
    
    self.navigationController.navigationItem.title=@"j";
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //设置item图片
    [self.tabBarItem setImage:[[UIImage imageNamed:@"tab_buddy_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_buddy_press.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    /******内置刷新的常用属性设置******目前只能用于UITableViewController/
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    refresh.tintColor = [UIColor blueColor];
    [refresh addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh; 
     */
    
    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *ego = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.table.bounds.size.height, self.view.frame.size.width, self.table.bounds.size.height)];
        ego.height=self.navigationController.navigationBar.frame.size.height+
            [[UIApplication sharedApplication] statusBarFrame].size.height;
        NSLog(@"%f",ego.height);
        self.refreshHeaderView=ego;
        self.refreshHeaderView.delegate = self;
        [self.table addSubview:ego];
        
         //ego.backgroundColor = [UIColor redColor];
        //设置宽
        [self.view addConstraint:[NSLayoutConstraint
                                       constraintWithItem:ego
                                       attribute:NSLayoutAttributeWidth
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.view
                                       attribute:NSLayoutAttributeWidth
                                       multiplier:1.0f
                                       constant:0]];
        //设置高
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:ego
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                                  attribute:NSLayoutAttributeHeight
                                  multiplier:1.0f
                                  constant:0]];
        //设置y
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:ego
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.table
                                  attribute:NSLayoutAttributeTop
                                  multiplier:1.0f
                                  constant:0]];
        
    }
    
    //  update the last update date
    [self.refreshHeaderView refreshLastUpdatedDate];
    self.table.delegate=self;
    self.table.dataSource=self;
    
    //set searchbar
    [self.searchBar setPlaceholder:@"搜索"];
    [self.searchBar setSearchBarStyle:UISearchBarStyleDefault];
    
    [self.searchDisplayController setActive:NO];
    self.searchDisplayController.delegate=self;
    self.searchDisplayController.searchResultsDataSource=self;
    self.searchDisplayController.searchResultsDelegate=self;

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

-(void)ShowRightView
{
    
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0)return 1;
    else return 3;
}

//row大小
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0)return 80;
    else return 50;
}

//列表分区顶大小
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0)return 0;
    else return 15;//如果为0，会被系统默认值代替
}

//列表分区底大小
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;//如果为0，会被系统默认值代替
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==1)return [NSString stringWithUTF8String:"QQ好友"];
    return nil;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    if(section==0)
    {
        return self.searchBar;
    }
    return nil;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"toolbar";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {//如果cell是用storyboard创建（不足时自动返回复制品），这一段可以省略
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    
    //cell.backgroundColor=[UIColor clearColor];
    return cell;
}






#pragma mark -
#pragma mark UIScrollViewDelegate Methods

//视图滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"%f %f",self.table.frame.origin.x,self.table.frame.origin.y);
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

//视图停止拽动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    
}



#pragma mark - UISearchDisplayDelegate

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [UIView animateWithDuration:0.2 animations:^
     {
         [self.refreshHeaderView Hide:YES];
         [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
         [self.navigationController setNavigationBarHidden:YES];//隐藏导航栏
     }completion:^(BOOL finished)
     {

     }];
    
    controller.searchBar.showsCancelButton = YES;
    for(UIView *subView in [[controller.searchBar.subviews objectAtIndex:0] subviews])
    {
        if([subView isKindOfClass:UIButton.class])
        {
            [(UIButton*)subView setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.navigationController setNavigationBarHidden:NO];//显示导航栏
    [self.refreshHeaderView Hide:NO];
    [UIView animateWithDuration:0.2 animations:^
     {

     }completion:^(BOOL finished)
     {
        
     }];
}
@end
