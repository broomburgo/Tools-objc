#import "Categories.h"
#import "Tools.h"

@interface VariadicBlock ()

@property (copy, nonatomic) void(^argBlock0)();
@property (copy, nonatomic) void(^argBlock1)(id);
@property (copy, nonatomic) void(^argBlock2)(id,id);
@property (copy, nonatomic) void(^argBlock3)(id,id,id);
@property (copy, nonatomic) void(^argBlock4)(id,id,id,id);
@property (copy, nonatomic) void(^argBlock5)(id,id,id,id,id);
@property (copy, nonatomic) void(^argBlock6)(id,id,id,id,id,id);
@property (copy, nonatomic) void(^argBlock7)(id,id,id,id,id,id,id);
@property (copy, nonatomic) void(^argBlock8)(id,id,id,id,id,id,id,id);
@property (copy, nonatomic) void(^argBlock9)(id,id,id,id,id,id,id,id,id);
@property (copy, nonatomic) void(^argBlock10)(id,id,id,id,id,id,id,id,id,id);

@end

@implementation VariadicBlock

- (id)init
{
  self = [super init];
  GuardNil(self != nil)
  return [[[[[[[[[[[self
                    with0Arg:^{ }]
                   with1Arg:^(id obj1) { }]
                  with2Arg:^(id obj1, id obj2) { }]
                 with3Arg:^(id obj1, id obj2, id obj3) { }]
                with4Arg:^(id obj1, id obj2, id obj3, id obj4) { }]
               with5Arg:^(id obj1, id obj2, id obj3, id obj4, id obj5) { }]
              with6Arg:^(id obj1, id obj2, id obj3, id obj4, id obj5, id obj6) { }]
             with7Arg:^(id obj1, id obj2, id obj3, id obj4, id obj5, id obj6, id obj7) { }]
            with8Arg:^(id obj1, id obj2, id obj3, id obj4, id obj5, id obj6, id obj7, id obj8) { }]
           with9Arg:^(id obj1, id obj2, id obj3, id obj4, id obj5, id obj6, id obj7, id obj8, id obj9) { }]
          with10Arg:^(id obj1, id obj2, id obj3, id obj4, id obj5, id obj6, id obj7, id obj8, id obj9, id obj10) { }];
}

- (VariadicBlock*)with0Arg:(void(^)())argBlock
{
  self.argBlock0 = argBlock;
  return self;
}

- (VariadicBlock*)with1Arg:(void(^)(id))argBlock
{
  self.argBlock1 = argBlock;
  return self;
}

- (VariadicBlock*)with2Arg:(void(^)(id,id))argBlock
{
  self.argBlock2 = argBlock;
  return self;
}

- (VariadicBlock*)with3Arg:(void(^)(id,id,id))argBlock
{
  self.argBlock3 = argBlock;
  return self;
}

- (VariadicBlock*)with4Arg:(void(^)(id,id,id,id))argBlock
{
  self.argBlock4 = argBlock;
  return self;
}

- (VariadicBlock*)with5Arg:(void(^)(id,id,id,id,id))argBlock
{
  self.argBlock5 = argBlock;
  return self;
}

- (VariadicBlock*)with6Arg:(void(^)(id,id,id,id,id,id))argBlock
{
  self.argBlock6 = argBlock;
  return self;
}

- (VariadicBlock*)with7Arg:(void(^)(id,id,id,id,id,id,id))argBlock
{
  self.argBlock7 = argBlock;
  return self;
}

- (VariadicBlock*)with8Arg:(void(^)(id,id,id,id,id,id,id,id))argBlock
{
  self.argBlock8 = argBlock;
  return self;
}

- (VariadicBlock*)with9Arg:(void(^)(id,id,id,id,id,id,id,id,id))argBlock
{
  self.argBlock9 = argBlock;
  return self;
}

- (VariadicBlock*)with10Arg:(void(^)(id,id,id,id,id,id,id,id,id,id))argBlock
{
  self.argBlock10 = argBlock;
  return self;
}

@end

@implementation NSArray (Tools)

- (id)head
{
  return self.firstObject;
}

- (NSArray*)tail
{
  return [[[Optional
            with:self
            when:^BOOL(id _) {
              return self.count > 1;
            }]
           map:^NSArray*(NSArray* selfArray) {
             return [selfArray subarrayWithRange:NSMakeRange(1, self.count -1)];
           }]
          get];
}

