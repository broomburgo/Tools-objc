#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Tools.h"

@interface CategoriesSomething : NSObject

@property (nonatomic, copy) NSString* name;

@end

@implementation CategoriesSomething

- (NSString*)description {
  return self.name;
}

@end

@interface ToolsTests : XCTestCase

@end

@implementation ToolsTests

- (void)testTools {
  CategoriesSomething* something = [CategoriesSomething new];
  something.name = @"something";
  
  NSArray* array1_valid = @[@1,@2,@3];
  NSArray* validatedArray1 = [Tools JSONValidatedArray:array1_valid];
  XCTAssertNotNil(validatedArray1);
  XCTAssertEqualObjects(array1_valid, validatedArray1);
  
  NSArray* array2_notValid = @[@1,something,@3];
  NSArray* validatedArray2 = [Tools JSONValidatedArray:array2_notValid];
  NSArray* validatedArray2Wannabe = @[@1,@"something",@3];
  XCTAssertNotNil(validatedArray2);
  XCTAssertNotEqualObjects(array2_notValid, validatedArray2);
  XCTAssertEqualObjects(validatedArray2, validatedArray2Wannabe);
  
  NSDictionary* dict1_valid = @{@"1": @1, @"2": @2, @"3": @3};
  NSDictionary* validatedDict1 = [Tools JSONValidatedDictionary:dict1_valid];
  XCTAssertNotNil(validatedDict1);
  XCTAssertEqualObjects(dict1_valid, validatedDict1);
  
  NSDictionary* dict2_notValid = @{@"1": @1, @"2": something, @"3": @3};
  NSDictionary* validatedDict2 = [Tools JSONValidatedDictionary:dict2_notValid];
  NSDictionary* validatedDict2Wannabe = @{@"1": @1, @"2": @"something", @"3": @3};
  XCTAssertNotNil(validatedDict2);
  XCTAssertNotEqualObjects(dict2_notValid, validatedDict2);
  XCTAssertEqualObjects(validatedDict2, validatedDict2Wannabe);
}

- (void)testMaybe {
  NSString* someString = @"12345";
  NSArray* someArray = @[@6, @7, @8, @9, @10];
  NSNull* someNSNull = [NSNull null];
  NSDictionary* dictionaryWithNull = @{@"none": someNSNull};
  
  NSUInteger someStringLength = someString.maybe.length;
  XCTAssertEqual(someStringLength, 5);
  
  NSInteger someStringToInteger = someString.maybe.integerValue;
  XCTAssertEqual(someStringToInteger, 12345);
  
  NSDictionary* dictionaryWithArray = @{@"some":someArray};
  NSUInteger someArrayCount = [[dictionaryWithArray[@"some"] maybe] count];
  XCTAssertEqual(someArrayCount, 5);
  
  NSNumber* someArrayThirdElement = [dictionaryWithArray[@"some"] maybe][2];
  XCTAssertEqual(someArrayThirdElement.integerValue, 8);
  
  NSString* fakeString = (NSString*)dictionaryWithNull[@"none"];
  XCTAssertNil(fakeString.maybe);
  XCTAssertEqual(fakeString.maybe.length, 0);
  XCTAssertEqual(fakeString.maybe.integerValue, 0);
  
  NSArray* fakeArray = (NSArray*)dictionaryWithNull[@"none"];
  XCTAssertEqual(fakeArray.maybe.count, 0);
  XCTAssertNil(fakeArray.maybe[2]);
  
  CategoriesSomething* something = [CategoriesSomething new];
  something.name = @"awesome something";
  XCTAssert([something.maybe.name isEqualToString:@"awesome something"]);
  
  NSDictionary* dictionaryWithMock = @{@"some":something};
  CategoriesSomething* maybeMock = (CategoriesSomething*)dictionaryWithMock[@"some"];
  XCTAssert([maybeMock.maybe.name isEqualToString:@"awesome something"]);
}

- (void)testArrayHeadTail
{
  NSArray* array1 = nil;
  id head1 = array1.head;
  NSArray* tail1 = array1.tail;
  
  XCTAssertNil(head1);
  XCTAssertNil(tail1);
  
  NSArray* array2 = @[];
  id head2 = array2.head;
  NSArray* tail2 = array2.tail;
  
  XCTAssertNil(head2);
  XCTAssertNil(tail2);
  
  NSArray* array3 = @[@2];
  id head3 = array3.head;
  NSArray* tail3 = array3.tail;
  XCTAssertNotNil(head3);
  XCTAssertTrue([head3 isKindOfClass:[NSNumber class]]);
  XCTAssertTrue([head3 integerValue] == 2);
  XCTAssertNil(tail3);
  
  NSArray* array4 = @[@1,@2];
  id head4 = array4.head;
  NSArray* tail4 = array4.tail;
  XCTAssertNotNil(head4);
  XCTAssertTrue([head4 isKindOfClass:[NSNumber class]]);
  XCTAssertTrue([head4 integerValue] == 1);
  XCTAssertNotNil(tail4);
  XCTAssertTrue([tail4 isKindOfClass:[NSArray class]]);
  XCTAssertTrue(tail4.count == 1);
  XCTAssertNotNil(tail4.head);
  XCTAssertTrue([tail4.head isKindOfClass:[NSNumber class]]);
  XCTAssertTrue([tail4.head integerValue] == 2);
  XCTAssertNil(tail4.tail);
  
  NSArray* array5 = @[@2,@1,@3];
  id head5 = array5.head;
  NSArray* tail5 = array5.tail;
  XCTAssertNotNil(head5);
  XCTAssertTrue([head5 isKindOfClass:[NSNumber class]]);
  XCTAssertTrue([head5 integerValue] == 2);
  XCTAssertNotNil(tail5);
  XCTAssertTrue([tail5 isKindOfClass:[NSArray class]]);
  XCTAssertTrue(tail5.count == 2);
  XCTAssertNotNil(tail5.head);
  XCTAssertTrue([tail5.head isKindOfClass:[NSNumber class]]);
  XCTAssertTrue([tail5.head integerValue] == 1);
  XCTAssertNotNil(tail5.tail);
  XCTAssertTrue([tail5.tail isKindOfClass:[NSArray class]]);
  XCTAssertTrue(tail5.tail.count == 1);
  XCTAssertNotNil(tail5.tail.head);
  XCTAssertTrue([tail5.tail.head isKindOfClass:[NSNumber class]]);
  XCTAssertTrue([tail5.tail.head integerValue] == 3);
  XCTAssertNil(tail5.tail.tail);  
}

