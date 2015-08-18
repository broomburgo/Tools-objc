#import <Foundation/Foundation.h>

#pragma mark - Basic Definitions

typedef NS_ENUM(NSInteger, ResultType) {
    ResultTypeFailure,
    ResultTypeSuccess
};

@interface Result : NSObject

+ (Result* __nonnull)failureWith:(id __nonnull)error;
+ (Result* __nonnull)successWith:(id __nonnull)value;

- (Result* __nonnull)mapResult:(id __nonnull(^ __nonnull)(id __nonnull))mapBlock;
- (Result* __nonnull)flatMapResult:(Result* __nonnull (^ __nonnull)(id __nonnull))flatMapBlock;

- (id __nonnull)selectForSuccess:(id __nonnull(^ __nonnull)(id __nonnull))successBlock selectForFailure:(id __nonnull(^ __nonnull)(id __nonnull))failureBlock;
- (id __nonnull)valueDefaultedTo:(id __nonnull(^ __nonnull)(void))lazyDefaultValue;

@end
