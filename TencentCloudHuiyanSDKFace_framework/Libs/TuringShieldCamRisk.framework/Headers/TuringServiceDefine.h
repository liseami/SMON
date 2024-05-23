//
//  TuringServiceDefine.h
//  TuringShield
//
//  Created by 徐森圣 on 2018/3/13.
//  Copyright © 2018年 Tecent Inc. All rights reserved.
//
//  $$api_level=TS_TURING_SHIELD_OPEN_API_LEVEL$$
//
//

#ifndef __TURING_SERVICE_DEFINE_H__
#define __TURING_SERVICE_DEFINE_H__

#import "TuringServiceSettings.h"

#define TS_OBJECT_CLASS(name) TS_CLASS_##name

#define TS_OBJECT_IMPL(name)  TS_REAL_##name

#define TS_OBJECT_DECL(name) \
    @protocol TS_OBJECT_CLASS(name) <NSObject> \
    @end \
    typedef NSObject<TS_OBJECT_CLASS(name)> *name##_t

#define TS_OBJECT_DECL_SUBCLASS(name, super) \
    @protocol TS_OBJECT_CLASS(name) <TS_OBJECT_CLASS(super)> \
    @end \
    typedef NSObject<TS_OBJECT_CLASS(name)> *name##_t

#if defined(__cplusplus)
#define    TS_BEGIN_DECLS  extern "C" {
#define    TS_END_DECLS    }
#else
#define    TS_BEGIN_DECLS
#define    TS_END_DECLS
#endif

TS_OBJECT_DECL(ts_object);


/**
 将浮点类型的秒数转换为长整数类型的毫秒数

 @param sec 秒数，需要为double类型
 @return 毫秒数，long long类型
 */
#define SEC_TO_MSEC(sec)  (int64_t)( (sec) * 1000ll )



/**
 如果condition的定义为0或未定义，则声明函数不可用

 @param condition 一个可展开的宏定义
 */
#define TS_AVAILABLE_IF(condition)                  \
    __TS_IF_ELSE(condition)                         \
        /*Case True*/ (__TS_EMPTY())                \
        /*Case False*/(UNAVAILABLE_ATTRIBUTE)


/**
 如果c1或c2中任意一个的定义为0或未定义，则声明函数不可用

 @param c1 条件1，一个可展开的宏定义
 @param c2 条件2，一个可展开的宏定义
 */
#define TS_AVAILABLE_IFS(c1, c2)                    \
    __TS_IF_ELSE(c1)                                \
        /*Case True*/ (TS_AVAILABLE_IF(c2))         \
        /*Case False*/(UNAVAILABLE_ATTRIBUTE)


/**
 如果当前线程是主线程，直接执行包含的短语句；如果当前不在主线
 程，将包含的短语句调度到主线程执行，并阻塞当前线程。

 @param ... 一个需要调度到主线程执行的短语句
 */
#define TSMainThreadProtectCall(...) do {           \
    if ([NSThread isMainThread] == NO) {            \
        dispatch_sync(dispatch_get_main_queue(), ^{ \
            __VA_ARGS__;                            \
        });                                         \
    }                                               \
    else {                                          \
        __VA_ARGS__;                                \
    }                                               \
} while (0)

/**
 如果当前线程是主线程，直接执行包含的短语句；如果当前不在主线
 程，将包含的短语句调度到主线程执行，并阻塞当前线程。然后返回
 短语句执行的结果。注意，如果返回值是Objective C对象，目前
 不支持MRC。
 
 @param ... 一个需要调度到主线程执行的短语句
 @return 短语句的返回值
 */
#define TSMainThreadProtectGet(...) ({              \
    typeof(__VA_ARGS__) val;                        \
    if ([NSThread isMainThread] == NO) {            \
        __block typeof(val) bval;                   \
        dispatch_sync(dispatch_get_main_queue(), ^{ \
            bval = __VA_ARGS__;                     \
        });                                         \
        val = bval;                                 \
    }                                               \
    else {                                          \
        val = __VA_ARGS__;                          \
    }                                               \
    val;                                            \
})