- (void)testNSArrayMapReduce {
  NSArray* array1 = @[@1,@2,@3];
  NSArray* array2 = [array1 map:^id(id object) {
    return @([object integerValue]*2);
  }];
  NSArray* array2Wannabe = @[@2,@4,@6];
  XCTAssert([array2 isEqualToArray:array2Wannabe]);
  
  NSArray* array3 = nil;
  NSArray* array4 = [array3 map:^id(id object) {
    return @([object integerValue]*2);
  }];
  XCTAssertNil(array4);
  
  NSArray* array3_1 = @[@1,@2,@3];
  NSArray* array3_2 = [array3_1 map:^id(id object) {
    if ([object isKindOfClass:[NSString class]]) {
      return object;
    }
    else {
      return nil;
    }
  }];
  XCTAssert([array3_2 isEqualToArray:[NSArray array]]);
  
  NSArray* array5 = @[@"1",@1];
  NSArray* array6 = [array5 map:^id(id object) {
    if ([object isKindOfClass:[NSString class]]) {
      return @([object integerValue]);
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
      return [NSString stringWithFormat:@"%@", object];
    }
    else {
      return nil;
    }
  }];
  NSArray* array6Wannabe = @[@1,@"1"];
  XCTAssert([array6 isEqualToArray:array6Wannabe]);
  
  NSArray* array7 = @[@1, @2, @3];
  NSDictionary* dictionary7 = [array7 mapToDictionary:^NSDictionary *(id object) {
    return @{[NSString stringWithFormat:@"key%@", object] : object};
  }];
  NSDictionary* dictionary7Wannabe = @{@"key1" : @1, @"key2" : @2, @"key3" : @3};
  XCTAssert([dictionary7 isEqualToDictionary:dictionary7Wannabe]);
  
  NSArray* array8 = @[@1, @2, @3, @4];
  NSDictionary* dictionary8 = [array8 mapToDictionary:^NSDictionary *(id object) {
    if ([object integerValue]%2 == 0) {
      return @{[NSString stringWithFormat:@"key%@", object] : object};
    }
    else {
      return nil;
    }
  }];
  NSDictionary* dictionary8Wannabe = @{@"key2" : @2, @"key4" : @4};
  XCTAssert([dictionary8 isEqualToDictionary:dictionary8Wannabe]);
  
  
  NSArray* array9 = @[@1,@2,@3,@"4",@(2+3)];
  NSNumber* array9Sum = [array9 reduceWithStartingElement:@0 reduceBlock:^id(id accumulator, id object) {
    return @([accumulator integerValue] + [object integerValue]);
  }];
  XCTAssert([array9Sum integerValue] == 15);
  
  NSNumber* number1 = [[NSArray array] reduceWithStartingElement:@3 reduceBlock:^id(id accumulator, id object) {
    return @([accumulator integerValue] + [object integerValue]);
  }];
  XCTAssert([number1 isKindOfClass:[NSNumber class]]);
  XCTAssert([number1 isEqualToNumber:@3]);
  
  NSNumber* number2 = [@[@2,@3,@4] reduceWithStartingElement:@1 reduceBlock:nil];
  XCTAssert([number2 isKindOfClass:[NSNumber class]]);
  XCTAssert([number2 isEqualToNumber:@1]);
}

- (void)testArrayforEach
{
  NSArray* array = @[@1,@2,@3,@4];
  NSMutableArray* m_doubledArray = [NSMutableArray array];
  [array forEach:^(NSNumber* object) {
    [m_doubledArray addObject:@(object.integerValue*2)];
  }];
  NSArray* doubledArray = [NSArray arrayWithArray:m_doubledArray];
  NSArray* doubledArrayWannabe = @[@2,@4,@6,@8];
  XCTAssertEqualObjects(doubledArray, doubledArrayWannabe);
  
  NSArray* emptyArray = @[];
  NSMutableArray* m_emptyArray = [NSMutableArray array];
  [emptyArray forEach:^(id object) {
    [m_emptyArray addObject:object];
  }];
  XCTAssertEqual(emptyArray.count, 0);
  XCTAssertEqual(m_emptyArray.count, 0);
}

- (void)testArrayRecursiveForEach
{
  NSArray* array1 = @[@[@[@1,
                          @2,
                          @3],
                        @[@4,
                          @5,
                          @6],
                        @[@7,
                          @8,
                          @9]],
                      @[@[@10,
                          @11,
                          @12],
                        @[@13,
                          @14,
                          @15],
                        @[@16,
                          @17,
                          @18]],
                      @[@[@19,
                          @20,
                          @21],
                        @[@22,
                          @23,
                          @24],
                        @[@25,
                          @26,
                          @27]]];
  
  NSMutableArray* m_flattened1 = [NSMutableArray array];
  [array1
   recursive:^NSArray*(id object) {
     return [[Optional
              with:object
              as:[NSArray class]]
             get];
   }
   forEach:[[VariadicBlock new]
            with3Arg:^(id array1, id array2, id object) {
              XCTAssert([array1 isKindOfClass:[NSArray class]]);
              XCTAssert([array2 isKindOfClass:[NSArray class]]);
              XCTAssert([object isKindOfClass:[NSNumber class]]);
              [m_flattened1 addObject:object];
            }]];
  NSArray* flattened1 = [m_flattened1 copy];
  NSArray* flattenedWannabe1 = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25,@26,@27];
  XCTAssertEqualObjects(flattened1, flattenedWannabe1);
  
  NSArray* array2 = @[@[@[@1,
                          @2,
                          @3],
                        @[@4,
                          @5,
                          @6],
                        @[@7,
                          @8,
                          @9]],
                      @[@10,
                        @11,
                        @12],
                      @[@[@13,
                          @14,
                          @15],
                        @[@16,
                          @17,
                          @18],
                        @[@19,
                          @20,
                          @21]]];
  NSMutableArray* m_flattened2 = [NSMutableArray array];
  [array2
   recursive:^NSArray*(id object) {
     return [[Optional
              with:object
              as:[NSArray class]]
             get];
   }
   forEach:[[[VariadicBlock new]
             with3Arg:^(id array1, id array2, id object) {
               XCTAssert([array1 isKindOfClass:[NSArray class]]);
               XCTAssert([array2 isKindOfClass:[NSArray class]]);
               XCTAssert([object isKindOfClass:[NSNumber class]]);
               [m_flattened2 addObject:object];
             }]
            with2Arg:^(id array1, id object) {
              XCTAssert([array1 isKindOfClass:[NSArray class]]);
              XCTAssert([object isKindOfClass:[NSNumber class]]);
              [m_flattened2 addObject:object];
            }]];
  NSArray* flattened2 = [m_flattened2 copy];
  NSArray* flattenedWannabe2 = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21];
  XCTAssertEqualObjects(flattened2, flattenedWannabe2);
}

- (void)testArrayFind
{
  NSString* string1 = @"3";
  NSArray* array1 = @[@1,@2,string1,@4];
  NSString* string1wannabe = [array1
                              find:^BOOL(id object) {
                                return [object isKindOfClass:[NSString class]];
                              }];
  XCTAssertNotNil(string1wannabe);
  XCTAssertEqualObjects(string1wannabe, string1);
  
  NSArray* array2 = @[@1,@5,@3,@4];
  NSNumber* number1 = [array2
                       find:^BOOL(NSNumber* object) {
                         return object.integerValue == 2;
                       }];
  XCTAssertNil(number1);
}

