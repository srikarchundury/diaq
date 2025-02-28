#include "config.hpp"

namespace diaq {

    valType* aligned_alloc_helper(size_t size) {
        size_t aligned_size = (size + NUM_BYTES_ALIGNED - 1) & ~(NUM_BYTES_ALIGNED - 1);  // Ensure alignment
        valType *alloced_array = (valType *)std::aligned_alloc(NUM_BYTES_ALIGNED, aligned_size);
        if (alloced_array == nullptr) {
            std::cerr << "Aligned memory allocation failed!" << std::endl;
            // Handle allocation error as needed
        }
        return alloced_array;
    }

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

        // // List of selected native events that read from perf
        // std::vector<std::string> native_events = {
        //     "perf::CYCLES",
        //     "perf::INSTRUCTIONS",
        //     "perf::CACHE-REFERENCES",
        //     "perf::CACHE-MISSES",
        //     "perf::L1-DCACHE-LOADS",
        //     "perf::L1-DCACHE-LOAD-MISSES",
        //     "perf::LLC-LOADS",
        //     "perf::LLC-LOAD-MISSES",
        //     "perf::BRANCH-INSTRUCTIONS",
        //     "perf::BRANCH-MISSES",
        //     "perf::RETIRED_BRANCH_INSTRUCTIONS",
        //     "perf::RETIRED_TAKEN_BRANCH_INSTRUCTIONS_MISPREDICTED",
        //     "perf::STALLED-CYCLES-FRONTEND",
        //     "perf::STALLED-CYCLES-BACKEND",
        //     "perf::IDLE-CYCLES-FRONTEND",
        //     "perf::IDLE-CYCLES-BACKEND",
        //     "perf::CONTEXT-SWITCHES",
        //     "perf::PAGE-FAULTS",
        //     "perf::CPU-CLOCK",
        //     "perf::CPU-MIGRATIONS"
        // };

        // List of selected PAPI events available on Intel architectures
        std::vector<std::string> native_events = {
            "PAPI_L1_DCM", // Level 1 data cache misses
            "PAPI_L1_ICM", // Level 1 instruction cache misses
            "PAPI_L2_DCM", // Level 2 data cache misses
            "PAPI_L2_ICM", // Level 2 instruction cache misses
            "PAPI_L1_TCM", // Level 1 cache misses
            "PAPI_L2_TCM", // Level 2 cache misses
            "PAPI_L3_TCM", // Level 3 cache misses
            "PAPI_CA_SNP", // Requests for a snoop
            "PAPI_CA_SHR", // Requests for exclusive access to shared cache line
            "PAPI_CA_CLN", // Requests for exclusive access to clean cache line
            "PAPI_CA_INV", // Requests for cache line invalidation
            "PAPI_CA_ITV", // Requests for cache line intervention
            "PAPI_L3_LDM", // Level 3 load misses
            "PAPI_TLB_DM", // Data translation lookaside buffer misses
            "PAPI_TLB_IM", // Instruction translation lookaside buffer misses
            "PAPI_L1_LDM", // Level 1 load misses
            "PAPI_L1_STM", // Level 1 store misses
            "PAPI_L2_LDM", // Level 2 load misses
            "PAPI_L2_STM", // Level 2 store misses
            "PAPI_PRF_DM", // Data prefetch cache misses
            "PAPI_MEM_WCY", // Cycles Stalled Waiting for memory writes
            "PAPI_STL_ICY", // Cycles with no instruction issue
            "PAPI_FUL_ICY", // Cycles with maximum instruction issue
            "PAPI_STL_CCY", // Cycles with no instructions completed
            "PAPI_FUL_CCY", // Cycles with maximum instructions completed
            "PAPI_BR_UCN", // Unconditional branch instructions
            "PAPI_BR_CN", // Conditional branch instructions
            "PAPI_BR_TKN", // Conditional branch instructions taken
            "PAPI_BR_NTK", // Conditional branch instructions not taken
            "PAPI_BR_MSP", // Conditional branch instructions mispredicted
            "PAPI_BR_PRC", // Conditional branch instructions correctly predicted
            "PAPI_TOT_INS", // Instructions completed
            "PAPI_LD_INS", // Load instructions
            "PAPI_SR_INS", // Store instructions
            "PAPI_BR_INS", // Branch instructions
            "PAPI_RES_STL", // Cycles stalled on any resource
            "PAPI_TOT_CYC", // Total cycles
            "PAPI_LST_INS", // Load/store instructions completed
            "PAPI_L2_DCA", // Level 2 data cache accesses
            "PAPI_L3_DCA", // Level 3 data cache accesses
            "PAPI_L2_DCR", // Level 2 data cache reads
            "PAPI_L3_DCR", // Level 3 data cache reads
            "PAPI_L2_DCW", // Level 2 data cache writes
            "PAPI_L3_DCW", // Level 3 data cache writes
            "PAPI_L2_ICH", // Level 2 instruction cache hits
            "PAPI_L2_ICA", // Level 2 instruction cache accesses
            "PAPI_L3_ICA", // Level 3 instruction cache accesses
            "PAPI_L2_ICR", // Level 2 instruction cache reads
            "PAPI_L3_ICR", // Level 3 instruction cache reads
            "PAPI_L2_TCA", // Level 2 total cache accesses
            "PAPI_L3_TCA", // Level 3 total cache accesses
            "PAPI_L2_TCR", // Level 2 total cache reads
            "PAPI_L3_TCR", // Level 3 total cache reads
            "PAPI_L2_TCW", // Level 2 total cache writes
            "PAPI_L3_TCW", // Level 3 total cache writes
            "PAPI_SP_OPS", // Floating point operations; optimized to count scaled single precision vector operations
            "PAPI_DP_OPS", // Floating point operations; optimized to count scaled double precision vector operations
            "PAPI_VEC_SP", // Single precision vector/SIMD instructions
            "PAPI_VEC_DP", // Double precision vector/SIMD instructions
            "PAPI_REF_CYC" // Reference clock cycles
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

        // Print added events
        std::cout << "\nAdded events:" << std::endl;
        for (size_t i = 0; i < papi_event_names.size(); ++i) {
            std::cout << "Event: " << papi_event_names[i] << ", Code: " << event_codes[i] << std::endl;
        }
        printf("\n");

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