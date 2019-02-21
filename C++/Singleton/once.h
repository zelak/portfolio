/* 
 * Base on: https://wiki.qt.io/Qt_thread-safe_singleton
 */
#ifndef UTILS_ONCE_H
#define UTILS_ONCE_H

#include <QThread>
#include <QBasicAtomicInt>

/**
 * Utilities, helpers, etc
 */
namespace utils {

/**
 * @brief Call once states
 */
typedef enum {
    UTILS_ONCE_Start,
    UTILS_ONCE_Running,
    UTILS_ONCE_Finished
} call_once_state_t;

/**
 * @brief Call a function only once
 * @param func Function that must be called only once
 * 
 * @usage
 * 
 * Using lambda:
 * ```
 * utils::call_once( [] { printf "Hello World only once!\n"; } );
 * ```
 */
template < typename Function >
inline static void call_once(Function func)
{
    static QBasicAtomicInt state {UTILS_ONCE_Start};
    int _state = state.fetchAndStoreAcquire(state);

    // Return if already run
    if ( _state == UTILS_ONCE_Finished ) {
        return;
    }

    // Execute the func if state is 'Start'
    if ( _state == UTILS_ONCE_Start && 
         state.testAndSetRelaxed(UTILS_ONCE_Start, UTILS_ONCE_Running) )
    {
        func();
        state.fetchAndStoreAcquire(UTILS_ONCE_Finished);
    }
    else //  If state is 'Running' yeild this thread until finish
    {
        do {
            QThread::yieldCurrentThread();
        } while ( ! state.testAndSetAcquire(UTILS_ONCE_Finished, UTILS_ONCE_Finished) );
    }
}

}; // namespace utils

#endif // UTILS_ONCE_H