+ (NSArray*)arrayWithCapacity:(NSUInteger)capacity
                   buildBlock:(id(^)(NSUInteger currentIndex, BOOL* prematureEnd))buildBlock
{
  Guard(capacity != 0 && buildBlock != nil, { return [NSArray array]; })
  
  NSMutableArray* m_array = [NSMutableArray array];
  for (NSInteger currentIndex = 0; currentIndex < capacity; currentIndex += 1)
  {
    BOOL prematureEnd = NO;
    id element = buildBlock(currentIndex, &prematureEnd);
    if (element)
    {
      [m_array addObject:element];
    }
    if (prematureEnd)
    {
      break;
    }
  }
  return [m_array copy];
}

- (id)reduceWithStartingElement:(id)startingElement
                    reduceBlock:(id (^)(id, id))reduceBlock
{
  Guard(self.count >= 1 && reduceBlock != nil, { return startingElement; })
  id reduced = startingElement;
  for (id obj in self) {
    reduced = reduceBlock(reduced, obj);
  }
  return reduced;
}

- (NSArray*)map:(id(^)(id object))mapBlock
{
  NSMutableArray* m_reduced = [self
                               reduceWithStartingElement:[NSMutableArray array]
                               reduceBlock:^id(id accumulator, id object) {
                                 NSMutableArray* currentAccumulator = (NSMutableArray*)accumulator;
                                 id currentObject = mapBlock(object);
                                 if (currentObject)
                                 {
                                   [currentAccumulator addObject:currentObject];
                                 }
                                 return currentAccumulator;
                               }];
  return [NSArray arrayWithArray:m_reduced];
}

- (NSArray*)filter:(BOOL(^)(id object))filterBlock
{
  NSMutableArray* m_reduced = [self
                               reduceWithStartingElement:[NSMutableArray array]
                               reduceBlock:^id(id accumulator, id object) {
                                 NSMutableArray* currentAccumulator = (NSMutableArray*)accumulator;
                                 if (filterBlock(object))
                                 {
                                   [currentAccumulator addObject:object];
                                 }
                                 return currentAccumulator;
                               }];
  return [NSArray arrayWithArray:m_reduced];
}

- (id _Nullable)find:(BOOL(^)(id object))findBlock
{
  for (id object in self)
  {
    if (findBlock(object))
    {
      return object;
    }
  }
  return nil;
}

- (NSDictionary*)mapToDictionary:(NSDictionary*(^)(id object))mapBlock
{
  GuardNil(mapBlock != nil)
  NSMutableDictionary* m_reduced = [self
                                    reduceWithStartingElement:[NSMutableDictionary dictionary]
                                    reduceBlock:^id(id accumulator, id object) {
                                      NSMutableDictionary* currentAccumulator = (NSMutableDictionary*)accumulator;
                                      NSDictionary* currentDictionary = mapBlock(object);
                                      if (currentDictionary.count > 0)
                                      {
                                        [currentAccumulator addEntriesFromDictionary:currentDictionary];
                                      }
                                      return currentAccumulator;
                                    }];
  return [NSDictionary dictionaryWithDictionary:m_reduced];
}

- (instancetype)optional:(id)optional
{
  GuardSelf(optional != nil)
  
  if ([self isKindOfClass:[NSMutableArray class]])
  {
    NSMutableArray* m_self = (NSMutableArray*)self;
    [m_self addObject:optional];
    return self;
  }
  else
  {
    return [self arrayByAddingObject:optional];
  }
}

- (instancetype)optionalArray:(NSArray*)optionalArray
{
  GuardSelf(optionalArray.count != 0)
  
  if ([self isKindOfClass:[NSMutableArray class]])
  {
    NSMutableArray* m_self = (NSMutableArray*)self;
    [m_self addObjectsFromArray:optionalArray];
    return self;
  }
  else
  {
    return [self arrayByAddingObjectsFromArray:optionalArray];
  }
}

- (void)forEach:(void(^)(id object))forEachBlock
{
  for (id object in self) {
    forEachBlock(object);
  }
}

- (void)recursive:(NSArray* _Nullable(^)(id object))recursiveBlock
          forEach:(VariadicBlock*)forEachBlock
{
  for (id object in self)
  {
    NSArray* subarray = recursiveBlock(object);
    if (subarray != nil)
    {
      [subarray
       inherited:@[object]
       recursive:recursiveBlock
       forEach:forEachBlock];
    }
    else
    {
      forEachBlock.argBlock1(object);
    }
  }
}

