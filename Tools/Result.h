#import <Foundation/Foundation.h>

#pragma mark - Basic Definitions

typedef NS_ENUM(NSInteger, ResultType) {
    ResultTypeFailure,
    ResultTypeSuccess
};

@interface Result : NSObject

@property (nonatomic, readonly) ResultType type;
@property (nonatomic, readonly) NSError* __nullable error;
@property (nonatomic, readonly) id __nullable value;

- (id __nonnull)valueDefaultedTo:(id __nonnull)defaultValue;

+ (Result* __nonnull)failureWith:(NSError* __nonnull)error;
+ (Result* __nonnull)successWith:(id __nonnull)value;

- (Result* __nonnull)mapResult:(id __nonnull(^ __nonnull)(id __nonnull))mapBlock;
- (Result* __nonnull)flatMapResult:(Result* __nonnull (^ __nonnull)(id __nonnull))flatMapBlock;

@end
