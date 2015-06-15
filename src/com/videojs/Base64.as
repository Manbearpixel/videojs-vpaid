/* 
 * Copyright (C) 2012 Jean-Philippe Auclair 
 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php 
 * Base64 library for ActionScript 3.0. 
 * By: Jean-Philippe Auclair : http://jpauclair.net 
 * Based on article: http://jpauclair.net/2010/01/09/base64-optimized-as3-lib/ 
 * Benchmark: 
 * This version: encode: 260ms decode: 255ms 
 * Blog version: encode: 322ms decode: 694ms 
 * as3Crypto encode: 6728ms decode: 4098ms 
 * 
 * Encode: com.sociodox.utils.Base64 is 25.8x faster than as3Crypto Base64 
 * Decode: com.sociodox.utils.Base64 is 16x faster than as3Crypto Base64 
 * 
 * Optimize & Profile any Flash content with TheMiner ( http://www.sociodox.com/theminer ) 
 */
package com.videojs {

    import flash.utils.ByteArray;

    public class Base64 {

        // TEMP BASE64 FOR TESTING
        // From: http://www.sociodox.com/base64.html
        private static const _decodeChars:Vector.<int> = InitDecodeChar();
        
        public static function decode(str:String):ByteArray  
        {  
            var c1:int;  
            var c2:int;  
            var c3:int;  
            var c4:int;  
            var i:int = 0;  
            var len:int = str.length;  
              
            var byteString:ByteArray = new ByteArray();  
            byteString.writeUTFBytes(str);  
            var outPos:int = 0;  
            while (i < len)  
            {  
                //c1  
                c1 = _decodeChars[int(byteString[i++])];  
                if (c1 == -1)  
                    break;  
                  
                //c2  
                c2 = _decodeChars[int(byteString[i++])];  
                if (c2 == -1)  
                    break;  
                  
                byteString[int(outPos++)] = (c1 << 2) | ((c2 & 0x30) >> 4);  
                  
                //c3  
                c3 = byteString[int(i++)];  
                if (c3 == 61)  
                {  
                    byteString.length = outPos  
                    return byteString;  
                }  
                  
                c3 = _decodeChars[int(c3)];  
                if (c3 == -1)  
                    break;  
                  
                byteString[int(outPos++)] = ((c2 & 0x0f) << 4) | ((c3 & 0x3c) >> 2);  
                  
                //c4  
                c4 = byteString[int(i++)];  
                if (c4 == 61)  
                {  
                    byteString.length = outPos  
                    return byteString;  
                }  
                  
                c4 = _decodeChars[int(c4)];  
                if (c4 == -1)  
                    break;  
                  
                byteString[int(outPos++)] = ((c3 & 0x03) << 6) | c4;  
            }  
            byteString.length = outPos  
            return byteString;  
        }
          
        public static function InitDecodeChar():Vector.<int>  
        {  
              
            var decodeChars:Vector.<int> = new <int>[  
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,   
                52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,   
                -1,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,   
                15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,   
                -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,   
                41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1,   
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];  
              
            return decodeChars;  
        }
    }
}