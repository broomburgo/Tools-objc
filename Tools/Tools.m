#import "Tools.h"

static NSString*const kRandomStringFullString = @"abcdefghijklmnopqrstuvwxyz0123456789";
static NSString*const kRandomStringDigitsOnlyString = @"0123456789";
static const NSInteger kRandomStringStandardStringLength = 8;

@implementation Tools

#pragma mark - randomization utilities

+ (NSString*)randomStringWithType:(RandomStringType)randomStringType
                           length:(NSUInteger)length
{
  Guard(length > 0, { return @""; })
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
  return [m_randomString copy];
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

#pragma mark - JSON validation

+ (NSArray*)JSONValidatedArray:(NSArray*)array
{
  Guard(array.count != 0, { return array; })
  Guard([NSJSONSerialization isValidJSONObject:array] == NO, { return array; })
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

+ (NSDictionary*)JSONValidatedDictionary:(NSDictionary*)dictionary
{
  Guard(dictionary.count != 0, { return dictionary; })
  Guard([NSJSONSerialization isValidJSONObject:dictionary] == NO, { return dictionary; })
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

#pragma mark - composition blocks

+ (Optional*(^)(NSDictionary*))optionalForKey:(NSString*)key
                                           as:(Class)asClass
{
  return ^Optional*(NSDictionary* dict) {
    return [dict optionalForKey:key as:asClass];
  };
}

+ (NSNumber*(^)(id))toIsEqualTo:(id)toObject
{
  return ^NSNumber*(id object) {
    return @([object isEqual:toObject]);
  };
}

+ (NSNumber*(^)(NSNumber*))conditionWith:(NSNumber*)otherCondition
{
  return ^NSNumber*(NSNumber*condition) {
    return @(condition.boolValue && otherCondition.boolValue);
  };
}

+ (NSString*(^)(NSString*))stringRemoveWhitespace
{
  return ^NSString*(NSString*string) {
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
  };
}

+ (BOOL(^)(NSString*))stringIsNotEmpty
{
  return ^BOOL(NSString*str) {
    return str.length > 0;
  };
}

+ (Optional*(^)(NSString*))stringToURL
{
  return ^Optional*(NSString*urlString) {
    return [Optional with:[NSURL URLWithString:urlString]];
  };
}

+ (NSNumber*(^)(id))toIsContainedIn:(NSArray*)array
{
  return ^NSNumber*(id object) {
    return @([array containsObject:object]);
  };
}

+ (NSString*(^)(id))stringWithFormat:(NSString*)format
{
  return ^NSString*(id object) {
    return [[NSString alloc] initWithFormat:format, object];
  };
}


@end
