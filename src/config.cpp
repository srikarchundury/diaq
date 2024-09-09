#include "config.hpp"

namespace diaq {

#ifdef PAPI_ON
	// Static variables for PAPI
    static int EventSet = PAPI_NULL;

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

        // event: total instructions
        if (PAPI_add_event(EventSet, PAPI_TOT_INS) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_TOT_INS!" << std::endl;
        }
        papi_event_names.push_back("PAPI_TOT_INS");

        // event: total cycles
        if (PAPI_add_event(EventSet, PAPI_TOT_CYC) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_TOT_CYC!" << std::endl;
        }
        papi_event_names.push_back("PAPI_TOT_CYC");

        // event: L1 data cache misses
        if (PAPI_add_event(EventSet, PAPI_L1_DCM) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_L1_DCM!" << std::endl;
        }
        papi_event_names.push_back("PAPI_L1_DCM");

        // event: L2 data cache misses
        if (PAPI_add_event(EventSet, PAPI_L2_DCM) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_L2_DCM!" << std::endl;
        }
        papi_event_names.push_back("PAPI_L2_DCM");

        // event: L3 data cache misses
        if (PAPI_add_event(EventSet, PAPI_L3_TCM) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_L3_TCM!" << std::endl;
        }
        papi_event_names.push_back("PAPI_L3_TCM");

        // event: L1 instruction cache misses
        if (PAPI_add_event(EventSet, PAPI_L1_ICM) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_L1_ICM!" << std::endl;
        }
        papi_event_names.push_back("PAPI_L1_ICM");

        // event: L2 instruction cache misses
        if (PAPI_add_event(EventSet, PAPI_L2_ICM) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_L2_ICM!" << std::endl;
        }
        papi_event_names.push_back("PAPI_L2_ICM");

        // event: L3 instruction cache misses
        if (PAPI_add_event(EventSet, PAPI_L3_ICM) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_L3_ICM!" << std::endl;
        }
        papi_event_names.push_back("PAPI_L3_ICM");

        // event: branch mispredictions
        if (PAPI_add_event(EventSet, PAPI_BR_MSP) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_BR_MSP!" << std::endl;
        }
        papi_event_names.push_back("PAPI_BR_MSP");

        // event: conditional branch instructions
        if (PAPI_add_event(EventSet, PAPI_BR_CN) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_BR_CN!" << std::endl;
        }
        papi_event_names.push_back("PAPI_BR_CN");

        // event: total load instructions
        if (PAPI_add_event(EventSet, PAPI_LD_INS) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_LD_INS!" << std::endl;
        }
        papi_event_names.push_back("PAPI_LD_INS");

        // event: total store instructions
        if (PAPI_add_event(EventSet, PAPI_SR_INS) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_SR_INS!" << std::endl;
        }
        papi_event_names.push_back("PAPI_SR_INS");

        // event: floating point instructions
        if (PAPI_add_event(EventSet, PAPI_FP_INS) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_FP_INS!" << std::endl;
        }
        papi_event_names.push_back("PAPI_FP_INS");

        // event: vector instructions
        if (PAPI_add_event(EventSet, PAPI_VEC_INS) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_VEC_INS!" << std::endl;
        }
        papi_event_names.push_back("PAPI_VEC_INS");

        // event: TLB data misses
        if (PAPI_add_event(EventSet, PAPI_TLB_DM) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_TLB_DM!" << std::endl;
        }
        papi_event_names.push_back("PAPI_TLB_DM");

        // event: instruction TLB misses
        if (PAPI_add_event(EventSet, PAPI_TLB_IM) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_TLB_IM!" << std::endl;
        }
        papi_event_names.push_back("PAPI_TLB_IM");

        // event: stalled cycles
        if (PAPI_add_event(EventSet, PAPI_STL_CCY) != PAPI_OK) {
            std::cerr << "PAPI add event error for PAPI_STL_CCY!" << std::endl;
        }
        papi_event_names.push_back("PAPI_STL_CCY");

        // more events can be added here
        // ...
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