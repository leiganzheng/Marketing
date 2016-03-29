//
//  IP.m
//  Marketing
//
//  Created by leiganzheng on 16/3/29.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

#import "IP.h"
#import "IPAdress.h"

@implementation IP
-(NSString*)getDeviceIPAddress

{
    
    InitAddresses();
    
    GetIPAddresses();
    
    GetHWAddresses();
    
    
    
    int i;
    
    NSString *deviceIP = nil;
    
    
    
    for (i=0; i<MAXADDRS; ++i)
        
    {
        
        static unsigned  long localHost = 0x7F000001;            // 127.0.0.1
        
        unsigned long theAddr;
        
        
        
        theAddr = ip_addrs[i];
        
        
        
        if (theAddr == 0) break;
        
        if (theAddr == localHost) continue;
        
        
        
        NSString *ifName = [NSString  stringWithFormat:@"%s",if_names[i]];
        
        
        
        
        
        if ([ifName isEqualToString:@"en0"])
            
        {
            
            deviceIP = [NSString stringWithFormat:@"%s",ip_names[i]];;
            
        }
        
        
        
    }
    
    
    
    //save deviceIP
    
    if (deviceIP.length > 1)
        
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:deviceIP forKey:@"deviceIP"];
        
    }
    
    return deviceIP;
    
}
@end
