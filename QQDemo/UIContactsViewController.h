//
//  UIContactsViewController.h
//  QQDemo
//
//  Created by admin on 15-2-6.
//  Copyright (c) 2015年 xinglely. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGORefreshTableHeaderView.h"

@interface UIContactsViewController : UIViewController<EGORefreshTableHeaderDelegate,
    UITableViewDelegate, UITableViewDataSource,
    UISearchDisplayDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes
    BOOL _reloading;
    UISearchBar *_searchBar;
}

@property (retain,nonatomic)IBOutlet UITableView* table;
@property (retain,nonatomic)IBOutlet EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic,retain) IBOutlet UISearchBar *searchBar;
@end
