#import <Foundation/Foundation.h>

#pragma mark - Basic Definitions

typedef NS_ENUM(NSInteger, ResultType) {
    ResultTypeFailure,
    ResultTypeSuccess
};

@interface Result : NSObject

+ (Result* __nonnull)failureWith:(id __nonnull)error;
+ (Result* __nonnull)successWith:(id __nonnull)value;

- (Result* __nonnull)map:(id __nonnull(^ __nonnull)(id __nonnull))mapBlock;
- (Result* __nonnull)flatMap:(Result* __nonnull (^ __nonnull)(id __nonnull))flatMapBlock;

- (id __nonnull)ifSuccess:(id __nonnull(^ __nonnull)(id __nonnull))successBlock
                ifFailure:(id __nonnull(^ __nonnull)(id __nonnull))failureBlock;
- (id __nonnull)getOrElse:(id __nonnull(^ __nonnull)(void))lazyElse;

@end
