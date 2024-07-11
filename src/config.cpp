#include "config.hpp"

namespace diaq {

#ifdef PAPI_ON
	// Static variables for PAPI
    static int EventSet = PAPI_NULL;

    // Initialize PAPI
    void initPAPI() {
        // Initialize the PAPI library
        if (PAPI_library_init(PAPI_VER_CURRENT) != PAPI_VER_CURRENT) {
            std::cerr << "PAPI library initialization error!" << std::endl;
            // Handle initialization error as needed
        }

        // Create an EventSet
        if (PAPI_create_eventset(&EventSet) != PAPI_OK) {
            std::cerr << "PAPI create event set error!" << std::endl;
            // Handle EventSet creation error as needed
        }

        // Add PAPI events to the EventSet
        if (PAPI_add_event(EventSet, PAPI_TOT_INS) != PAPI_OK) {
            std::cerr << "PAPI add event error!" << std::endl;
            // Handle adding event error as needed
        }
        if (PAPI_add_event(EventSet, PAPI_TOT_CYC) != PAPI_OK) {
            std::cerr << "PAPI add event error!" << std::endl;
            // Handle adding event error as needed
        }

        // // Optionally, start counting immediately
        // if (PAPI_start(EventSet) != PAPI_OK) {
        //     std::cerr << "PAPI start counters error!" << std::endl;
        //     // Handle starting counters error as needed
        // }
    }

    // Cleanup PAPI resources
    void cleanupPAPI() {
        // // Stop counting
        // long long values[2];
        // if (PAPI_stop(EventSet, values) != PAPI_OK) {
        //     std::cerr << "PAPI stop counters error!" << std::endl;
        //     // Handle stopping counters error as needed
        // }

        // // Print the results (example)
        // std::cout << "Total instructions: " << values[0] << std::endl;
        // std::cout << "Total cycles: " << values[1] << std::endl;

        // Cleanup EventSet
        if (PAPI_cleanup_eventset(EventSet) != PAPI_OK) {
            std::cerr << "PAPI cleanup event set error!" << std::endl;
            // Handle cleanup error as needed
        }
        if (PAPI_destroy_eventset(&EventSet) != PAPI_OK) {
            std::cerr << "PAPI destroy event set error!" << std::endl;
            // Handle destroy event set error as needed
        }

        // Shutdown PAPI library
        PAPI_shutdown();
    }

    // Start PAPI counters
    void startPAPI() {
        if (PAPI_start(EventSet) != PAPI_OK) {
            std::cerr << "PAPI start counters error!" << std::endl;
            // Handle starting counters error as needed
        }
    }

    // Stop PAPI counters
    void stopPAPI(std::string message) {
        // Stop counting
        long long values[2];
        if (PAPI_stop(EventSet, values) != PAPI_OK) {
            std::cerr << "PAPI stop counters error!" << std::endl;
            // Handle stopping counters error as needed
        }
        std::time_t now = std::time(nullptr);
        std::cout << std::put_time(std::localtime(&now), "%F %T") << " - " << message << " - Total instructions: " << values[0] << std::endl;
        std::cout << std::put_time(std::localtime(&now), "%F %T") << " - " << message << " - Total cycles: " << values[1] << std::endl;
    }

#endif

} // namespace diaq