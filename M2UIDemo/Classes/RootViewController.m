//
//  RootViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 13-12-2.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import "RootViewController.h"
#import "PullDownRefreshViewController.h"
#import "M2HelpView.h"

@interface RootViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *_sections;
    NSArray *_rows;
    UITableView *_tableView;
}
@end

@implementation RootViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _sections = @[@"_临时测试",
                      @"数据加载",
                      @"提示框",
                      @"启动帮助",
                      @"UITableView",
                      @"TabBar",
                      @"TabBar切换View",
                      @"列表页常用控件",
                      @"App详情页常用控件",
                      @"设置页常用代码",
                      @"平铺拉伸图片",
                      @"瀑布流",
                      @"图片浏览",
                      @"键盘相关",
                      @"上滑scrollView上推其他View",
                      @"展示时遮罩点击收起的View"];
        _rows = @[
                  @[
                      @[@"_临时测试", @"_tempTestViewController"]
                      ],
                  @[
                      @[@"下拉刷新", @"PullDownRefreshViewController"],
                      @[@"下拉刷新简化版", @"HeaderRefreshSimpleViewController"],
                      @[@"无限滚动加载下页", @"MLoadMoreViewController"],
                      @[@"遮罩", @"MLoadingCoverViewController"]
                      ],
                  @[
                      @[@"屏幕中央", @"CenterToastViewController"],
                      @[@"状态条", @"StatusToastViewController"]
                      ],
                  @[
                      @[@"启动帮助", @"LaunchHelpViewController"]
                      ],
                  @[
                      @[@"可展开的section", @"MExtensibleItemTableViewController"]
                      ],
                  @[
                      @[@"单行点击", @"MButtonTabBarViewController"],
                      @[@"多行", @"MMultiRowTabViewController"]
                      ],
                  @[
                      @[@"点击切换子ViewController", @"MTVCRootViewController"],
                      @[@"点击tab或滑动子view", @"MTapTabPanSubViewViewController"],
                      @[@"滑动tab或滑动子view", @"MPanTabPanSubViewViewController"],
                      @[@"循环tab", @"MCycleTabBarViewController"]
                      ],
                  @[
                      @[@"轮播图", @"MAutoScrollViewController"],
                      @[@"3个Cell的轮播图", @"MCell3AutoScrollViewController"],
                      ],
                  @[
                      @[@"可展开的详细信息", @"MShowFullInfoViewController"],
                      @[@"评论Cell", @"MCommentViewController"],
                      @[@"星级评分", @"MStarViewController"]
                      ],
                  @[
                      @[@"检查更新", @"MSettingVersionViewController"],
                      ],
                  @[
                      @[@"平铺拉伸图片", @"MResizableImageViewController"]
                      ],
                  @[
                      @[@"无复用", @"MWaterFallMeViewController"]
                      ],
                  @[
                      @[@"图片浏览点击全屏A", @"MImageGalleryViewController_A"],
                      @[@"图片浏览点击全屏B", @"MImageGalleryViewController_B"],
                      @[@"图片浏览横屏图片旋转", @"MSimpleGalleryViewController"],
                      @[@"图片浏览横屏旋转B_paging", @"MSimpleGalleryBViewController"],
                      @[@"横屏图片旋转", @"MRotateImageViewController"]
                      ],
                  @[
                      @[@"键盘上方的输入框", @"MKeyboardInputViewController"]
                      ],
                  @[
                      @[@"上滑超过阈值时上推", @"MRearchThresholdViewController"]
                      ],
                  @[
                      @[@"展示时遮罩点击收起的View", @"MCoverViewController"]
                      ]
                  ];
    }
    return self;
}

- (void)loadView{
    self.view = [UIView new];
    
    CGRect frame = [UIScreen mainScreen].bounds;
//    float modifier = isios7 ? 20 : 0;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 44 - 20)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionLabel = [UILabel new];
    sectionLabel.backgroundColor = randomColor;
    sectionLabel.text = [_sections objectAtIndex:section];
    
    return sectionLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSArray*)[_rows objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text = [((NSArray*)[_rows objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row][0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *ctrl = [NSClassFromString([((NSArray*)[_rows objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row][1]) new];
    if (ctrl) {
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
