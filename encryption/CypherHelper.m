#import "CypherHelper.h"

@implementation CypherHelper
+ (NSData *)encryptData:(NSData *)data password:(NSString *)password {
  return [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:password error:nil];
}
+ (NSData *)decryptData:(NSData *)data password:(NSString *)password {
  return [RNDecryptor decryptData:data withSettings:kRNCryptorAES256Settings password:password error:nil];
}

+(NSString *)createSHA512:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF16LittleEndianStringEncoding];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString  stringWithCapacity:CC_SHA512_DIGEST_LENGTH];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}
@end