- (void)testNSArraySelect
{
  NSArray* array_a = @[@5,@2,@3,@1,@4];
  NSInteger select2 = 2;
  NSArray* array_a_2 = [array_a select:select2];
  XCTAssertNotNil(array_a_2);
  XCTAssertTrue([array_a_2 isKindOfClass:[NSArray class]]);
  XCTAssertEqual(array_a_2.count, select2);
  XCTAssertEqualObjects([array_a_2 objectAtIndex:0], @5);
  XCTAssertEqualObjects([array_a_2 objectAtIndex:1], @2);

  NSArray* array_b = @[@3];
  NSArray* array_b_2 = [array_b select:select2];
  XCTAssertNotNil(array_b_2);
  XCTAssertTrue([array_b_2 isKindOfClass:[NSArray class]]);
  XCTAssertEqual(array_b_2.count, 1);
  XCTAssertEqualObjects([array_b_2 objectAtIndex:0], @3);

  NSArray* array_c = @[];
  NSArray* array_c_2 = [array_c select:select2];
  XCTAssertNotNil(array_c_2);
  XCTAssertTrue([array_c_2 isKindOfClass:[NSArray class]]);
  XCTAssertEqual(array_c_2.count, 0);
  
  NSArray* array_d = @[@2,@1];
  NSArray* array_d_2 = [array_d select:0];
  XCTAssertNotNil(array_d_2);
  XCTAssertTrue([array_d_2 isKindOfClass:[NSArray class]]);
  XCTAssertEqual(array_d_2.count, 0);
  
  NSArray* array_a_3 = [array_a selectBut:select2];
  XCTAssertNotNil(array_a_3);
  XCTAssertTrue([array_a_3 isKindOfClass:[NSArray class]]);
  XCTAssertEqual(array_a_3.count, array_a.count - select2);
  XCTAssertEqualObjects([array_a_3 objectAtIndex:0], @3);
  XCTAssertEqualObjects([array_a_3 objectAtIndex:1], @1);
  
  NSArray* array_b_3 = [array_b selectBut:select2];
  XCTAssertNotNil(array_b_3);
  XCTAssertTrue([array_b_3 isKindOfClass:[NSArray class]]);
  XCTAssertEqual(array_b_3.count, 0);
  
  NSArray* array_c_3 = [array_c selectBut:select2];
  XCTAssertNotNil(array_c_3);
  XCTAssertTrue([array_c_3 isKindOfClass:[NSArray class]]);
  XCTAssertEqual(array_c_3.count, 0);
  
  NSArray* array_d_3 = [array_d selectBut:0];
  XCTAssertNotNil(array_d_3);
  XCTAssertTrue([array_d_3 isKindOfClass:[NSArray class]]);
  XCTAssertEqualObjects(array_d_3, array_d);
}

- (void)testNSDictionaryMapReduce {
  NSDictionary* dictionary1 = @{@"1":@11,
                                @"2":@12};
  NSDictionary* dictionary2 = [dictionary1 map:^NSDictionary *(id key, id object) {
    return @{[NSString stringWithFormat:@"1%@", key]:@([object integerValue]+10)};
  }];
  NSDictionary* dictionary2Wannabe = @{@"11":@21,
                                       @"12":@22};
  XCTAssert([dictionary2 isEqualToDictionary:dictionary2Wannabe]);
  
  NSDictionary* dictionary3 = nil;
  NSDictionary* dictionary4 = [dictionary3 map:^NSDictionary *(id key, id object) {
    return nil;
  }];
  XCTAssertNil(dictionary4);
  
  NSDictionary* dictionary5 = @{@1:@1,@2:@2,@3:@3};
  NSDictionary* dictionary6 = [dictionary5 map:^NSDictionary *(id key, id object) {
    if ([object isKindOfClass:[NSString class]]) {
      return @{key:object};
    }
    else {
      return nil;
    }
  }];
  XCTAssert([dictionary6 isEqualToDictionary:[NSDictionary dictionary]]);
  
  NSDictionary* dictionary7 = @{@1:@"1",@"2":@2,@"3":@3,@4:@"4"};
  NSArray* array1 = [dictionary7 mapToArray:^id(id key, id object) {
    if ([key isKindOfClass:[NSNumber class]]) {
      return key;
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
      return object;
    }
    else {
      return nil;
    }
  } sortedWith:^NSComparisonResult(id object1, id object2) {
    return [object1 compare:object2];
  }];
  NSArray* array1Wannabe = @[@1,@2,@3,@4];
  XCTAssert([array1 isEqualToArray:array1Wannabe]);
  
  NSDictionary* dict8 = @{
                          @"1":@1,
                          @"2":@{
                              @"1":@1,
                              @"2":@2
                              },
                          @"3":@3,
                          @"4":@{
                              @"1":@1,
                              @"2":@{
                                  @"1":@1,
                                  @"2":@2,
                                  @"3":@3
                                  }
                              },
                          @"6":@[@1,@2]
                          };
  NSDictionary* otherDict8 = @{
                               @"1":@10,
                               @"2":@{
                                   @"2":@20,
                                   @"3":@30
                                   },
                               @"4":@{
                                   @"2":@{
                                       @"1":@10,
                                       @"3":@3,
                                       @"4":@{
                                           @"1":@10
                                           }
                                       }
                                   },
                               @"5":@5,
                               @"6":@[@3,@"4"]
                               };
  NSDictionary* expectedDict8 = @{
                                  @"1":@10,
                                  @"2":@{
                                      @"1":@1,
                                      @"2":@20,
                                      @"3":@30
                                      },
                                  @"3":@3,
                                  @"4":@{
                                      @"1":@1,
                                      @"2":@{
                                          @"1":@10,
                                          @"2":@2,
                                          @"3":@3,
                                          @"4":@{
                                              @"1":@10
                                              }
                                          }
                                      },
                                  @"5":@5,
                                  @"6":@[@1,@2,@3,@"4"]
                                  };
  NSDictionary* mergedDict8 = [dict8 mergeWith:otherDict8];
  XCTAssertNotNil(mergedDict8);
  XCTAssertNotEqual(mergedDict8.count, 0);
  XCTAssertEqualObjects(mergedDict8, expectedDict8);
  
  NSDictionary* dict9 = @{@"1":@"a",@"2":@"b",@"3":@3};
  NSString* reducedString9 = [[dict9 reduceWithStartingElement:[@"" mutableCopy] reduceBlock:^NSMutableString*(NSMutableString* m_accumulator, id key, id object) {
    [m_accumulator appendFormat:@"|key: %@, object: %@|", key, object];
    return m_accumulator;
  }] copy];
  XCTAssertNotNil(reducedString9);
  XCTAssertNotEqual(reducedString9.length, 0);
  NSString* expectedString9 = @"|key: 1, object: a||key: 2, object: b||key: 3, object: 3|";
  XCTAssertEqualObjects(reducedString9, expectedString9);
  
}

- (void)testNSDictionaryRequestClass {
  NSDictionary* dictionary = @{@1:@"a",
                               @2:@10,
                               @3:@[@1,@2,@3],
                               @4:@{@"1":@1,@"2":@2},
                               @5:[NSNull null]};
  NSString* a = [dictionary objectForKey:@1 as:[NSString class]];
  XCTAssert([a isKindOfClass:[NSString class]]);
  XCTAssert([a isEqualToString:@"a"]);
  
  XCTAssertNil([dictionary objectForKey:@1 as:[NSNumber class]]);
  XCTAssertNil([dictionary objectForKey:@2 as:[NSString class]]);
  
  NSArray* array = [dictionary objectForKey:@3 as:[NSArray class]];
  XCTAssert(array.count == 3);
  
  XCTAssertNil([dictionary objectForKey:@4 as:[NSArray class]]);
  XCTAssertNil([dictionary objectForKey:@5 as:[NSDictionary class]]);
}

