#import "Match.h"

@interface Match ()

@property (nonatomic) id value;
@property (nonatomic) BOOL isMatched;

@end

@implementation Match

+ (Match*):(id)value
{
  return [Match
          value:value
          isMatched:NO];
}

+ (Match*)value:(id)value
      isMatched:(BOOL)isMatched
{
  Match* match = [Match new];
  match.value = value;
  match.isMatched = isMatched;
  return match;
}

- (Match*)with:(BOOL(^)(id))withBlock
          give:(id _Nullable(^)(id))giveBlock
{
  if (self.isMatched)
  {
    return self;
  }
  if (withBlock(self.value))
  {
    return [Match
            value:giveBlock(self.value)
            isMatched:YES];
  }
  return self;
}

- (id)otherwise:(id _Nullable(^)())otherwiseBlock {
  if (self.isMatched)
  {
    return self.value;
  }
  self.isMatched = YES;
  return otherwiseBlock();
}

@end
