//
//  Macro.h
//  APP
//
//  Created by hx on 2020/12/26.
//

#ifndef Macro_h
#define Macro_h

//学习多target管理

#ifdef APPDEV

#define BASE_URL @"http://www.kpl.com"

#else

#define BASE_URL @"http://www.kpltest.com"

#endif



#endif /* Macro_h */