- (void)testNSDictionaryOptionals {
  NSDictionary* dict = [[[[[[[NSDictionary dictionary]
                             key:@"a" optional:@1]
                            key:@"b" optional:nil]
                           key:nil optional:@3]
                          key:@"d" optional:@"4"]
                         key:nil optional:nil]
                        optionalDict:[[[[[[NSMutableDictionary dictionary]
                                          key:@"f" optional:nil]
                                         key:nil optional:@7]
                                        key:@"h" optional:@8]
                                       key:@"i" optional:nil]
                                      key:nil optional:@10]];
  XCTAssert([dict isKindOfClass:[NSDictionary class]]);
  XCTAssert(dict.count == 3);
  XCTAssert([dict[@"a"] isEqual:@1]);
  XCTAssert(dict[@"b"] == nil);
  XCTAssert(dict[@"c"] == nil);
  XCTAssert([dict[@"d"] isEqual:@"4"]);
  XCTAssert(dict[@"e"] == nil);
  XCTAssert(dict[@"f"] == nil);
  XCTAssert(dict[@"g"] == nil);
  XCTAssert([dict[@"h"] isEqual:@8]);
  XCTAssert(dict[@"i"] == nil);
  XCTAssert(dict[@"j"] == nil);
  
  NSMutableDictionary* m_dict = [[[[[[[NSMutableDictionary dictionary]
                                      key:@"a" optional:nil]
                                     key:@"b" optional:@2]
                                    key:@"c" optional:@3]
                                   key:nil optional:@4]
                                  key:nil optional: nil]
                                 optionalDict:[[[[[[NSDictionary dictionary]
                                                   key:@"f" optional:@6]
                                                  key:@"g" optional:nil]
                                                 key:nil optional:@8]
                                                key:@"i" optional:@"9"]
                                               key:nil optional:nil]];
  XCTAssert([m_dict isKindOfClass:[NSMutableDictionary class]]);
  XCTAssert(m_dict.count == 4);
  XCTAssert(m_dict[@"a"] == nil);
  XCTAssert([m_dict[@"b"] isEqual:@2]);
  XCTAssert([m_dict[@"c"] isEqual:@3]);
  XCTAssert(m_dict[@"d"] == nil);
  XCTAssert(m_dict[@"e"] == nil);
  XCTAssert([m_dict[@"f"] isEqual:@6]);
  XCTAssert(m_dict[@"g"] == nil);
  XCTAssert(m_dict[@"h"] == nil);
  XCTAssert([m_dict[@"i"] isEqual:@"9"]);
  XCTAssert(m_dict[@"j"] == nil);
}

- (void)testNSArrayOptionals {
  NSArray* array = [[[[[[[NSArray array]
                         optional:@1]
                        optional:nil]
                       optional:@3]
                      optional:@4]
                     optional:nil]
                    optionalArray:[[[[NSMutableArray array]
                                     optional:@6]
                                    optional:nil]
                                   optional:@8]];
  XCTAssert([array isKindOfClass:[NSArray class]]);
  XCTAssert(array.count == 5);
  XCTAssert([array[0] isEqual:@1]);
  XCTAssert([array[1] isEqual:@3]);
  XCTAssert([array[2] isEqual:@4]);
  XCTAssert([array[3] isEqual:@6]);
  XCTAssert([array[4] isEqual:@8]);
  
  NSMutableArray* m_array = [[[[[[[NSMutableArray array]
                                  optional:nil]
                                 optional:@2]
                                optional:nil]
                               optional:@4]
                              optional: nil]
                             optionalArray:[[[[NSArray array]
                                              optional:nil]
                                             optional:nil]
                                            optional:@8]];
  XCTAssert([m_array isKindOfClass:[NSMutableArray class]]);
  XCTAssert(m_array.count == 3);
  XCTAssert([m_array[0] isEqual:@2]);
  XCTAssert([m_array[1] isEqual:@4]);
  XCTAssert([m_array[2] isEqual:@8]);
}

- (void)testNSArrayBuild {
  NSUInteger numberOfElements = 5;
  
  NSArray* builtArray1 = [NSArray arrayWithCapacity:numberOfElements buildBlock:^id(NSUInteger currentIndex, BOOL *prematureEnd) {
    return @(currentIndex);
  }];
  XCTAssert(builtArray1.count == numberOfElements);
  
  NSArray* builtArray1Wannabe = @[@(0),@1,@2,@3,@4];
  XCTAssert([builtArray1 isEqualToArray:builtArray1Wannabe]);
  
  NSUInteger maxCapacity = 3;
  NSArray* builtArray2 = [NSArray arrayWithCapacity:numberOfElements buildBlock:^id(NSUInteger index, BOOL *prematureEnd) {
    if (index >= maxCapacity -1) {
      *prematureEnd = YES;
    }
    return @(index);
  }];
  XCTAssert(builtArray2.count == maxCapacity);
  
  NSArray* builtArray2Wannabe = @[@(0),@1,@2];
  XCTAssert([builtArray2 isEqualToArray:builtArray2Wannabe]);
  
  NSUInteger bannedIndex = 2;
  NSArray* builtArray3 = [NSArray arrayWithCapacity:numberOfElements buildBlock:^id(NSUInteger currentIndex, BOOL *prematureEnd) {
    if (currentIndex != bannedIndex) {
      return @(currentIndex);
    }
    else {
      return nil;
    }
  }];
  XCTAssert(builtArray3.count == numberOfElements -1);
  
  NSArray* builtArray3Wannabe = @[@(0),@1,@3,@4];
  XCTAssert([builtArray3 isEqualToArray:builtArray3Wannabe]);
}

- (void)testNSIndexSetToArray {
  NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)];
  XCTAssert(indexSet.firstIndex == 0);
  XCTAssert(indexSet.lastIndex == 4);
  XCTAssert(indexSet.count == 5);
  NSArray* indexArray = [indexSet mapToArray];
  XCTAssert([indexArray.firstObject isKindOfClass:[NSNumber class]]);
  XCTAssert([indexArray.firstObject isEqualToNumber:@0]);
  XCTAssert([indexArray.lastObject isKindOfClass:[NSNumber class]]);
  XCTAssert([indexArray.lastObject isEqualToNumber:@4]);
  XCTAssert(indexArray.count == 5);
}

- (void)testNSNumberIfTrueIfFalse
{
  NSNumber* _true = @(YES);
  NSNumber* _false = @(NO);
  
  NSNumber* one = [_true
                   ifTrue:^NSNumber*{
                     return @1;
                   }
                   ifFalse:^NSNumber*{
                     return @2;
                   }];
  XCTAssertNotNil(one);
  XCTAssertTrue([one isKindOfClass:[NSNumber class]]);
  XCTAssertEqualObjects(one, @1);
  
  NSNumber* two = [_false
                   ifTrue:^NSNumber*{
                     return @1;
                   }
                   ifFalse:^NSNumber*{
                     return @2;
                   }];
  XCTAssertNotNil(two);
  XCTAssertTrue([two isKindOfClass:[NSNumber class]]);
  XCTAssertEqualObjects(two, @2);
  
  NSNumber* nilNumber1 = [_true
                          ifTrue:^NSNumber*{
                            return nil;
                          }
                          ifFalse:^NSNumber*{
                            return @2;
                          }];
  XCTAssertNil(nilNumber1);
  
  NSNumber* nilNumber2 = [_false
                          ifTrue:^NSNumber*{
                            return @1;
                          }
                          ifFalse:^NSNumber*{
                            return nil;
                          }];
  XCTAssertNil(nilNumber2);
}

