#import "CypherHelper.h"

@implementation CypherHelper
+ (NSData *)encryptData:(NSData *)data password:(NSString *)password {
  return [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:password error:nil];
}
+ (NSData *)decryptData:(NSData *)data password:(NSString *)password {
  return [RNDecryptor decryptData:data withSettings:kRNCryptorAES256Settings password:password error:nil];
}
@end
