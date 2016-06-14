
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

- (Signal*)send:(id)value {
	for (SignalSegue(^observeBlock)(id) in [self.m_observeBlocks copy]) {
		[self.sendQueue async:^{
			SignalSegue segue = observeBlock(value);
			[self.segueQueue async:^{
				switch (segue) {
					case SignalSegueContinue:
						break;
					case SignalSegueStop:
						[self.m_observeBlocks removeObject:observeBlock];
						break;
				}
			}];
		}];
	}
	return self;
}

- (NSUInteger)observersCount {
	return self.m_observeBlocks.count;
}

@end
