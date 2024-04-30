//
//  RSA.m
//  SHUMEIApp
//
//  Created by mac on 2023/4/19.
//

#import "RSA.h"
#import <Security/Security.h>

#define PUBLIC_KEY @"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCT+e3G3N0amkboF5Bv11tk13dLRGoBMq5dkIQE732gKbpoGIpzjZzO3TAM6jmZjiVKECuEuuzbY9npt/+lr99DPQ9mJdivWLM1sgt0Wf4CY2xwHhP8rC7CUHQQ9DoUm3YzjGYsQgUcSrZZ+UypSN3AtTQoRRk2VGZbu5nykwY6500hGu73dmU7GQETRKdECPuUbFaveMSlTPCZYivAFV5E/JjpAib1irRNT5OpkzWl+fg+TxRNYhDzLGU1boYb51CIAZmFwg1WiaK7DWXs9mpTZeE1cC7oJRSG+4yuSBgNHHnN6Ku9U8pPs/XEiw6At4W+4OUw5GOmwC3wUMhlA7mJAgMBAAECggEAEXp68HtUDnlcmLt3zw4T+IROzfAlyUBwQhL41RBouUtUfkkvyVhXxkNwEoZ0CUQ1+VqRmVru8TcJHUcjhjGQ4INM11bvEj8a4+PE4JhknWma/F9BIx4/Y6pXG02NsrNuMcaKpv2hVucoRNZijLhToRiGMZ9/y+AKOxmcpH9jQ/+wdNi/ouhnXTa0wDOiS1N7Y2sLzSis8qEqhNGhAM7zvJo40NpLKQKdbgaQv4bBDDS+Fr/7ADN+M/OZRZMv0ELc5elYWmkd3EzH/z6jhS1nzqbKT9UOb3Na8eUSN5xPnURjc0/2YigrQmG3C8/tskWcdKxSry61WwyhTUCcaX/4gQKBgQD/nvew1U1aeULPx6Wu+bSatTw6QHf07Mgx3Bt0bDopXBP62aO97lairKuvYoC2lXr0clWWqZM7PeZxDOEr79Q/oI2qdlDnkCwpDjg2kxPryXwofRH96VzGxOhkfJM0O8nYEB3QEysuYe7yFrY4fq2lf4UfUGV2avROh05NGuTgcQKBgQCUMhmR8iPwrVSfdPJTGozF+N6VqfPPpQDJyRPb/QwZpCf3i/m1rQbyJ/crznJqVJh4MHDiVYNrmktNxi9RylyCvaS8xJZowyLUyLC3PpqZY+UgPmyZ8dvV3mH+Z0N7sS2RpVbsIULJjE+qXuz18pWbyCVkmXJw9khF3fNQMd32mQKBgF09PfnZhBKpQo6Js0yktpTr4KEa3OaQ6+EL+VO5Gmn1tS/97PUdl6pUs3cQxgRTd/rsLX38MsEcLg80dHnTTCc9SA9SguZEN2duUWDOuyh5YPlfzY1Bbt7t+hqVOhiGanSORGGebFTJ0h+p2yO2SV6hqgwnBitwjdaLEiub0LpxAoGBAIS3FUUph1wrreQbdEROO5Gz3YpEqE7lov4SsFFLncF8zDoZxegYa2cDuYwmlzp4Rg8kuoNHN6luhU/CU3A4/H4tXdGbcGOjlZbfn7qLOyJxXqlwnguDmG9Ad5vAWKP2OSv82Qogg1JB8LpPxoA/3hGjvTEJZn6ZYIIJUbQY5IHJAoGAKfqocglDEKlXHHsF1fiLM87HhAM1v1FxbefQGF/CJRNwG0sXVKH2/DdQFTQs57ntu4Td8wt0UyGnXmYL+N8z1zRE3MP0MZAjL6I5k1wanKXK+RT3FP9BVmEl+kHh4hQIcOYOfYz+0N+GUHD41pO5YESZSiwO/ZBXZmz7t2jsfMs="

@implementation RSA

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}


