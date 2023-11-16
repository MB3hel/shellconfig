
#include <string>
#include <cstdlib>

static inline void replace_all(std::string &str, const std::string& from, const std::string& to) {
    size_t start_pos = 0;
    while((start_pos = str.find(from, start_pos)) != std::string::npos) {
        str.replace(start_pos, from.length(), to);
        start_pos += to.length(); // Handles case where 'to' is a substring of 'from'
    }
}


int main(int argc, char *argv[]){
    std::string userprofile = std::getenv("USERPROFILE");
    replace_all(userprofile, "\\", "/");

    _putenv("CHERE_INVOKING=1");
    _putenv("MSYSTEM=MSYS2");
    _putenv("MSYS2_PATH_TYPE=inherit");

    std::string cmd = "";
    cmd += userprofile;
    cmd += "/standalonemsys2/usr/bin/bash.exe --login -i";
    for(int i = 1; i < argc; ++i){
        cmd += " \"";
        cmd += argv[i];
        cmd += "\"";
    }
    return system(cmd.c_str());
}

