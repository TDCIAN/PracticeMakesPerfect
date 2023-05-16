//
//  main.m
//  objectivec-smile-han
//
//  Created by JeongminKim on 2023/05/16.
//

#import "MyClass.h"
#import "Dog.h"
#import "Man.h"

int main(int argc, const char * argv[]) {

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Dog *happy = [[Dog alloc] init];
//    [happy setAge:5];
    happy.age = 5;
    NSLog(@"해피의 나이는 %d", [happy age]);
//    [happy setAge:2];
    happy.age = 2;
//    NSLog(@"해피의 나이는 %d", [happy age]);
    NSLog(@"해피의 나이는 %d", happy.age);
//    [happy show];
    
    Man *man = [[Man alloc] init];
    [man run];    
    [pool drain];
    return 0;
}
