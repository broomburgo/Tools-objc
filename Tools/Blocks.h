
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Optional;

@interface Block : NSObject

#pragma mark - composition blocks

+ (Optional*(^)(NSDictionary*))optionalForKey:(NSString*)key as:(Class)asClass;
+ (NSNumber*(^)(id))toIsEqualTo:(id)toObject;
+ (NSNumber*(^)(NSNumber*))conditionWith:(NSNumber*)otherCondition;
+ (NSString*(^)(NSString*))stringRemoveWhitespace;
+ (BOOL(^)(NSString*))stringIsNotEmpty;
+ (Optional*(^)(NSString*))stringToURL;
+ (NSNumber*(^)(id))toIsContainedIn:(NSArray*)array;
+ (NSString*(^)(id))stringWithFormat:(NSString*)format;

@end

NS_ASSUME_NONNULL_END
