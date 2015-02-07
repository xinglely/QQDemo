

#import "EGORefreshTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;
@synthesize lastUpdatedLabel=_lastUpdatedLabel;
@synthesize height;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.translatesAutoresizingMaskIntoConstraints=NO;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
        label.translatesAutoresizingMaskIntoConstraints=NO;//自动布局时要关闭
        
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		self.lastUpdatedLabel=label;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.translatesAutoresizingMaskIntoConstraints=NO;//自动布局时要关闭
        
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
        
        [self setCenterLayout:self.lastUpdatedLabel];
        [self setCenterLayout:_statusLabel];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.lastUpdatedLabel
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeBottom
                             multiplier:1.0f
                             constant:-20]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_statusLabel
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeBottom
                             multiplier:1.0f
                             constant:-40]];
        
        
        
        
        
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, frame.size.height - 130.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
        //圆形指示器
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 110.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		
		[self setState:EGOOPullRefreshNormal];
        

		
    }
	
    return self;
	
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
    //respondsToSelector是实例方法也是类方法，用于判断某个类/实例是否能处理某个方法（包括基类方法）
    //判断delegate是否实现了方法egoRefreshTableHeaderDataSourceLastUpdated
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		//NSLog(@"delegate实现方法egoRefreshTableHeaderDataSourceLastUpdated");
        
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
        //NSLog(@"delegate没有实现方法egoRefreshTableHeaderDataSourceLastUpdated");
		_lastUpdatedLabel.text = nil;
		
	}


}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling://释放刷新
			
			_statusLabel.text = NSLocalizedString(@"释放刷新...", @"释放刷新状态");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            //自旋转180度
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal://正常状态
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"下拉刷新...", @"下拉刷新状态");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading://刷新中
			
			_statusLabel.text = NSLocalizedString(@"加载中...", @"加载状态");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {//显示刷新状态
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, height+80);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -(self.height+80) && !_loading) {
            
			[self setState:EGOOPullRefreshNormal];//状态正常
            
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -(self.height+80) && !_loading) {
            
			[self setState:EGOOPullRefreshPulling];//状态转为松开刷新
		}
		
		if (scrollView.contentInset.top != 0) {
            
			scrollView.contentInset = UIEdgeInsetsMake(self.height, 0.0f, 0.0f, 0.0f);//显示内容坐标
		}
		
	}
	
    
        //NSLog(@"%f %f %f %f",self.frame.origin.x,self.frame.origin.y,self.bounds.size.width,self.bounds.size.height);
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (_state== EGOOPullRefreshPulling&& !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(160.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(self.height, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];

}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
}


-(void)setCenterLayout:(UIView*)view
{
    
    
    /*
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-0-[v1][v2(==v1)]-0-|"
                          options:0
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(view)]];
    / *
     |: 表示父视图
     -:表示距离
     V:  :表示垂直
     H:  :表示水平
     >= :表示视图间距、宽度和高度必须大于或等于某个值
     <= :表示视图间距、宽度和高度必须小宇或等于某个值
     == :表示视图间距、宽度或者高度必须等于某个值
     @  :>=、<=、==  限制   最大为  1000
     
     1.|-[view]-|:  视图处在父视图的左右边缘内
     2.|-[view]  :   视图处在父视图的左边缘
     3.|[view]   :   视图和父视图左边对齐
     4.-[view]-  :  设置视图的宽度高度
     5.|-30.0-[view]-30.0-|:  表示离父视图 左右间距  30
     6.[view(200.0)] : 表示视图宽度为 200.0
     7.|-[view(view1)]-[view1]-| :表示视图宽度一样，并且在父视图左右边缘内
     8. V:|-[view(50.0)] : 视图高度为  50
     9: V:|-(==padding)-[imageView]->=0-[button]-(==padding)-| : 表示离父视图的距离
     为Padding,这两个视图间距必须大于或等于0并且距离底部父视图为 padding。
     10:  [wideView(>=60@700)]  :视图的宽度为至少为60 不能超过  700
     11: 如果没有声明方向默认为  水平  V:
     */
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:view
                         attribute:NSLayoutAttributeCenterX
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeCenterX
                         multiplier:1.0f
                         constant:0]];
}

- (void)Hide:(BOOL)hide
{
    self.hidden=hide;
}
@end
