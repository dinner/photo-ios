//
//  NSString+Size.m
//  photo-ios
//
//  Created by James on 2019/5/31.
//  Copyright © 2019 James. All rights reserved.
//

#import "NSString+Size.h"


@implementation NSString (Size)

- (CGSize)sizeWithFont:(UIFont*)font   andMaxSize:(CGSize)size {
    //特殊的格式要求都写在属性字典中
    NSDictionary*attrs =@{NSFontAttributeName: font};
    //返回一个矩形，大小等于文本绘制完占据的宽和高。
    return  [self boundingRectWithSize:size  options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs context:nil].size;
}

+ (CGSize)sizeWithString:(NSString*)str andFont:(UIFont*)font  andMaxSize:(CGSize)size{
    NSDictionary*attrs =@{NSFontAttributeName: font};
    return  [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs  context:nil].size;
}

@end
