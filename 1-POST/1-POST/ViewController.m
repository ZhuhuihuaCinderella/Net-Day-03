//
//  ViewController.m
//  1-POST
//
//  Created by Qianfeng on 16/1/20.
//  Copyright © 2016年 王鹏宇. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "AlbumsModel.h"
#import "JSONModel.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self registerPoset];
   // [self loginPost];
//    [self profilePost];
//    [self upLoadImage];
   // [self createAlbumName:@"我的相册"];
   // [self albumlist];
   // [self UploadPhoto];
    [self albumPhoto];
}
#define BaseURL @"http://10.0.8.8/sns"
#define RegisterAPI [NSString stringWithFormat:@"%@%@",BaseURL,@"/my/register.php" ]
#define LoginAPI [NSString stringWithFormat:@"%@%@",BaseURL,@"/my/login.php" ]
#define ProfileAPI [NSString stringWithFormat:@"%@%@",BaseURL,@"/my/profile.php" ]
#define UploadImageAPI [NSString stringWithFormat:@"%@%@",BaseURL,@"/my/upload_headimage.php" ]
//创建相册 /my/create_album.php!
#define Create_AlbumAPI [NSString stringWithFormat:@"%@%@",BaseURL,@"/my/create_album.php" ]
//获取相册列表 /my/album_list.php
#define Album_ListAPI [NSString stringWithFormat:@"%@%@",BaseURL,@"/my/album_list.php" ]
//上传图片到指定的相册里面 /my/test_upload_photo.php
#define Upload_PhotoAPI [NSString stringWithFormat:@"%@%@",BaseURL,@"/my/upload_photo.php" ]
//获取相册照片 /my/photo_list.php?uid=2&id=6&format=xml!
#define Photo_listAPI [NSString stringWithFormat:@"%@%@",BaseURL,@"/my/photo_list.php" ]
/**
 *  注册post
 */
- (void)registerPoset {
    
    NSDictionary * para = @{@"username":@"twjuncai",@"password":@"123456",@"email":@"twjuncai@163.com"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:RegisterAPI parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"message"]);
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"user_name_already_exists"]) {
           
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
/**
 *  登录
 */
- (void)loginPost {
    NSDictionary *param = @{@"username":@"twjuncai",@"password":@"123456"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:LoginAPI parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@%@",responseObject,responseObject[@"message"]);
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"login_success"]) {
            //是登陆成功
           
                    }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
/**
 *  获取信息
 */
- (void)profilePost {
    
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    //获取个人资料 需要登陆的（token/auth）
    NSDictionary *param = @{@"m_auth":token};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:ProfileAPI parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"返回数据%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
/**
 *  上传文件
 */
- (void)upLoadImage {
    //auth /token 需要登录
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    //登录参数，传这个参数 服务器就会认为你已经登录过了
    NSDictionary *param = @{@"m_auth":token};
    
    AFHTTPRequestOperationManager * manager  = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:UploadImageAPI parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //这个代码块就是用来 放文件数据
        //formData
        //方法一
       // UIImage *headImage = [UIImage imageNamed:@"me"];
        
        //把文件转换成二进制数据
     //   NSData *data = UIImagePNGRepresentation(headImage);
        //添加到我们的formdata中
//        [formData appendPartWithFormData:data name:@"heamImage"];
        
//        [formData appendPartWithFileData:data name:@"headimage" fileName:@"headimage.png" mimeType:@"image/png"];
        
        //方法二
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"me" withExtension:@"png"];
        
        [formData appendPartWithFileURL:fileUrl name:@"headimage" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"message"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    //这个方法可以同时上传多张图片
    
    //2 文件路径 直接把文件路径拿过来用
    //找文件的路径url
    
}
/**
 *  创建相册
 */
- (void)createAlbumName:(NSString *)albumName {
    NSString *token = [self getToken];
     NSDictionary *param = @{@"m_auth":token,@"albumname":albumName,@"privacy":@0};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:Create_AlbumAPI parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功 %@",responseObject[@"message"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
/**
 *  获取相册列表
 */
- (void)albumlist {
    NSDictionary *param = @{@"username":@"twjuncai",@"password":@"123456"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:Album_ListAPI parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        AlbumsModel * albums = [[AlbumsModel alloc] initWithDictionary:responseObject error:nil];
        NSLog(@"%@",albums);
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
/**
 *  上传照片到指定分组
 */
- (void)UploadPhoto {
    NSString *token = [self getToken];
    NSDictionary * params = @{@"m_auth":token,@"albumid":@34613};
    AFHTTPRequestOperationManager * manager  = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:Upload_PhotoAPI parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"me" withExtension:@"png"];
        [formData appendPartWithFileURL:fileUrl name:@"attach" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"message"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)albumPhoto {
    NSString *token = [self getToken];
    NSDictionary *params = @{@"m_auth":token,@"uid":@167224,@"id":@34613};
    AFHTTPRequestOperationManager * manager  = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:Photo_listAPI parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [_imageView sd_setImageWithURL:[NSURL URLWithString:@"http://10.0.8.8/sns/attachment/201601/20/167224_14532810657MoQ.png"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    AFNetworkReachabilityManager *mange = [AFNetworkReachabilityManager sharedManager];
    /**
     AFNetworkReachabilityStatusUnknown          = -1,
     AFNetworkReachabilityStatusNotReachable     = 0,
     AFNetworkReachabilityStatusReachableViaWWAN = 1,
     AFNetworkReachabilityStatusReachableViaWiFi = 2,
     */
    [mange setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"亲断网了");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"移动网络");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"进入WiFi网络");
            }
                break;
            default:
                break;
        }
    }];
    [mange startMonitoring];
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netChange:) name:kReachabilityChangedNotification object:nil];
    //开始监听
    [reach startNotifier];
}
//这个库监听网络需要真机
- (void)netChange:(id)sender {
    NSLog(@"网络状态发生了变化");
}
- (NSString *)getToken {
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    return token;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
