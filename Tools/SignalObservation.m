
#import "SignalObservation.h"

@interface Signal ()

@property (strong, nonatomic) Queue* sendQueue;
@property (strong, nonatomic) Queue* segueQueue;
@property (strong, nonatomic) NSMutableArray* m_observeBlocks;

@end

@implementation Signal

+ (Signal*)withQueue:(Queue *)queue
{
  Signal* signal = [Signal new];
  signal.sendQueue = queue;
  signal.segueQueue = [Queue main];
  signal.m_observeBlocks = [NSMutableArray array];
  return signal;
}

- (Signal*)observe:(SignalSegue(^)(id))observeBlock
{
  [self.m_observeBlocks addObject:[observeBlock copy]];
  return self;
}

- (Signal*)send:(id)value
{
  NSUInteger currentCount = self.m_observeBlocks.count;
  while (currentCount > 0)
  {
    SignalSegue(^observeBlock)(id) = [self.m_observeBlocks objectAtIndex:0];
    [self.m_observeBlocks removeObjectAtIndex:0];
    [self.sendQueue async:^{
      SignalSegue segue = observeBlock(value);
      [self.segueQueue async:^{
        switch (segue)
        {
          case SignalSegueContinue:
            [self observe:observeBlock];
            break;
          case SignalSegueStop:
            /// STOP
            break;
        }
      }];
    }];
    currentCount -= 1;
  }
  return self;
}

@end
