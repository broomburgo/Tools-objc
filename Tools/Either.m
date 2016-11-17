#import "Either.h"

@interface Either ()

@property (nonatomic, nullable) id right;
@property (nonatomic, nullable) id left;
@property (nonatomic, readonly) EitherType type;

@end

@implementation Either

- (EitherType)type
{
  return self.left != nil ? EitherTypeLeft : EitherTypeRight;
}

+ (Either*)leftWith:(id)left
{
  Either* result = [Either new];
  result.left = left;
  result.right = nil;
  return result;
}


+ (Either*)rightWith:(id)right
{
  Either* result = [Either new];
  result.left = nil;
  result.right = right;
  return result;
}

- (Either*)map:(id(^)(id))mapBlock
{
  switch (self.type)
  {
    case EitherTypeLeft:
    {
      return [Either leftWith:self.left];
      break;
    }
    case EitherTypeRight:
    {
      return [Either rightWith:mapBlock(self.right)];
      break;
    }
  }
}

- (Either*)flatMap:(Either*(^)(id))flatMapBlock
{
  switch (self.type)
  {
    case EitherTypeLeft:
    {
      return [Either leftWith:self.left];
      break;
    }
    case EitherTypeRight:
    {
      return flatMapBlock(self.right);
      break;
    }
  }
}

- (id)ifLeft:(id(^)(id))leftBlock
     ifRight:(id(^)(id))rightBlock
{
  switch (self.type)
  {
    case EitherTypeLeft:
    {
      return leftBlock(self.left);
      break;
    }
    case EitherTypeRight:
    {
      return rightBlock(self.right);
      break;
    }
  }
}

- (id _Nullable)get
{
  return self.right;
}

- (id)getOrElse:(id(^)(void))lazyDefaultValue
{
  return [self
          ifLeft:^id(id _) {
            return lazyDefaultValue();
          }
          ifRight:^id(id right) {
            return right;
          }];
}

@end