#define __1second           (1.0f)
#define __10seconds         (__1second * 10)
#define __20seconds         (__1second * 20)
#define __1minute           (__1second * 60)
#define __10minutes         (__1minute * 10)
#define __30minutes         (__1minute * 30)
#define __1hour             (__1minute * 60)
#define __1day              (__1hour * 24)
#define __1week             (__1day * 7)

#define ts_shutup(v)            (void)(v)


///
/// there's a stupid bug in @available:
///     If we build TuringShield in Xcode 11 and use @available in TuringShield, Xcode 11 is ALSO required
///  on building the An app that integrating TuringShield. The main reason is, the implementation of
///  @available in Xcode 11 is different to the one in Xcode 10.
///     So let's disable @available for time being.
///
#if 0
#define ts_ios_version_is_at_least(major, minor, patch) @available(iOS major##.##minor##.##patch, *)
#else
#define ts_ios_version_is_at_least(major, minor, patch) \
({ \
    NSOperatingSystemVersion v =                          \
        NSProcessInfo.processInfo.operatingSystemVersion; \
    v.majorVersion == major ?               \
        ( v.minorVersion == minor ?         \
            ( v.patchVersion >= patch ) :   \
            ( v.minorVersion > minor ) ) :  \
        ( v.majorVersion > major );         \
})
#endif


#if defined(TS_SDK_CHANNEL_ID) && TS_USES_CLASS_ALIAS
#define tsclassname(name)           __TS_CAT(name, TS_ALIAS_SURFIX)
#define tsmethodname(name)          __TS_CAT(TS_ALIAS_SURFIX, name)
#define tsclass(className)          class tsclassname(className); @compatibility_alias className tsclassname(className)
#else
#define tsclassname(name)           name
#define tsmethodname(name)          name
#define tsclass(className)          class className
#endif

#define ts_channel_alias(name)      __TS_CAT(name, __TS_CAT(_, TS_SDK_CHANNEL_ID))

#define TS_DEPRECATED          __attribute__((deprecated))
#define TS_MSG_DEPRECATED(msg) __attribute((deprecated((msg))))

#pragma mark - Inner Macro, do NOT use


#define __TS_ARG_0_(n, ...)                                        n
#define __TS_ARG_1_(x0, n, ...)                                    n
#define __TS_ARG_2_(x0, x1, n, ...)                                n
#define __TS_ARG_3_(x0, x1, x2, n, ...)                            n
#define __TS_ARG_4_(x0, x1, x2, x3, n, ...)                        n
#define __TS_ARG_5_(x0, x1, x2, x3, x4, n, ...)                    n
#define __TS_ARG_6_(x0, x1, x2, x3, x4, x5, n, ...)                n
#define __TS_ARG_7_(x0, x1, x2, x3, x4, x5, x6, n, ...)            n
#define __TS_ARG_8_(x0, x1, x2, x3, x4, x5, x6, x7, n, ...)        n
#define __TS_ARG_9_(x0, x1, x2, x3, x4, x5, x6, x7, x8, n, ...)    n

#define __TS_EVAL(...)              __TS_EVAL1(__TS_EVAL1(__TS_EVAL1(__VA_ARGS__)))
#define __TS_EVAL1(...)             __TS_EVAL2(__TS_EVAL2(__TS_EVAL2(__VA_ARGS__)))
#define __TS_EVAL2(...)             __TS_EVAL3(__TS_EVAL3(__TS_EVAL3(__VA_ARGS__)))
#define __TS_EVAL3(...)             __TS_EVAL4(__TS_EVAL4(__TS_EVAL4(__VA_ARGS__)))
#define __TS_EVAL4(...)             __TS_EVAL5(__TS_EVAL5(__TS_EVAL5(__VA_ARGS__)))
#define __TS_EVAL5(...)             __VA_ARGS__

#define __TS_TO_CSTRING_(str)       #str
#define __TS_TO_CSTRING(...)        __TS_TO_CSTRING_(__VA_ARGS__)

#define __TS_TO_NSSTRING_(str)      @#str
#define __TS_TO_NSSTRING(...)       __TS_TO_NSSTRING_(__VA_ARGS__)

#define __TS_PRIMITIVE_CAT(a, ...)  a##__VA_ARGS__
#define __TS_CAT(a, ...)            __TS_PRIMITIVE_CAT(a, __VA_ARGS__)

