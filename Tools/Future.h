#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FutureState) {
    FutureStateIncomplete = 0,
    FutureStateSucceeded,
    FutureStateFailed
};

@class Future;

typedef void(^CompleteBlock)(BOOL success, id __nullable value, id __nullable error);
typedef void(^SuccessBlock)(id __nonnull value);
typedef void(^FailureBlock)(id __nonnull error);
typedef id __nonnull (^MapBlock)(id __nonnull value);
typedef Future* __nonnull (^FlatMapBlock)(id __nonnull value);

@interface Future : NSObject

@property (copy, nonatomic, readonly) id __nullable value;
@property (copy, nonatomic, readonly) id __nullable error;
@property (nonatomic, readonly) FutureState state;
@property (nonatomic, readonly) BOOL isComplete;

+ (Future* __nonnull)succeededWith:(id __nonnull)value;
+ (Future* __nonnull)failedWith:(id __nonnull)error;

- (Future* __nonnull)onComplete:(void(^ __nonnull)(BOOL success, id __nullable value, id __nullable error))successBlock;
- (Future* __nonnull)onSuccess:(void(^ __nonnull)(id __nonnull value))successBlock;
- (Future* __nonnull)onFailure:(void(^ __nonnull)(id __nonnull error))failureBlock;

- (Future* __nonnull)map:(id __nonnull (^ __nonnull)(id __nonnull value))mapBlock;
- (Future* __nonnull)flatMap:(Future* __nonnull (^ __nonnull)(id __nonnull value))flatMapBlock;

@end
