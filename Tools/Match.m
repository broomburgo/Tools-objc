#import "Match.h"
#import "Tools.h"

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
  GuardSelf(self.isMatched == NO)
  GuardSelf(withBlock(self.value))
  return [Match
          value:giveBlock(self.value)
          isMatched:YES];
}

- (id)otherwise:(id _Nullable(^)())otherwiseBlock
{
  Guard(self.isMatched == NO, { return self.value; })
  self.isMatched = YES;
  return otherwiseBlock();
}

@end
