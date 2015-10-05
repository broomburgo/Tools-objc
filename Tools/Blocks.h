
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Optional;

@interface Block : NSObject

#pragma mark - composition blocks

+ (Optional*(^)(NSDictionary*))optionalForKey:(NSString*)key as:(Class)asClass;
+ (NSNumber*(^)(id))toIsEqualTo:(id)toObject;
+ (NSNumber*(^)(NSNumber*))toConditionWith:(NSNumber*)otherCondition;
+ (NSString*(^)(NSString*))toStringRemovingWhitespace;
+ (BOOL(^)(NSString*))stringIsNotEmpty;
+ (Optional*(^)(NSString*))stringToURL;
+ (NSNumber*(^)(id))toIsContainedIn:(NSArray*)array;
+ (NSString*(^)(id))toStringWithFormat:(NSString*)format;

@end

NS_ASSUME_NONNULL_END
