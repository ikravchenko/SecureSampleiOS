#import <Foundation/Foundation.h>
#import <RNCryptor/RNCryptor.h>
#import <RNCryptor/RNDecryptor.h>
#import <RNCryptor/RNEncryptor.h>

@interface CypherHelper : NSObject
+ (NSData *)encryptData:(NSData *)data password:(NSString *)password;
+ (NSData *)decryptData:(NSData *)data password:(NSString *)password;
@end