#import "Categories.h"
#import "Tools.h"

@implementation NSArray (Tools)

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
  GuardVoid(forEachBlock != nil)
  for (id object in self) {
    forEachBlock(object);
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