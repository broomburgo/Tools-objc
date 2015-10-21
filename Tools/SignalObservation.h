
#import <Foundation/Foundation.h>
#import "Queue.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SignalSegue)
{
  SignalSegueStop,
  SignalSegueContinue
};

@interface Signal : NSObject

+ (Signal*)withQueue:(Queue*)queue;

- (Signal*)observe:(SignalSegue(^)(id))observeBlock;
- (Signal*)send:(id)value;

@end

NS_ASSUME_NONNULL_END
