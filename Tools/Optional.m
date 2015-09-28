#import "Optional.h"
#import "Either.h"

@interface Optional ()

@property (nonatomic) id get;

@end

@implementation Optional

- (OptionalType)type
{
  if (self.get == nil)
  {
    return OptionalTypeNone;
  }
  return OptionalTypeSome;
}

- (id)getOrElse:(id(^)(void))lazyElse
{
  if (self.get != nil)
  {
    return self.get;
  }
  else
  {
    return lazyElse();
  }
}

+ (Optional*)with:(id)value
{
  Optional* optional = [Optional new];
  optional.get = value;
  return optional;
}

+ (Optional*)with:(id)value as:(Class)requiredClass
{
  return [[Optional with:value]
          flatMap:^Optional*(id actualValue) {
            if ([actualValue isKindOfClass:[requiredClass class]])
            {
              return [Optional with:actualValue];
            }
            else
            {
              return [Optional with:nil];
            }
          }];
}

+ (Optional*)with:(id)value when:(BOOL(^)(id value))ifBlock
{
  return [[Optional with:value]
          flatMap:^Optional*(id actualValue){
            if (ifBlock(actualValue))
            {
              return [Optional with:actualValue];
            }
            else
            {
              return [Optional with:nil];
            }
          }];
}

- (Optional*)filter:(BOOL(^)(id))filterBlock
{
  switch (self.type)
  {
    case OptionalTypeNone:
    {
      return self;
      break;
    }
    case OptionalTypeSome:
    {
      return [Optional
              with:self.get
              when:filterBlock];
      break;
    }
  }
}

- (Optional*)map:(id  (^)(id))mapBlock
{
  switch (self.type)
  {
    case OptionalTypeNone:
    {
      return self;
      break;
    }
    case OptionalTypeSome:
    {
      return [Optional with:mapBlock(self.get)];
      break;
    }
  }
}

- (Optional*)flatMap:(Optional*(^)(id))flatMapBlock
{
  switch (self.type)
  {
    case OptionalTypeNone:
    {
      return self;
      break;
    }
    case OptionalTypeSome:
    {
      return flatMapBlock(self.get);
      break;
    }
  }
}

- (Either*)eitherWithError:(id)error
{
  switch (self.type)
  {
    case OptionalTypeNone:
      return [Either leftWith:error];
      break;
    case OptionalTypeSome:
      return [Either rightWith:self.get];
      break;
  }
}

- (void)applyIfPossible:(void(^)(id))applyBlock
{
  switch (self.type)
  {
    case OptionalTypeNone:
      break;
    case OptionalTypeSome:
      applyBlock(self.get);
      break;
  }
}

@end

@implementation NSDictionary (Optional)

- (Optional*)optionalForKey:(id)key as:(Class)requiredClass
{
  if (key == nil)
  {
    return [Optional with:nil];
  }
  id value = [self objectForKey:key];
  if (value == nil)
  {
    return [Optional with:nil];
  }
  if ([value isKindOfClass:requiredClass] == NO)
  {
    return [Optional with:nil];
  }
  return [Optional with:value];
}

@end
