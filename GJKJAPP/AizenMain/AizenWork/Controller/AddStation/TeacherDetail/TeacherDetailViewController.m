//
//  TeacherDetailViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/3.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "TeacherDetailViewController.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "AddStationTwoViewController.h"

@interface TeacherDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *results;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation TeacherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"教师输入";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _results = [[NSMutableArray alloc]init];
    _datas = [[NSMutableArray  alloc]init];
    
    
    _tableView = [[BaseTablewView alloc]init];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _tableView.tableHeaderView = _searchController.searchBar;
    _searchController.searchBar.placeholder = @"请输入师傅名称";
    _searchController.searchBar.delegate = self;
//    [_searchController br_removeLogoKeyboard];
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor grayColor]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_tableView addSubview:_activityIndicatorView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([_searchController isActive]){
        return [_results count];
    }
    return [_datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if ([_searchController isActive]) {
        cell.textLabel.text = [[_results objectAtIndex:indexPath.row] objectForKey:@"ManName"];
    } else {
        cell.textLabel.text = [[_datas objectAtIndex:indexPath.row] objectForKey:@"ManName"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_searchController.active) {
        _searchController.active = NO;
        NSLog(@"选择了搜索结果中的%@", [_results objectAtIndex:indexPath.row]);
        AddStationTwoViewController *addStation = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        addStation.getStationDic = nil;
        addStation.getStationDic = [_results objectAtIndex:indexPath.row];
        [self.navigationController popToViewController:addStation animated:YES];
    } else {
        _searchController.active = NO;
        NSLog(@"选择了列表中的%@", [_datas objectAtIndex:indexPath.row]);
        AddStationTwoViewController *addStation = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        addStation.getStationDic = nil;
        addStation.getStationDic = [_datas objectAtIndex:indexPath.row];
        [self.navigationController popToViewController:addStation animated:YES];
    }
    
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    searchController.searchBar.showsCancelButton = YES;
    for(id sousuo in [searchController.searchBar subviews]) {
        for (id view in [sousuo subviews]) {
            if([view isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)view;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
    
    NSString *inputStr = searchController.searchBar.text ;
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiEnterpriseInfo/GetLinkManList?PositionID=%@&LinkManName=%@",kCacheHttpRoot,_uploadStationID,inputStr];
    NSLog(@"%@",url);
    NSString *encodeValue = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_activityIndicatorView startAnimating];
    [AizenHttp asynRequest:encodeValue httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        NSLog(@"%@",jsonDic);
        if([[jsonDic objectForKey:@"ResultType"] intValue] == 0){
            [self handleData:[jsonDic objectForKey:@"AppendData"]];
        }else{
            [_datas removeAllObjects];
            [_results removeAllObjects];
            [_tableView reloadData];
        }
    } failue:^(NSError *error) {
        NSLog(@"请求失败--模糊搜索教师");
        [_activityIndicatorView stopAnimating];
    }];
}


-(void) handleData:(NSArray *)dataArr{
    [_results removeAllObjects];
    [_datas removeAllObjects];
    
    for(int i = 0;i<[dataArr count];i++){
        NSMutableDictionary *setDic = [[NSMutableDictionary alloc]init];
        [setDic setObject:[[dataArr objectAtIndex:i] objectForKey:@"LinkManName"] forKey:@"ManName"];
        [setDic setObject:[[[dataArr objectAtIndex:i] objectForKey:@"ID"] stringValue] forKey:@"ID"];
        [setDic setObject:[[dataArr objectAtIndex:i] objectForKey:@"LinkManEmail"] forKey:@"ManEmail"];
        [setDic setObject:[[dataArr objectAtIndex:i] objectForKey:@"LinkManTel"] forKey:@"ManTel"];
        [setDic setObject:[[dataArr objectAtIndex:i] objectForKey:@"LinkManMobile"] forKey:@"ManMobile"];
        [_datas addObject:setDic];
        
    }
    
    
    if ([_results count] > 0) {
        [_results removeAllObjects];
    }
    for (NSDictionary *getDic in _datas) {
        [_results addObject:getDic];
    }
    
    [_tableView reloadData];
}



#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidBeginEditing");
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *inputStr = searchBar.text;
    NSDictionary *setDic = [[NSDictionary alloc]initWithObjectsAndKeys:inputStr,@"ManName",@"0",@"ID", nil];
    _searchController.active = NO;
    
    AddStationTwoViewController *addStation = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    addStation.getStationDic = nil;
    addStation.getStationDic = setDic;
    [self.navigationController popToViewController:addStation animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidEndEditing");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchBar");
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

@end
