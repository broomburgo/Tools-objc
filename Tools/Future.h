#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FutureState)
{
    FutureStateIncomplete = 0,
    FutureStateSucceeded,
    FutureStateFailed
};

@class Future;

typedef void(^CompleteBlock)(BOOL success, id value, id error);
typedef void(^SuccessBlock)(id value);
typedef void(^FailureBlock)(id error);
typedef id _Nonnull(^MapBlock)(id value);
typedef Future* _Nonnull(^FlatMapBlock)(id value);

@interface Future : NSObject

@property (nonatomic, readonly, nullable) id get;
@property (nonatomic, readonly, nullable) id error;
@property (nonatomic, readonly) FutureState state;
@property (nonatomic, readonly) BOOL isComplete;

+ (Future*)succeededWith:(id)value;
+ (Future*)failedWith:(id)error;

- (Future*)onComplete:(void(^)(BOOL success, id _Nullable value, id _Nullable error))successBlock;
- (Future*)onSuccess:(void(^)(id value))successBlock;
- (Future*)onFailure:(void(^)(id error))failureBlock;

- (Future*)map:(id (^)(id value))mapBlock;
- (Future*)flatMap:(Future* (^)(id value))flatMapBlock;

- (void)succeedWith:(id)value;
- (void)failWith:(id)error;

@end

NS_ASSUME_NONNULL_END
