#include "utils.h"

#include <flutter_windows.h>
#include <io.h>
#include <stdio.h>
#include <windows.h>

#include <iostream>

void CreateAndAttachConsole() {
  if (::AllocConsole()) {
    FILE *unused;
    if (!freopen_s(&unused, "CONOUT$", "w", stdout)) {
      if (_dup2(_fileno(stdout), 1) == -1) {
        std::cerr << "Failed to redirect stdout" << std::endl;
      }
    }
    if (!freopen_s(&unused, "CONOUT$", "w", stderr)) {
      if (_dup2(_fileno(stderr), 2) == -1) {
        std::cerr << "Failed to redirect stderr" << std::endl;
      }
    }
    std::ios::sync_with_stdio();
    FlutterDesktopResyncOutputStreams();
  }
}

std::vector<std::string> GetCommandLineArguments() {
  // Convert the UTF-16 command line arguments to UTF-8 for the Engine to use.
  int argc;
  wchar_t** argv = ::CommandLineToArgvW(::GetCommandLineW(), &argc);
  if (argv == nullptr) {
    return std::vector<std::string>();
  }

  std::vector<std::string> command_line_arguments;

  // Skip the first argument as it's the binary name.
  for (int i = 1; i < argc; i++) {
    if (argv[i] != nullptr) {
      std::string utf8_arg = Utf8FromUtf16(argv[i]);
      if (!utf8_arg.empty()) {
        command_line_arguments.push_back(utf8_arg);
      }
    }
  }

  ::LocalFree(argv);

  return command_line_arguments;
}

std::string Utf8FromUtf16(const wchar_t* utf16_string) {
  if (utf16_string == nullptr) {
    return std::string();
  }
  int required_length = ::WideCharToMultiByte(
      CP_UTF8, WC_ERR_INVALID_CHARS, utf16_string,
      -1, nullptr, 0, nullptr, nullptr);
  if (required_length <= 0) {
    return std::string();
  }
  // Remove redundant check since required_length is already int
  unsigned int target_length = static_cast<unsigned int>(required_length - 1); // remove trailing null
  std::string utf8_string;
  if (target_length > utf8_string.max_size()) {
    return utf8_string;
  }
  utf8_string.resize(target_length);
  int converted_length = ::WideCharToMultiByte(
      CP_UTF8, WC_ERR_INVALID_CHARS, utf16_string,
      -1, utf8_string.data(), required_length, nullptr, nullptr);
  if (converted_length <= 0) {
    return std::string();
  }
  return utf8_string;
}
