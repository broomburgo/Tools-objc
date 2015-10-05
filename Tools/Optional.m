#import "Optional.h"
#import "Tools.h"

@interface Zipped ()

@property (strong, nonatomic) id object1;
@property (strong, nonatomic) id object2;

@end

@implementation Zipped

+ (Zipped*)withObject1:(id)object1
               object2:(id)object2
{
  Zipped* zip = [Zipped new];
  zip.object1 = object1;
  zip.object2 = object2;
  return zip;
}

@end

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
  else {
    return OptionalTypeSome;
  }
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

- (Optional*)zipWith:(Optional *)otherOptional
{
  switch (self.type) {
    case OptionalTypeNone: {
      return [Optional with:nil];
      break;
    }
    case OptionalTypeSome: {
      switch (otherOptional.type) {
        case OptionalTypeNone: {
          return [Optional with:nil];
          break;
        }
        case OptionalTypeSome: {
          return [Optional with:[Zipped withObject1:[self get]
                                            object2:[otherOptional get]]];
        }
      }
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

@interface OptionalList ()

@property (nonatomic, nonnull) NSMutableArray* m_list;
@property (nonatomic, readonly, nonnull) NSArray* list;

@end

@implementation OptionalList

- (id)init
{
  self = [super init];
  GuardNil(self != nil)
  
  _m_list = [NSMutableArray array];
  return self;
}

- (OptionalList*)with:(Optional*)optional
{
  [self.m_list addObject:optional];
  return self;
}

- (NSArray*)list
{
  return [[NSArray alloc] initWithArray:self.m_list];
}

- (id)getFirst
{
  return [[self getFirstOptionalSome] get];
}

- (Optional*)getFirstOptionalSome
{
  return [self.list
          find:^BOOL(Optional* optional) {
            return optional.type == OptionalTypeSome;
          }];
}

@end

