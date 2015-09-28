#import "Queue.h"

@interface Queue ()

@property dispatch_queue_t dispatchQueue;

@end

@implementation Queue

+ (Queue*)withDispatchQueue:(dispatch_queue_t)dispatchQueue
{
  Queue* queue = [Queue new];
  queue.dispatchQueue = dispatchQueue;
  return queue;
}

+ (Queue*)main
{
  return [Queue withDispatchQueue:dispatch_get_main_queue()];
}

+ (Queue*)global
{
  return [Queue withDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

- (void)executeAsynchronously:(BOOL)async
                        after:(double)seconds
                         task:(Task)task
{
  if (self.dispatchQueue)
  {
    if (async)
    {
      if (seconds > 0)
      {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), self.dispatchQueue, ^{
          task();
        });
      }
      else
      {
        dispatch_async(self.dispatchQueue, ^{
          task();
        });
      }
    }
    else
    {
      dispatch_sync(self.dispatchQueue, ^{
        task();
      });
    }
  }
}

- (void)sync:(Task)task
{
  [self
   executeAsynchronously:NO
   after:0
   task:task];
}

- (void)async:(Task)task
{
  [self
   executeAsynchronously:YES
   after:0
   task:task];
}

- (void)after:(double)seconds
         task:(Task)task
{
  [self
   executeAsynchronously:YES
   after:seconds
   task:task];
}

@end
