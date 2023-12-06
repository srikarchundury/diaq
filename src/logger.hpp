#ifndef LOGGER_HPP
#define LOGGER_HPP

#include <stdio.h>
#include <stdarg.h>
#include <iostream>
#include <string>

#define RELEASE 0
#define INFO 1
#define DEBUG 2
#define DEEP_DEBUG 3

class Logger {
	public:
		int log_level;
		Logger(int level) {
			log_level = level;
		}
		void log(std::string message) {
			if (log_level >= DEBUG) {
				std::cout << message << std::endl;
			}
		}
};

#endif // LOGGER_HPP