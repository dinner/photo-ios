//
//  ViewController.m
//  photo-ios
//
//  Created by James on 2019/5/30.
//  Copyright © 2019 James. All rights reserved.
//

#import "ViewController.h"
#import "ImageSaveOp.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)_generateImgurl:(NSURL*)imgUrl{
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session=[NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue new]];
    NSURLRequest* imgRequest=[NSURLRequest requestWithURL:imgUrl];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:imgRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData * data = [NSData dataWithContentsOfURL:location];
        UIImage* backImg=[UIImage imageWithData:data];
        
        CGSize size=[[UIScreen mainScreen] bounds].size;

        UIGraphicsBeginImageContext(size);
        [backImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
        [@"$100" drawInRect:CGRectMake(100, 100, 100, 40) withAttributes:@{ NSForegroundColorAttributeName:[UIColor redColor],
                NSBackgroundColorAttributeName:[UIColor greenColor],
                NSFontAttributeName:[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:19.0],
                                NSKernAttributeName:@1.0 }];
        UIImage* resultImg=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView* imgView=[[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [imgView setImage:resultImg];
            [self.view addSubview:imgView];
        });
    }];
    [task resume];
}

- (IBAction)btClicked:(id)sender {
    NSString* url=@"http://192.168.10.191/api.php/1/files/Simiyun/WechatIMG443.jpeg?access_token=56e932fc15efc60c835273603e7ede3e&sign=d55d9e625442c364b1bb8ed35c16c63b";//需改info.plist
    
//    NSString* url=@"http://192.168.10.191/api.php/1/thumbnails/Simiyun/YunCloud_blackground.png?rev=1&size=large&access_token=56e932fc15efc60c835273603e7ede3e&sign=cec65353d6e4e9b5d567a379aec695ce&signature=cec65353d6e4e9b5d567a379aec695ce";
//    NSString* url=@"http://192.168.10.191/index.php/api/file/download?file_id=239206";//不需要改info.plist why
    
    flutter_info* ob=[[flutter_info alloc] init];
    
    ImageSaveOp* imgOb=[[ImageSaveOp alloc] init];
    [imgOb _generateImgurl:[NSURL URLWithString:url] obInfo:ob];
}
@end
