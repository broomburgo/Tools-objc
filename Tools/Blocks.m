
#import "Blocks.h"
#import "Optional.h"

@implementation Block

#pragma mark - composition blocks

+ (Optional*(^)(NSDictionary*))optionalForKey:(NSString*)key
                                           as:(Class)asClass
{
  return ^Optional*(NSDictionary* dict) {
    return [Optional
            with:[dict objectForKey:key]
            as:asClass];
  };
}

+ (NSNumber*(^)(id))toIsEqualTo:(id)toObject
{
  return ^NSNumber*(id object) {
    return @([object isEqual:toObject]);
  };
}

+ (NSNumber*(^)(NSNumber*))toConditionWith:(NSNumber*)otherCondition
{
  return ^NSNumber*(NSNumber*condition) {
    return @(condition.boolValue && otherCondition.boolValue);
  };
}

+ (NSString*(^)(NSString*))toStringRemovingWhitespace
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

+ (NSString*(^)(id))toStringWithFormat:(NSString*)format
{
  return ^NSString*(id object) {
    return [[NSString alloc] initWithFormat:format, object];
  };
}

@end
