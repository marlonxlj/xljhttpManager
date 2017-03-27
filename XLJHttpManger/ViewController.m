//
//  ViewController.m
//  XLJHttpManger
//
//  Created by m on 2017/3/25.
//  Copyright © 2017年 XLJ. All rights reserved.
//

#import "ViewController.h"
#import "XLJHttpRequestManger.h"


static NSString *const getUrl = @"http://7xs2n0.com1.z0.glb.clouddn.com/fourth/new/mamabangRes.json";
static NSString *const postUrl = @"http://app.wonaonao.com:81/product/index?ajax=1";

static NSString *const dataUrl = @"http://api.budejie.com/api/api_open.php";
static NSString *const downloadUrl = @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4";

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)getRequestAction:(id)sender {
    
    [XLJHttpRequestManger requestNetWorkWithType:HTTPRequestGET requestUrl:getUrl parameters:nil responseCache:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"get error: %@",error);
    }];
    
}
- (IBAction)postRequestActin:(id)sender {
    

    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setObject:@"13812345678" forKey:@"username"];
    [dict setObject:@"1" forKey:@"page"];
    [dict setObject:@"1.2.6" forKey:@"version"];
    
    [XLJHttpRequestManger requestNetWorkWithType:HTTPRequestPOST requestUrl:dataUrl parameters:dict responseCache:nil success:^(id responseObject) {
        NSLog(@"post:%@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"post error: %@",error);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
