#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Task)();

@interface Queue : NSObject

+ (Queue*)withDispatchQueue:(dispatch_queue_t)dispatchQueue;
+ (Queue*)main;
+ (Queue*)global;

- (void)sync:(Task)task;
- (void)async:(Task)task;
- (void)after:(double)seconds task:(Task)task;

@end

NS_ASSUME_NONNULL_END