- (void)inherited:(NSArray* _Nonnull)inherited
        recursive:(NSArray* _Nullable(^)(id object))recursiveBlock
          forEach:(VariadicBlock*)forEachBlock
{
  for (id object in self)
  {
    NSArray* subarray = recursiveBlock(object);
    if (subarray != nil)
    {
      [subarray
       inherited:[inherited arrayByAddingObject:object]
       recursive:recursiveBlock
       forEach:forEachBlock];
    }
    else
    {
      switch (inherited.count) {
        case 1: {
          forEachBlock.argBlock2(inherited[0], object);
          break;
        }
        case 2: {
          forEachBlock.argBlock3(inherited[0], inherited[1], object);
          break;
        }
        case 3: {
          forEachBlock.argBlock4(inherited[0], inherited[1], inherited[2], object);
          break;
        }
        case 4: {
          forEachBlock.argBlock5(inherited[0], inherited[1], inherited[2], inherited[3], object);
          break;
        }
        case 5: {
          forEachBlock.argBlock6(inherited[0], inherited[1], inherited[2], inherited[3], inherited[4], object);
          break;
        }
        case 6: {
          forEachBlock.argBlock7(inherited[0], inherited[1], inherited[2], inherited[3], inherited[4], inherited[5], object);
          break;
        }
        case 7: {
          forEachBlock.argBlock8(inherited[0], inherited[1], inherited[2], inherited[3], inherited[4], inherited[5], inherited[6], object);
          break;
        }
        case 8: {
          forEachBlock.argBlock9(inherited[0], inherited[1], inherited[2], inherited[3], inherited[4], inherited[5], inherited[6], inherited[7], object);
          break;
        }
        case 9: {
          forEachBlock.argBlock10(inherited[0], inherited[1], inherited[2], inherited[3], inherited[4], inherited[5], inherited[6], inherited[7], inherited[8], object);
          break;
        }
        default: {
          forEachBlock.argBlock1(object);
          break;
        }
      }
    }
  }
}

@end

@implementation NSDictionary (Tools)

- (NSDictionary*)append:(NSDictionary *)otherDictionary
{
  GuardSelf(otherDictionary.count != 0)
  
  NSMutableDictionary* m_self = [NSMutableDictionary dictionaryWithDictionary:self];
  [m_self addEntriesFromDictionary:otherDictionary];
  return [NSDictionary dictionaryWithDictionary:m_self];
}

- (id)reduceWithStartingElement:(id)startingElement
                    reduceBlock:(id(^)(id accumulator, id key, id object))reduceBlock
{
  Guard(self.count >= 1 && reduceBlock != nil, { return startingElement; })
  __block id reduced = startingElement;
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
   {
     reduced = reduceBlock(reduced, key, obj);
   }];
  return reduced;
}

- (NSDictionary*)map:(NSDictionary*(^)(id key, id object))mapBlock
{
  GuardSelf(self.count >= 1 && mapBlock != nil)
  NSMutableDictionary* m_reduced = [self
                                    reduceWithStartingElement:[NSMutableDictionary dictionary]
                                    reduceBlock:^NSMutableDictionary*(NSMutableDictionary* m_accumulator, id key, id object) {
                                      NSDictionary* currentDictionary = mapBlock(key, object);
                                      if (currentDictionary != nil)
                                      {
                                        [m_accumulator addEntriesFromDictionary:currentDictionary];
                                      }
                                      return m_accumulator;
                                    }];
  return [NSDictionary dictionaryWithDictionary:m_reduced];
}

- (NSDictionary*)filter:(BOOL(^)(id key, id object))filterBlock
{
  GuardSelf(self.count >= 1 && filterBlock != nil)
  NSMutableDictionary* m_reduced = [self
                                    reduceWithStartingElement:[NSMutableDictionary dictionary]
                                    reduceBlock:^NSMutableDictionary*(NSMutableDictionary* m_accumulator, id key, id object) {
                                      if (filterBlock(key,object) == YES)
                                      {
                                        [m_accumulator setObject:object forKey:key];
                                      }
                                      return m_accumulator;
                                    }];
  return [NSDictionary dictionaryWithDictionary:m_reduced];
}