- (void)testRandomization {
  NSString* randomString1 = [Tools randomString];
  XCTAssertNotNil(randomString1);
  XCTAssertNotEqual(randomString1.length, 0);
  
  NSUInteger randomStringLength = 10;
  
  NSString* randomString2 = [Tools randomStringWithLength:randomStringLength];
  XCTAssertNotNil(randomString2);
  XCTAssertEqual(randomString2.length, randomStringLength);
  
  NSString* randomString3 = [Tools randomStringWithLength:randomStringLength];
  XCTAssertNotNil(randomString3);
  XCTAssertEqual(randomString3.length, randomStringLength);
  
  XCTAssertNotEqualObjects(randomString2, randomString3);
  
  NSString* noDigitsString = @"abcdefghijklmnopqrstuvwxyz";
  NSMutableArray* m_noDigitsArray = [NSMutableArray array];
  [noDigitsString enumerateSubstringsInRange:NSMakeRange(0, noDigitsString.length)
                                     options:NSStringEnumerationByComposedCharacterSequences
                                  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                    [m_noDigitsArray addObject:substring];
                                  }];
  NSSet* noDigitsSet = [NSSet setWithArray:m_noDigitsArray];
  XCTAssertNotNil(noDigitsSet);
  XCTAssertEqual(noDigitsSet.count, noDigitsString.length);
  
  NSString* randomDigitsOnlyString = [Tools randomStringDigitsOnlyWithLength:randomStringLength];
  XCTAssertNotNil(randomDigitsOnlyString);
  XCTAssertEqual(randomDigitsOnlyString.length, randomStringLength);
  
  NSMutableArray* m_randomDigitsOnlyArray = [NSMutableArray array];
  [randomDigitsOnlyString enumerateSubstringsInRange:NSMakeRange(0, randomDigitsOnlyString.length)
                                             options:NSStringEnumerationByComposedCharacterSequences
                                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                            [m_randomDigitsOnlyArray addObject:substring];
                                          }];
  NSSet* randomDigitsOnlySet = [NSSet setWithArray:m_randomDigitsOnlyArray];
  XCTAssertNotNil(randomDigitsOnlySet);
  XCTAssert(randomDigitsOnlySet.count > 0);
  
  XCTAssert([noDigitsSet intersectsSet:randomDigitsOnlySet] == NO);
}

