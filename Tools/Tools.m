#import "Tools.h"

static NSString*const kRandomStringFullString = @"abcdefghijklmnopqrstuvwxyz0123456789";
static NSString*const kRandomStringDigitsOnlyString = @"0123456789";
static const NSInteger kRandomStringStandardStringLength = 8;

@implementation Tools

//MARK: - randomization utilities

+ (NSString*)randomStringWithType:(RandomStringType)randomStringType
                           length:(NSUInteger)length
{
  NSString* randomString = @"";
  if (length > 0)
  {
    NSString* fullString = kRandomStringFullString;
    if (randomStringType == RandomStringTypeDigitsOnly)
    {
      fullString = kRandomStringDigitsOnlyString;
    }
    NSMutableString* m_randomString = [NSMutableString stringWithString:@""];
    NSUInteger fullStringLength = fullString.length;
    NSUInteger index = 0;
    while (index < length)
    {
      [m_randomString
       appendString:[fullString
                     substringWithRange:NSMakeRange(arc4random()%fullStringLength, 1)]];
      index++;
    }
    randomString = [m_randomString copy];
  }
  return randomString;
}

+ (NSString*)randomStringWithLength:(NSUInteger)length
{
  return [self
          randomStringWithType:RandomStringTypeRegular
          length:length];
}

+ (NSString*)randomString
{
  return [self
          randomStringWithType:RandomStringTypeRegular
          length:kRandomStringStandardStringLength];
}

+ (NSString*)randomStringDigitsOnlyWithLength:(NSUInteger)length
{
  return [self
          randomStringWithType:RandomStringTypeDigitsOnly
          length:length];
}

+ (NSString*)randomStringDigitsOnly
{
  return [self
          randomStringWithType:RandomStringTypeDigitsOnly
          length:kRandomStringStandardStringLength];
}

+ (float)randomFloatBetweenZeroAndOne
{
  u_int32_t maxInt = 1000000;
  u_int32_t randomInt = arc4random() % (maxInt +1);
  float randomFloat = (float)randomInt/(float)maxInt;
  return randomFloat;
}

/// JSON validation

+ (NSArray*)JSONValidatedArray:(NSArray*)array
{
  if (array.count == 0)
  {
    return [NSArray array];
  }
  if ([NSJSONSerialization isValidJSONObject:array])
  {
    return array;
  }
  else
  {
    return [array
            map:^id(id object) {
              id validObject = object;
              if ([NSJSONSerialization isValidJSONObject:@[validObject]] == NO)
              {
                validObject = [validObject description];
              }
              return validObject;
            }];
  }
}

+ (NSDictionary*)JSONValidatedDictionary:(NSDictionary*)dictionary
{
  if (dictionary.count == 0)
  {
    return [NSDictionary dictionary];
  }
  if ([NSJSONSerialization isValidJSONObject:dictionary])
  {
    return dictionary;
  }
  else
  {
    return [dictionary
            map:^NSDictionary *(id key, id object) {
              id validKey = key;
              id validObject = object;
              if ([NSJSONSerialization isValidJSONObject:@[validKey]] == NO)
              {
                validKey = [validKey description];
              }
              if ([NSJSONSerialization isValidJSONObject:@[validObject]] == NO)
              {
                validObject = [validObject description];
              }
              return @{validKey: validObject};
            }];
  }
}

@end