- (NSArray*)mapToArray:(id(^)(id key, id object))mapBlock sortedWith:(NSComparisonResult(^)(id object1, id object2))comparator
{
  GuardNil(self.count >= 1 && mapBlock != nil)
  NSMutableArray* m_reduced = [self
                               reduceWithStartingElement:[NSMutableArray array]
                               reduceBlock:^NSMutableArray*(NSMutableArray* m_accumulator, id key, id object) {
                                 id currentObject = mapBlock(key, object);
                                 if (currentObject != nil)
                                 {
                                   [m_accumulator addObject:currentObject];
                                 }
                                 return m_accumulator;
                               }];
  if (comparator)
  {
    [m_reduced sortUsingComparator:comparator];
  }
  return [NSArray arrayWithArray:m_reduced];
}

- (NSDictionary*)mergeWith:(NSDictionary *)otherDictionary
{
  GuardSelf(otherDictionary >= 0)
  
  return [[self
           map:^NSDictionary *(id key, id object) {
             id otherObject = [otherDictionary objectForKey:key];
             if (otherObject == nil)
             {
               return @{key: object};
             }
             else if ([otherObject isKindOfClass:[object class]] == NO)
             {
               return @{key: otherObject};
             }
             else
             {
               if ([object isKindOfClass:[NSDictionary class]])
               {
                 NSDictionary* dict = (NSDictionary*)object;
                 NSDictionary* otherDict = (NSDictionary*)otherObject;
                 return @{key: [dict mergeWith:otherDict]};
               }
               else if ([object isKindOfClass:[NSArray class]])
               {
                 NSArray* array = (NSArray*)object;
                 NSArray* otherArray = (NSArray*)otherObject;
                 return @{key: [array arrayByAddingObjectsFromArray:otherArray]};
               }
               else
               {
                 return @{key: otherObject};
               }
             }
           }]
          append:[otherDictionary filter:^BOOL(id key, id object) {
    return [self objectForKey:key] == nil;
  }]];
}

- (instancetype)key:(id<NSCopying>)key optional:(id)optional
{
  GuardSelf(optional != nil && key != nil)
  if ([self isKindOfClass:[NSMutableDictionary class]])
  {
    NSMutableDictionary* m_self = (NSMutableDictionary*)self;
    [m_self setObject:optional forKey:key];
    return self;
  }
  else
  {
    NSMutableDictionary* m_self = [self mutableCopy];
    [m_self setObject:optional forKey:key];
    return [NSDictionary dictionaryWithDictionary:m_self];
  }
}

- (instancetype)optionalDict:(NSDictionary*)optionalDict
{
  GuardSelf(optionalDict.count != 0)
  if ([self isKindOfClass:[NSMutableDictionary class]])
  {
    NSMutableDictionary* m_self = (NSMutableDictionary*)self;
    [m_self addEntriesFromDictionary:optionalDict];
    return self;
  }
  else
  {
    NSMutableDictionary* m_self = [self mutableCopy];
    [m_self addEntriesFromDictionary:optionalDict];
    return [NSDictionary dictionaryWithDictionary:m_self];
  }
}

- (id)objectForKey:(id)key
                as:(Class)requiredClass
{
  GuardNil(key != nil)
  
  id object = [self objectForKey:key];
  
  Guard(requiredClass != nil, { return object; })
  
  if ([object isKindOfClass:requiredClass])
  {
    return object;
  }
  else
  {
    return nil;
  }
}

@end

@implementation NSSet (Tools)

- (NSSet*)filter:(BOOL(^)(id object))filterBlock
{
  NSMutableSet* m_set = [NSMutableSet set];
  [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    if (filterBlock(obj))
    {
      [m_set addObject:obj];
    }
  }];
  return [NSSet setWithSet:m_set];
}

@end

@implementation NSIndexSet (Tools)

- (NSArray*)mapToArray
{
  NSMutableArray* m_array = [NSMutableArray array];
  [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    [m_array addObject:@(idx)];
  }];
  return [NSArray arrayWithArray:m_array];
}

@end

@implementation NSObject (Tools)

- (instancetype)maybe
{
  GuardNil([self isKindOfClass:[NSNull class]] == NO)
  return self;
}

- (instancetype)setup:(id(^)(id value))setupBlock
{
  GuardSelf(setupBlock != nil)
  return setupBlock(self);
}

@end

@implementation NSNumber (Tools)

- (id _Nullable)ifTrue:(id _Nullable(^)())ifTrueBlock
               ifFalse:(id _Nullable(^)())ifFalseBlock
{
  if ([self boolValue] == YES)
  {
    return ifTrueBlock();
  }
  else {
    return ifFalseBlock();
  }
}

@end