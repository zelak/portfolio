/*
 * Base on Meyer's singleton implementation.
 */
#ifndef UTILS_SINGLETON_H
#define UTILS_SINGLETON_H

#include "utils/once.h"

/**
 * Utilities, helpers, etc
 */
namespace utils {

namespace Singleton {

/**
 * @brief Get the singleton instance of T
 * @return an unique pointer to the instance of T
 * 
 * @usage
 * 
 * auto pointer = utils::Singleton::instanceOf<Type>();
 */
template< class T>
T * instanceOf()
{
    static T * _instance = nullptr;

    if (_instance == nullptr) {
         // create instance if not exists
        utils::call_once([&](){
            _instance = new T();
        });
    }

    return _instance;
}

}; // namespace Singleton

}; // namespace utils

#endif // UTILS_SINGLETON_H