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
		std::string level_str;
		Logger(int level) {
			log_level = level;
			switch (level) {
				case RELEASE:
					level_str = "RELEASE";
					break;
				case INFO:
					level_str = "INFO";
					break;
				case DEBUG:
					level_str = "DEBUG";
					break;
				case DEEP_DEBUG:
					level_str = "DEEP_DEBUG";
					break;
				default:
					level_str = "RELEASE";
					break;
			}
		}
		void log(std::string message) {
			if (log_level == DEBUG) {
				std::cout << "\n[" << level_str << "] " << message << std::endl;
			}
		}
};

#endif // LOGGER_HPP