- (void)testFuture {
  Future* future1 = [Future new];
  XCTAssertNil(future1.get);
  XCTAssertNil(future1.error);
  XCTAssertEqual(future1.state, FutureStateIncomplete);
  XCTestExpectation* success1 = [self expectationWithDescription:@"success1"];
  NSString* expectedValue1 = @"expectedValue1";
  [future1 onSuccess:^(NSString* __nonnull get) {
    [success1 fulfill];
    XCTAssertEqualObjects(get, expectedValue1);
  }];
  [future1 onFailure:^(NSError * __nonnull error) {
    XCTAssert(NO);
  }];
  [future1 succeedWith:expectedValue1];
  XCTAssertEqual(future1.state, FutureStateSucceeded);
  XCTAssertNotNil(future1.get);
  XCTAssertNil(future1.error);
  XCTAssertEqualObjects(future1.get, expectedValue1);
  
  Future* future2 = [Future new];
  XCTAssertEqual(future2.state, FutureStateIncomplete);
  XCTAssertNil(future2.get);
  XCTAssertNil(future2.error);
  XCTestExpectation* failure1 = [self expectationWithDescription:@"failure1"];
  NSString* expectedValue2 = @"expectedValue2";
  NSError* expectedError2 = [NSError errorWithDomain:expectedValue2 code:0 userInfo:nil];
  [future2 onSuccess:^(NSString* __nonnull get) {
    XCTAssert(NO);
  }];
  [future2 onFailure:^(NSError * __nonnull error) {
    [failure1 fulfill];
    XCTAssertEqualObjects(error.domain, expectedValue2);
  }];
  [future2 failWith:expectedError2];
  XCTAssertEqual(future2.state, FutureStateFailed);
  XCTAssertNil(future2.get);
  XCTAssertNotNil(future2.error);
  XCTAssertEqualObjects(((NSError*)future2.error).domain, expectedError2.domain);
  
  Future* future3 = [Future new];
  XCTAssertNil(future3.get);
  XCTAssertNil(future3.error);
  XCTAssertEqual(future3.state, FutureStateIncomplete);
  XCTestExpectation* success3_1 = [self expectationWithDescription:@"success3_1"];
  XCTestExpectation* success3_2 = [self expectationWithDescription:@"success3_2"];
  XCTestExpectation* success3_3 = [self expectationWithDescription:@"success3_3"];
  NSString* expectedValue3 = @"expectedValue3";
  [future3 onSuccess:^(NSString* __nonnull get) {
    [success3_1 fulfill];
    XCTAssertEqualObjects(get, expectedValue3);
  }];
  [future3 onSuccess:^(NSString* __nonnull get) {
    [success3_2 fulfill];
    XCTAssertEqualObjects(get, expectedValue3);
  }];
  [future3 onFailure:^(NSError * __nonnull error) {
    XCTAssert(NO);
  }];
  [future3 succeedWith:expectedValue3];
  XCTAssertEqual(future3.state, FutureStateSucceeded);
  XCTAssertNotNil(future3.get);
  XCTAssertNil(future3.error);
  XCTAssertEqualObjects(future3.get, expectedValue3);
  [future3 onSuccess:^(NSString* __nonnull get) {
    [success3_3 fulfill];
    XCTAssertEqualObjects(get, expectedValue3);
  }];
  
  Future* future4 = [Future new];
  XCTAssertNil(future4.get);
  XCTAssertNil(future4.error);
  XCTAssertEqual(future4.state, FutureStateIncomplete);
  XCTestExpectation* success4_1 = [self expectationWithDescription:@"success4_1"];
  XCTestExpectation* success4_2 = [self expectationWithDescription:@"success4_2"];
  XCTestExpectation* failure4_3 = [self expectationWithDescription:@"success4_2"];
  NSString* expectedValue4 = @"expectedValue4";
  NSError* expectedError4 = [NSError errorWithDomain:expectedValue4 code:0 userInfo:nil];
  [future4 onSuccess:^(NSString* __nonnull get) {
    [success4_1 fulfill];
    XCTAssertEqualObjects(get, expectedValue4);
  }];
  [future4 onFailure:^(NSError * __nonnull error) {
    XCTAssert(NO);
  }];
  
  Future* future5 = [[[future4
                       flatMap:^Future * __nonnull(id __nonnull get) {
                         [success4_2 fulfill];
                         XCTAssertEqualObjects(get, expectedValue4);
                         Future* newFuture = [Future new];
                         [newFuture succeedWith:get];
                         return newFuture;
                       }]
                      flatMap:^Future * __nonnull(id __nonnull get) {
                        [failure4_3 fulfill];
                        XCTAssertEqualObjects(get, expectedValue4);
                        Future* newFuture = [Future new];
                        [newFuture failWith:expectedError4];
                        return newFuture;
                      }]
                     flatMap:^Future * __nonnull(id __nonnull get) {
                       XCTAssert(NO);
                       return [Future new];
                     }];
  [future4 succeedWith:expectedValue4];
  XCTAssertEqual(future4.state, FutureStateSucceeded);
  XCTAssertNotNil(future4.get);
  XCTAssertNil(future4.error);
  XCTAssertEqualObjects(future4.get, expectedValue4);
  
  XCTestExpectation* wait = [self expectationWithDescription:@"wait"];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [wait fulfill];
    XCTAssertEqual(future5.state, FutureStateFailed);
    XCTAssertNil(future5.get);
    XCTAssertNotNil(future5.error);
    XCTAssertEqualObjects(((NSError*)future5.error).domain, expectedError4.domain);
  });
  
  [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testOptionalNoneSome {
  Optional* some = [Optional with:[NSArray array]];
  Optional* none = [Optional with:nil];
  XCTAssertEqual(some.type, OptionalTypeSome);
  XCTAssertNotNil(some.get);
  XCTAssert([some.get isKindOfClass:[NSArray class]]);
  XCTAssertEqual(none.type, OptionalTypeNone);
  XCTAssertNil(none.get);
  
  Optional* someAs = [Optional with:@2 as:[NSNumber class]];
  Optional* noneAs = [Optional with:@"2" as:[NSArray class]];
  XCTAssertEqual(someAs.type, OptionalTypeSome);
  XCTAssertNotNil(someAs.get);
  XCTAssert([someAs.get isKindOfClass:[NSNumber class]]);
  XCTAssertEqual([someAs.get integerValue], 2);
  XCTAssertEqual(noneAs.type, OptionalTypeNone);
  XCTAssertNil(noneAs.get);
  
  Optional* someWhen = [Optional with:@3 when:^BOOL(NSNumber* __nonnull number) {
    return number.integerValue == 3;
  }];
  Optional* noneWhen = [Optional with:@"4" when:^BOOL(NSString* __nonnull string) {
    return [string isEqualToString:@"3"];
  }];
  XCTAssertEqual(someWhen.type, OptionalTypeSome);
  XCTAssertNotNil(someWhen.get);
  XCTAssert([someWhen.get isKindOfClass:[NSNumber class]]);
  XCTAssertEqual([someWhen.get integerValue], 3);
  XCTAssertEqual(noneWhen.type, OptionalTypeNone);
  XCTAssertNil(noneWhen.get);
}

- (void)testOptionalMap {
  Optional* someNumber = [Optional with:@10];
  Optional* noneNumber = [Optional with:nil];
  XCTAssertEqual(someNumber.type, OptionalTypeSome);
  XCTAssertNotNil(someNumber.get);
  XCTAssert([someNumber.get isKindOfClass:[NSNumber class]]);
  XCTAssertEqual([someNumber.get integerValue], 10);
  XCTAssertEqual(noneNumber.type, OptionalTypeNone);
  XCTAssertNil(noneNumber.get);
  
  NSNumber*(^mapBlock)(NSNumber*) = ^NSNumber*(NSNumber* number) {
    return @([number integerValue]*0.5);
  };
  
  Optional* someHalfNumber = [someNumber map:mapBlock];
  XCTAssertEqual(someHalfNumber.type, OptionalTypeSome);
  XCTAssertNotNil(someHalfNumber.get);
  XCTAssert([someHalfNumber.get isKindOfClass:[NSNumber class]]);
  XCTAssertEqual([someHalfNumber.get integerValue], 5);
  
  Optional* noneHalfNumber = [noneNumber map:mapBlock];
  XCTAssertEqual(noneHalfNumber.type, OptionalTypeNone);
  XCTAssertNil(noneHalfNumber.get);
}

- (void)testOptionalFlatMap {
  NSArray* array = @[@1,@2,@3];
  NSArray* doubledArray = @[@2,@4,@6];
  Optional* someArray = [Optional with:array];
  Optional* noneArray = [Optional with:nil];
  XCTAssertEqual(someArray.type, OptionalTypeSome);
  XCTAssertNotNil(someArray.get);
  XCTAssert([someArray.get isKindOfClass:[NSArray class]]);
  XCTAssertEqual([someArray.get count], 3);
  XCTAssertEqualObjects(someArray.get[1], @2);
  XCTAssertEqual(noneArray.type, OptionalTypeNone);
  XCTAssertNil(noneArray.get);
  
  Optional*(^flatMapBlockToSome)(NSArray*) = ^Optional*(NSArray* array) {
    return [Optional with:doubledArray];
  };
  
  Optional*(^flatMapBlockToNone)(NSArray*) = ^Optional*(NSArray* array) {
    return [Optional with:nil];
  };
  
  Optional* someToSomeDoubledArray = [someArray flatMap:flatMapBlockToSome];
  Optional* someToNoneDoubledArray = [someArray flatMap:flatMapBlockToNone];
  Optional* noneToSomeDoubledArray = [noneArray flatMap:flatMapBlockToSome];
  Optional* noneToNoneDoubledArray = [noneArray flatMap:flatMapBlockToNone];
  
  XCTAssertEqual(someToSomeDoubledArray.type, OptionalTypeSome);
  XCTAssertEqual(someToNoneDoubledArray.type, OptionalTypeNone);
  XCTAssertEqual(noneToSomeDoubledArray.type, OptionalTypeNone);
  XCTAssertEqual(noneToNoneDoubledArray.type, OptionalTypeNone);
  
  XCTAssertNotNil(someToSomeDoubledArray.get);
  XCTAssert([someToSomeDoubledArray.get isKindOfClass:[NSArray class]]);
  XCTAssertNil(someToNoneDoubledArray.get);
  XCTAssertNil(noneToSomeDoubledArray.get);
  XCTAssertNil(noneToNoneDoubledArray.get);
  
  XCTAssertEqualObjects(someToSomeDoubledArray.get, doubledArray);
}

- (void)testOptionalZip
{
  Optional* opt1 = [Optional with:@1];
  Optional* opt2 = [Optional with:@2];
  Optional* zipped1 = [opt1 zipWith:opt2];
  
  XCTestExpectation* expectation1 = [self expectationWithDescription:@"expectation1"];
  
  NSNumber* sum1 = [[zipped1
                    map:^NSNumber*(Zipped* zip) {
                      NSNumber* number1 = zip.object1;
                      NSNumber* number2 = zip.object2;
                      
                      XCTAssertNotNil(number1);
                      XCTAssertNotNil(number2);
                      XCTAssertTrue([number1 isKindOfClass:[NSNumber class]]);
                      XCTAssertTrue([number2 isKindOfClass:[NSNumber class]]);
                      XCTAssertTrue([number1 integerValue] == 1);
                      XCTAssertTrue([number2 integerValue] == 2);
                      
                      [expectation1 fulfill];
                      return @([number1 integerValue] + [number2 integerValue]);
                    }]
                    get];
  
  XCTAssertNotNil(sum1);
  XCTAssertTrue([sum1 isKindOfClass:[NSNumber class]]);
  XCTAssertTrue([sum1 integerValue] == 3);
  
  [self waitForExpectationsWithTimeout:0.5 handler:nil];
}

- (void)testOptionalList
{
  OptionalList* list1 = [[[[[[OptionalList new]
                             with:[Optional with:nil]]
                            with:[Optional with:nil]]
                           with:[Optional with:@10]]
                          with:[Optional with:nil]]
                         with:[Optional with:@5]];
  
  Optional* firstOptional1 = [list1 getFirstOptionalSomeOrNone];
  XCTAssertNotNil(firstOptional1);
  XCTAssertTrue([firstOptional1 isKindOfClass:[Optional class]]);
  NSNumber* firstGet1 = [firstOptional1 get];
  XCTAssertNotNil(firstGet1);
  XCTAssertTrue([firstGet1 isKindOfClass:[NSNumber class]]);
  XCTAssertTrue([firstGet1 integerValue] == 10);
  
  NSNumber* get1 = [list1 getFirst];
  XCTAssertNotNil(get1);
  XCTAssertTrue([get1 isKindOfClass:[NSNumber class]]);
  XCTAssertTrue([get1 integerValue] == 10);
  
  OptionalList* list2 = [[[[OptionalList new]
                           with:[Optional with:nil]]
                          with:[Optional with:nil]]
                         with:[Optional with:nil]];
  
  Optional* firstOptional2 = [list2 getFirstOptionalSomeOrNone];
  XCTAssertNotNil(firstOptional2);
  
  NSNumber* get2 = [list2 getFirst];
  XCTAssertNil(get2);
}

- (void)testResultFailureSuccess {
  NSInteger errorCode = 12345;
  Either* success = [Either rightWith:[NSArray array]];
  Either* failure = [Either leftWith:[NSError errorWithDomain:@"" code:errorCode userInfo:nil]];
  XCTAssertEqual(success.type, EitherTypeRight);
  XCTAssertNotNil(success.right);
  XCTAssertNil(success.left);
  XCTAssert([success.right isKindOfClass:[NSArray class]]);
  XCTAssertEqual(failure.type, EitherTypeLeft);
  XCTAssertNotNil(failure.left);
  XCTAssertNil(failure.right);
  XCTAssert([failure.left isKindOfClass:[NSError class]]);
  XCTAssert(((NSError*)failure.left).code == errorCode);
}

- (void)testResultMap {
  NSInteger errorCode = 12345;
  Either* successNumber = [Either rightWith:@10];
  Either* failureNumber = [Either leftWith:[NSError errorWithDomain:@"" code:errorCode userInfo:nil]];
  XCTAssertEqual(successNumber.type, EitherTypeRight);
  XCTAssertNotNil(successNumber.right);
  XCTAssertNil(successNumber.left);
  XCTAssert([successNumber.right isKindOfClass:[NSNumber class]]);
  XCTAssertEqual([successNumber.right integerValue], 10);
  XCTAssertEqual(failureNumber.type, EitherTypeLeft);
  XCTAssertNotNil(failureNumber.left);
  XCTAssertNil(failureNumber.right);
  XCTAssert([failureNumber.left isKindOfClass:[NSError class]]);
  
  NSNumber*(^mapBlock)(NSNumber*) = ^NSNumber*(NSNumber* number) {
    return @([number integerValue]*0.5);
  };
  
  Either* resultHalfNumber = [successNumber map:mapBlock];
  XCTAssertEqual(resultHalfNumber.type, EitherTypeRight);
  XCTAssertNil(resultHalfNumber.left);
  XCTAssertNotNil(resultHalfNumber.right);
  XCTAssert([resultHalfNumber.right isKindOfClass:[NSNumber class]]);
  XCTAssertEqual([resultHalfNumber.right integerValue], 5);
  
  Either* failureHalfNumber = [failureNumber map:mapBlock];
  XCTAssertEqual(failureHalfNumber.type, EitherTypeLeft);
  XCTAssertNil(failureHalfNumber.right);
  XCTAssertNotNil(failureHalfNumber.left);
  XCTAssert([failureHalfNumber.left isKindOfClass:[NSError class]]);
  XCTAssert(((NSError*)failureHalfNumber.left).code == errorCode);
}

- (void)testResultFlatMap {
  NSInteger errorCode = 12345;
  NSArray* array = @[@1,@2,@3];
  NSArray* doubledArray = @[@2,@4,@6];
  Either* successArray = [Either rightWith:array];
  Either* failureArray = [Either leftWith:[NSError errorWithDomain:@"" code:errorCode userInfo:nil]];
  XCTAssertEqual(successArray.type, EitherTypeRight);
  XCTAssertNotNil(successArray.right);
  XCTAssertNil(successArray.left);
  XCTAssert([successArray.right isKindOfClass:[NSArray class]]);
  XCTAssertEqual([successArray.right count], 3);
  XCTAssertEqualObjects(successArray.right[1], @2);
  XCTAssertEqual(failureArray.type, EitherTypeLeft);
  XCTAssertNil(failureArray.right);
  XCTAssertNotNil(failureArray.left);
  XCTAssertNil(failureArray.right);
  XCTAssert(((NSError*)failureArray.left).code == errorCode);
  
  Either*(^flatMapBlockToSuccess)(NSArray*) = ^Either*(NSArray* array) {
    return [Either rightWith:doubledArray];
  };
  
  Either*(^flatMapBlockToFailure)(NSArray*) = ^Either*(NSArray* array) {
    return [Either leftWith:[NSError errorWithDomain:@"" code:errorCode userInfo:nil]];
  };
  
  Either* successToSuccessDoubledArray = [successArray flatMap:flatMapBlockToSuccess];
  Either* successToFailureDoubledArray = [successArray flatMap:flatMapBlockToFailure];
  Either* failureToSuccessDoubledArray = [failureArray flatMap:flatMapBlockToSuccess];
  Either* failureToFailureDoubledArray = [failureArray flatMap:flatMapBlockToFailure];
  
  XCTAssertEqual(successToSuccessDoubledArray.type, EitherTypeRight);
  XCTAssertEqual(successToFailureDoubledArray.type, EitherTypeLeft);
  XCTAssertEqual(failureToSuccessDoubledArray.type, EitherTypeLeft);
  XCTAssertEqual(failureToFailureDoubledArray.type, EitherTypeLeft);
  
  XCTAssertNotNil(successToSuccessDoubledArray.right);
  XCTAssertNil(successToSuccessDoubledArray.left);
  XCTAssert([successToSuccessDoubledArray.right isKindOfClass:[NSArray class]]);
  XCTAssertNil(successToFailureDoubledArray.right);
  XCTAssertNotNil(successToFailureDoubledArray.left);
  XCTAssert(((NSError*)successToFailureDoubledArray.left).code == errorCode);
  XCTAssertNil(failureToSuccessDoubledArray.right);
  XCTAssertNotNil(failureToSuccessDoubledArray.left);
  XCTAssert(((NSError*)failureToSuccessDoubledArray.left).code == errorCode);
  XCTAssertNil(failureToFailureDoubledArray.right);
  XCTAssertNotNil(failureToFailureDoubledArray.left);
  XCTAssert(((NSError*)failureToFailureDoubledArray.left).code == errorCode);
  
  XCTAssertEqualObjects(successToSuccessDoubledArray.right, doubledArray);
}

- (void)testMatch {
  NSNumber* numberToMatch = @2;
  
  NSString* matchedString1  =
  [[[[[Match :numberToMatch]
      
      with:^BOOL(NSNumber* get){
        return [get isEqualToNumber:@1];
      }
      give:^NSString*(NSNumber* get) {
        return @"number is 1";
      }]
     
     with:^BOOL(NSNumber* get){
       return [get isEqualToNumber:@2];
     }
     give:^NSString*(NSNumber* get) {
       return @"number is 2";
     }]
    
    with:^BOOL(NSNumber* get){
      return [get isEqualToNumber:@3];
    }
    give:^NSString*(NSNumber* get) {
      return @"number is 3";
    }]
   
   otherwise:^id{
     return nil;
   }];
  
  XCTAssertNotNil(matchedString1);
  XCTAssertEqualObjects(matchedString1, @"number is 2");
  
  NSString* matchedString2  =
  [[[[[Match :numberToMatch]
      
      with:^BOOL(NSNumber* get){
        return [get isEqualToNumber:@1];
      }
      give:^NSString*(NSNumber* get) {
        return @"number is 1";
      }]
     
     with:^BOOL(NSNumber* get){
       return [get isEqualToNumber:@3];
     }
     give:^NSString*(NSNumber* get) {
       return @"number is 2";
     }]
    
    with:^BOOL(NSNumber* get){
      return [get isEqualToNumber:@2];
    }
    give:^NSString*(NSNumber* get) {
      return @"number is 3";
    }]
   
   otherwise:^id{
     return nil;
   }];
  
  XCTAssertNotNil(matchedString2);
  XCTAssertEqualObjects(matchedString2, @"number is 3");
  
  NSString* matchedString3  =
  [[[[[Match :numberToMatch]
      
      with:^BOOL(NSNumber* get){
        return [get isEqualToNumber:@1];
      }
      give:^NSString*(NSNumber* get) {
        return @"number is 1";
      }]
     
     with:^BOOL(NSNumber* get){
       return [get isEqualToNumber:@3];
     }
     give:^NSString*(NSNumber* get) {
       return @"number is 2";
     }]
    
    with:^BOOL(NSNumber* get){
      return [get isEqualToNumber:@4];
    }
    give:^NSString*(NSNumber* get) {
      return @"number is 3";
    }]
   
   otherwise:^id{
     return nil;
   }];
  
  XCTAssertNil(matchedString3);
  
  NSString* matchedString4  =
  [[[[[Match :numberToMatch]
      
      with:^BOOL(NSNumber* get){
        return [get isEqualToNumber:@1];
      }
      give:^NSString*(NSNumber* get) {
        return @"number is 1";
      }]
     
     with:^BOOL(NSNumber* get){
       return [get isEqualToNumber:@3];
     }
     give:^NSString*(NSNumber* get) {
       return @"number is 2";
     }]
    
    with:^BOOL(NSNumber* get){
      return [get isEqualToNumber:@4];
    }
    give:^NSString*(NSNumber* get) {
      return @"number is 3";
    }]
   
   otherwise:^NSString*{
     return @"number not found";
   }];
  
  XCTAssertNotNil(matchedString4);
  XCTAssertEqualObjects(matchedString4, @"number not found");
  
  NSString* matchedString5 =
  [[[[[[Match :@3]
       type:[NSString class] give:^NSString*(NSString* string) { return @"string"; }]
      type:[NSArray class] give:^NSString*(NSArray* array) { return @"array"; }]
     type:[NSNumber class] give:^NSString*(NSNumber* number) { return @"number"; }]
    type:[NSDictionary class] give:^NSString*(NSDictionary* dictionary) { return @"dictionary"; }]
   otherwise:^id{ return nil; }];
  
  XCTAssertNotNil(matchedString5);
  XCTAssert([matchedString5 isKindOfClass:[NSString class]]);
  XCTAssertEqualObjects(matchedString5, @"number");
}

- (void)testBlocks1
{
  NSString* key1 = @"key1";
  NSString* key2 = @"key2";
  NSNumber* value1 = @1;
  NSString* value2 = @"1";
  Optional*(^block1)(NSDictionary*) = [Block
                                       optionalForKey:key1
                                       as:[NSNumber class]];
  
  NSDictionary* dict1 = @{key1 : value1};
  NSDictionary* dict2 = @{key2 : value1};
  NSDictionary* dict3 = @{key1 : value2};
  NSDictionary* dict4 = @{key2 : value2};
  
  Optional* optional1 = block1(dict1);
  XCTAssertNotNil(optional1);
  XCTAssertTrue([optional1 isKindOfClass:[Optional class]]);
  XCTAssertTrue(optional1.type == OptionalTypeSome);
  XCTAssertNotNil(optional1.get);
  XCTAssertTrue([optional1.get isKindOfClass:[NSNumber class]]);
  XCTAssertEqualObjects(optional1.get, value1);
  
  Optional* optional2 = block1(dict2);
  XCTAssertNotNil(optional2);
  XCTAssertTrue([optional2 isKindOfClass:[Optional class]]);
  XCTAssertTrue(optional2.type == OptionalTypeNone);
  XCTAssertNil(optional2.get);
  
  Optional* optional3 = block1(dict3);
  XCTAssertNotNil(optional3);
  XCTAssertTrue([optional3 isKindOfClass:[Optional class]]);
  XCTAssertTrue(optional3.type == OptionalTypeNone);
  XCTAssertNil(optional3.get);
  
  Optional* optional4 = block1(dict4);
  XCTAssertNotNil(optional4);
  XCTAssertTrue([optional4 isKindOfClass:[Optional class]]);
  XCTAssertTrue(optional4.type == OptionalTypeNone);
  XCTAssertNil(optional4.get);

}

- (void)testSignal
{
  Signal* signal1 = [Signal withQueue:[Queue main]];
  
  XCTestExpectation* expectation1 = [self expectationWithDescription:@"expectation1"];
  XCTestExpectation* expectation2 = [self expectationWithDescription:@"expectation2"];
  XCTestExpectation* expectation3 = [self expectationWithDescription:@"expectation3"];

  NSString* string1 = @"string1";
  
  [signal1
   observe:^SignalSegue(id value) {
     XCTAssertNotNil(value);
     XCTAssertTrue([value isKindOfClass:[NSString class]]);
     XCTAssertEqualObjects(value, string1);
     [expectation1 fulfill];
     return SignalSegueStop;
   }];
  
  [signal1
   observe:^SignalSegue(id value) {
     XCTAssertNotNil(value);
     XCTAssertTrue([value isKindOfClass:[NSString class]]);
     XCTAssertEqualObjects(value, string1);
     [expectation2 fulfill];
     return SignalSegueStop;
   }];
  
  [signal1
   observe:^SignalSegue(id value) {
     XCTAssertNotNil(value);
     XCTAssertTrue([value isKindOfClass:[NSString class]]);
     XCTAssertEqualObjects(value, string1);
     [expectation3 fulfill];
     return SignalSegueStop;
   }];
  
  [signal1 send:string1];

  [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testSignalSegue
{
  Signal* signal1 = [Signal withQueue:[Queue main]];
  
  XCTestExpectation* expectation1 = [self expectationWithDescription:@"expectation1"];
  XCTestExpectation* expectation2 = [self expectationWithDescription:@"expectation2"];
  XCTestExpectation* expectation3 = [self expectationWithDescription:@"expectation3"];
  
  NSString* string1 = @"string1";
  NSString* string2 = @"string2";
  NSString* string3 = @"string3";
  NSString* string4 = @"string4";

  __block NSInteger observationCount = 0;
  
  [signal1
   observe:^SignalSegue(NSString* string) {
     observationCount += 1;
     
     switch (observationCount)
     {
       case 1:
       {
         [expectation1 fulfill];
         XCTAssertEqualObjects(string, string1);
         return SignalSegueContinue;
         break;
       }
       case 2:
       {
         [expectation2 fulfill];
         XCTAssertEqualObjects(string, string2);
         return SignalSegueContinue;
         break;
       }
       case 3:
       {
         [expectation3 fulfill];
         XCTAssertEqualObjects(string, string3);
         return SignalSegueStop;
         break;
       }
       case 4:
       {
         XCTAssertTrue(false);
         return SignalSegueStop;
         break;
       }
         
       default:
       {
         XCTAssertTrue(false);
         break;
       }
     }
     
     
   }];
  
  XCTestExpectation* expectationWait = [self expectationWithDescription:@"expectationWait"];
  [[Queue main]
   after:2.5
   task:^{
     [expectationWait fulfill];
   }];
  
  [[Queue main]
  after:0.5
   task:^{
     [signal1 send:string1];
   }];
  
  [[Queue main]
   after:1
   task:^{
     [signal1 send:string2];
   }];
  
  [[Queue main]
   after:1.5
   task:^{
     [signal1 send:string3];
   }];
  
  [[Queue main]
   after:2
   task:^{
     [signal1 send:string4];
   }];
  
  [self waitForExpectationsWithTimeout:3 handler:nil];
}

@end
