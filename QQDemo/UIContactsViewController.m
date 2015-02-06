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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    
    NSLog(@"%f %f",self.table.frame.origin.x,self.table.frame.origin.y);

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

-(void)pullToRefresh
{
    
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [NSString stringWithFormat:@"Section %i", section];
    
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

@end
