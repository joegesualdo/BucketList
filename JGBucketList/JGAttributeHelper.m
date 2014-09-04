//
//  JGDate.m
//  JGBucketList
//
//  Created by Joe Gesualdo on 9/4/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import "JGAttributeHelper.h"

@implementation JGAttributeHelper

+(NSString *)timestampUTC
{
  NSDate *currentDate = [[NSDate alloc] init];

//  NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
//  // or specifc Timezone: with name
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
  NSString *localDateString = [dateFormatter stringFromDate:currentDate];
  
  return localDateString;
}

+(NSString *)uuid
{
  NSString *uuid = [[NSUUID UUID] UUIDString];
  return uuid;
}
@end