#pragma mark - 使用私钥字符串解密


 //使用私钥字符串解密
 + (NSDictionary *)decryptString:(NSString *)str privateKey:(NSString *)privKey{
     if (!str) return nil;
     
     privKey = PUBLIC_KEY;
     
     NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
     data = [self decryptData:data privateKey:privKey];
//     NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSDictionary *ret = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
     return ret;
 }

 + (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey{
     if(!data || !privKey){
         return nil;
     }
     SecKeyRef keyRef = [self addPrivateKey:privKey];
     if(!keyRef){
         return nil;
     }
     return [self decryptData:data withKeyRef:keyRef];
 }

 + (SecKeyRef)addPrivateKey:(NSString *)key{
     NSRange spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
     NSRange epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
     if(spos.location != NSNotFound && epos.location != NSNotFound){
         NSUInteger s = spos.location + spos.length;
         NSUInteger e = epos.location;
         NSRange range = NSMakeRange(s, e-s);
         key = [key substringWithRange:range];
     }
     key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
     key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
     key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
     key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];

     // This will be base64 encoded, decode it.
     NSData *data = base64_decode(key);
     data = [self stripPrivateKeyHeader:data];
       if(!data){
          return nil;
      }
 
      //a tag to read/write keychain storage
      NSString *tag = @"RSAUtil_PrivKey";
      NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
 
      // Delete any old lingering key with the same tag
      NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
      [privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
      [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
      [privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
      SecItemDelete((__bridge CFDictionaryRef)privateKey);
 
      // Add persistent version of the key to system keychain
      [privateKey setObject:data forKey:(__bridge id)kSecValueData];
      [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
       kSecAttrKeyClass];
      [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
       kSecReturnPersistentRef];
 
      CFTypeRef persistKey = nil;
      OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
      if (persistKey != nil){
          CFRelease(persistKey);
      }
      if ((status != noErr) && (status != errSecDuplicateItem)) {
          return nil;
      }
      [privateKey removeObjectForKey:(__bridge id)kSecValueData];
      [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
      [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
      [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
 
      // Now fetch the SecKeyRef version of the key
      SecKeyRef keyRef = nil;
      status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
      if(status != noErr){
          return nil;
      }
      return keyRef;
  }
 
  + (NSData *)stripPrivateKeyHeader:(NSData *)d_key{
      // Skip ASN.1 private key header
      if (d_key == nil) return(nil);
 
      unsigned long len = [d_key length];
      if (!len) return(nil);
 
      unsigned char *c_key = (unsigned char *)[d_key bytes];
      unsigned int  idx     = 22; //magic byte at offset 22
 
      if (0x04 != c_key[idx++]) return nil;
 
      //calculate length of the key
      unsigned int c_len = c_key[idx++];
      int det = c_len & 0x80;
      if (!det) {
          c_len = c_len & 0x7f;
      } else {
          int byteCount = c_len & 0x7f;
          if (byteCount + idx > len) {
              //rsa length field longer than buffer
              return nil;
          }
          unsigned int accum = 0;
          unsigned char *ptr = &c_key[idx];
          idx += byteCount;
          while (byteCount) {
              accum = (accum << 8) + *ptr;
              ptr++;
              byteCount--;
          }
          c_len = accum;
      }
      // Now make a new NSData from this buffer
      return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
  }
 
  + (NSData *)decryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
      const uint8_t *srcbuf = (const uint8_t *)[data bytes];
      size_t srclen = (size_t)data.length;
 
      size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
      UInt8 *outbuf = malloc(block_size);
      size_t src_block_size = block_size;
 
      NSMutableData *ret = [[NSMutableData alloc] init];
      for(int idx=0; idx<srclen; idx+=src_block_size){
          //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
          size_t data_len = srclen - idx;
          if(data_len > src_block_size){
              data_len = src_block_size;
          }
 
          size_t outlen = block_size;
          OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                                 kSecPaddingNone,
                                 srcbuf + idx,
                                 data_len,
                                 outbuf,
                                 &outlen
                                 );
          if (status != 0) {
              NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
              ret = nil;
              break;
          }else{
              //the actual decrypted data is in the middle, locate it!
              int idxFirstZero = -1;
              int idxNextZero = (int)outlen;
              for ( int i = 0; i < outlen; i++ ) {
                  if ( outbuf[i] == 0 ) {
                      if ( idxFirstZero < 0 ) {
                          idxFirstZero = i;
                      } else {
                          idxNextZero = i;
                          break;
                      }
                  }
              }
 
              [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
          }
      }
      free(outbuf);
      CFRelease(keyRef);
      return ret;
  }

@end
