#include "config.hpp"

namespace diaq {

#ifdef PAPI_ON
	// Static variables for PAPI
    static int EventSet = PAPI_NULL;
    std::vector<int> event_codes;

    // init a vector of strings to store the PAPI event names
    static std::vector<std::string> papi_event_names;

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

        // List of selected native events
        std::vector<std::string> native_events = {
            "perf::CYCLES",
            "perf::INSTRUCTIONS",
            "perf::CACHE-REFERENCES",
            "perf::CACHE-MISSES",
            "perf::L1-DCACHE-LOADS",
            "perf::L1-DCACHE-LOAD-MISSES",
            "perf::LLC-LOADS",
            "perf::LLC-LOAD-MISSES",
            "perf::BRANCH-INSTRUCTIONS",
            "perf::BRANCH-MISSES",
            "perf::RETIRED_BRANCH_INSTRUCTIONS",
            "perf::RETIRED_TAKEN_BRANCH_INSTRUCTIONS_MISPREDICTED",
            "perf::STALLED-CYCLES-FRONTEND",
            "perf::STALLED-CYCLES-BACKEND",
            "perf::IDLE-CYCLES-FRONTEND",
            "perf::IDLE-CYCLES-BACKEND",
            "perf::CONTEXT-SWITCHES",
            "perf::PAGE-FAULTS",
            "perf::CPU-CLOCK",
            "perf::CPU-MIGRATIONS"
        };

        // Convert native event names to event codes
        for (const std::string& event_name : native_events) {
            int event_code;
            if (PAPI_event_name_to_code(event_name.c_str(), &event_code) == PAPI_OK) {
                if (PAPI_add_event(EventSet, event_code) == PAPI_OK) {
                    papi_event_names.push_back(event_name);
                    event_codes.push_back(event_code);
                } else {
                    std::cerr << "PAPI add event error for " << event_name << "!" << std::endl;
                }
            } else {
                std::cerr << "PAPI event name to code conversion error for " << event_name << "!" << std::endl;
            }
        }

    }

    // Cleanup PAPI resources
    void cleanupPAPI() {

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
        long int num_events = papi_event_names.size();
        long long values[num_events];
        if (PAPI_stop(EventSet, values) != PAPI_OK) {
            std::cerr << "PAPI stop counters error!" << std::endl;
            // Handle stopping counters error as needed
        }
        for(int i = 0; i < num_events; i++) {
            std::cout << message << "," << papi_event_names[i] << "," << values[i] << std::endl;
        }
    }

#endif

} // namespace diaq