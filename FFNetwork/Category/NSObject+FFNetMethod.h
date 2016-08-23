//
//  NSObject+FFNetMethod.h
//  FFMusic
//
//  Created by xiazer on 14/10/21.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FFNetMethod)
- (id)FFNet_defaultValue:(id)defaultData;
- (BOOL)FFNet_isEmptyObject;

- (NSString *)replaceAllCurrentString:(NSString *)fullString;
@end
