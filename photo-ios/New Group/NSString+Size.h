//
//  NSString+Size.h
//  photo-ios
//
//  Created by James on 2019/5/31.
//  Copyright © 2019 James. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Size)
+ (CGSize)sizeWithString:(NSString*)str andFont:(UIFont*)font andMaxSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
