//
//  ImageSaveOp.m
//  photo-ios
//
//  Created by James on 2019/5/30.
//  Copyright © 2019 James. All rights reserved.
//

#import "ImageSaveOp.h"
#import <UIKit/UIKit.h>

#define SAVE_PATH  \
[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/image"]

#define INFO_VIEW_HEIGHT    200.f

@implementation flutter_info

-(id)init{
    self=[super init];
    self.name=@"李宁超屌夏季畅销板鞋学生鞋";
    self.prise_now=@"$99";
    self.prise=@"100";
    self.sells=@"10万";
    return self;
}

-(id)initWithDic:(NSDictionary*)dic;{
    self=[super init];
    self.name=[dic objectForKey:@""];
    self.prise_now=[dic objectForKey:@""];
    self.prise=[dic objectForKey:@""];
    self.sells=[dic objectForKey:@""];
    self.url5=[dic objectForKey:@""];
    self.url6=[dic objectForKey:@""];
    self.url7=[dic objectForKey:@""];
    return self;
}

@end

@implementation ImageSaveOp

-(void)getImg:(NSArray*)ar{
    for (int i=0; i<ar.count; i++) {
        NSDictionary* dic=ar[i];
        flutter_info* fi=[[flutter_info alloc] initWithDic:dic];
        
    }
}

-(void)_generateImgurl:(NSURL*)imgUrl obInfo:(flutter_info*)ob{
    __weak ImageSaveOp* weakSelf=self;
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session=[NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue new]];
    NSURLRequest* imgRequest=[NSURLRequest requestWithURL:imgUrl];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:imgRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData * data = [NSData dataWithContentsOfURL:location];
        UIImage* commodityImg=[UIImage imageWithData:data];
                
        UIImage* resultImg = [weakSelf generateImg:commodityImg info:ob];
        [weakSelf saveFile:resultImg name:@"1.png"];
        
        
        /*
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView* imgView=[[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [imgView setImage:resultImg];
        });
         */
    }];
    [task resume];
}

//相对infoview偏移
#define tmImgY_deviation_x                  10
#define tmImgY_deviation_y                  INFO_VIEW_HEIGHT*0.1

#define goodsName_deviation_x               35
#define goodsName_deviation_y               INFO_VIEW_HEIGHT*0.1

#define goodsPrise_deviation_x              10
#define goodsPrise_deviation_y              INFO_VIEW_HEIGHT*0.75

#define goodsNowPrise_deviation_x           10
#define goodsNowPrise_deviation_y           INFO_VIEW_HEIGHT*0.85

#define goodsSells_deviation_x              200
#define goodsSells_deviation_y              INFO_VIEW_HEIGHT*0.85

#define qrcode_deviation_x                  260
#define qrcode_deviation_y                  INFO_VIEW_HEIGHT*0.2

#define qrcode_width                        INFO_VIEW_HEIGHT*0.3

-(UIImage*)generateImg:(UIImage*)img info:(flutter_info*)ob{
    CGSize sceenSize=[[UIScreen mainScreen] bounds].size;
    CGSize newImgSize=[self generateTargetSize:CGSizeMake(sceenSize.width, sceenSize.height-INFO_VIEW_HEIGHT) imgSize:img.size];
    CGSize resultImgSize=CGSizeMake(newImgSize.width, newImgSize.height+INFO_VIEW_HEIGHT);
    
    UIGraphicsBeginImageContext(newImgSize);
    [img drawInRect:CGRectMake(0, 0, resultImgSize.width, newImgSize.height)];
    
    [[UIImage imageNamed:@"tmall.png"] drawInRect:CGRectMake(tmImgY_deviation_x, tmImgY_deviation_y, 30, 30)];
    [ob.name drawInRect:CGRectMake(goodsName_deviation_x, goodsName_deviation_y, 200, 50) withAttributes:@{ NSForegroundColorAttributeName:[UIColor blackColor],
             NSFontAttributeName:[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:19.0],
         NSKernAttributeName:@1.0 }];
    [[NSString stringWithFormat:@"原价 %@",ob.prise] drawInRect:CGRectMake(goodsPrise_deviation_x, goodsPrise_deviation_y, 100, 30) withAttributes:@{ NSForegroundColorAttributeName:[UIColor grayColor],
                        NSFontAttributeName:[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:14.0],
                NSKernAttributeName:@1.0 }];
    [[NSString stringWithFormat:@"现价 %@",ob.prise_now] drawInRect:CGRectMake(goodsNowPrise_deviation_x, goodsNowPrise_deviation_y, 100, 30) withAttributes:@{ NSForegroundColorAttributeName:[UIColor grayColor],
                        NSFontAttributeName:[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:15.0],
                        NSKernAttributeName:@1.0 }];
    [[NSString stringWithFormat:@"销量 %@",ob.sells] drawInRect:CGRectMake(goodsNowPrise_deviation_x, goodsNowPrise_deviation_y, 100, 30) withAttributes:@{ NSForegroundColorAttributeName:[UIColor grayColor],
                          NSFontAttributeName:[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:15.0],
                          NSKernAttributeName:@1.0 }];
    
    UIImage* resultImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImg;
}

-(CGSize)generateTargetSize:(CGSize)targetSize imgSize:(CGSize)imgSize{
    CGFloat targetWidth=targetSize.width;
    CGFloat targetHeight=targetSize.height;
    CGFloat width=imgSize.width;
    CGFloat height=imgSize.height;
    CGFloat scaleFactor = 0.0;
    
    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;
    if (widthFactor < heightFactor)
        scaleFactor = widthFactor;
    else
        scaleFactor = heightFactor;
    return CGSizeMake(width * scaleFactor, height * scaleFactor);
}

-(void)saveFile:(UIImage*)img name:(NSString*)fileName{
    NSData *imgData=UIImagePNGRepresentation(img);
    NSString* filePath=[SAVE_PATH stringByAppendingPathComponent:fileName];
    if([imgData writeToFile:filePath atomically:YES])
    {
        NSLog(@"保存成功");
        NSLog(@"%@",filePath);
    }
    else{
        NSLog(@"保存失败");
    }
}

@end