#define __TS_ARG_0(n, ...)          n
#define __TS_ARG_1(x0, n, ...)      n
#define __TS_IS_PROBE(...)          __TS_ARG_1(__VA_ARGS__, 0)
#define __TS_PROBE()                ~, 1
#define __TS_NOT(x)                 __TS_IS_PROBE(__TS_CAT(__TS_NOT_, x))
#define __TS_NOT_0                  __TS_PROBE()
#define __TS_BOOL(x)                __TS_NOT(__TS_NOT(x))

#define __TS_AND(x1, x2)            __TS_IF_ELSE(x1)(__TS_IF_ELSE(x2)(1)(0))(0)
#define __TS_AND_3(x1, x2, x3)      __TS_AND(x1, __TS_AND(x2, x3))
#define __TS_AND_4(x1, x2, x3, x4)  __TS_AND(__TS_AND(x1, x2), __TS_AND(x3, x4))

#define __TS_OR(x1, x2)             __TS_IF_ELSE(x1)(1)(__TS_IF_ELSE(x2)(1)(0))
#define __TS_OR_3(x1, x2, x3)       __TS_OR(x1, __TS_OR(x2, x3))

#define __TS_IIF(c)                 __TS_PRIMITIVE_CAT(__TS_IIF_, c)
#define __TS_IIF_0(...)
#define __TS_IIF_1(...)             __VA_ARGS__

#define __TS_IELSE(c)               __TS_PRIMITIVE_CAT(__TS_IELSE_, c)
#define __TS_IELSE_0(...)           __VA_ARGS__
#define __TS_IELSE_1(...)

#define __TS_IIF_ELSE(c)            __TS_PRIMITIVE_CAT(__TS_IIF_ELSE_, c)
#define __TS_IIF_ELSE_0(...)                    __TS_IELSE_0
#define __TS_IIF_ELSE_1(...)        __VA_ARGS__ __TS_IELSE_1

#define __TS_IF(c)                  __TS_IIF(__TS_BOOL(c))
#define __TS_IF_ELSE(c)             __TS_IIF_ELSE(__TS_BOOL(c))

#define __TS_EMPTY()
#define __TS_DEFER(id)              id __TS_EMPTY()
#define __TS_OBSTRUCT(...)          __VA_ARGS__ __TS_DEFER(__TS_EMPTY)()


#pragma mark - API Levels

#define TS_ALWAYS_VISIBLE __attribute__ ((visibility ("default")))
#define TS_ALWAYS_HIDDEN  __attribute__ ((visibility ("hidden")))


#define TS_TURING_HIGHER_WRAPPER_LEVEL      1
#define TS_TURING_SHIELD_OPEN_API_LEVEL     2
#define TS_FRIENDLY_API_LEVEL               3
#define TS_PRIVATE_LEVEL                    4


#if TS_API_LEVEL >= TS_TURING_HIGHER_WRAPPER_LEVEL && !!TS_TURING_ID_WRAPPER_APIS
#   define TS_TURING_ID_API                 1
#else
#   define TS_TURING_ID_API                 0
#endif

#if TS_API_LEVEL >= TS_TURING_HIGHER_WRAPPER_LEVEL && !!TS_TURING_AGE_WRAPPER_APIS
#   define TS_TURING_AGE_API                1
#else
#   define TS_TURING_AGE_API                0
#endif

#if TS_API_LEVEL >= TS_TURING_SHIELD_OPEN_API_LEVEL
#   define TS_TURING_SHIELD_OPEN_API        1
#else
#   define TS_TURING_SHIELD_OPEN_API        0
#endif

#if TS_API_LEVEL >= TS_FRIENDLY_API_LEVEL
#   define TS_FRIENDLY_API                  1
#else
#   define TS_FRIENDLY_API                  0
#endif

#if TS_API_LEVEL >= TS_PRIVATE_LEVEL
#   define TS_PRIVATE                       1
#else
#   define TS_PRIVATE                       0
#endif

#define TS_VISIBLE_LEVEL(APIKind)           \
    __TS_IF_ELSE(APIKind)                   \
       /*CASE TRUE*/  (TS_ALWAYS_VISIBLE)   \
       /*CASE FALSE*/ (TS_ALWAYS_HIDDEN)



#endif /* __TURING_SERVICE_DEFINE_H__ */
